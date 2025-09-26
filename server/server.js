const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());


const PORT = process.env.PORT || 3000;
let latestData = [];
app.post("/iot-data", (req, res) => {
  latestData.push(req.body);
  console.log("Received IoT data:", latestData);
  res.status(200).send({ message: "Data received" });
});

// Flutter client fetches data here
app.get("/iot-data", (req, res) => {
  if (!latestData) {
    return res.status(404).send({ message: "No data yet" });
  }
  res.send(latestData);
});


app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});