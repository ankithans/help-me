const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const { check, validationResult } = require("express-validator");

const auth = require("../middleware/auth");
const User = require("../models/user");

// @route       POST api/v1/users
// @dsc         login a user
// @access      Public
router.post(
  "/",
  [
    check("name", "Please add a name").notEmpty(),
    check("phone", "Please include a valid number").isLength(10),
    check("location.coordinates", "Please include a valid location").isArray(),
    check("address", "Please include a valid address").notEmpty(),
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
      const { name, phone, location, address } = req.body;
      let user = await User.findOne({ phone });
      if (user) {
        user.name = name;
        user.phone = phone;
        user.location = location;
        user.address = address;
        await user.updateOne({ phone });

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
      } else {
        user = new User({
          name,
          phone,
          location,
          address,
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
