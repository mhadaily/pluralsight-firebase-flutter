import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const auth = admin.auth();
const database = admin.firestore();
const messaging = admin.messaging();

export const sentToUserWhenOrderIsReady = functions.firestore
  .document('/Orders/{orderId}')
  .onUpdate(async (change, context) => {
    // Get an object representing the document
    const newValue = change.after.data();
    // ...or the previous value before this update
    // const previousValue = change.before.data();

    // if order is ready
    if (newValue.status === 'ready') {
      const userId = newValue.userId;

      const user = await auth.getUser(userId);

      const tokensDoc = await database.collection(`/Users/${userId}/Tokens`).listDocuments();
      const tokens = tokensDoc.map((doc) => doc.id);

      if (tokens && tokens.length) {
        messaging.sendToDevice(tokens, {
          notification: {
            title: 'Your Order is ready',
            body: `Dear ${
              user.displayName || 'customer'
            }, you may pickup your order now. thank you!`,
          },
        });
      } else {
        console.log('User does not have any tokens!');
      }
    }
  });
