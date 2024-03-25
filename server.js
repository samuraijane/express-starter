import dotenv from "dotenv";
import express from "express";
import { access, constants, F_OK } from "fs";
import { dirname, resolve } from "path";
import { fileURLToPath } from "url";

dotenv.config();
const __dirname = dirname(fileURLToPath(import.meta.url)); // [1]

const server = express();

const { NODE_ENV, PORT } = process.env;

server.use("/assets", express.static(__dirname + "/assets"));
server.use("/build", express.static(__dirname + "/build"));

server.get("/heartbeat", (req, res) => {
  res.json({
    "is": "working"
  });
});

server.get("/assets/*", (req, res) => {
  res.json({
    path: req.url,
    message: "The requested asset is not found at the path you have provided."
  })
});

server.get("/api/version", (req, res) => {
  const versionFile = `${__dirname}/version.txt`;
  access(versionFile, F_OK, (err) => { // [2]
    if (err) {
      res.json({ message: "Version not available", err })
    } else {
      res.sendFile(resolve(versionFile));  
    }
  });
});

server.get("*", (req, res) => {
  access(`${__dirname}/build/${NODE_ENV}/index.html`, constants.F_OK, (err) => { // [2]
    if (!err) {
      res.sendFile(resolve(`${__dirname}/build/${NODE_ENV}/index.html`));
    } else {
      console.error(`ERROR: ${err}`);
      res.send(`
        <div class="error error--missing-files">
          <h1>Missing File</h1>
          <p>The <span>index.html</span> file inside of <span>/build/${NODE_ENV}</span> is not found.</p>
        </div>
      `);
    }
  });  
});

server.listen(PORT, () => {
  console.log(`The server is listening at port ${PORT}`);
});

/*
NOTES

[1]
Because we are using es5 modules (see package.json), we need to
initialize `__dirname` with this code so we can continue to use it and
have it work as expected.

[2]
TODO – Determine if there is a meaningful difference between `F_OK` and
`constants.F_OK`.
*/
