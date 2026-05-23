import { config } from 'dotenv';
config({ path: '.env.local', quiet: true });
import { neon } from '@neondatabase/serverless';

/** dotenv / 手入力でよくある余分な引用符・BOM を除いた接続文字列 */
function normalizeDatabaseUrl(raw: string | undefined): string {
  if (raw == null) return '';
  let s = raw.trim().replace(/^\uFEFF/, '');
  const pairs: [string, string][] = [
    ['"', '"'],
    ["'", "'"],
    ['\u201c', '\u201d'],
    ['\u2018', '\u2019'],
  ];
  for (const [open, close] of pairs) {
    if (s.startsWith(open) && s.endsWith(close) && s.length > 1) {
      s = s.slice(open.length, -close.length).trim();
    }
  }
  return s;
}

async function migrate() {
  const url = normalizeDatabaseUrl(process.env.DATABASE_URL);
  if (!url) {
    console.error('DATABASE_URL is not set. Add it to .env.local');
    process.exit(1);
  }
  if (!/^postgres(ql)?:\/\//i.test(url)) {
    console.error(
      'DATABASE_URL must start with postgresql:// or postgres://\n' +
        'Check .env.local: one line, no line breaks inside the URL, copy the value from Vercel as-is.',
    );
    process.exit(1);
  }

  const sql = neon(url);

  await sql`
    CREATE TABLE IF NOT EXISTS comments (
      id TEXT PRIMARY KEY,
      author TEXT NOT NULL,
      type TEXT NOT NULL DEFAULT 'comment',
      quote TEXT NOT NULL DEFAULT '',
      quote_context_before TEXT NOT NULL DEFAULT '',
      quote_context_after TEXT NOT NULL DEFAULT '',
      content TEXT NOT NULL DEFAULT '',
      priority TEXT NOT NULL DEFAULT 'want',
      parent_id TEXT,
      resolved BOOLEAN NOT NULL DEFAULT false,
      resolved_by TEXT,
      resolved_at BIGINT,
      timestamp BIGINT NOT NULL,
      updated_at BIGINT,
      page_url TEXT NOT NULL,
      project_slug TEXT NOT NULL
    )
  `;

  await sql`CREATE INDEX IF NOT EXISTS idx_comments_project ON comments (project_slug)`;
  await sql`CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments (parent_id)`;

  console.log('Migration complete.');
}

migrate().catch((e) => {
  console.error('Migration failed:', e);
  process.exit(1);
});
