CREATE OR REPLACE FUNCTION sch01.fn_ret_nome_cliente_tupla (integer)
  RETURNS varchar AS
  $$
    DECLARE
      v_tupla sch01.tb_cliente%ROWTYPE;
    BEGIN
      SELECT * INTO v_tupla FROM sch01.tb_cliente
      WHERE id_cliente = $1;
      RETURN 'Tupla (linha): ' || v_tupla;
    END
  $$
  LANGUAGE plpgsql;

SELECT sch01.fn_ret_nome_cliente_tupla(2);

CREATE OR REPLACE FUNCTION sch01.fn_ret_nome_cliente_record (sch01.tb_cliente.id_cliente%TYPE)
  RETURNS text AS
  $$
    DECLARE
      v_linha RECORD;
    BEGIN
      SELECT * INTO v_linha FROM sch01.tb_cliente WHERE id_cliente = $1;
      IF NOT FOUND THEN
        RAISE EXCEPTION 'Cliente % não encontrado', $1;
      ELSE
        RETURN 'Cliente Encontrado!';
      END IF;
    END
  $$
  LANGUAGE plpgsql;

SELECT sch01.fn_ret_nome_cliente_record(2);

CREATE TABLE sch01.tb_log(
nome	VARCHAR(30),
data_hora	TIMESTAMP
);

CREATE OR REPLACE FUNCTION sch01.fn_log(pNome varchar) RETURNS TIMESTAMP AS
$$
  BEGIN
    INSERT INTO sch01.tb_log VALUES (pNome, now());
    RETURN now();
  END
$$
LANGUAGE plpgsql;

SELECT sch01.fn_log('Joao')

CREATE OR REPLACE FUNCTION sch01.fn_loop_basico() RETURNS VOID AS
$$
  DECLARE
    v_contador INTEGER;
  BEGIN
    v_contador := 0;
    LOOP
      v_contador := v_contador + 1;
      RAISE NOTICE 'Contador: %',v_contador;
      EXIT WHEN v_contador > 20;
    END LOOP;
    RETURN;
  END
$$
LANGUAGE plpgsql;

SELECT sch01.fn_loop_basico();

CREATE TABLE sch01.tb_categoria (
  id_categoria  SERIAL,
  ds_categoria  VARCHAR(40) NOT NULL,
  fg_ativo      INTEGER NOT NULL,
  PRIMARY KEY (id_categoria)
);

CREATE OR REPLACE FUNCTION sch01.fn_categoria(
  p_id_categoria INTEGER,
  p_descricao VARCHAR,
  p_flag INTEGER,
  p_opcao CHAR) RETURNS INTEGER AS
  $$
    BEGIN
      IF p_opcao = 'I' THEN
        INSERT INTO sch01.tb_categoria (ds_categoria, fg_ativo)
          VALUES (p_descricao, p_flag);
        RETURN 1;
      ELSIF p_opcao = 'U' THEN
        UPDATE sch01.tb_categoria
          SET ds_categoria = p_descricao
          WHERE id_categoria = p_id_categoria;
        RETURN 3;
      ELSIF p_opcao = 'D' THEN
        DELETE FROM sch01.tb_categoria
          WHERE id_categoria = p_id_categoria;
        RETURN 0;
      ELSE
        RETURN 2;
      END IF;
      EXCEPTION WHEN OTHERS THEN RETURN -1;
    END
  $$
LANGUAGE plpgsql;

SELECT sch01.fn_categoria(NULL, 'Categoria 3', 1, 'I');
SELECT sch01.fn_categoria(1, 'Categoria 1 - U', 1, 'U');
SELECT sch01.fn_categoria(1, NULL, NULL, 'D');
SELECT * FROM sch01.tb_categoria;
