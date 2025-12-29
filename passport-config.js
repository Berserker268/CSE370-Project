const passport = require('passport')
const localStrategy = require('passport-local').Strategy
const bcrypt = require('bcrypt')

function initialize(passport, db){
    const authenticateUser = async (email, password, done) =>{
        db.query("SELECT * FROM user WHERE email = ?", [email], async (err,result) =>{
            if(err) return done(err);
            if (result.length === 0) {
                return done(null, false, {message: 'No user with this email'})
            }
            const user = result[0];
            try{
                if(await bcrypt.compare(password, user.password)){
                    return done(null, user)
                }else{
                    return done(null, false, {message: 'Password incorrect'})
                }
            }catch (e){
                return done(e)
            }
        })
    }
    passport.use(new localStrategy({ usernameField: 'email'}, 
    authenticateUser))
    passport.serializeUser((user, done) => done(null, user.user_id))
    passport.deserializeUser((user_id, done) => {
        db.query("SELECT * FROM user where user_id = ?", [user_id], (err,result) =>{
            return done (err, result[0])
        })
    })
}

module.exports = initialize