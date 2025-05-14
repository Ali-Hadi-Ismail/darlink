const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const mongoose = require("mongoose");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  pingTimeout: 60000,
  connectTimeout: 5000,
  transports: ["websocket"],
  cors: {
    origin: "*",
  },
});

// MongoDB Connection
const MONGO_URI = "mongodb+srv://salimshatila21:UfXFh4SuoVCusLO8@cluster0.p3mm2.mongodb.net/seniorDBtest1?retryWrites=true&w=majority&appName=Cluster0";
mongoose
  .connect(MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log("MongoDB connection error:", err));

// Create schema for messages
const MessageSchema = new mongoose.Schema({
  sender: String,
  receiver: String,
  content: String,
  timestamp: { type: Date, default: Date.now },
  isRead: { type: Boolean, default: false },
});

const Message = mongoose.model("Message", MessageSchema);

// Connected users map: { userId: socketId }
const connectedUsers = new Map();

io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);

  // User authentication and mapping socket to user
  socket.on("user_connected", (userData) => {
    console.log(`User ${userData.email} connected with socket ID ${socket.id}`);
    connectedUsers.set(userData.email, socket.id);

    // Notify other users that this user is online
    socket.broadcast.emit("user_status", {
      email: userData.email,
      status: "online",
    });
  });

  // Handle sending messages
  socket.on("send_message", async (messageData) => {
    console.log("Message received:", messageData);

    // Save message to database
    try {
      const newMessage = new Message({
        sender: messageData.sender,
        receiver: messageData.receiver,
        content: messageData.content,
      });

      await newMessage.save();

      // Send to receiver if online
      const receiverSocketId = connectedUsers.get(messageData.receiver);
      if (receiverSocketId) {
        io.to(receiverSocketId).emit("receive_message", {
          id: newMessage._id,
          sender: messageData.sender,
          content: messageData.content,
          timestamp: newMessage.timestamp,
          isRead: false,
        });
      }

      // Send confirmation back to sender
      socket.emit("message_sent", {
        id: newMessage._id,
        timestamp: newMessage.timestamp,
        status: "sent",
      });
    } catch (error) {
      console.error("Error saving message:", error);
      socket.emit("message_error", { error: "Failed to send message" });
    }
  });

  // Get chat history between two users
  socket.on("get_chat_history", async (data) => {
    try {
      const messages = await Message.find({
        $or: [
          { sender: data.user1, receiver: data.user2 },
          { sender: data.user2, receiver: data.user1 },
        ],
      }).sort({ timestamp: 1 });

      socket.emit("chat_history", messages);
    } catch (error) {
      console.error("Error fetching chat history:", error);
      socket.emit("chat_history_error", { error: "Failed to fetch chat history" });
    }
  });

  // Get recent conversations for a user
  socket.on("get_recent_conversations", async (data) => {
    try {
      // Find all messages where the user is either sender or receiver
      const messages = await Message.find({
        $or: [{ sender: data.email }, { receiver: data.email }],
      }).sort({ timestamp: -1 });

      // Extract unique conversation partners
      const conversationPartners = new Map();

      messages.forEach((message) => {
        const partner = message.sender === data.email ? message.receiver : message.sender;

        if (!conversationPartners.has(partner)) {
          conversationPartners.set(partner, {
            email: partner,
            lastMessage: message.content,
            timestamp: message.timestamp,
          });
        }
      });

      // Convert Map to array and sort by timestamp
      const conversations = Array.from(conversationPartners.values()).sort((a, b) => b.timestamp - a.timestamp);

      socket.emit("recent_conversations", conversations);
    } catch (error) {
      console.error("Error fetching recent conversations:", error);
      socket.emit("conversations_error", { error: "Failed to fetch conversations" });
    }
  });

  // Mark messages as read
  socket.on("mark_as_read", async (data) => {
    try {
      await Message.updateMany({ sender: data.sender, receiver: data.receiver, isRead: false }, { isRead: true });

      // Notify sender that messages were read
      const senderSocketId = connectedUsers.get(data.sender);
      if (senderSocketId) {
        io.to(senderSocketId).emit("messages_read", {
          by: data.receiver,
        });
      }
    } catch (error) {
      console.error("Error marking messages as read:", error);
    }
  });

  // Handle disconnection
  socket.on("disconnect", () => {
    let disconnectedUser = null;

    // Find and remove the disconnected user
    for (const [user, socketId] of connectedUsers.entries()) {
      if (socketId === socket.id) {
        disconnectedUser = user;
        connectedUsers.delete(user);
        break;
      }
    }

    if (disconnectedUser) {
      console.log(`User ${disconnectedUser} disconnected`);

      // Notify other users this user is offline
      socket.broadcast.emit("user_status", {
        email: disconnectedUser,
        status: "offline",
      });
    } else {
      console.log("Unknown user disconnected:", socket.id);
    }
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
