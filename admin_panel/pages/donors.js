import { useState, useEffect } from 'react'
import Head from 'next/head'
import Nav from '../components/Nav'

const API = process.env.NEXT_PUBLIC_API_URL

export default function Donors() {
  const [donors, setDonors] = useState([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [filterBg, setFilterBg] = useState('')

  useEffect(() => {
    if (!localStorage.getItem('admin_token')) { window.location.href = '/login'; return }
    loadDonors()
  }, [])

  const loadDonors = async () => {
    try {
      const res = await fetch(`${API}/admin/donors`)
      const data = await res.json()
      setDonors(data)
    } catch (err) {
      console.error(err)
    }
    setLoading(false)
  }

  const handleDelete = async (phone) => {
    if (!confirm('এই ডোনারটি মুছে ফেলবেন?')) return
    try {
      await fetch(`${API}/admin/donors/${phone}`, { method: 'DELETE' })
      loadDonors()
    } catch (err) {
      console.error(err)
    }
  }

  const filtered = donors.filter(d => {
    const matchSearch = !search || d.name.toLowerCase().includes(search.toLowerCase()) || d.phone.includes(search)
    const matchBg = !filterBg || d.blood_group === filterBg
    return matchSearch && matchBg
  })

  if (loading) return <div className="loading">লোড হচ্ছে...</div>

  return (
    <div>
      <Head><title>ডোনার তালিকা - Chuadanga Blood Bank</title></Head>
      <Nav />
      <div className="container">
        <h2 style={{ marginBottom: 24 }}>সব ডোনার</h2>
        <div className="card">
          <div style={{ display: 'flex', gap: 12, marginBottom: 20 }}>
            <input className="input" placeholder="নাম বা ফোন দিয়ে খুঁজুন..." value={search} onChange={(e) => setSearch(e.target.value)} style={{ flex: 1 }} />
            <select className="select" value={filterBg} onChange={(e) => setFilterBg(e.target.value)} style={{ width: 150 }}>
              <option value="">সব গ্রুপ</option>
              {['A+','A-','B+','B-','AB+','AB-','O+','O-'].map(bg => <option key={bg} value={bg}>{bg}</option>)}
            </select>
          </div>
          {filtered.length === 0 ? (
            <p style={{ textAlign: 'center', color: '#666', padding: 40 }}>কোনো ডোনার পাওয়া যায়নি</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>নাম</th>
                  <th>ফোন</th>
                  <th>ব্লাড গ্রুপ</th>
                  <th>উপজেলা</th>
                  <th>ঠিকানা</th>
                  <th>স্ট্যাটাস</th>
                  <th>অ্যাকশন</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map(d => (
                  <tr key={d.phone}>
                    <td><strong>{d.name}</strong></td>
                    <td>{d.phone}</td>
                    <td><span className="badge badge-active">{d.blood_group}</span></td>
                    <td>{d.upazila}</td>
                    <td>{d.address}</td>
                    <td><span className={`badge ${d.status === 'active' ? 'badge-active' : 'badge-inactive'}`}>{d.status}</span></td>
                    <td><button className="btn btn-danger" style={{ padding: '6px 12px', fontSize: 13 }} onClick={() => handleDelete(d.phone)}>মুছে ফেলুন</button></td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  )
}
