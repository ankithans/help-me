const express = require("express");
const router = express.Router();
const { check, validationResult } = require("express-validator");
const { admin } = require("../services/firebase_config.js");

const auth = require("../middleware/auth");
const User = require("../models/user");
const user = require("../models/user");

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = require("twilio")(accountSid, authToken);

const notification_options = {
  priority: "high",
  timeToLive: 60 * 60 * 24,
};

// @route       PUT api/v1/location/update
// @dsc         update user location
// @access      Private
router.put(
  "/update",
  [check("location.coordinates", "Please include a valid location").isArray()],
  auth,
  async (req, res) => {
    const { location } = req.body;
    try {
      let user = await User.findById(req.user.id);
      user.location = location;
      console.log(user.location);
      await user.save();

      res.status(200).json({
        success: true,
        message: "user location updated successfully",
      });
    } catch (err) {
      console.log(err);
      res.status(500).json({
        success: false,
        error: "Internal Server Error",
      });
    }
  }
);

// @route       POST api/v1/location/users
// @dsc         get near by users
// @access      Private
router.post("/users", auth, async (req, res) => {
  var nearByUsers = [];
  var receiverIDs = [];
  var notifData = {};
  let user = await User.findById(req.user.id);

  const { longitude, latitude, distance } = req.body;
  const lat = latitude.toString();
  const long = longitude.toString();
  try {
    await User.find({
      location: {
        $near: {
          $maxDistance: distance,
          $geometry: {
            type: "Point",
            coordinates: [longitude, latitude],
          },
        },
      },
    }).find((error, results) => {
      if (error) {
        console.log(error);

        return res.status(200).json({
          success: false,
          results: [],
        });
      }

      nearByUsers = results;
      // notifications logic
      for (var i = 0; i < results.length; i++) {
        let receiver = results[i].id;
        console.log(receiver);
        const registrationToken = results[i].fcmToken;
        const message = "Help me";
        const options = notification_options;

        const payload = {
          notification: {
            title: `Help Me`,
            body: `someone in the distance ${distance} needs your help. To know his/her coordinates tap on the notification.`,
          },
          // NOTE: The 'data' object is inside payload, not inside notification
          data: {
            long,
            lat,
          },
        };
        notifData = payload;
        receiverIDs.push(receiver);

        admin
          .messaging()
          .sendToDevice(registrationToken, payload, options)
          .then((response) => {
            // console.log(notif);
            // console.log(response);
          })
          .catch((error) => {
            console.log(error);
            return res.status(500).json({
              success: false,
              message: "failed to send notifications",
            });
          });
      }
    });

    for (var i = 0; i < receiverIDs.length; i++) {
      let recieverUser = await User.findById(receiverIDs[i]);
      let prevNotif = recieverUser.notifications;
      prevNotif.push(notifData);
      await recieverUser.save();
    }

    if (user.closeContacts == undefined) {
    } else {
      const phoneNumbers = Array.from(user.closeContacts.values());
      console.log(phoneNumbers);

      for (var i = 0; i < phoneNumbers.length; i++) {
        client.messages
          .create({
            body: `Message from Help-me! Your contact ${user.name} is in trouble. His/Her coordinates are lat: ${latitude} long: ${longitude}`,
            from: "+12058461985",
            to: `+91${phoneNumbers[i]}`,
          })
          .then((message) => console.log(message.sid));
      }
    }
    client.messages
      .create({
        body: `Message from Help-me! Your contact ${user.name} is in trouble. His coordinates are lat: ${latitude} long: ${longitude}`,
        from: "+12058461985",
        to: `+919996850279`,
      })
      .then((message) => console.log(message.sid));

    console.log(req.user.id);
    return res.status(200).json({
      success: true,
      results: nearByUsers,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
});

module.exports = router;
