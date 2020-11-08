const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const { check, validationResult } = require("express-validator");

const auth = require("../middleware/auth");
const User = require("../models/user");

// @route       POST api/v1/users/verify
// @dsc         register a user
// @access      Public
router.post(
  "/verify",
  [check("phone", "Please include a valid number").isLength(10)],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array(),
      });
    }

    const { phone } = req.body;

    try {
      let user = await User.findOne({ phone });
      if (user) {
        res.status(409).json({
          success: false,
          error: `User with ${phone} already exists`,
        });
      } else {
        res.status(200).json({
          success: true,
          message: `Successfully sent the Code to verify the Mobile Number ${phone}`,
          code: "123456",
        });
      }
    } catch (err) {
      console.error(err.message);
      res.status(500).json({
        success: false,
        error: "Internal Server Error",
      });
    }
  }
);

// @route       POST api/v1/users
// @dsc         register a user
// @access      Public
router.post(
  "/register",
  [
    check("name", "Please add a name").notEmpty(),
    check("phone", "Please include a valid number").isLength(10),
    check("location.coordinates", "Please include a valid location").isArray(),
    check("address", "Please include a valid address").notEmpty(),
    check("fcmToken", "Please add fcm token").notEmpty(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array(),
      });
    }

    try {
      const { name, phone, location, address, fcmToken } = req.body;
      let user = await User.findOne({ phone });
      if (user) {
        res.status(409).json({
          success: false,
          error: `User with ${phone} already exists`,
        });
      } else {
        user = new User({
          name,
          phone,
          location,
          address,
          fcmToken,
        });
        await user.save();

        const payload = {
          user: {
            id: user.id,
          },
        };

        jwt.sign(
          payload,
          process.env.JWT_SECRET,
          {
            expiresIn: 360000000,
          },
          (err, token) => {
            if (err) throw err;
            res.status(200).json({
              success: true,
              token: token,
              userId: user.id,
            });
          }
        );
      }
    } catch (err) {
      console.error(err.message);
      res.status(500).json({
        success: false,
        error: "Internal Server Error",
      });
    }
  }
);

// @route       POST api/v1/users
// @dsc         login a user
// @access      Public
router.post(
  "/login",
  [
    check("phone", "Please include a valid number").isLength(10),
    check("location.coordinates", "Please include a valid location").isArray(),
    check("fcmToken", "Please add fcm token").notEmpty(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array(),
      });
    }

    try {
      const { phone, location, fcmToken } = req.body;
      let user = await User.findOne({ phone });
      if (!user) {
        res.status(404).json({
          success: false,
          error: `User with ${phone} doesn't exists`,
        });
      } else {
        user.location = location;
        user.fcmToken = fcmToken;
        await user.save();

        const payload = {
          user: {
            id: user.id,
          },
        };

        jwt.sign(
          payload,
          process.env.JWT_SECRET,
          {
            expiresIn: 360000000,
          },
          (err, token) => {
            if (err) throw err;
            res.status(200).json({
              success: true,
              token: token,
              userId: user.id,
            });
          }
        );
      }
    } catch (err) {
      console.error(err.message);
      res.status(500).json({
        success: false,
        error: "Internal Server Error",
      });
    }
  }
);

// @route       GET api/v1/users/addCloseContacts
// @dsc         add close contacts of user
// @access      Private
router.post(
  "/addCloseContact",
  [check("closeContacts", "closeContacts is a type of map").exists()],
  auth,
  async (req, res) => {
    const { closeContacts } = req.body;
    try {
      let user = await User.findById(req.user.id);
      user.closeContacts = closeContacts;
      await user.save();
      res.status(200).json({
        success: true,
        user: user,
      });
    } catch (err) {
      console.error(err.message);
      res.status(500).json({
        success: false,
        error: "Internal Server Error",
      });
    }
  }
);

// @route       GET api/v1/users/getCloseContacts
// @dsc         get close contacts of user()family etc)
// @access      Private
router.get("/getCloseContact", auth, async (req, res) => {
  try {
    let user = await User.findById(req.user.id);

    const phoneNumbers = Array.from(user.closeContacts.values());

    // for (var i = 0; i < phoneNumbers.length; i++) {
    //   client.messages
    //     .create({
    //       body:
    //         "Message from Help-me! if you recieved it then ping on the group",
    //       from: "+12058461985",
    //       to: `+91${phoneNumbers[i]}`,
    //     })
    //     .then((message) => console.log(message.sid));
    // }

    res.status(200).json({
      success: true,
      phoneNumbers: phoneNumbers,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({
      success: false,
      error: "Internal Server Error",
    });
  }
});

// @route       GET api/v1/users/me
// @dsc         get current logged in user
// @access      Private
router.get("/me", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    res.status(200).json({
      success: true,
      user: user,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({
      success: false,
      error: "Internal Server Error",
    });
  }
});

// @route       GET api/users/:id
// @dsc         get user with uid
// @access      Public
router.get("/:id", async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    res.status(200).json({
      success: true,
      user: user,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({
      success: false,
      error: "Internal Server Error",
    });
  }
});

module.exports = router;
