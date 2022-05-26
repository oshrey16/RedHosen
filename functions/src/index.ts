import * as functions from "firebase-functions";
import {initializeApp, auth} from "firebase-admin/lib/index";
// import {UserInfo} from "firebase-admin/lib/index";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
const admin = initializeApp();

export const createUser = functions.https.onCall((data, context) => {
  const uid = context.auth?.uid;
  if (uid != undefined) {
    createUserStore(uid, data.mapvars).then(() => {
      console.log("User Created in FireStore");
      const fullName = data.mapvars["fname"] + " " + data.mapvars["lname"];
      updateUserName(uid, fullName).then(() => {
        const phone = "+972" + data.mapvars["phone"];
        updatePhoneNumber(uid, phone).then(() => {
          insertUserType(uid, data.mapvars["claimtype"])
            .then(() => {
              console.log("User Created!");
            })
            .then(() => {
              insertfcmToken(
                uid,
                data.mapvars["fcmToken"],
                data.mapvars["claimtype"]
              );
            });
        });
      });
    });
  }
});

export const getUser = functions.https.onCall((data) => {
  interface map {
    [key: string]: string | number;
  }
  const di: map = {};
  di["A"] = 3;
  console.log(di["A"]);
  return admin
    .auth()
    .getUser(data.uid)
    .then((v) => {
      v.displayName ? (di["name"] = v.displayName) : (di["name"] = "error");
      v.phoneNumber ? (di["phone"] = v.phoneNumber) : (di["phone"] = "error");
      return di;
    });
});

/**
 * This Function Create user In FireStore - save user data
 * @param {string} uid - uid of user
 * @param {any} mapvars - map with parameters
 * @return {Promise<FirebaseFirestore.WriteResult>} result
 */
function createUserStore(
  uid: string,
  mapvars: any
): Promise<FirebaseFirestore.WriteResult> {
  return admin
    .firestore()
    .collection("Users")
    .doc(mapvars["usertype"])
    .collection(mapvars["usertype"])
    .doc(uid)
    .create({
      uid: uid,
      fname: mapvars["fname"],
      lname: mapvars["lname"],
      id: mapvars["idcon"],
      phone: mapvars["phone"],
      email: mapvars["email"],
      enabled: false,
    });
}

// export const createUserStore = functions.https.onCall((data) => {
//   admin.auth().getUserByEmail(data.mapvars["email"])
//   .then((user)=>{
//     const uid = user.uid;
//     admin.firestore().collection("Users").
//     doc(data.mapvars["usertype"]).
//     collection(data.mapvars["usertype"]).
//     doc(uid).create({
//       "uid": uid,
//       "fname": data.mapvars["fname"],
//       "lname": data.mapvars["lname"],
//       "id": data.mapvars["idcon"],
//       "phone": data.mapvars["phone"],
//       "email": data.mapvars["email"],
//       "enabled": false,
//     });
//   });
// });

/**
 * This Function create Display name to user
 * @param {string} uid - uid of user
 * @param {string} fullname - fullname of user
 * @return {Promise<auth.UserRecord>} result
 */
function updateUserName(
  uid: string,
  fullname: string
): Promise<auth.UserRecord> {
  return admin.auth().updateUser(uid, {displayName: fullname});
}

/**
 * This Function create Phone number to user
 * @param {string} uid - uid of user
 * @param {string} phone - fullname of user
 * @return {Promise<auth.UserRecord>} result
 */
function updatePhoneNumber(
  uid: string,
  phone: string
): Promise<auth.UserRecord> {
  return admin.auth().updateUser(uid, {phoneNumber: phone});
}

// export const updateUserName = functions.https.onCall((data) => {
//   admin.auth().getUserByEmail(data.email)
//   .then((user)=>{
//     admin.auth().updateUser(user.uid, {displayName: data.name});
//   });
// });

exports.disableUserOnCreate = functions.auth.user().onCreate((user) => {
  return admin
    .auth()
    .updateUser(user.uid, {disabled: true})
    .then(() => {
      console.log("Successfully Disabled user", user.email);
      return 0;
    })
    .catch((error) => {
      console.log("Error Disabled user:", error);
      return -1;
    });
});

exports.updateUserEnable = functions.https.onCall((data, context) => {
  const v = new Promise((resolve, reject) => {
    admin
      .auth()
      .updateUser(data.uid, {
        disabled: false,
      })
      .then(() => {
        const resetRef = admin
          .firestore()
          .collection("Users")
          .doc(data.collection)
          .collection(data.collection)
          .doc(data.uid);
        resetRef
          .get()
          .then((doc) => {
            if (doc.exists) {
              resetRef
                .update({enabled: true})
                .then(() => {
                  console.log(
                    "Successfully Enable user uid: ",
                    data.uid,
                    ", Byuid: ",
                    context.auth?.token.uid,
                    ", AdminEmail: ",
                    context.auth?.token.email
                  );
                  return resolve("success");
                })
                .catch((error) => {
                  console.log("Error", error);
                  return reject(error);
                });
            }
          })
          .catch((error) => {
            console.log("Error", error);
            return reject(error);
          });
      })
      .catch((error) => {
        console.log("Error Enable user:", error);
        return reject(error);
      });
  });
  return v
    .then((resolve) => {
      return resolve;
    })
    .catch((error) => {
      return error;
    });
});

exports.updateUserDisable = functions.https.onCall((data, context) => {
  const v = new Promise((resolve) => {
    admin
      .auth()
      .updateUser(data.uid, {disabled: true})
      .then(() => {
        const resetRef = admin
          .firestore()
          .collection("Users")
          .doc(data.collection)
          .collection(data.collection)
          .doc(data.uid);
        resetRef
          .get()
          .then((doc) => {
            if (doc.exists) {
              resetRef
                .update({enabled: false})
                .then(() => {
                  console.log(
                    "Successfully Disable user uid: ",
                    data.uid,
                    ", Byuid: ",
                    context.auth?.token.uid,
                    ", AdminEmail: ",
                    context.auth?.token.email
                  );
                  return resolve("success");
                })
                .catch((error) => {
                  console.log("Error", error);
                });
            }
          })
          .catch((error) => {
            console.log("Error", error);
          });
      })
      .catch((error) => {
        console.log("Error Disable user:", error);
      });
  });
  return v
    .then((resolve) => {
      return resolve;
    })
    .catch((error) => {
      return error;
    });
});

export const makeAdmin = functions.https.onCall((data) => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let customClaims: { [key: string]: any } = {};
  admin
    .auth()
    .getUser(data.uid)
    .then((data) => {
      if (data.customClaims != undefined) {
        customClaims = data.customClaims;
        customClaims.isAdmin = true;
        admin
          .auth()
          .setCustomUserClaims(data.uid, customClaims)
          .then(() => {
            console.log(
              `admin ${data.uid} : ${data.displayName} is active Admin`
            );
          });
      }
    });
});
export const unmakeAdmin = functions.https.onCall((data) => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let customClaims: { [key: string]: any } = {};
  admin
    .auth()
    .getUser(data.uid)
    .then((data) => {
      if (data.customClaims != undefined) {
        customClaims = data.customClaims;
        customClaims.isAdmin = false;
        admin
          .auth()
          .setCustomUserClaims(data.uid, customClaims)
          .then(() => {
            console.log(
              `admin ${data.uid} : ${data.displayName}is Disabled Admin`
            );
          });
      }
    });
});

/**
 * This Function update User type in Custom Claims
 * @param {string} uid - uid of user
 * @param {string} type - type of user
 * @return {Promise<auth.UserRecord>} result
 */
function insertUserType(
  uid: string,
  type: string
): Promise<void | auth.UserRecord> {
  let customClaims: { [key: string]: any } = {};
  return admin
    .auth()
    .getUser(uid)
    .then((user) => {
      customClaims = user.customClaims ?? {};
      customClaims.usertype = type;
      return admin
        .auth()
        .setCustomUserClaims(user.uid, customClaims)
        .then(() => {
          console.log(`User ${user.email} set To ${type}`);
        });
    });
}

/**
 * This Function insert FCM token in DB
 * @param {string} uid - uid of user
 * @param {string} fcmToken - fcmToken
 * @param {string} type - type of user
 * @return {Promise<auth.UserRecord>} result
 */
function insertfcmToken(
  uid: string,
  fcmToken: string,
  type: string
): Promise<void | auth.UserRecord> {
  const ref = admin.database().ref("FCMTokens").child(type).child(uid);
  return ref.set({
    Token: fcmToken,
  });
}

interface Dictionary<T> {
  [Key: string]: T;
}

exports.sendListenerPushNotification = functions.database
  .ref("/activeReports")
  .onWrite((data, context) => {
    const FCMRef = admin.database().ref("FCMTokens");
    const FCMTokenHosen = FCMRef.child("Therapist").once("value");
    const FCMTokenSocial = FCMRef.child("SocialWorker").once("value");
    FCMTokenHosen.then((v1) => {
      FCMTokenSocial.then((v2) => {
      const k = [];
      const d1 = v1.val();
      const d2 = v2.val();
      if (d1 != null) {
        for (const [key, value] of Object.entries(d1)) {
          console.log(key);
          const choiceItem = value as Dictionary<string>;
          console.log(choiceItem["Token"]);
          k.push(choiceItem["Token"]);
        }
      }
      if (d2 != null) {
        for (const [key, value] of Object.entries(d2)) {
          console.log(key);
          const choiceItem = value as Dictionary<string>;
          console.log(choiceItem["Token"]);
          k.push(choiceItem["Token"]);
        }
      }
      k.forEach((element) => {
        const payload = {
          token: element,
          notification: {
            title: "התראה",
            body: "התראה חדשה",
          },
          data: {
            body: "בדיקה בדיקה",
          },
        };
        admin
          .messaging()
          .send(payload)
          .then((response) => {
            // Response is a message ID string.
            console.log("Successfully sent message:", response);
            return {success: true};
          })
          .catch((error) => {
            return {error: error.code};
          });
      });
    });
    });
  });
