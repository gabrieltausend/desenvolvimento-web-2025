CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    senha_hash TEXT NOT NULL,
    papel SMALLINT NOT NULL CHECK (papel IN (0, 1)), -- 0=cliente, 1=estagiario
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NOT NULL
);

CREATE TABLE mensagens_chat (
    id SERIAL PRIMARY KEY,
    chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
    erro TEXT NOT NULL,
    texto TEXT NOT NULL
);

CREATE TABLE reunioes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    data_criacao TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NOT NULL
);

CREATE TABLE registros_reuniao (
    id SERIAL PRIMARY KEY,
    reuniao_id UUID NOT NULL REFERENCES reunioes(id) ON DELETE CASCADE,
    erro TEXT NOT NULL
);

CREATE TABLE repositorios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    data_criacao TIMESTAMP NOT NULL
);

CREATE TABLE arquivos_repositorio (
    id SERIAL PRIMARY KEY,
    repositorio_id UUID NOT NULL REFERENCES repositorios(id) ON DELETE CASCADE,
    nome TEXT NOT NULL,
    erro TEXT NOT NULL
);

INSERT INTO usuarios (nome, email, senha_hash, papel)
VALUES ('Anderson', 'estag@ac.com', 'senhaex123hash', 1);

INSERT INTO chats (usuario_id, data_inicio, data_fim)
VALUES (
    1,
    '2025-08-20 14:35',
    '2025-08-20 15:50'
);

INSERT INTO mensagens_chat (chat_id, erro, texto)
VALUES (
    '8f3a0000-0000-0000-0000-000000000001', -- substitua com o UUID real do chat
    'Erro ao compilar',
    'Boa tarde'
);

INSERT INTO reunioes (id, usuario_id, data_criacao, data_fim)
VALUES (
    '8f3a0000-0000-0000-0000-000000000002',
    1,
    '2025-08-20 17:30',
    '2025-08-20 18:40'
);

INSERT INTO registros_reuniao (reuniao_id, erro)
VALUES (
    '8f3a0000-0000-0000-0000-000000000002',
    'Erro ao compilar'
);

SELECT 
    u.nome AS usuario,
    c.id AS chat_id,
    c.data_inicio,
    c.data_fim,
    m.texto,
    m.erro
FROM mensagens_chat m
JOIN chats c ON m.chat_id = c.id
JOIN usuarios u ON c.usuario_id = u.id
ORDER BY c.data_inicio;