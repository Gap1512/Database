--Stored Procedure

--Declaração da Função
CREATE OR REPLACE FUNCTION sch01.fn_teste(real) RETURNS real AS
$$
  BEGIN
    RETURN $1 * 0.5;
  END
$$
LANGUAGE plpgsql;

--Chamada da Função
SELECT sch01.fn_teste(5);

--Declaração da Função 2
CREATE OR REPLACE FUNCTION sch01.fn_teste2(real) RETURNS real AS
$$
  DECLARE
    v_var1 ALIAS FOR $1
  BEGIN
    RETURN v_var1 * 0.5;
  END
$$
LANGUAGE plpgsql;

--Chamada da Função 2
SELECT sch01.fn_teste2(5);

--Declaração da Função 3
CREATE OR REPLACE FUNCTION sch01.fn_soma(real, real) RETURNS real AS
$$
  DECLARE
    v_var1 ALIAS FOR $1;
    v_var2 ALIAS FOR $2;
  BEGIN
    RETURN v_var1 + v_var2;
  END
$$
LANGUAGE plpgsql;

--Chamada da Função 3
SELECT sch01.fn_soma(2.1, -7);

--Declaração da Função 4
CREATE OR REPLACE FUNCTION sch01.fn_soma2(pvar1 real, pvar2 real) RETURNS real AS
$$
  BEGIN
    RETURN pvar1 + pvar2;
  END
$$
LANGUAGE plpgsql;

--Chamada da Função 4
SELECT sch01.fn_soma2(2.1, -7);

--Declaração da Função 5
CREATE OR REPLACE FUNCTION sch01.fn_soma3(pvar1 real, pvar2 real) RETURNS VARCHAR AS
$$
  BEGIN
    RETURN 'Resultado --> ' || (pvar1 + pvar2);
  END
$$
LANGUAGE plpgsql;

--Chamada da Função 5
SELECT sch01.fn_soma3(2.1, -7);

--Declaração da Função 6
CREATE OR REPLACE FUNCTION sch01.fn_ret_nome_cliente(integer) RETURNS VARCHAR AS
$$
  DECLARE
    v_nome sch01.tb_cliente.nome%TYPE;
  BEGIN
    SELECT nome INTO v_nome FROM sch01.tb_cliente
      WHERE id_cliente = $1;
    RETURN 'Nome do Cliente: ' || v_nome;
  END
$$
LANGUAGE plpgsql;

--Chamada da Função 6
SELECT sch01.fn_ret_nome_cliente(5);

--Declaração da Função 7
CREATE OR REPLACE FUNCTION sch01.fn_ret_nome_cliente2(integer) RETURNS VARCHAR AS
$$
  DECLARE
    v_nome sch01.tb_cliente.nome%TYPE;
  BEGIN
    SELECT nome INTO v_nome FROM sch01.tb_cliente
      WHERE id_cliente = $1;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Cliente % nao encontrado', $1;
    ELSE
    RETURN 'Nome do Cliente: ' || v_nome;
    END IF;
  END
$$
LANGUAGE plpgsql;

--Chamada da Função 7
SELECT sch01.fn_ret_nome_cliente2(1000);
