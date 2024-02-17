import dotenv from "dotenv";
import express from "express";

dotenv.config();

const server = express();

const { PORT } = process.env;

server.get('/heartbeat', (req, res) => {
  res.json({
    "is": "working"
  });
});

server.listen(PORT, () => {
  console.log(`The server is listening at port ${PORT}`);
});
