// First login with temp credentials, then verify a voter
const API = 'http://localhost:3000/api';

async function test() {
  // Step 1: Login with temp credentials
  console.log('1. Logging in with temp credentials...');
  const loginRes = await fetch(`${API}/auth/login-temp`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username: 'VOTER_TEST123', password: 'TESTPASS123' }),
  });
  const loginData = await loginRes.json();
  console.log('Login status:', loginRes.status);
  console.log('Token:', loginData.accessToken?.substring(0, 30) + '...');

  // Step 2: Verify voter
  console.log('\n2. Verifying voter VOT-2026-5837161F...');
  const verifyRes = await fetch(`${API}/students/verify-voter`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${loginData.accessToken}`,
      'X-Tenant-Id': loginData.user?.tenantId || 'default',
    },
    body: JSON.stringify({ voterId: 'VOT-2026-5837161F' }),
  });
  const verifyData = await verifyRes.json();
  console.log('Verify status:', verifyRes.status);
  console.log('Verify response:', JSON.stringify(verifyData, null, 2));

  // Step 3: Get candidates
  console.log('\n3. Getting candidates...');
  const candRes = await fetch(`${API}/students/candidates`, {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${loginData.accessToken}`,
      'X-Tenant-Id': loginData.user?.tenantId || 'default',
    },
  });
  const candData = await candRes.json();
  console.log('Candidates status:', candRes.status);
  console.log('Candidates:', JSON.stringify(candData, null, 2));
}

test().catch(e => console.error('Error:', e.message));
