import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import admin from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const sendNotification = onCall(async (request) => {
  const {receivingUserIds, message} = request.data;

  // Prepare document references
  const userDocRefs =
  receivingUserIds.map((id) => db.collection("users").doc(id));

  try {
    // Batch fetch all user docs at once
    const userDocs = await db.getAll(...userDocRefs);

    const messages = [];

    userDocs.forEach((docSnapshot, index) => {
      const userId = receivingUserIds[index];
      const token = docSnapshot.data()?.fcmToken;

      if (!token) {
        logger.warn(`No FCM token for user ${userId}`);
        return;
      }

      messages.push({
        token,
        android: {
          priority: "high",
          notification: {
            title: "Shared!",
            body: message,
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
                title: "Shared!",
                body: message,
              },
              sound: "default",
            },
          },
        },
        notification: {
          title: "Shared!",
          body: message,
        },
        data: {
          silent: "false",
          type: "sharedItem",
          message,
        },
      });
    });
    if (messages.length === 0) {
      return {success: false, message: "No valid FCM tokens found"};
    }
    const response = await admin.messaging().sendEach(messages);
    return {success: true, message: response};
  } catch (error) {
    logger.error("Error sending notifications", error);
    throw new Error("Failed to send notifications");
  }
});
