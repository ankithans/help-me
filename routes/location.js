const express = require("express");
const router = express.Router();
const { check, validationResult } = require("express-validator");
const { admin } = require("../services/firebase_config.js");

const auth = require("../middleware/auth");
const User = require("../models/user");

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

// @route       GET api/v1/location/users
// @dsc         get near by users
// @access      Private
router.get("/users", auth, async (req, res) => {
  const { longitude, latitude, distance } = req.body;
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
      // notifications logic
      for (var i = 0; i < results.length; i++) {
        const registrationToken = results[i].fcmToken;
        const message = "Help me";
        const options = notification_options;

        const payload = {
          notification: {
            title: `Help Me`,
            body: `are help-me`,
          },
          // NOTE: The 'data' object is inside payload, not inside notification
          data: {
            personSent: "userSent",
          },
        };

        admin
          .messaging()
          .sendToDevice(registrationToken, payload, options)
          .then((response) => {
            console.log(response);
          })
          .catch((error) => {
            console.log(error);
            return res.status(500).json({
              success: false,
              message: "failed to send notifications",
            });
          });
      }

      return res.status(200).json({
        success: true,
        results: results,
      });
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
});

module.exports = router;
