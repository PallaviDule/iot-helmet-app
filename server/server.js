const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

let sessionData = [];

app.post('/command', (req, res) => {
  const { user, command, timestamp } = req.body;

  if (!command || !timestamp) {
    return res.status(400).json({ error: 'Missing required fields: command and timestamp' });
  }

  const validCommands = ['pair', 'start', 'pause', 'stop', 'continue'];
  if (!validCommands.includes(command)) {
    return res.status(400).json({ error: 'Invalid command' });
  }

  sessionData.push({
    user: user || 'anonymous',
    command,
    timestamp
  });

  res.status(200).json({ status: 'Command logged successfully' });
});

app.get('/sessions', (req, res) => {
  res.status(200).json(sessionData);
});

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});