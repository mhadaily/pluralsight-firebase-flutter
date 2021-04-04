import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const auth = admin.auth();
const database = admin.firestore();
const messaging = admin.messaging();

export const sentToUserWhenOrderIsReady = functions.firestore
  .document('/Orders/{orderId}')
  .onUpdate(async (change, context) => {
    // Get an object representing the document [DocumentReference In Dart]
    const doc = change.after;
    const newValue = doc.data();

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
            body: `Dear ${user.displayName || 'customer'}, 
            you may pickup your order ${doc.id} now. Thank you!`,
            icon:
              'https://firebasestorage.googleapis.com/v0/b/wiredbrain-15518.appspot.com/o/FCMImages%2Flogo.png?alt=media&token=34270b69-f4ae-4e7d-aefe-0ad10883a609',
          },
        });
      } else {
        console.log('User does not have any tokens!');
      }
    }
  });
