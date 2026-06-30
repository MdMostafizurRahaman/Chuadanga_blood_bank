import { useState, useEffect } from 'react'
import Head from 'next/head'
import Nav from '../components/Nav'

const API = process.env.NEXT_PUBLIC_API_URL

export default function Dashboard() {
  const [stats, setStats] = useState({ total: 0, active: 0, registered: 0 })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const token = localStorage.getItem('admin_token')
    if (!token) { window.location.href = '/login'; return }
    fetch(`${API}/admin/donors`)
      .then(res => res.json())
      .then(data => {
        setStats({
          total: data.length,
          active: data.filter(d => d.status === 'active').length,
          registered: data.filter(d => d.is_registered).length
        })
        setLoading(false)
      })
      .catch(() => setLoading(false))
  }, [])

  if (loading) return <div className="loading">লোড হচ্ছে...</div>

  return (
    <div>
      <Head><title>ড্যাশবোর্ড - Chuadanga Blood Bank</title></Head>
      <Nav />
      <div className="container">
        <h2 style={{ marginBottom: 24 }}>ড্যাশবোর্ড</h2>
        <div className="grid-2">
          <div className="card stat-card">
            <div className="stat-number">{stats.total}</div>
            <div className="stat-label">মোট ডোনার</div>
          </div>
          <div className="card stat-card">
            <div className="stat-number">{stats.active}</div>
            <div className="stat-label">সক্রিয় ডোনার</div>
          </div>
        </div>
        <div className="card" style={{ marginTop: 20 }}>
          <h3 style={{ marginBottom: 16 }}>দ্রুত কার্যক্রম</h3>
          <div style={{ display: 'flex', gap: 12 }}>
            <a href="/register" className="btn btn-primary">নতুন ডোনার নিবন্ধন</a>
            <a href="/donors" className="btn btn-secondary">সব ডোনার দেখুন</a>
          </div>
        </div>
      </div>
    </div>
  )
}
