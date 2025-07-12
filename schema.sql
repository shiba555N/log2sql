/*
 * ログから抽出したSQLクエリの情報を格納するためのテーブル定義
 */

-- 抽出した個々のSQLクエリを時系列で保存するテーブル
CREATE TABLE IF NOT EXISTS query_logs (
    id SERIAL PRIMARY KEY,                -- 主キー（自動採番）
    executed_at TIMESTAMPTZ NOT NULL,     -- クエリの実行時刻（タイムゾーン付き）
    query_sql TEXT NOT NULL,              -- 実行されたSQL文の全文
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP -- このレコードの作成時刻
);

COMMENT ON TABLE query_logs IS 'ログから抽出した個々のSQLクエリの実行履歴';
COMMENT ON COLUMN query_logs.id IS 'シリアルID';
COMMENT ON COLUMN query_logs.executed_at IS 'ログに記録されたクエリの実行時刻';
COMMENT ON COLUMN query_logs.query_sql IS 'パラメータが埋め込まれた後の完全なSQL文';
COMMENT ON COLUMN query_logs.created_at IS 'このレコードがデータベースに登録された時刻';


-- SQLクエリのパターンと出現回数を格納するテーブル
CREATE TABLE IF NOT EXISTS query_patterns (
    id SERIAL PRIMARY KEY,                -- 主キー（自動採番）
    pattern_sql TEXT NOT NULL UNIQUE,     -- 正規化されたSQLパターン（例: SELECT * FROM users WHERE id = ?）
    occurrence_count INTEGER NOT NULL DEFAULT 1, -- このパターンが出現した回数
    first_seen TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP, -- このパターンが最初に現れた時刻
    last_seen TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP  -- このパターンが最後に現れた時刻
);

COMMENT ON TABLE query_patterns IS 'SQLクエリのユニークなパターンと統計情報';
COMMENT ON COLUMN query_patterns.id IS 'シリアルID';
COMMENT ON COLUMN query_patterns.pattern_sql IS 'パラメータを?などに正規化したSQLパターン文字列';
COMMENT ON COLUMN query_patterns.occurrence_count IS 'このパターンがログ内で出現した合計回数';
COMMENT ON COLUMN query_patterns.first_seen IS 'このパターンが最初に観測された時刻';
COMMENT ON COLUMN query_patterns.last_seen IS 'このパターンが最後に観測された時刻';

