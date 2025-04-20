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

    const messages = [];

    for (const userOffset of sharedUserOffsetDetails) {
      const userId = userOffset.userId;
      const triggerTimeForUser = userOffset.offsettedTime;

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
            isLocation: alarmData.isLocationEnabled.toString(),
            isActivity: alarmData.isActivityEnabled.toString(),
            isWeather: alarmData.isWeatherEnabled.toString(),
            location: alarmData.location,
            weatherTypes: JSON.stringify(alarmData.weatherTypes),
            triggerTime: triggerTimeForUser,
          },
        };
      } else {
        // Send visible notification to shared users (not owner)
        message = {
          token,
          android: {
            priority: "high",
            notification: {
              title: "Alarm updated!",
              body: `${changedUserName} has made changes to your alarm!`,
            },
          },
          apns: {
            payload: {
              aps: {
                alert: {
                  title: "Alarm updated!",
                  body: `${changedUserName} has made changes to your alarm!`,
                },
                sound: "default",
              },
            },
          },
          data: {
            silent: "false",
            type: "rescheduleAlarm",
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
    }
    if (messages.length > 0) {
      await admin.messaging().sendEach(messages);
      return {success: true, sentTo: sharedUserOffsetDetails.length};
    } else {
      return {success: false, message: "No valid tokens found"};
    }
  } catch (error) {
    logger.error("Error sending notification", error);
    throw new Error("Failed to send notification");
  }
});
