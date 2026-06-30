import { useRouter } from 'next/router'
import { useState, useEffect } from 'react'

export default function Nav() {
  const router = useRouter()
  const [name, setName] = useState('')

  useEffect(() => {
    setName(localStorage.getItem('admin_name') || '')
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_name')
    router.push('/login')
  }

  const links = [
    { href: '/', label: 'ড্যাশবোর্ড' },
    { href: '/register', label: 'ডোনার নিবন্ধন' },
    { href: '/donors', label: 'ডোনার তালিকা' },
  ]

  return (
    <nav className="nav">
      <div className="nav-inner">
        <div className="nav-brand">🩸 Chuadanga Blood Bank</div>
        <div className="nav-links">
          {links.map(link => (
            <a key={link.href} href={link.href} className={router.pathname === link.href ? 'active' : ''}>
              {link.label}
            </a>
          ))}
          <span style={{ color: '#999', padding: '8px 0' }}>|</span>
          <span style={{ color: '#666', padding: '8px 0' }}>{name}</span>
          <button onClick={handleLogout} className="btn btn-danger" style={{ padding: '6px 16px', fontSize: 14 }}>লগআউট</button>
        </div>
      </div>
    </nav>
  )
}
