import dotenv from "dotenv";
import express from "express";
import { access, constants, existsSync } from "fs";
import { dirname, resolve } from "path";
import { fileURLToPath } from "url";

dotenv.config();
const __dirname = dirname(fileURLToPath(import.meta.url)); // [1]

const server = express();

const { NODE_ENV, PORT } = process.env;

server.use("/build", express.static(__dirname + "/build"));

server.get('/heartbeat', (req, res) => {
  res.json({
    "is": "working"
  });
});

server.get('*', (req, res) => {
  access(`${__dirname}/build/${NODE_ENV}/index.html`, constants.F_OK, (err) => {
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
  [1] Because we are using es5 modules (see package.json), we need to
      initialize `__dirname` with this code so we can continue to use it
      and have it work as expected.
*/
