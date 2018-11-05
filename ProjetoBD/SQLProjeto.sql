--CREATE DATABASE projeto;

CREATE SCHEMA main;

CREATE TABLE main.tb_locais(
  id_local SERIAL,
  nome VARCHAR(40) NOT NULL,
  cidade VARCHAR(40) NOT NULL,
  estado VARCHAR(2) NOT NULL,
  clima VARCHAR(40),
  PRIMARY KEY (id_local)
);

CREATE TABLE main.tb_usuarios(
  id_pessoa SERIAL,
  nome VARCHAR(40) NOT NULL,
  idade INTEGER NOT NULL,
  curso VARCHAR(40),
  PRIMARY KEY (id_pessoa)
);

CREATE TABLE main.tb_medidas(
  id_medida SERIAL,
  temp_ar NUMERIC(4,2),
  umid_ar NUMERIC(4,2),
  umid_solo NUMERIC(4,2),
  luminosidade NUMERIC(4,2),
  id_pessoa INTEGER,
  id_local INTEGER,
  PRIMARY KEY (id_medida),
  FOREIGN KEY (id_pessoa) REFERENCES main.tb_usuarios (id_pessoa),
  FOREIGN KEY (id_local) REFERENCES main.tb_locais (id_local)
);

CREATE TABLE main.tb_log(
  id_log SERIAL,
  horario TIMESTAMP NOT NULL,
  operacao VARCHAR(40) NOT NULL,
  id_pessoa INTEGER,
  id_medida INTEGER,
  id_local INTEGER,
  PRIMARY KEY (id_log)
);

--Stored Procedures

--Registrar Log (operacao, id_pessoa, id_medida, id_local)
--Sem Retorno
CREATE OR REPLACE FUNCTION main.fn_log (
  p_operacao VARCHAR(40),
  p_id_pessoa INTEGER,
  p_id_medida INTEGER,
  p_id_local INTEGER
)
  RETURNS VOID AS
  $$
  DECLARE
    horario_atual TIMESTAMP;
  BEGIN
    SELECT CURRENT_TIMESTAMP INTO horario_atual;
    INSERT INTO main.tb_log
      (horario, operacao, id_pessoa, id_medida, id_local)
    VALUES
      (horario_atual, p_operacao, p_id_pessoa, p_id_medida, p_id_local);
  END
  $$
  LANGUAGE plpgsql;

--Verificar Usuário
--Retorna: '-1 se não encontrado e id se encontrado'
CREATE OR REPLACE FUNCTION main.fn_consulta_usuario (
  p_id_usuario INTEGER
)
  RETURNS INTEGER AS
  $$
  DECLARE
    dados INTEGER;
  BEGIN
    SELECT id_pessoa INTO dados FROM main.tb_usuarios WHERE id_pessoa = $1;
    IF NOT FOUND THEN
      RETURN -1;
    ELSE
      RETURN dados;
    END IF;
  END
  $$
  LANGUAGE plpgsql;

--Inserir Medições (temp_ar, umid_ar, umid_solo, luminosidade, id_pessoa, id_local)
--Retorna: 'Sucesso!'
CREATE OR REPLACE FUNCTION main.fn_inserir_medicoes (
  p_temp_ar NUMERIC(4,2),
  p_umid_ar NUMERIC(4,2),
  p_umid_solo NUMERIC(4,2),
  p_luminosidade NUMERIC(4,2),
  p_id_pessoa INTEGER,
  p_id_local INTEGER
)
  RETURNS TEXT AS
  $$
  DECLARE
    out_id_medida INTEGER;
  BEGIN
    INSERT INTO main.tb_medidas
      (temp_ar, umid_ar, umid_solo, luminosidade, id_pessoa, id_local)
    VALUES
      (p_temp_ar, p_umid_ar, p_umid_solo, p_luminosidade, p_id_pessoa, p_id_local)
    RETURNING
      id_medida INTO out_id_medida;

    PERFORM main.fn_log (
      'INSERT MEDIDA', p_id_pessoa, out_id_medida, p_id_local
    );

    RETURN 'Sucesso!';
  END
  $$
  LANGUAGE plpgsql;

--Deletar Medições (id_medida, id_pessoa, id_local)
--Retorna: 'Sucesso!'
CREATE OR REPLACE FUNCTION main.fn_deletar_medicoes (
  p_id_medida INTEGER,
  p_id_pessoa INTEGER,
  p_id_local INTEGER
)
  RETURNS TEXT AS
  $$
  BEGIN
    DELETE FROM main.tb_medidas WHERE p_id_medida = id_medida;

    PERFORM main.fn_log (
      'DELETE MEDIDA', p_id_pessoa, p_id_medida, p_id_local
    );
  RETURN 'Sucesso';
  END
  $$
  LANGUAGE plpgsql;

--Cadastrar ou Atualizar Usuário (operacao('I' ou 'U'), nome, idade, curso, id_usuario(caso atualizar))
--Retorna: '-1 se erro, 0 se operação nao encontrada e id_pessoa se sucesso'
CREATE OR REPLACE FUNCTION main.fn_usuario (
  p_operacao CHAR,
  p_nome VARCHAR(40),
  p_idade INTEGER,
  p_curso VARCHAR(40),
  p_id_usuario INTEGER
)
  RETURNS INTEGER AS
  $$
  DECLARE
    out_id_usuario INTEGER;
  BEGIN
    IF p_operacao = 'I' THEN
      INSERT INTO main.tb_usuarios (nome, idade, curso)
        VALUES (p_nome, p_idade, p_curso)
        RETURNING id_pessoa INTO out_id_usuario;

      PERFORM main.fn_log (
        'INSERT USUARIO', out_id_usuario, NULL, NULL
      );
      RETURN out_id_usuario;
    ELSIF p_operacao = 'U' THEN
      UPDATE main.tb_usuarios
        SET
          nome = p_nome,
          idade = p_idade,
          curso = p_curso
        WHERE
          id_pessoa = p_id_usuario;

        PERFORM main.fn_log (
          'UPDATE USUARIO', p_id_usuario, NULL, NULL
        );
        RETURN p_id_usuario;
    ELSE
      RETURN 0;
    END IF;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
  END
  $$
  LANGUAGE plpgsql;

--Cadastrar ou Atualizar Local (operacao, id_pessoa, nome, cidade, estado, clima, id_local(caso atualizar))
--Retorna: '-1 se erro, 0 se operação nao encontrada e id_local caso sucesso'
CREATE OR REPLACE FUNCTION main.fn_local (
  p_operacao CHAR,
  p_id_pessoa INTEGER,
  p_nome VARCHAR(40),
  p_cidade VARCHAR(40),
  p_estado VARCHAR(2),
  p_clima VARCHAR(40),
  p_id_local INTEGER
)
  RETURNS INTEGER AS
  $$
  DECLARE
    out_id_local INTEGER;
  BEGIN
    IF p_operacao = 'I' THEN
      INSERT INTO main.tb_locais (nome, cidade, estado, clima)
        VALUES (p_nome, p_cidade, p_estado, p_clima)
        RETURNING id_local INTO out_id_local;

      PERFORM main.fn_log (
        'INSERT LOCAL', p_id_pessoa, NULL, out_id_local
      );
      RETURN out_id_local;

    ELSIF p_operacao = 'U' THEN
      UPDATE main.tb_locais
        SET
          nome = p_nome,
          cidade = p_cidade,
          estado = p_estado,
          clima = p_clima
        WHERE
          id_local = p_id_local;

        PERFORM main.fn_log (
          'UPDATE LOCAL', p_id_pessoa, NULL, p_id_local
        );
        RETURN p_id_local;
    ELSE
      RETURN 0;
    END IF;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
  END
  $$
  LANGUAGE plpgsql;
