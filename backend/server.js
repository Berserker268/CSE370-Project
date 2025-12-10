if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config()
}

const express = require('express')
const app = express()
const bcrypt = require('bcrypt')
const cors = require('cors')

app.use(cors())
app.use(express.json()) // Allows the server to accept JSON data

const users = []

// GET route to see all users (for testing purposes)
app.get('/users', (req, res) => {
    res.json(users)
})

// Register Route
app.post('/register', async (req, res) => {
    try {
        // Check if user already exists
        if (users.find(user => user.email === req.body.email)) {
            return res.status(400).json({ message: 'User already exists' })
        }

        const hashedPassword = await bcrypt.hash(req.body.password, 10)
        const user = { 
            name: req.body.name, 
            email: req.body.email,
            password: hashedPassword 
        }
        users.push(user)
        res.status(201).json({ message: 'User registered successfully' })
    } catch {
        res.status(500).json({ message: 'Error registering user' })
    }
})

// Login Route
app.post('/login', async (req, res) => {
    const user = users.find(user => user.email === req.body.email)
    if (user == null) {
        return res.status(400).json({ message: 'Cannot find user' })
    }
    try {
        if (await bcrypt.compare(req.body.password, user.password)) {
            res.json({ message: 'Login successful', user: { name: user.name, email: user.email } })
        } else {
            res.status(403).json({ message: 'Password incorrect' })
        }
    } catch {
        res.status(500).json({ message: 'Error logging in' })
    }
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => console.log(`Server running on port ${PORT}`))