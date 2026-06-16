import Head from 'next/head'

export default function Dashboard() {
  return (
    <div>
      <Head>
        <title>Admin Dashboard - Blood Bank</title>
      </Head>
      <main style={{ padding: '20px', fontFamily: 'sans-serif' }}>
        <h1>Admin Dashboard</h1>
        <div style={{ display: 'flex', gap: '20px' }}>
          <div style={{ border: '1px solid #ccc', padding: '20px', borderRadius: '8px' }}>
            <h3>Total Donors</h3>
            <p>150</p>
          </div>
          <div style={{ border: '1px solid #ccc', padding: '20px', borderRadius: '8px' }}>
            <h3>Pending Applications</h3>
            <p>5</p>
          </div>
        </div>
      </main>
    </div>
  )
}
