import { useState } from 'react'
import Head from 'next/head'

const API = process.env.NEXT_PUBLIC_API_URL

export default function Login() {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')

  const handleLogin = async (e) => {
    e.preventDefault()
    setError('')
    try {
      const res = await fetch(`${API}/admin/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.detail || 'লগইন ব্যর্থ হয়েছে')
      localStorage.setItem('admin_token', data.token)
      localStorage.setItem('admin_name', data.name)
      window.location.href = '/'
    } catch (err) {
      setError(err.message)
    }
  }

  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#f0f2f5' }}>
      <Head><title>অ্যাডমিন লগইন - Chuadanga Blood Bank</title></Head>
      <div className="card" style={{ width: 400, padding: 40 }}>
        <div style={{ textAlign: 'center', marginBottom: 30 }}>
          <div style={{ fontSize: 48, marginBottom: 8 }}>🩸</div>
          <h1 style={{ color: '#e74c3c', marginBottom: 4 }}>অ্যাডমিন লগইন</h1>
          <p style={{ color: '#666' }}>Chuadanga Blood Bank</p>
        </div>
        {error && <div className="alert alert-error">{error}</div>}
        <form onSubmit={handleLogin}>
          <div style={{ marginBottom: 16 }}>
            <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>ইউজারনেম</label>
            <input className="input" type="text" value={username} onChange={(e) => setUsername(e.target.value)} required />
          </div>
          <div style={{ marginBottom: 24 }}>
            <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>পাসওয়ার্ড</label>
            <input className="input" type="password" value={password} onChange={(e) => setPassword(e.target.value)} required />
          </div>
          <button className="btn btn-primary" style={{ width: '100%' }} type="submit">লগইন</button>
        </form>
      </div>
    </div>
  )
}
