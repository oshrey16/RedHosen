import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp({
  credential: admin.credential.cert({
    projectId: functions.config().project.id,
  }),
});

const db = admin.firestore();
export {admin, db};
