export default function Home({ user, setUser }) {
  return (
    <div className="container">
      <h2>Welcome, {user.name}!</h2>
      <p style={{textAlign: 'center'}}>You are logged in.</p>
      <button onClick={() => setUser(null)} style={{marginTop: '1rem', width: '100%'}}>
        Logout
      </button>
    </div>
  )
}
