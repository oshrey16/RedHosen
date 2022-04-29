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
    admin.firestore().collection("Users").
    doc(data.mapvars["usertype"]).
    collection(data.mapvars["usertype"]).
    doc(uid).create({
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

export const updateUserName = functions.https.onCall((data) => {
  admin.auth().getUserByEmail(data.email)
  .then((user)=>{
    admin.auth().updateUser(user.uid, {displayName: data.name});
  });
});

exports.disableUserOnCreate = functions.auth.user().onCreate((user) => {
  return admin.auth().updateUser(user.uid,
    {disabled: true}).then(() => {
    console.log("Successfully Disabled user", user.email);
    return admin.auth().setCustomUserClaims(user.uid, {"disabled": true})
    .then(()=> {
return 0;
}).catch((error)=>{
  console.log("Error Disabled user:", error);
  return -1;
    });
  }).catch((error) => {
    console.log("Error Disabled user:", error);
    return -1;
  });
});

exports.updateUserEnable = functions.https.onCall((data, context) =>{
  const v = new Promise((resolve, reject) => {
    admin.auth().updateUser(data.uid, {
      disabled: false,
    }).then(()=> {
      const resetRef = admin.firestore()
      .collection("Users")
      .doc(data.collection)
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
              return resolve("success");
            }).catch((error)=> {
              console.log("Error", error);
              return reject(error);
          });
          });
        }
      }).catch((error)=> {
        console.log("Error", error);
        return reject(error);
      });
    }).catch((error)=> {
      console.log("Error Enable user:", error);
      return reject(error);
    });
  });
  return v.then((resolve) => {
      return resolve;
  }).catch((error)=> {
    return (error);
  });
});

exports.updateUserDisable = functions.https.onCall((data, context) =>{
  const v = new Promise((resolve) => {
    admin.auth().updateUser(data.uid, {disabled: true}).then(()=> {
      const resetRef = admin.firestore()
      .collection("Users")
      .doc(data.collection)
      .collection(data.collection)
      .doc(data.uid);
      resetRef.get().then((doc) => {
        if (doc.exists) {
          resetRef.update({enabled: false})
          .then(()=>{
            console.log("Successfully Disable user uid: ", data.uid,
            ", Byuid: ", context.auth?.token.uid,
            ", AdminEmail: ", context.auth?.token.email);
            return resolve("success");
          }).catch((error)=> {
            console.log("Error", error);
        });
      }
      }).catch((error)=> {
        console.log("Error", error);
      });
  }).catch((error)=> {
      console.log("Error Disable user:", error);
    });
  });
  return v.then((resolve)=>{
    return resolve;
  }).catch((error)=> {
    return error;
  });
});

exports.makeAdmin = functions.https.onCall((data) =>{
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    let customClaims: {[key: string]: any } = {};
    admin.auth().getUser(data.uid)
    .then((data)=> {
      if (data.customClaims != undefined) {
        customClaims = data.customClaims;
        customClaims.isAdmin = true;
        admin.auth().setCustomUserClaims(data.uid, customClaims).then(()=>{
          console.log(
            `admin ${data.uid} : ${data.displayName} is active Admin`);
        });
      }
  });
});
exports.makeAdmin = functions.https.onCall((data) =>{
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let customClaims: {[key: string]: any } = {};
  admin.auth().getUser(data.uid)
  .then((data)=> {
    if (data.customClaims != undefined) {
      customClaims = data.customClaims;
      customClaims.isAdmin = false;
      admin.auth().setCustomUserClaims(data.uid, customClaims).then(()=> {
        console.log(
          `admin ${data.uid} : ${data.displayName}is Disabled Admin`);
      });
    }
});
});
