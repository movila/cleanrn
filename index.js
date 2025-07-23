#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");

const scriptPath = path.resolve(__dirname, "bin", "cleanrn.sh");

// Check if script exists
if (!fs.existsSync(scriptPath)) {
  console.error(`Error: Script not found at ${scriptPath}`);
  process.exit(1);
}

const child = spawn("bash", [scriptPath, ...process.argv.slice(2)], {
  stdio: "inherit"
});

child.on("error", (error) => {
  console.error(`Error executing script: ${error.message}`);
  process.exit(1);
});

child.on("exit", (code) => {
  process.exit(code || 0);
});