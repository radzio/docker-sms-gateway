const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');

const app = express();
app.use(bodyParser.json());

// Endpoint to send SMS
app.post('/send-sms', (req, res) => {
    const { number, text } = req.body;
    
    if (!number || !text) {
        return res.status(400).json({ error: 'Phone number and text are required' });
    }

    const command = `echo "${text}" | gammu-smsd-inject --config /etc/gammu-smsd/gammu-smsdrc TEXT ${number}`;
    
    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error}`);
            return res.status(500).json({ error: 'Failed to send SMS' });
        }
        res.json({ message: 'SMS sent successfully' });
    });
});

app.listen(3000, () => {
    console.log('SMS API server running on port 3000');
});
