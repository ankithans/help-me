var admin = require("firebase-admin");

var serviceAccount = require("../help-me-firebase-adminsdk.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://help-me-3d306.firebaseio.com",
});

module.exports.admin = admin;
