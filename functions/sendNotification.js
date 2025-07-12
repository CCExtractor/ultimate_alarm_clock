import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import admin from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const sendNotification = onCall(async (request) => {
  const {receivingUserIds, message, sharedItem} = request.data;

  logger.info(`📤 sendNotification called with ${receivingUserIds.length} recipients`);
  logger.info(`📦 Shared item data:`, sharedItem);

  // Prepare document references
  const userDocRefs =
  receivingUserIds.map((id) => db.collection("users").doc(id));

  try {
    // Batch fetch all user docs at once
    const userDocs = await db.getAll(...userDocRefs);

    const messages = [];
    const batch = db.batch(); // Create a batch for Firestore updates

    userDocs.forEach((docSnapshot, index) => {
      const userId = receivingUserIds[index];
      const userData = docSnapshot.data();
      const token = userData?.fcmToken;

      if (!token) {
        logger.warn(`No FCM token for user ${userId}`);
        return;
      }

      // Add push notification message
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

      // Add shared item to user's receivedItems array if sharedItem is provided
      if (sharedItem && docSnapshot.exists) {
        logger.info(`📦 Adding shared item to user ${userId}: ${userData?.fullName || userData?.email}`);
        const userDocRef = db.collection("users").doc(userId);
        const currentReceivedItems = userData?.receivedItems || [];
        
        // Add the new shared item to the array
        const updatedReceivedItems = [...currentReceivedItems, sharedItem];
        
        batch.update(userDocRef, {
          receivedItems: updatedReceivedItems
        });
        
        logger.info(`✅ Queued receivedItems update for user ${userId}`);
      }
    });

    // Execute Firestore batch update first
    if (sharedItem) {
      logger.info(`🔄 Committing Firestore batch updates...`);
      await batch.commit();
      logger.info(`✅ Firestore batch updates completed`);
    }

    // Send push notifications
    if (messages.length === 0) {
      return {success: false, message: "No valid FCM tokens found"};
    }
    
    logger.info(`📱 Sending ${messages.length} push notifications...`);
    const response = await admin.messaging().sendEach(messages);
    logger.info(`✅ Push notifications sent successfully`);
    
    return {success: true, message: response};
  } catch (error) {
    logger.error("Error in sendNotification function", error);
    throw new Error("Failed to send notifications");
  }
});
