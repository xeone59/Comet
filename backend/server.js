//
//  server.js
//  Comet
//
//  Created by 小序 on 3/19/25.
//

const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const { Pool } = require("pg"); // 引入 PostgreSQL 连接库

// 加载环境变量
dotenv.config();

// 创建 Express 服务器
const app = express();
app.use(cors());
app.use(express.json());

// 配置 PostgreSQL 连接池
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432, // PostgreSQL 端口
});

// 测试数据库连接
pool.connect((err, client, release) => {
  if (err) {
    console.error("❌ 数据库连接失败:", err.stack);
  } else {
    console.log("✅ 成功连接到 Supabase 数据库");
    release();
  }
});

// API 测试路由
app.get("/", (req, res) => {
  res.send("🚀 Server is running");
});

// 查询用户 API
app.get("/users", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (err) {
    console.error("❌ 查询用户失败:", err);
    res.status(500).json({ error: "数据库查询失败" });
  }
});

// 监听端口
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
