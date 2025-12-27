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
initializePassport(
    passport, 
    email => users.find(user => user.email === email),
    id => users.find(user => user.id === id)
)
const storage = multer.diskStorage({ //this line tells multer to store the file in hard drive
    destination: (req, file, cb) => { 
        cb(null, 'uploads/'); //takes the request and the file and then the call back function redirects to uploads folder
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); // same thing just oi uploads folder e its saved w this name
    }
})

const upload = multer({ storage: storage });

const users = [] //eita just locally store korbe user info for now but database banaile connect kore dite hobe


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
    const sql = "SELECT username, score FROM leaderboard ORDER BY score DESC LIMIT 3";
    db.query(sql, (err, result) => {
        if (err) {
            console.log("Leaderboard table not ready yet, using empty list.");
            return res.render('index.ejs', { 
                leaderboard: [], // Sends an empty list
                name: req.user.name 
            });
        }
        res.render('index.ejs', { leaderboard: result, name: req.user.name });
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
        users.push({
            id: Date.now().toString(),//this is locally stored but database hoile oitai point korbe
            name: req.body.name,
            email: req.body.email,
            password: hashedPassword
        })
        res.redirect('/login')
    }catch{
        res.redirect('/register')
    }
    req.body
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
    const sql = "INSERT INTO note (title, content,subtitle, file_path) VALUES (?, ?, ?, ?)";
    const data = [title, content, subtitle, filePath];
    db.query(sql, data, (err,result) => {
        if (err) return res.status(500).send(err);
        const noteId = result.insertId;
        let totaltags = 0;
        for(let name of tags){
            db.query("INSERT IGNORE INTO tag (tag_name) VALUES (?)", [name], (err) => {
                if (err) return res.status(500).send(err);
                db.query("SELECT id FROM tag WHERE tag_name = ?", [name], (err, tagResult) => {
                    if (err) return res.status(500).send(err);
                    const tagId = tagResult[0].id;
                    db.query("INSERT INTO note_tag (note_id, tag_id) VALUES (?, ?)", [noteId, tagId], (err) => {
                        if (err) return res.status(500).send(err);
                        totaltags++;
                        if(totaltags===tags.length){
                            res.redirect('/notes');
                        }
                    });
                });
            });
        }
    })
})

app.get('/notes', checkAuthenticated, (req,res) =>{
    res.render('notes.ejs', {name: req.user.name})
})

app.get('/chat', checkAuthenticated, (req,res)=>{
    res.render('chat.ejs', {name: req.user.name})
})

app.get('/dashboard', checkAuthenticated, (req, res) => {
    res.render('dashboard.ejs', { name: req.user.name });
});

app.get('/leaderboard', checkAuthenticated, (req, res) => {
    res.render('leaderboard.ejs', { name: req.user.name });
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