/******************************************************************************/
/***                          Confinamento Tabelas                           ***/
/******************************************************************************/
CREATE GENERATOR GEN_RACAO_ID;
CREATE TABLE RACAO (
    ID                  INTEGER NOT NULL,
    TIPO                INTEGER NOT NULL,
    NOME                VARCHAR(100) NOT NULL,
    GMD                 NUMERIC(15,3),
    MATERIASECA         NUMERIC(15,3),
    STATUS              INTEGER DEFAULT 1 NOT NULL,
    DATAREGISTRO        TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    IDUSUARIO           INTEGER NOT NULL,
    DATAALTERACAO       TIMESTAMP,
    IDUSUARIOALTERACAO  INTEGER,
    VALORKG             NUMERIC(15,3),
    DATAFORMULACAO      DATE NOT NULL,
    ID_PROPRIEDADE      INTEGER NOT NULL
);
ALTER TABLE RACAO ADD CONSTRAINT RACAO_PKEY PRIMARY KEY (ID);
ALTER TABLE RACAO ADD CONSTRAINT FK_RACAO_1 FOREIGN KEY (ID_PROPRIEDADE) REFERENCES PROPRIEDADES (ID) ON DELETE CASCADE ON UPDATE CASCADE;

SET TERM ^ ;
/* Trigger: RACAO_BI */
CREATE OR ALTER TRIGGER RACAO_BI FOR RACAO
ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_racao_id,1);
end
^
SET TERM ; ^



CREATE GENERATOR GEN_RACAOINSUMOS_ID;
CREATE TABLE RACAOINSUMOS (
    ID                      INTEGER NOT NULL,
    IDRACAO                 INTEGER NOT NULL,
    IDINSUMOALIMENTO        INTEGER NOT NULL,
    PERCENTMATERIASECA      NUMERIC(15,3) NOT NULL,
    KGMATERIASECA           NUMERIC(15,3) NOT NULL,
    INCLUSAOMATERIASECA     NUMERIC(15,3),
    INCLUSAOMATERIANATURAL  NUMERIC(15,3),
    VALORKG                 NUMERIC(15,3) NOT NULL,
    VALORINCLUSAO           NUMERIC(15,3),
    STATUS                  INTEGER DEFAULT 1 NOT NULL,
    DATAREGISTRO            TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    IDUSUARIO               INTEGER NOT NULL,
    DATAALTERACAO           TIMESTAMP,
    IDUSUARIOALTERACAO      INTEGER,
    KGMATERIANATURAL        NUMERIC(15,3)
);
ALTER TABLE RACAOINSUMOS ADD CONSTRAINT RACAOINSUMOS_PK PRIMARY KEY (ID);
ALTER TABLE RACAOINSUMOS ADD CONSTRAINT RACAOINSUMOS_FK_1 FOREIGN KEY (IDRACAO) REFERENCES RACAO (ID);
ALTER TABLE RACAOINSUMOS ADD CONSTRAINT RACAOINSUMOS_FK_2 FOREIGN KEY (IDINSUMOALIMENTO) REFERENCES ALIMENTO (ID);
SET TERM ^ ;
CREATE OR ALTER TRIGGER RACAOINSUMOS_BI FOR RACAOINSUMOS
ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_racaoinsumos_id,1);
end
^
SET TERM ; ^
