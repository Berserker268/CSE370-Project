if(process.env.NODE_ENV !== 'production'){
    require('dotenv').config()
}

const express = require('express')
const app = express()
const bcrypt = require('bcrypt')
const passport = require('passport')
const flash = require('express-flash')
const session = require('express-session')
const methodOverride = require('method-override')
const path = require('path')
const multer = require('multer')
const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',      
    password: '',      
    database: 'onlynotes'
});

const initializePassport = require('./passport-config')
const { name } = require('ejs')
initializePassport(passport,db)

const storage = multer.diskStorage({ //this line tells multer to store the file in hard drive
    destination: (req, file, cb) => { 
        cb(null, 'uploads/'); //takes the request and the file and then the call back function redirects to uploads folder
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); // same thing just oi uploads folder e its saved w this name
    }
})

const upload = multer({ storage: storage });

app.set('view engine', 'ejs')
app.use(express.urlencoded({extended: false }))
app.use(flash())
app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false
}))
app.use(passport.initialize())
app.use(passport.session())
app.use(methodOverride('_method'))

app.use('/uploads', express.static('uploads'));
app.use(express.static(path.join(__dirname, 'public')))
app.use('/image', express.static(path.join(__dirname, 'image')))

app.get('/', checkAuthenticated, (req, res) => {
    const userId = req.user.user_id;
    const leaderboardsql = `
    SELECT 
        u.name, 
        u.rank_level, 
        (SUM(n.upvotes)* 10) AS points 
    FROM user u
    LEFT JOIN note n ON u.user_id = n.uploader_id
    GROUP BY u.user_id
    ORDER BY points DESC 
    LIMIT 3`;
    const notesSql = `
    SELECT 
        n.*, 
        u.name AS author_name,
        GROUP_CONCAT(t.tag_name) AS tag_list
    FROM note n
    JOIN user u ON n.uploader_id = u.user_id
    JOIN note_tag nt ON n.note_id = nt.note_id
    JOIN tag t ON nt.tag_id = t.tag_id
    WHERE n.uploader_id != ? 
      AND n.note_id NOT IN (SELECT note_id FROM saved_notes WHERE user_id = ?)
    GROUP BY n.note_id
    ORDER BY n.created_at DESC 
    LIMIT 50`;
    db.query(leaderboardsql, (err, leaderboardresult) => {
        if (err) {
            console.error("Error fetching Leaderboard", err);
            return res.render('index.ejs', { 
                leaderboard: [],
                notes: [],
                name: req.user.name 
            });
        }
        db.query(notesSql, [userId, userId], (err, notesresult) => {
            if (err) {
                console.error("Error fetching Notes", err);
                return res.render('index.ejs', { 
                    leaderboard: leaderboardresult,
                    notes: [], 
                    name: req.user.name 
                });
            }
                res.render('index.ejs', {
                    leaderboard : leaderboardresult,
                    notes: notesresult,
                    name: req.user.name
                })
        });
    })
})

app.get('/login', checkNotAuthenticated,(req, res) =>{
    res.render('login.ejs')
})

app.post('/login',checkNotAuthenticated, passport.authenticate('local', {
    successRedirect: '/',
    failureRedirect: '/login',
    failureFlash: true
}))

app.get('/register',checkNotAuthenticated, (req, res) =>{
    res.render('register.ejs')
})

app.post('/register',checkNotAuthenticated, async (req, res) =>{
    try{
        const salt = await bcrypt.genSalt()
        const hashedPassword = await bcrypt.hash(req.body.password, salt)
        const { name, email} = req.body
        const sql = "INSERT INTO user (name, email, password, role, points, rank_level) values (?, ?, ?, 'user', 0, 'Beginner')";
        db.query(sql, [name, email, hashedPassword], (err,result) =>{
            if(err){
                console.error(err);
                return res.redirect('/register');
            }
            res.redirect('/login');
        })
    }catch{
        res.redirect('/register');
    }
})

app.get('/upload', checkAuthenticated, (req, res) => {
    res.render('upload.ejs', { name: req.user.name });
});

app.post('/upload', upload.single('note_file'), (req, res)=>{
    const {title, content, subtitle} = req.body;
    const tags = req.body.tags ? req.body.tags.split(',').filter(tag => tag.trim() !== "") : [];
    let filePath = req.file ? req.file.path : null;

    if(content && filePath){
        return res.send('<script>alert("Please choose ONLY one: either write a note OR upload a file"); window.history.back();</script>');
    }
    if(tags.length === 0){
        return res.send('<script>alert("You must select at least one relevant tag for your note."); window.history.back();</script>');
    }
    if(!content && !filePath){
        return res.send('<script>alert("Write a note or upload a file first."); window.history.back();</script>')
    }
    const sql = "INSERT INTO note (title, content, subtitle, file_path, uploader_id) VALUES (?, ?, ?, ?, ?)";
    const data = [title, content, subtitle, filePath, req.user.user_id];
    db.query(sql, data, (err,result) => {
        if (err) {
            console.error("Upload Error:", err);
            return res.status(500).send("Database error during upload.");
        };
        const noteId = result.insertId;
        let totaltags = 0;
        tags.forEach((name) => {
            db.query("INSERT IGNORE INTO tag (tag_name) VALUES (?)", [name.trim()], (err) => {
                db.query("SELECT tag_id FROM tag WHERE tag_name = ?", [name.trim()], (err, tagResult) => {
                    const tagId = tagResult[0].tag_id;
                    db.query("INSERT INTO note_tag (note_id, tag_id) VALUES (?, ?)", [noteId, tagId], (err) => {
                        totaltags++;
                        if (totaltags === tags.length) {
                            return res.redirect('/dashboard'); 
                        }
                    });
                });
            });
        });
    })
})

app.get('/notes', checkAuthenticated, (req,res) =>{
    res.render('notes.ejs', {name: req.user.name})
})

app.get('/chat', checkAuthenticated, (req,res)=>{
    res.render('chat.ejs', {name: req.user.name})
})

app.get('/dashboard', checkAuthenticated, async (req, res) => {
    const userName = req.user.name;
    const userId = req.user.user_id;
    const statsQuery = `
        SELECT 
            (SELECT COUNT(*) FROM note WHERE uploader_id = ?) as notes_count,
            (SELECT IFNULL(SUM(upvotes), 0) FROM note WHERE uploader_id = ?) as total_upvotes,
            (SELECT COUNT(*) FROM saved_notes WHERE user_id = ?) as saved_count
        `;
    const notesQuery = `
        SELECT n.*, u.name as author_name 
        FROM note n
        JOIN saved_notes s ON n.note_id = s.note_id
        JOIN user u ON n.uploader_id = u.user_id
         WHERE s.user_id = ?
    `;
    db.query(statsQuery, [userId, userId, userId], (err, statsResult) => {
        if (err) {
            console.error("Database Error:", err);
            return res.status(500).send("Error fetching stats");
        }
        db.query(notesQuery, [userId], (err, savedNotes) => {
            if (err) {
                console.error("Database Error:", err);
                return res.status(500).send("Error fetching saved notes");
            }
            res.render('dashboard', {
                name: userName,
                stats: statsResult[0],
                savedNotes: savedNotes
            });
        });    
    });
});

app.get('/leaderboard', checkAuthenticated, (req, res) => {
    res.render('leaderboard.ejs', { name: req.user.name });
});

app.get('/profile', checkAuthenticated, (req, res) => {
    res.render('profile.ejs', { name: req.user.name });
});

app.post('/like-note/:id', async (req, res) => {
    const noteId = req.params.id;
    const userId = req.user.user_id;

    if (!userId) {
        return res.status(401).json({ error: "User not authenticated" });
    }

    try {
        const query = "INSERT INTO saved_notes (user_id, note_id) VALUES (?, ?)";
        const updateQuery = "UPDATE note SET upvotes = upvotes + 1 WHERE note_id = ?";
        db.query(query, [userId, noteId], (err, result) => {
            if (err) {
                console.error("Error inserting into saved_notes:", err);
                return res.status(500).json({ error: "Database error" });
            }
            db.query(updateQuery, [noteId], (err, updateResult) => {
                if (err) {
                    console.error("Error updating upvotes:", err);
                    return res.status(500).json({ error: "Upvote failed" });
                }
                res.json({ success: true, message: "Note liked and upvoted!" });
            });
        });
    } catch (err) {
        console.error("Database error:", err);
        res.status(500).json({ error: "Could not save note" });
    }
});

app.delete('/logout', (req, res, next) => {
    req.logOut(function(err) {
        if (err) { return next(err) }
        res.redirect('/login')
    })
})

function checkAuthenticated(req, res, next){
    if(req.isAuthenticated()){
        return next()
    }

    res.redirect('/login')
}

function checkNotAuthenticated(req, res, next){
    if(req.isAuthenticated()){
        return res.redirect('/')
    }
    next()
}
app.listen(3000)