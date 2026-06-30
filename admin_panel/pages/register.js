import { useState, useEffect } from 'react'
import Head from 'next/head'
import Nav from '../components/Nav'

const API = process.env.NEXT_PUBLIC_API_URL

const BLOOD_GROUPS = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
const UPAZILAS = ['Chuadanga Sadar', 'Alamdanga', 'Damurhuda', 'Jibannagar']

export default function Register() {
  const [form, setForm] = useState({ name: '', phone: '', blood_group: '', upazila: '', address: '', photo_url: '' })
  const [message, setMessage] = useState({ type: '', text: '' })
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (!localStorage.getItem('admin_token')) window.location.href = '/login'
  }, [])

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

  const handleSubmit = async (e) => {
    e.preventDefault()
    setSubmitting(true)
    setMessage({ type: '', text: '' })
    try {
      const res = await fetch(`${API}/admin/register-donor`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form)
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.detail || 'নিবন্ধন ব্যর্থ হয়েছে')
      setMessage({ type: 'success', text: `ডোনার নিবন্ধিত হয়েছে! ফোন: ${data.phone}` })
      setForm({ name: '', phone: '', blood_group: '', upazila: '', address: '', photo_url: '' })
    } catch (err) {
      setMessage({ type: 'error', text: err.message })
    }
    setSubmitting(false)
  }

  return (
    <div>
      <Head><title>ডোনার নিবন্ধন - Chuadanga Blood Bank</title></Head>
      <Nav />
      <div className="container">
        <div className="card" style={{ maxWidth: 600, margin: '0 auto' }}>
          <h2 style={{ marginBottom: 24, textAlign: 'center', color: '#e74c3c' }}>নতুন ডোনার নিবন্ধন</h2>
          {message.text && <div className={`alert alert-${message.type}`}>{message.text}</div>}
          <form onSubmit={handleSubmit}>
            <div style={{ marginBottom: 16 }}>
              <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>পুরো নাম</label>
              <input className="input" name="name" value={form.name} onChange={handleChange} required />
            </div>
            <div style={{ marginBottom: 16 }}>
              <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>ফোন নম্বর</label>
              <input className="input" name="phone" value={form.phone} onChange={handleChange} placeholder="যেমন: 017XXXXXXXX" required />
            </div>
            <div className="grid-2">
              <div style={{ marginBottom: 16 }}>
                <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>ব্লাড গ্রুপ</label>
                <select className="select" name="blood_group" value={form.blood_group} onChange={handleChange} required>
                  <option value="">নির্বাচন করুন</option>
                  {BLOOD_GROUPS.map(bg => <option key={bg} value={bg}>{bg}</option>)}
                </select>
              </div>
              <div style={{ marginBottom: 16 }}>
                <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>উপজেলা</label>
                <select className="select" name="upazila" value={form.upazila} onChange={handleChange} required>
                  <option value="">Select</option>
                  {UPAZILAS.map(u => <option key={u} value={u}>{u}</option>)}
                </select>
              </div>
            </div>
            <div style={{ marginBottom: 16 }}>
              <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>ঠিকানা</label>
              <textarea className="input" name="address" value={form.address} onChange={handleChange} rows="2" required></textarea>
            </div>
            <div style={{ marginBottom: 24 }}>
              <label style={{ display: 'block', marginBottom: 6, fontWeight: 500 }}>ফটো URL (ঐচ্ছিক)</label>
              <input className="input" name="photo_url" value={form.photo_url} onChange={handleChange} placeholder="https://..." />
            </div>
            <button className="btn btn-primary" style={{ width: '100%' }} type="submit" disabled={submitting}>
              {submitting ? 'নিবন্ধন হচ্ছে...' : 'ডোনার নিবন্ধন'}
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
