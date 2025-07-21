#!/usr/bin/env node

const { spawn } = require("child_process");
const path = require("path");

const scriptPath = path.resolve(__dirname, "bin", "cleanrn.sh");

const child = spawn("bash", [scriptPath], {
  stdio: "inherit"
});

child.on("exit", (code) => {
  process.exit(code);
});