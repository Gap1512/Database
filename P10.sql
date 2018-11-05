CREATE TEMP TABLE tb_bkp_cli
AS SELECT * FROM sch01.tb_cliente;

SELECT * FROM sch01.tb_bkp_cli;

CREATE TABLE sch01.tb_exemplo_csv (
  id_cliente INTEGER,
  nm_cliente VARCHAR(50),
  sobrenome  VARCHAR(50),
  idade      INTEGER
)

COPY sch01.tb_exemplo_csv FROM
  '/home/gap1512/pCloudDrive/UFU/Banco de Dados/P10.csv'
  USING DELIMITERS ';' CSV HEADER

CREATE DATABASE bkp05112018;

-- pg_dump (cria backup)

-- pg_restore (restaura backup)

-- pg_dump -U postgres -W -F -t banco_de_dados > computacao.tar

-- pg_restore --host localhost --port 5432 --username "postgres" --dbname "bkp05112018" --role "postgres"
-- --no-password --verbose "computacao.tar"
