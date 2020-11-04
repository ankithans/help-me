const express = require("express");
const router = express.Router();

const User = require("../models/user");

router.get("/users", async (req, res) => {
  try {
    await User.find({
      location: {
        $near: {
          $maxDistance: 1000,
          $geometry: {
            type: "Point",
            coordinates: [26.597898, 75.788759],
          },
        },
      },
    }).find((error, results) => {
      if (error) console.log(error);
      return res.json({
        results,
      });
    });
  } catch (err) {}
});

router.post("/users", async (req, res) => {
  try {
    const user = new User({
      name: "jaipur",
      location: {
        type: "Point",
        coordinates: [26.597458, 75.788068],
      },
    });
    await user.save();
    return res.json({
      message: "user successfully saved!",
    });
  } catch (err) {
    console.error(err);
  }
});

module.exports = router;
