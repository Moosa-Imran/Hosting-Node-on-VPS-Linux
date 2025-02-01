const express = require("express");
const app = express();

app.get("/", (req, res) => {
    res.send("Node.js server is running!");
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
