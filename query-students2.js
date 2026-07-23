const { Client } = require('pg');
const c = new Client({
  host: 'localhost',
  port: 5432,
  user: 'sims',
  password: 'sims_password',
  database: 'sims'
});
c.connect()
  .then(() => c.query(`SELECT "voterId", "tenantId", "firstName", "lastName" FROM students WHERE "voterId" = $1 AND "tenantId" = $2`, ['VOT-2026-5837161F', 'tenant-001']))
  .then(r => {
    console.log('Direct SQL query result:');
    console.log(JSON.stringify(r.rows, null, 2));
    console.log('Row count:', r.rowCount);
    
    // Also check for any hidden characters in voterId
    return c.query(`SELECT "voterId", length("voterId") as len, encode("voterId"::bytea, 'hex') as hex FROM students WHERE "voterId" LIKE 'VOT-2026-5837%' LIMIT 3`);
  })
  .then(r => {
    console.log('\nVoter ID details (checking for hidden chars):');
    r.rows.forEach(row => {
      console.log(`  voterId: "${row.voterId}" (length: ${row.len})`);
      console.log(`  hex: ${row.hex}`);
    });
    c.end();
  })
  .catch(e => {
    console.error('Error:', e.message);
    c.end();
  });
