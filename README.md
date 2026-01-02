📝 OnlyNotes | Real-Time Academic Note Sharing

OnlyNotes is a full-stack community platform designed for students to upload, share, and discover academic notes. It features a gamified experience where users earn ranks based on community engagement and a real-time global study room for collaboration.

🚀 Features

🎓 For Students

Note Management: Upload notes with specialized tags for easy discoverability.

Engagement System: Like/Save notes to build your personal dashboard and support other authors.

Gamified Ranks: Progress through levels (New → Active → Skilled → Pro → Expert → Master) based on points earned from upvotes.

Real-time Global Chat: A Socket.io-powered "Global Study Room" to discuss topics with everyone online instantly.

Leaderboard: Track the top contributors in the community based on total points.

🛡️ For Administrators

Moderation Queue: Review reported notes that are automatically hidden from the public feed upon reporting.

User Management: Ban/Unban users for community violations (spam reporting or bad content).

Auto-Cleanup: Advanced database logic to remove "orphan" tags and resolve reports permanently.

Secure Access: Strict Role-Based Access Control (RBAC) ensuring admins stay in the command center and students in the portal.

🛠️ Tech Stack

Frontend: EJS (Embedded JavaScript Templates), CSS3, FontAwesome.

Backend: Node.js, Express.js.

Real-time: Socket.io.

Database: MySQL (Relational schema with Many-to-Many relationships).

Authentication: Passport.js (Local Strategy), Bcrypt (Password Hashing).

📋 Database Schema

The project uses a structured MySQL database including:

user: Profiles, ranks, and authentication data.

note: Content storage with visibility states.

tag & note_tag: Many-to-many relationship for categorizing content.

messages: Persistent storage for the Global Chat history.

reports: Tracking and resolving community moderation issues.
