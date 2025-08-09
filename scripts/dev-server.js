#!/usr/bin/env node

import { spawn } from 'child_process';
import express from 'express';
import { createRequire } from 'module';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const require = createRequire(import.meta.url);

// Start Vite dev server
const viteProcess = spawn('vite', ['--port', '3001'], {
  stdio: 'inherit',
  cwd: path.resolve(__dirname, '..'),
});

// Start API server on port 3002
const app = express();

// Import and setup API routes
async function setupAPI() {
  try {
    // Import the chat-rooms API
    const chatRoomsModule = await import('../api/chat-rooms.js');
    const chatModule = await import('../api/chat.ts');
    
    // Setup middleware
    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    
    // CORS
    app.use((req, res, next) => {
      res.header('Access-Control-Allow-Origin', 'http://localhost:3001');
      res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization, X-Username');
      if (req.method === 'OPTIONS') {
        res.sendStatus(200);
      } else {
        next();
      }
    });
    
    // Route handlers
    app.all('/api/chat-rooms', async (req, res) => {
      try {
        const handler = req.method === 'GET' ? chatRoomsModule.GET : 
                      req.method === 'POST' ? chatRoomsModule.POST :
                      req.method === 'DELETE' ? chatRoomsModule.DELETE : null;
        
        if (!handler) {
          return res.status(405).json({ error: 'Method not allowed' });
        }
        
        const response = await handler(req);
        const data = await response.text();
        res.status(response.status).send(data);
      } catch (error) {
        console.error('API Error:', error);
        res.status(500).json({ error: 'Internal server error' });
      }
    });
    
    app.all('/api/chat', async (req, res) => {
      try {
        const response = await chatModule.default(req);
        const data = await response.text();
        res.status(response.status).send(data);
      } catch (error) {
        console.error('Chat API Error:', error);
        res.status(500).json({ error: 'Internal server error' });
      }
    });
    
    app.listen(3002, () => {
      console.log('🚀 API server running on http://localhost:3002');
    });
    
  } catch (error) {
    console.error('Failed to setup API:', error);
  }
}

setupAPI();

// Handle process termination
process.on('SIGINT', () => {
  console.log('\n🛑 Shutting down dev servers...');
  viteProcess.kill();
  process.exit(0);
});

process.on('SIGTERM', () => {
  viteProcess.kill();
  process.exit(0);
});
