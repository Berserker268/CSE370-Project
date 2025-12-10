import { Routes, Route, Navigate } from 'react-router-dom'
import Login from './components/Login'
import Register from './components/Register'
import Home from './components/Home'
import { useState } from 'react'

function App() {
  const [user, setUser] = useState(null)

  return (
    <Routes>
      <Route path="/" element={user ? <Home user={user} setUser={setUser} /> : <Navigate to="/login" />} />
      <Route path="/login" element={<Login setUser={setUser} />} />
      <Route path="/register" element={<Register />} />
    </Routes>
  )
}

export default App
