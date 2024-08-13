const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {logger} = require("firebase-functions/v2");
admin.initializeApp();


exports.sendNotificationOnDataChange = functions.firestore
    .document('your_collection/{docId}')
    .onUpdate((change, context) => {
        const newValue = change.after.data();
        const previousValue = change.before.data();

        // Check if the data has changed
        if (newValue.someField !== previousValue.someField) {
            const userEmail = newValue.userEmail;
            return admin.firestore().collection('user').doc(userEmail).get()
                .then(userDoc => {
                    const userToken = userDoc.data().token;
                    const payload = {
                        notification: {
                            title: 'Data Changed',
                            body: 'The data has been updated.',
                        }
                    };
                    return admin.messaging().sendToDevice(userToken, payload);
                });
        }
        return null;
    });
