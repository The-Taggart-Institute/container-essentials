const express = require("express");
const { allowedNodeEnvironmentFlags } = require("process");
const app = express();
const PORT = process.env["NODE_PORT"] || 8000;


app.use(express.static("public"));
// app.use(express.json());


// Listen on port
app.listen(PORT, () => {
  console.log(`Listening on ${PORT}`);
})
