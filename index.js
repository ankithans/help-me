const express = require("express");
const connectDB = require("./services/db");
const bodyParser = require("body-parser");
const app = express();
require("dotenv").config();

const userRoute = require("./routes/user");
const locationRoute = require("./routes/location");

// db connection
connectDB();

// middlewares
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// routes
app.get("/", (req, res) => {
  return res.status(200).json({
    message: "app is delpoyed and tested",
  });
});

app.use("/api/v1/users", userRoute);
app.use("/api/v1/location", locationRoute);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () =>
  console.log(`Server started on http://localhost:${PORT}`)
);
