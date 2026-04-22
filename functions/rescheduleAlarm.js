import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import admin from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}
const db = admin.firestore();

export const rescheduleAlarm = onCall(async (request, context) => {
  const {firestoreAlarmId, changedByUserId} = request.data;
  try {
    const alarmDocSnap =
    await db.collection("sharedAlarms")
        .doc(firestoreAlarmId).get();
    const alarmData = alarmDocSnap.data();

    if (!alarmData) {
      return {success: false, message: "Alarm not found"};
    }

    const {offsetDetails: sharedUserOffsetDetails = []} = alarmData;

    if (sharedUserOffsetDetails.length === 0) {
      return {success: false, message: "No users found"};
    }

    const changedUserDocSnap =
    await db.collection("users")
        .doc(changedByUserId).get();
    const changedUserData = changedUserDocSnap.data();
    const changedUserName = changedUserData?.fullName || "Someone";

    const updatedMainAlarmTime = alarmData.alarmTime || alarmData.mainAlarmTime;
    logger.info(`🕐 Using updated main alarm time: ${updatedMainAlarmTime}`);

    const messages = [];

    for (const userOffset of sharedUserOffsetDetails) {
      const userId = userOffset.userId;

      let triggerTimeForUser = updatedMainAlarmTime;

      if (userOffset.offsetDuration && userOffset.offsetDuration > 0) {
        const [hours, minutes] = updatedMainAlarmTime.split(":").map(Number);
        let totalMinutes = hours * 60 + minutes;

        if (userOffset.isOffsetBefore) {
          totalMinutes -= userOffset.offsetDuration;
        } else {
          totalMinutes += userOffset.offsetDuration;
        }

        if (totalMinutes < 0) totalMinutes += 24 * 60;
        if (totalMinutes >= 24 * 60) totalMinutes -= 24 * 60;

        const newHours = Math.floor(totalMinutes / 60);
        const newMinutes = totalMinutes % 60;
        triggerTimeForUser = `${newHours.toString().padStart(2, "0")}:` +
          `${newMinutes.toString().padStart(2, "0")}`;
      }

      logger.info(`👤 User ${userId}: Main time ${updatedMainAlarmTime} → ` +
        `Trigger time ${triggerTimeForUser}`);

      const userDocSnap = await db.collection("users").doc(userId).get();
      const userData = userDocSnap.data();
      const token = userData?.fcmToken;

      if (!token) {
        logger.warn(`User token not found for userId: ${userId}`);
        continue;
      }

      let message;

      if (userId === changedByUserId) {
        // Send silent notification to changed user to reschedule alarm
        message = {
          token,
          android: {priority: "high"},
          apns: {
            headers: {
              "apns-priority": "10",
              "apns-push-type": "background",
            },
            payload: {
              aps: {contentAvailable: true},
            },
          },
          data: {
            silent: "true",
            type: "rescheduleAlarm",
            alarmId: firestoreAlarmId,
            firestoreAlarmId: firestoreAlarmId,
            newAlarmTime: triggerTimeForUser,
            ownerName: changedUserName,
            isLocation: alarmData.isLocationEnabled.toString(),
            isActivity: alarmData.isActivityEnabled.toString(),
            isWeather: alarmData.isWeatherEnabled.toString(),
            location: alarmData.location,
            weatherTypes: JSON.stringify(alarmData.weatherTypes),
            triggerTime: triggerTimeForUser,
          },
        };
      } else {
        message = {
          token,
          android: {
            priority: "high",
            data: {
              silent: "false",
              type: "rescheduleAlarm",
              alarmId: firestoreAlarmId,
              firestoreAlarmId: firestoreAlarmId,
              newAlarmTime: triggerTimeForUser,
              ownerName: changedUserName,
              isLocation: alarmData.isLocationEnabled.toString(),
              isActivity: alarmData.isActivityEnabled.toString(),
              isWeather: alarmData.isWeatherEnabled.toString(),
              location: alarmData.location,
              weatherTypes: JSON.stringify(alarmData.weatherTypes),
              triggerTime: triggerTimeForUser,
            },
            notification: {
              title: "Shared Alarm Updated! 🔔",
              body: `${changedUserName} updated the alarm time to ` +
                `${triggerTimeForUser}`,
              priority: "high",
              channelId: "alarm_updates",
            },
          },
          apns: {
            headers: {
              "apns-priority": "10",
              "apns-push-type": "alert",
            },
            payload: {
              aps: {
                alert: {
                  title: "Shared Alarm Updated! 🔔",
                  body: `${changedUserName} updated the alarm time to ` +
                    `${triggerTimeForUser}`,
                },
                sound: "default",
                contentAvailable: true,
              },
            },
          },
          data: {
            silent: "false",
            type: "rescheduleAlarm",
            alarmId: firestoreAlarmId,
            firestoreAlarmId: firestoreAlarmId,
            newAlarmTime: triggerTimeForUser,
            ownerName: changedUserName,
            isLocation: alarmData.isLocationEnabled.toString(),
            isActivity: alarmData.isActivityEnabled.toString(),
            isWeather: alarmData.isWeatherEnabled.toString(),
            location: alarmData.location,
            weatherTypes: JSON.stringify(alarmData.weatherTypes),
            triggerTime: triggerTimeForUser,
          },
        };
      }

      messages.push(message);

      const dataOnlyMessage = {
        token,
        android: {
          priority: "high",
          data: {
            silent: "true",
            type: "rescheduleAlarm",
            alarmId: firestoreAlarmId,
            firestoreAlarmId: firestoreAlarmId,
            newAlarmTime: triggerTimeForUser,
            ownerName: changedUserName,
            isLocation: alarmData.isLocationEnabled.toString(),
            isActivity: alarmData.isActivityEnabled.toString(),
            isWeather: alarmData.isWeatherEnabled.toString(),
            location: alarmData.location,
            weatherTypes: JSON.stringify(alarmData.weatherTypes),
            triggerTime: triggerTimeForUser,
          },
        },
        apns: {
          headers: {
            "apns-priority": "10",
            "apns-push-type": "background",
          },
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
        },
        data: {
          silent: "true",
          type: "rescheduleAlarm",
          alarmId: firestoreAlarmId,
          firestoreAlarmId: firestoreAlarmId,
          newAlarmTime: triggerTimeForUser,
          ownerName: changedUserName,
          isLocation: alarmData.isLocationEnabled.toString(),
          isActivity: alarmData.isActivityEnabled.toString(),
          isWeather: alarmData.isWeatherEnabled.toString(),
          location: alarmData.location,
          weatherTypes: JSON.stringify(alarmData.weatherTypes),
          triggerTime: triggerTimeForUser,
        },
      };

      messages.push(dataOnlyMessage);
      logger.info(`📨 Added 2 messages (notification + data-only) for ` +
        `user ${userId}`);
    }

    if (messages.length > 0) {
      logger.info(`📤 Sending reschedule notifications to ` +
        `${messages.length} messages (${sharedUserOffsetDetails.length} ` +
        `users) for alarm ${firestoreAlarmId}`);
      const response = await admin.messaging().sendEach(messages);

      logger.info(`✅ Reschedule notifications sent: ` +
        `${response.successCount}/${messages.length} successful`);
      if (response.failureCount > 0) {
        logger.warn(`❌ ${response.failureCount} messages failed:`);
        response.responses.forEach((resp, index) => {
          if (!resp.success) {
            logger.warn(`   Message ${index}: ` +
              `${resp.error?.message || "Unknown error"}`);
          }
        });
      }

      return {
        success: true,
        sentTo: sharedUserOffsetDetails.length,
        successCount: response.successCount,
        totalMessages: messages.length,
      };
    } else {
      return {success: false, message: "No valid tokens found"};
    }
  } catch (error) {
    logger.error("Error sending reschedule notification", error);
    throw new Error("Failed to send notification");
  }
});
