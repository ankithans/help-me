const mongoose = require("mongoose");

const UserSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  //   email: {
  //     type: String,
  //     required: true,
  //   },
  //   password: {
  //     type: String,
  //     required: true,
  //   },
  location: {
    type: {
      type: String,
      default: "Point",
    },
    coordinates: {
      type: [Number],
      required: true,
    },
  },
});

UserSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("User", UserSchema);
