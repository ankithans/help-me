const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const { check, validationResult } = require("express-validator");

const User = require("../models/user");

// @route       POST api/v1/users
// @dsc         login a user
// @access      Public
router.post(
  "/users",
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

// router.get("/users", async (req, res) => {
//   try {
//     await User.find({
//       location: {
//         $near: {
//           $maxDistance: 1000,
//           $geometry: {
//             type: "Point",
//             coordinates: [26.597898, 75.788759],
//           },
//         },
//       },
//     }).find((error, results) => {
//       if (error) console.log(error);
//       return res.json({
//         results,
//       });
//     });
//   } catch (err) {}
// });

// router.post("/users", async (req, res) => {
//   try {
//     const user = new User({
//       name: "jaipur",
//       location: {
//         type: "Point",
//         coordinates: [26.597458, 75.788068],
//       },
//     });
//     await user.save();
//     return res.json({
//       message: "user successfully saved!",
//     });
//   } catch (err) {
//     console.error(err);
//   }
// });

module.exports = router;
