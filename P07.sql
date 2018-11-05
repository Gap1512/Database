--Triggers

CREATE TABLE sch01.tb_empregados (
  nome VARCHAR NOT NULL,
  salario NUMERIC
);

CREATE TABLE sch01.tb_empregados_auditoria (
  operacao CHAR      NOT NULL,
  usuario  VARCHAR   NOT NULL,
  dt_hr    TIMESTAMP NOT NULL,
  nome     VARCHAR   NOT NULL,
  salario  NUMERIC
);

CREATE TRIGGER tg_empregados_auditoria
  AFTER INSERT OR UPDATE OR DELETE ON sch01.tb_empregados
  FOR EACH ROW EXECUTE PROCEDURE sch01.fn_empregado_auditoria();

CREATE OR REPLACE FUNCTION sch01.fn_empregado_auditoria()
  RETURNS TRIGGER AS
  $$
    BEGIN
      IF (tg_op = 'DELETE') THEN
        INSERT INTO sch01.tb_empregados_auditoria
        SELECT 'E', user, now(), OLD.*;
        RETURN OLD;
      ELSIF  (tg_op = 'UPDATE') THEN
        INSERT INTO sch01.tb_empregados_auditoria
        SELECT 'A', user, now(), NEW.*;
        RETURN NEW;
      ELSIF  (tg_op = 'INSERT') THEN
        INSERT INTO sch01.tb_empregados_auditoria
        SELECT 'I', user, now(), NEW.*;
        RETURN NEW;
      END IF;
      RETURN NULL;
    END
  $$
  LANGUAGE plpgsql;

INSERT INTO sch01.tb_empregados(nome, salario)
  VALUES
  ('João', 1500.98),
  ('Pedro', 3452.76),
  ('Marta', 3745.65);

SELECT * FROM sch01.tb_empregados_auditoria;

UPDATE sch01.tb_empregados SET nome = 'João Alterado'
  WHERE salario = 1500.98;

DELETE FROM sch01.tb_empregados WHERE nome = 'João Alterado';
