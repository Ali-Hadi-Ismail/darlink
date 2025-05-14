const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  pingTimeout: 60000,
  connectTimeout: 5000,
  transports: ["websocket"],
});

io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);
  console.log("Socket ID:", socket.id);
  socket.on("test", (msg) => {
    console.log("Received from client:", msg);
    socket.emit("test_response", "Message received by server!");
  });

  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
