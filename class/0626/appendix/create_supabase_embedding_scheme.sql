-- 기존 테이블 삭제 후 UUID 타입으로 재생성
DROP TABLE IF EXISTS public.embeddings CASCADE;

-- UUID 확장 활성화 (이미 활성화되어 있을 수 있음)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 올바른 구조로 테이블 재생성 (id를 UUID로)
CREATE TABLE public.embeddings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  content text NOT NULL,
  metadata jsonb DEFAULT '{}',
  embedding vector(1536) NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- 인덱스 생성
CREATE INDEX embeddings_embedding_cos_ivfflat 
ON public.embeddings 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- RLS 정책 설정
ALTER TABLE public.embeddings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all for anon" ON public.embeddings
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- 검색 함수도 UUID에 맞게 수정
drop function if exists match_embeddings;
CREATE OR REPLACE FUNCTION match_embeddings(
    query_embedding VECTOR(1536),
    match_count INTEGER DEFAULT 5,
    filter JSONB DEFAULT '{}'
)
RETURNS TABLE (
    id UUID,
    content TEXT,
    metadata JSONB,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        embeddings.id,
        embeddings.content,
        embeddings.metadata,
        1 - (embeddings.embedding <=> query_embedding) AS similarity
    FROM embeddings
    WHERE embeddings.metadata @> filter
    ORDER BY embeddings.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;