import { useState, useEffect } from 'react'
import Head from 'next/head'
import Nav from '../components/Nav'

export default function Dashboard() {
  const [stats, setStats] = useState({ total: 0, active: 0, registered: 0 })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const token = localStorage.getItem('admin_token')
    if (!token) { window.location.href = '/login'; return }
    fetch('http://localhost:8000/admin/donors')
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

  if (loading) return <div className="loading">Loading...</div>

  return (
    <div>
      <Head><title>Dashboard - Chuadanga Blood Bank</title></Head>
      <Nav />
      <div className="container">
        <h2 style={{ marginBottom: 24 }}>Dashboard</h2>
        <div className="grid-2">
          <div className="card stat-card">
            <div className="stat-number">{stats.total}</div>
            <div className="stat-label">Total Donors</div>
          </div>
          <div className="card stat-card">
            <div className="stat-number">{stats.active}</div>
            <div className="stat-label">Active Donors</div>
          </div>
        </div>
        <div className="card" style={{ marginTop: 20 }}>
          <h3 style={{ marginBottom: 16 }}>Quick Actions</h3>
          <div style={{ display: 'flex', gap: 12 }}>
            <a href="/register" className="btn btn-primary">Register New Donor</a>
            <a href="/donors" className="btn btn-secondary">View All Donors</a>
          </div>
        </div>
      </div>
    </div>
  )
}
