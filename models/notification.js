const mongoose = require("mongoose");

const NotificationSchema = mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  body: {
    type: String,
    required: true,
  },
  data: [Number],
});

module.exports = mongoose.model("Notification", NotificationSchema);
