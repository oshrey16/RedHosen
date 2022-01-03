import * as functions from "firebase-functions";
import {initializeApp} from "firebase-admin/lib/index";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
const admin = initializeApp();

export const createUserStore = functions.https.onCall((data) => {
  admin.auth().getUserByEmail(data.mapvars["email"])
  .then((user)=>{
    const uid = user.uid;
    admin.firestore().collection(data.mapvars["usertype"]).doc(uid).create({
      "uid": uid,
      "fname": data.mapvars["fname"],
      "lname": data.mapvars["lname"],
      "id": data.mapvars["idcon"],
      "phone": data.mapvars["phone"],
      "email": data.mapvars["email"],
      "enabled": false,
    });
  });
});

exports.disableUserOnCreate = functions.auth.user().onCreate((user) => {
  admin.auth().updateUser(user.uid, {disabled: true}).then(() => {
    console.log("Successfully Disabled user", user.email);
    admin.auth().generateEmailVerificationLink(user.email ?? "")
    .then(()=>{
      console.log("generateEmailVerificationLink Send!");
      admin.auth().setCustomUserClaims(user.uid, {"disabled": true});
    }).catch((error)=>{
      console.log("Error generateEmailVerificationLink :", error);
    });
  }).catch((error) => {
    console.log("Error Disabled user:", error);
  });
  return 0;
});

exports.updateUserEnable = functions.https.onCall((data, context) =>{
  admin.auth().updateUser(data.uid, {
    disabled: false,
  }).then(()=> {
    const resetRef = admin.firestore()
    .collection(data.collection)
    .doc(data.uid);
    resetRef.get().then((doc) => {
      if (doc.exists) {
        resetRef.update({enabled: true})
        .then(()=>{
          admin.auth().setCustomUserClaims(data.uid, {"disabled": false})
          .then(()=>{
            console.log("Successfully Enable user uid: ", data.uid,
            ", Byuid: ", context.auth?.token.uid,
            ", AdminEmail: ", context.auth?.token.email);
            return {
              result: "success"};
          }).catch((error)=> {
            console.log("Error", error);
        });
        });
      }
    }).catch((error)=> {
      console.log("Error", error);
    });
  }).catch((error)=> {
    console.log("Error Enable user:", error);
  });
});

//     console.log("Successfully Enable user: $s , By: $s", data.uid,
//     context.auth?.token.uid);
//   }).catch((error)=> {
//     console.log("Error Enable user:", error);
//   });
// });
