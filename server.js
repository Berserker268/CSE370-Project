if(process.env.NODE_ENV !== 'production'){
    require('dotenv').config()
}

const express = require('express')
const app = express()
const http = require('http').createServer(app);
const io = require('socket.io')(http);
const bcrypt = require('bcrypt')
const passport = require('passport')
const flash = require('express-flash')
const session = require('express-session')
const methodOverride = require('method-override')
const path = require('path')
const mysql = require('mysql2');


const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the MySQL database.');
});

const initializePassport = require('./passport-config')
const { name } = require('ejs')
initializePassport(passport,db)


app.set('view engine', 'ejs')
app.use(express.json());
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

app.use(express.static(path.join(__dirname, 'public')))
app.use('/image', express.static(path.join(__dirname, 'image')))

app.get('/', isUser, checkAuthenticated, (req, res) => {
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
        u.rank_level AS author_rank,
        GROUP_CONCAT(DISTINCT t.tag_name) AS tag_list
    FROM note n
    JOIN user u ON n.uploader_id = u.user_id
    JOIN note_tag nt ON n.note_id = nt.note_id
    JOIN tag t ON nt.tag_id = t.tag_id
    WHERE n.uploader_id != ?
      AND n.visibility = 'public'
      AND n.note_id NOT IN (SELECT note_id FROM saved_notes WHERE user_id = ?)
    GROUP BY n.note_id, u.name, u.rank_level
    ORDER BY n.created_at DESC 
    LIMIT 50`;
    const trendingSql = `
    SELECT 
        n.*, 
        u.name AS author_name, 
        u.rank_level AS author_rank, 
        GROUP_CONCAT(DISTINCT t.tag_name) AS tag_list
    FROM note n
    JOIN user u ON n.uploader_id = u.user_id
    JOIN note_tag nt ON n.note_id = nt.note_id
    JOIN tag t ON nt.tag_id = t.tag_id
    WHERE n.uploader_id != ?
      AND n.visibility = 'public'
      AND n.note_id NOT IN (SELECT note_id FROM saved_notes WHERE user_id = ?)
    GROUP BY n.note_id, u.name, u.rank_level
    ORDER BY 
        CASE u.rank_level
            WHEN 'Master Uploader' THEN 1
            WHEN 'Expert Uploader' THEN 2
            WHEN 'Pro Uploader' THEN 3
            WHEN 'Skilled Uploader' THEN 4
            WHEN 'Active Uploader' THEN 5
            ELSE 6 
        END ASC,
        n.upvotes DESC
    LIMIT 50`;
    db.query(leaderboardsql, (err, leaderboardresult) => {
        if (err) {
            console.error("Error fetching Leaderboard", err);
            leaderboardresult = [];
        }
        db.query(notesSql, [userId, userId], (err, notesresult) => {
            if (err) {
                console.error("Error fetching For You Notes", err);
                notesresult = [];
            }
            db.query(trendingSql, [userId, userId], (err, trendingResult) => {
                if (err) {
                    console.error("Error fetching Trending Notes", err);
                    trendingResult = [];
                }
                res.render('index.ejs', {
                    leaderboard: leaderboardresult || [],
                    forYouNotes: notesresult || [],
                    trendingNotes: trendingResult || [],
                    name: req.user.name
                })
            });
        });
    })
})

app.get('/login', checkNotAuthenticated,(req, res) =>{
    res.render('login.ejs')
})

app.post('/login', checkNotAuthenticated, (req, res, next) => {
    passport.authenticate('local', (err, user, info) => {
        if (err) return next(err);
        if (!user) {
            return res.redirect('/login'); 
        }
        if (user.status === 'banned') {
            return res.render('login.ejs', { 
                message: 'Your account has been banned for violating community guidelines.' 
            });
        }
        req.logIn(user, (err) => {
            if (err) return next(err);
            return user.role === 'admin' ? res.redirect('/admin') : res.redirect('/');
        });

    })(req, res, next);
});

app.get('/register',checkNotAuthenticated, (req, res) =>{
    res.render('register.ejs')
})

app.post('/register',checkNotAuthenticated, async (req, res) =>{
    try{
        const salt = await bcrypt.genSalt()
        const hashedPassword = await bcrypt.hash(req.body.password, salt)
        const { name, email} = req.body
        const sql = "INSERT INTO user (name, email, password, role, points, rank_level) values (?, ?, ?, 'user', 0, 'New Uploader')";
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

app.get('/upload', isUser, checkAuthenticated, (req, res) => {
    res.render('upload.ejs', { name: req.user.name });
});

app.post('/upload', checkAuthenticated, (req, res)=>{
    const {title, content, subtitle} = req.body;
    const tags = req.body.tags ? req.body.tags.split(',').filter(tag => tag.trim() !== "") : [];

    if(tags.length === 0){
        return res.send('<script>alert("You must select at least one relevant tag for your note and press enter."); window.history.back();</script>');
    }
    if(!content){
        return res.send('<script>alert("Write a note first."); window.history.back();</script>')
    }
    const sql = "INSERT INTO note (title, content, subtitle, uploader_id) VALUES (?, ?, ?, ?)";
    const data = [title, content, subtitle, req.user.user_id];
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
                            return res.redirect('/profile'); 
                        }
                    });
                });
            });
        });
    })
})

app.get('/chat', isUser, checkAuthenticated, (req, res) => {
    const sql = `
        SELECT u.name AS username, m.message_text AS message 
        FROM messages m 
        JOIN user u ON m.sender_id = u.user_id 
        ORDER BY m.sent_at ASC 
        LIMIT 50`;

    db.query(sql, (err, results) => {
        if (err) {
            console.error("Chat History Error:", err);
            return res.render('chat.ejs', { name: req.user.name, user: req.user, history: [] });
        }
        res.render('chat.ejs', { 
            name: req.user.name, 
            user: req.user, 
            history: results 
        });
    });
});



app.get('/dashboard', isUser, checkAuthenticated, async (req, res) => {
    const userName = req.user.name;
    const userId = req.user.user_id;
    const statsQuery = `
        SELECT 
            ( SELECT COUNT(*)FROM note WHERE uploader_id = ?) as notes_count,
            (SELECT IFNULL(SUM(upvotes), 0) FROM note WHERE uploader_id = ?) as total_upvotes,
            (SELECT COUNT(*) FROM saved_notes WHERE user_id = ?) as saved_count
        `;
    const notesQuery = `
        SELECT n.*, u.name as author_name, GROUP_CONCAT(t.tag_name) as tags
        FROM note n
        JOIN saved_notes s ON n.note_id = s.note_id
        JOIN user u ON n.uploader_id = u.user_id
        LEFT JOIN note_tag nt ON n.note_id = nt.note_id
        LEFT JOIN tag t ON nt.tag_id = t.tag_id
        WHERE s.user_id = ?
        GROUP BY n.note_id
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

app.post('/unsave-note/:id', (req, res) => {
    const noteId = req.params.id;
    const userId = req.user.user_id;
    const deleteQuery = `DELETE FROM saved_notes WHERE user_id = ? AND note_id = ?`;
    db.query(deleteQuery, [userId, noteId], (err, result) => {
        if (err) return res.status(500).send("Error unsaving note");
        const decrementQuery = `UPDATE note SET upvotes = GREATEST(0, upvotes - 1) WHERE note_id = ?`;
        db.query(decrementQuery, [noteId], (err, updateResult) => {
            if (err) return res.status(500).send("Error updating upvote count");
            const deductPointsQuery = `
                UPDATE user 
                SET points = GREATEST(0, points - 10) 
                WHERE user_id = (SELECT uploader_id FROM note WHERE note_id = ?)`;
            db.query(deductPointsQuery, [noteId], (err, pointResult) => {
                if (err) {
                    console.error("Error updating user points:", err);
                }
                const updateRankQuery = `
                    UPDATE user u
                    SET u.rank_level = CASE
                        WHEN u.points >= 300 THEN 'Master Uploader'
                        WHEN u.points >= 200 THEN 'Expert Uploader'
                        WHEN u.points >= 150 THEN 'Pro Uploader'
                        WHEN u.points >= 100 THEN 'Skilled Uploader'
                        WHEN u.points >= 50  THEN 'Active Uploader'
                    ELSE 'New Uploader'
                    END
                    WHERE u.user_id = (SELECT uploader_id FROM note WHERE note_id = ?)`;
                db.query(updateRankQuery, [noteId], (err) => {
                    if (err) console.error("Rank update error:", err);
                    res.redirect('/dashboard');
                });
            });
        });
    });
});

app.post('/report-note', checkAuthenticated, (req, res) => {
    const { noteId, reason } = req.body;
    const reporterId = req.user.user_id;
    const sqlReport = "INSERT INTO reports (reporter_id, note_id, reason) VALUES (?, ?, ?)";    
    db.query(sqlReport, [reporterId, noteId, reason], (err) => {
        if (err) return res.status(500).send(err);
        const sqlHide = "UPDATE note SET visibility = 'hidden' WHERE note_id = ?";        
        db.query(sqlHide, [noteId], (err) => {
            if (err) return res.status(500).send(err);
            const sqlRemoveSaved = "DELETE FROM saved_notes WHERE note_id = ?";            
            db.query(sqlRemoveSaved, [noteId], (err) => {
                if (err) return res.status(500).send(err);
                const decrementQuery = `UPDATE note SET upvotes = GREATEST(0, upvotes - 1) WHERE note_id = ?`;
                db.query(decrementQuery, [noteId], (err, updateResult) => {
                    if (err) return res.status(500).send("Error updating upvote count");
                    const deductPointsQuery = `
                        UPDATE user 
                        SET points = GREATEST(0, points - 10) 
                        WHERE user_id = (SELECT uploader_id FROM note WHERE note_id = ?)`;
                    db.query(deductPointsQuery, [noteId], (err, pointResult) => {
                        if (err) {
                            console.error("Error updating user points:", err);
                        }
                        const updateRankQuery = `
                        UPDATE user u
                        SET u.rank_level = CASE
                            WHEN u.points >= 300 THEN 'Master Uploader'
                            WHEN u.points >= 200 THEN 'Expert Uploader'
                            WHEN u.points >= 150 THEN 'Pro Uploader'
                            WHEN u.points >= 100 THEN 'Skilled Uploader'
                            WHEN u.points >= 50  THEN 'Active Uploader'
                        ELSE 'New Uploader'
                        END
                        WHERE u.user_id = (SELECT uploader_id FROM note WHERE note_id = ?)`;
                        db.query(updateRankQuery, [noteId], (err) => {
                            if (err) console.error("Rank update error:", err);
                            res.json({ success: true, message: "Note reported and scrubbed from app." });
                        });
                    });
                });
            });
        });
    });
});

app.get('/leaderboard', isUser, checkAuthenticated, (req, res) => {
    const leaderboardQuery = `
        SELECT
            COUNT(n.note_id) AS notes_uploaded,
            IFNULL(SUM(upvotes), 0) as total_upvotes,
            u.name, u.rank_level, u.points 
        FROM user u
        LEFT JOIN note n ON u.user_id = n.uploader_id
        WHERE u.status = 'active' AND u.role = 'user'
        GROUP BY u.user_id, u.name, u.rank_level, u.points
        ORDER BY u.points DESC
    `;
    db.query(leaderboardQuery, (err, results) => {
        if (err) {
                    console.error("Error Loading LeaderBoard", err);
                    return res.status(500).json({ error: "LeaderBoard failed" });
                }
        res.render('leaderboard', {
            name: req.user.name,
            students: results
        });
    });
});

app.get('/profile', isUser, checkAuthenticated, (req, res) => {
    const userId = req.user.user_id;
    const statsQuery = `
        SELECT 
            (SELECT COUNT(*) FROM note WHERE uploader_id = ?) as notes_count,
            (SELECT IFNULL(SUM(upvotes), 0) FROM note WHERE uploader_id = ?) as total_upvotes,
            (SELECT COUNT(*) FROM saved_notes WHERE user_id = ?) as saved_count
    `;
    const uploadedNotesQuery = `
        SELECT n.*, u.name as author_name, GROUP_CONCAT(t.tag_name) as tags
        FROM note n
        JOIN user u ON n.uploader_id = u.user_id
        LEFT JOIN note_tag nt ON n.note_id = nt.note_id
        LEFT JOIN tag t ON nt.tag_id = t.tag_id
        WHERE n.uploader_id = ?
        GROUP BY n.note_id
        ORDER BY n.created_at DESC
    `;

    db.query(statsQuery, [userId, userId, userId], (err, statsResult) => {
        if (err) {
            console.error("Database Error:", err);
            return res.status(500).send("Error fetching stats");
        }
        db.query(uploadedNotesQuery, [userId], (err, uploadedNotes) => {
            if (err) {
                console.error("Database Error:", err);
                return res.status(500).send("Error fetching uploaded notes");
            }
            res.render('profile', {
                user: req.user,
                name: req.user.name,
                stats: statsResult[0],
                uploadedNotes: uploadedNotes
            });
        });
    });
});

function isUser(req, res, next) {
    if (req.isAuthenticated() && req.user.role === 'user') {
        return next();
    }
    if (req.isAuthenticated() && req.user.role === 'admin') {
        return res.redirect('/admin');
    }
    res.redirect('/login');
}

function isAdmin(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') {
            return next();
        }
        return res.redirect('/'); 
    }
    res.redirect('/login');
}

app.get('/admin', isAdmin, checkAuthenticated, (req, res) => {
    const sql = `
        SELECT r.report_id, r.reason, r.reported_at, 
            n.note_id, n.title, n.content, 
            n.uploader_id,
            r.reporter_id,
            u.name AS reporter_name
        FROM reports r
        JOIN note n ON r.note_id = n.note_id
        JOIN user u ON r.reporter_id = u.user_id
        WHERE r.status = 'open'
        ORDER BY r.reported_at DESC`;
    const bannedUsersSql = "SELECT user_id, name FROM user WHERE status = 'banned'";

    db.query(sql, (err, reports) => {
        if (err) return res.status(500).send("Database Error");
        db.query(bannedUsersSql, (err, bannedUsers) => {
            if (err) return res.status(500).send("Database Error");
            res.render('admin', { reports, name: req.user.name, bannedUsers });
        });
    });
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
        const pointquery = "UPDATE user u JOIN note n ON u.user_id = n.uploader_id SET u.points = u.points + 10 WHERE n.note_id = ?";
        const rankquery = `
        UPDATE user u
        JOIN note n ON u.user_id = n.uploader_id
        SET u.rank_level =
            CASE
                WHEN u.points >= 300 THEN 'Master Uploader'
                WHEN u.points >= 200 THEN 'Expert Uploader'
                WHEN u.points >= 150 THEN 'Pro Uploader'
                WHEN u.points >= 100 THEN 'Skilled Uploader'
                WHEN u.points >= 50  THEN 'Active Uploader'
                ELSE 'New Uploader'
            END
        WHERE n.note_id = ?
        `;
        db.query(query, [userId, noteId], (err) => {
            if (err) {
                console.error("Error inserting into saved_notes:", err);
                return res.status(500).json({ error: "Database error" });
            }
            db.query(updateQuery, [noteId], (err) => {
                if (err) {
                    console.error("Error updating upvotes:", err);
                    return res.status(500).json({ error: "Upvote failed" });
                }
                db.query(pointquery, [noteId], (err) =>{
                    if (err) {
                        console.error("Error updating points:", err);
                        return res.status(500).json({ error: "point update failed" });
                    }
                    db.query(rankquery, [noteId], (err) =>{
                        if (err) {
                        console.error("Error updating rank:", err);
                        return res.status(500).json({ error: "rank update failed" });
                    }
                    })
                })
                res.json({ success: true, message: "Note liked and upvoted!" });
            });
        });
    } catch (err) {
        console.error("Database error:", err);
        res.status(500).json({ error: "Could not save note" });
    }
});

// Delete Note Permanently
app.post('/admin/delete-note/:noteId', isAdmin, checkAuthenticated, (req, res) => {
    const noteId = req.params.noteId;
    const sql = "DELETE FROM note WHERE note_id = ?";
    
    db.query(sql, [noteId], (err) => {
        if (err) return res.status(500).send(err);
        const resolveReportsSql = "UPDATE reports SET status = 'resolved' WHERE note_id = ?";
        db.query(resolveReportsSql, [noteId], (err) => {
            if (err) console.error("Report resolve error:", err);
            const cleanupTagsSql = `
                DELETE FROM tag 
                WHERE tag_id NOT IN (SELECT DISTINCT tag_id FROM note_tag)`;
            
            db.query(cleanupTagsSql, (err) => {
                if (err) console.error("Tag cleanup error:", err);
                res.redirect('/admin');
            });
        });
    });
});

// (False Report)
app.post('/admin/resolve-report/:reportId/:noteId', isAdmin, checkAuthenticated, (req, res) => {
    const { reportId, noteId } = req.params;
    const restoreSql = "UPDATE note SET visibility = 'public' WHERE note_id = ?";
    const resolveSql = "UPDATE reports SET status = 'resolved' WHERE report_id = ?";

    db.query(restoreSql, [noteId], (err) => {
        db.query(resolveSql, [reportId], (err) => {
            res.redirect('/admin');
        });
    });
});

// (bad content)
app.post('/admin/ban-uploader/:userId', isAdmin, checkAuthenticated, (req, res) => {
    const uploaderId = req.params.userId;
    const bansql = "UPDATE user SET status = 'banned' WHERE user_id = ?";
    db.query(bansql, [uploaderId], (err) => {
        if (err) return res.status(500).send("Error banning user");
        const hideNotesSql = "UPDATE note SET visibility = 'hidden' WHERE uploader_id = ?";
        db.query(hideNotesSql, [uploaderId], (err) => {
            if (err) return res.status(500).send("Error hiding notes");
            const clearReportsSql = `
                UPDATE reports r 
                JOIN note n ON r.note_id = n.note_id 
                SET r.status = 'resolved' 
                WHERE n.uploader_id = ?`;
            db.query(clearReportsSql, [uploaderId], (err) => {
                if (err) return res.status(500).send("Error clearing reports");
                res.redirect('/admin');
            });
        });
    });
});

// (spam reporting)
app.post('/admin/ban-reporter/:userId/:noteId', isAdmin, checkAuthenticated, (req, res) => {
    const reporterId = req.params.userId;
    const noteId = req.params.noteId;
    const sql = "UPDATE user SET status = 'banned' WHERE user_id = ?";
    db.query(sql, [reporterId], (err) => {
        if (err) return res.status(500).send("Error banning user");
        const resolveSql = "UPDATE reports SET status = 'resolved' WHERE reporter_id = ?";
        const restoreSql = "UPDATE note SET visibility = 'public' WHERE note_id = ?";
        db.query(restoreSql, [noteId], (err) => {
            if (err) return res.status(500).send("Error restoring note");
            db.query(resolveSql, [reporterId], (err) => {
                if (err) return res.status(500).send("Error clearing reports");
                res.redirect('/admin');
            });
        });
    });
});
// (Unban User)
app.post('/admin/unban-user/:userId', isAdmin, (req, res) => {
    const userId = req.params.userId;
    const unbanSql = "UPDATE user SET status = 'active' WHERE user_id = ?";
    db.query(unbanSql, [userId], (err) => {
        if (err) return res.status(500).send(err);
        const restoreNotesSql = "UPDATE note SET visibility = 'public' WHERE uploader_id = ?";
        db.query(restoreNotesSql, [userId], (err) => {
            res.redirect('/admin');
        });
    });
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

io.on('connection', (socket) => {
    socket.on('joinRoom', ({ username, userId }) => {
        socket.username = username;
        socket.userId = userId;
    });
    socket.on('chatMessage', (msg) => {
        if (!msg || msg.trim() === "") return;
        const sql = "INSERT INTO messages (sender_id, message_text) VALUES (?, ?)";
        db.query(sql, [socket.userId, msg], (err) => {
            if (err) return console.error("Socket DB Error:", err);
            io.emit('message', { 
                user: socket.username, 
                text: msg 
            });
        });
    });
});

const PORT = process.env.PORT || 3000;
http.listen(PORT, () => {
    console.log(`🚀 Server & Chat running on http://localhost:${PORT}`);
});