const { Client } = require('pg');
const c = new Client({
  host: 'localhost',
  port: 5432,
  user: 'sims',
  password: 'sims_password',
  database: 'sims'
});
c.connect()
  .then(() => c.query(`SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'students' ORDER BY ordinal_position`))
  .then(r => {
    console.log('Columns in students table:');
    r.rows.forEach(row => console.log(`  ${row.column_name} (${row.data_type})`));
    return c.query('SELECT "voterId", "voter_id", "tenantId", "tenant_id" FROM students LIMIT 3');
  })
  .then(r => {
    console.log('\nSample data with both naming styles:');
    console.log(JSON.stringify(r.rows, null, 2));
    c.end();
  })
  .catch(e => {
    console.error('Error:', e.message);
    c.end();
  });
