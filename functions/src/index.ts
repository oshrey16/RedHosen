import * as functions from "firebase-functions";
import {initializeApp} from "firebase-admin/lib/index";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const helloBurusssh = functions.https.onRequest((request, response) => {
  functions.logger.info("Burush!", {structuredData: true});
  response.send("Hurush!");
});

const admin = initializeApp();

exports.disableUserOnCreate = functions.auth.user().onCreate((user) => {
  admin.auth().updateUser(user.uid, {disabled: true}).then(() => {
    console.log("Successfully Disabled user", user.email);
  }).catch((error) => {
    console.log("Error Disabled user:", error);
  });
  return 0;
});
