SET TERM ^ ;

CREATE OR ALTER procedure EXTRATO_DIARIAS (
    ID_FAZENDA integer)
returns (
    IDFAZENDA integer,
    ID_LOCAL integer,
    PASTO varchar(200),
    DATA_DIA date,
    SALDO_INI integer,
    TOTAL_ENT integer,
    TOTAL_SAI integer,
    SALDO_FINAL integer)
as
declare variable IDPASTO integer;
declare variable I integer;
declare variable VSALDOINIENTRADA integer;
declare variable VSALDOINISAIDA integer;
declare variable VSALDOINIGERAL integer;
declare variable VSALDOENTRADADIA integer;
declare variable VSALDOSAIDADIA integer;
declare variable VSALDOENTRADAMOVDIA integer;
declare variable VSALDOSAIDAMOVDIA integer;
declare variable VDATACONTROLE date;
declare variable DATAINICIO date;
declare variable DATAFIM date;
BEGIN    

  select max(data_dia) from tmp_extrato_animais a
  where a.id_fazenda=:ID_FAZENDA
  INTO:DATAINICIO;
  if(:DATAINICIO is null) then
  begin
   SELECT min(DATA_PROC) FROM ANIMAL
   WHERE STATUS=1
   INTO:DATAINICIO;
  end
  DATAFIM = CURRENT_DATE;
    
  FOR SELECT ID,CODIGO FROM CURRAIS 
  WHERE ID IN(SELECT DISTINCT ID_LOCAL FROM 
  (SELECT DISTINCT ID_LOCAL FROM ANIMAL
   WHERE ID_PROPRIEDADE=:ID_FAZENDA
   UNION ALL  
   SELECT DISTINCT ID_PASTO_DESTINO FROM MOVIMENTACAO_ANIMAL 
   JOIN CURRAIS C ON ID_PASTO_DESTINO=C.ID
   WHERE ID_PROPRIEDADE=:ID_FAZENDA
   UNION ALL 
   SELECT DISTINCT ID_PASTO_ORIGEM FROM MOVIMENTACAO_ANIMAL
   JOIN CURRAIS C ON ID_PASTO_DESTINO=C.ID
   WHERE ID_PROPRIEDADE=:ID_FAZENDA)) 
  INTO:idPasto,PASTO
  DO 
  BEGIN  
      ID_lOCAL      = :idPasto; 
      IDFazenda     = :ID_FAZENDA;
      vDataControle = :DATAINICIO;     

    select a.saldo_final from tmp_extrato_animais a
    where a.id_fazenda=:ID_FAZENDA and a.data_dia=:vDataControle and a.id_local=:ID_lOCAL
    INTO:vSaldoIniGeral;
    if(vSaldoIniGeral is null) then
    begin
    /*TODOS ANIMAIS QUE ENTRARAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
     SELECT  COUNT(DISTINCT(AN.ID_ANIMAL))  FROM MOVIMENTACAO_ANIMAL AN
     WHERE AN.ID_PASTO_ORIGEM=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=1
     INTO:vSaldoIniEntrada;
   
     SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
     WHERE AN.ID_PASTO_DESTINO=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=0
     INTO:vSaldoEntradaMovDia;
      
    /*TODOS ANIMAIS QUE SAIRAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
     SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
     WHERE AN.ID_PASTO_ORIGEM=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=0
     INTO:vSaldoSaidaMovDia;

     SELECT COUNT(*) FROM ANIMAL
     WHERE ID_LOCAL=:idPasto AND DATA_SAIDA<:vDataControle
     AND ID NOT IN(SELECT ID_ANIMAL FROM MOVIMENTACAO_ANIMAL
     WHERE DATA<:vDataControle)
     INTO:vSaldoIniSAIDA;
    
     vSaldoIniGeral =(vSaldoIniEntrada+vSaldoEntradaMovDia)-(vSaldoIniSAIDA+vSaldoSaidaMovDia);
    end
    i=0;
    vSaldoSaidaMovDia =0;
    vSaldoEntradaMovDia=0;
    while (vDataControle<= DATAFIM) DO
    BEGIN  
      IF (i=0) THEN 
       SALDO_INI = :vSaldoIniGeral;
      ELSE 
       SALDO_INI = :SALDO_FINAL;
       vSaldoEntradaMovDia=0;
       vSaldoEntradaDia=0; 
       vSaldoSaidaDia=0;
       vSaldoSaidaMovDia=0;
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_DESTINO=:idPasto
      INTO:vSaldoEntradaMovDia;
     
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_ORIGEM=:idPasto
      AND TIPO=0
      INTO:vSaldoSaidaMovDia;
      
      
      SELECT COUNT(*) FROM ANIMAL MA 
      WHERE STATUS<>-1 AND MA.DATA_SAIDA=:vDataControle AND  MA.ID_LOCAL=:idPasto
      INTO:vSaldoSaidaDia;
      
      TOTAL_ENT    = :vSaldoEntradaMovDia+:vSaldoEntradaDia; 
      TOTAL_SAI    = :vSaldoSaidaDia+:vSaldoSaidaMovDia;
      SALDO_FINAL  = :SALDO_INI +(:TOTAL_ENT-:TOTAL_SAI);
      DATA_DIA  = :vDataControle;
      i=i+1;   
      vDataControle =vDataControle+1;
      SUSPEND;
    END 
  END  
END^

SET TERM ; ^

SET TERM ^ ;

CREATE OR ALTER procedure EXTRATO_DIARIAS_F (
    ID_FAZENDA integer)
returns (
    IDFAZENDA integer,
    ID_LOCAL integer,
    PASTO varchar(200),
    DATA_DIA date,
    SALDO_INI integer,
    TOTAL_ENT integer,
    TOTAL_SAI integer,
    SALDO_FINAL integer)
as
declare variable IDPASTO integer;
declare variable I integer;
declare variable VSALDOINIENTRADA integer;
declare variable VSALDOINISAIDA integer;
declare variable VSALDOINIGERAL integer;
declare variable VSALDOENTRADADIA integer;
declare variable VSALDOSAIDADIA integer;
declare variable VSALDOENTRADAMOVDIA integer;
declare variable VSALDOSAIDAMOVDIA integer;
declare variable VDATACONTROLE date;
declare variable DATAINICIO date;
declare variable DATAFIM date;
BEGIN    

  select max(data_dia) from tmp_extrato_animais a
  where a.id_fazenda=:ID_FAZENDA
  INTO:DATAINICIO;
  if(:DATAINICIO is null) then
  begin
   SELECT min(DATA_PROC) FROM ANIMAL
   WHERE STATUS=1
   INTO:DATAINICIO;
  end
  DATAFIM = CURRENT_DATE;

    
  FOR SELECT ID,CODIGO FROM CURRAIS 
  WHERE ID IN(SELECT DISTINCT ID_LOCAL FROM 
  (SELECT DISTINCT ID_LOCAL FROM ANIMAL
   WHERE ID_PROPRIEDADE=:ID_FAZENDA
   UNION ALL  
   SELECT DISTINCT ID_PASTO_DESTINO FROM MOVIMENTACAO_ANIMAL 
   JOIN CURRAIS C ON ID_PASTO_DESTINO=C.ID
   WHERE ID_PROPRIEDADE=:ID_FAZENDA
   UNION ALL 
   SELECT DISTINCT ID_PASTO_ORIGEM FROM MOVIMENTACAO_ANIMAL
   JOIN CURRAIS C ON ID_PASTO_DESTINO=C.ID
   WHERE ID_PROPRIEDADE=:ID_FAZENDA)) 
  INTO:idPasto,PASTO
  DO 
  BEGIN  
      ID_lOCAL      = :idPasto; 
      IDFazenda     = :ID_FAZENDA;
      vDataControle = :DATAINICIO;     
    select a.saldo_final from tmp_extrato_animais_sexo a
    where a.id_fazenda=:ID_FAZENDA and a.data_dia=:vDataControle and a.id_local=:ID_lOCAL
    and a.sexo='F'
    INTO:vSaldoIniGeral;
    if(vSaldoIniGeral is null) then
    begin
     /*TODOS ANIMAIS QUE ENTRARAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
     SELECT  COUNT(DISTINCT(AN.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL AN
     JOIN ANIMAL A ON A.ID=AN.ID_ANIMAL
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='F'
     WHERE AN.ID_PASTO_ORIGEM=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=1
     INTO:vSaldoIniEntrada;
   
     SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
     JOIN ANIMAL A ON A.ID=AN.ID_ANIMAL
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='F'
     WHERE AN.ID_PASTO_DESTINO=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=0
     INTO:vSaldoEntradaMovDia;
      
    /*TODOS ANIMAIS QUE SAIRAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
     SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
     JOIN ANIMAL A ON A.ID=AN.ID_ANIMAL
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='F'
     WHERE AN.ID_PASTO_ORIGEM=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=0
     INTO:vSaldoSaidaMovDia;

     SELECT COUNT(*) FROM ANIMAL A
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='F'
     WHERE ID_LOCAL=:idPasto AND DATA_SAIDA<:vDataControle
     AND A.ID NOT IN(SELECT ID_ANIMAL FROM MOVIMENTACAO_ANIMAL
     WHERE DATA<:vDataControle)
     INTO:vSaldoIniSAIDA;
    
     vSaldoIniGeral =(vSaldoIniEntrada+vSaldoEntradaMovDia)-(vSaldoIniSAIDA+vSaldoSaidaMovDia);
    END
    i=0;
    vSaldoSaidaMovDia =0;
    vSaldoEntradaMovDia=0;
    while (vDataControle<= DATAFIM) DO
    BEGIN  
      IF (i=0) THEN 
       SALDO_INI = :vSaldoIniGeral;
      ELSE 
       SALDO_INI = :SALDO_FINAL;
       vSaldoEntradaMovDia=0;
       vSaldoEntradaDia=0; 
       vSaldoSaidaDia=0;
       vSaldoSaidaMovDia=0;
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      JOIN ANIMAL A ON A.ID=MA.ID_ANIMAL
      JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='F'
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_DESTINO=:idPasto
      INTO:vSaldoEntradaMovDia;
     
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      JOIN ANIMAL A ON A.ID=MA.ID_ANIMAL
      JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='F'
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_ORIGEM=:idPasto
      AND TIPO=0
      INTO:vSaldoSaidaMovDia;
      
      
      SELECT COUNT(*) FROM ANIMAL MA 
      JOIN CATEGORIAS CA ON CA.ID=MA.ID_CATEGORIA AND CA.SEXO='F'
      WHERE MA.STATUS<>-1 AND MA.DATA_SAIDA=:vDataControle AND  MA.ID_LOCAL=:idPasto
      INTO:vSaldoSaidaDia;
      
      TOTAL_ENT    = :vSaldoEntradaMovDia+:vSaldoEntradaDia; 
      TOTAL_SAI    = :vSaldoSaidaDia+:vSaldoSaidaMovDia;
      SALDO_FINAL  = :SALDO_INI +(:TOTAL_ENT-:TOTAL_SAI);
      DATA_DIA  = :vDataControle;
      i=i+1;   
      vDataControle =vDataControle+1;
      SUSPEND;
    END 
  END  
END^

SET TERM ; ^

SET TERM ^ ;

CREATE OR ALTER procedure EXTRATO_DIARIAS_M (
    ID_FAZENDA integer)
returns (
    IDFAZENDA integer,
    ID_LOCAL integer,
    PASTO varchar(200),
    DATA_DIA date,
    SALDO_INI integer,
    TOTAL_ENT integer,
    TOTAL_SAI integer,
    SALDO_FINAL integer)
as
declare variable IDPASTO integer;
declare variable I integer;
declare variable VSALDOINIENTRADA integer;
declare variable VSALDOINISAIDA integer;
declare variable VSALDOINIGERAL integer;
declare variable VSALDOENTRADADIA integer;
declare variable VSALDOSAIDADIA integer;
declare variable VSALDOENTRADAMOVDIA integer;
declare variable VSALDOSAIDAMOVDIA integer;
declare variable VDATACONTROLE date;
declare variable DATAINICIO date;
declare variable DATAFIM date;
BEGIN    
  select max(data_dia) from tmp_extrato_animais a
  where a.id_fazenda=:ID_FAZENDA
  INTO:DATAINICIO;
  if(:DATAINICIO is null) then
  begin
   SELECT min(DATA_PROC) FROM ANIMAL
   WHERE STATUS=1
   INTO:DATAINICIO;
  END
  DATAFIM = CURRENT_DATE;
    
  FOR SELECT ID,CODIGO FROM CURRAIS 
  WHERE ID IN(SELECT DISTINCT ID_LOCAL FROM 
  (SELECT DISTINCT ID_LOCAL FROM ANIMAL
   WHERE ID_PROPRIEDADE=:ID_FAZENDA
   UNION ALL  
   SELECT DISTINCT ID_PASTO_DESTINO FROM MOVIMENTACAO_ANIMAL 
   JOIN CURRAIS C ON ID_PASTO_DESTINO=C.ID
   WHERE ID_PROPRIEDADE=:ID_FAZENDA
   UNION ALL 
   SELECT DISTINCT ID_PASTO_ORIGEM FROM MOVIMENTACAO_ANIMAL
   JOIN CURRAIS C ON ID_PASTO_DESTINO=C.ID
   WHERE ID_PROPRIEDADE=:ID_FAZENDA)) 
  INTO:idPasto,PASTO
  DO 
  BEGIN  
      ID_lOCAL      = :idPasto; 
      IDFazenda     = :ID_FAZENDA;
      vDataControle = :DATAINICIO;     
    select a.saldo_final from tmp_extrato_animais_sexo a
    where a.id_fazenda=:ID_FAZENDA and a.data_dia=:vDataControle and a.id_local=:ID_lOCAL
    and a.sexo='M'
    INTO:vSaldoIniGeral;
    if(vSaldoIniGeral is null) then
    begin
     /*TODOS ANIMAIS QUE ENTRARAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
     SELECT  COUNT(DISTINCT(AN.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL AN
     JOIN ANIMAL A ON A.ID=AN.ID_ANIMAL
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='M'
     WHERE AN.ID_PASTO_ORIGEM=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=1
     INTO:vSaldoIniEntrada;
   
     SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
     JOIN ANIMAL A ON A.ID=AN.ID_ANIMAL
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='M'
     WHERE AN.ID_PASTO_DESTINO=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=0
     INTO:vSaldoEntradaMovDia;

    /*TODOS ANIMAIS QUE SAIRAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
     SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
     JOIN ANIMAL A ON A.ID=AN.ID_ANIMAL
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='M'
     WHERE AN.ID_PASTO_ORIGEM=:idPasto AND AN."DATA"<:vDataControle
     AND TIPO=0
     INTO:vSaldoSaidaMovDia;

     SELECT COUNT(*) FROM ANIMAL A
     JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='M'
     WHERE ID_LOCAL=:idPasto AND DATA_SAIDA<:vDataControle
     AND A.ID NOT IN(SELECT ID_ANIMAL FROM MOVIMENTACAO_ANIMAL
     WHERE DATA<:vDataControle)
     INTO:vSaldoIniSAIDA;
    
     vSaldoIniGeral =(vSaldoIniEntrada+vSaldoEntradaMovDia)-(vSaldoIniSAIDA+vSaldoSaidaMovDia);
    END
    i=0;
    vSaldoSaidaMovDia =0;
    vSaldoEntradaMovDia=0;
    while (vDataControle<= DATAFIM) DO
    BEGIN  
      IF (i=0) THEN 
       SALDO_INI = :vSaldoIniGeral;
      ELSE 
       SALDO_INI = :SALDO_FINAL;
       vSaldoEntradaMovDia=0;
       vSaldoEntradaDia=0; 
       vSaldoSaidaDia=0;
       vSaldoSaidaMovDia=0;
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      JOIN ANIMAL A ON A.ID=MA.ID_ANIMAL
      JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='M'
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_DESTINO=:idPasto
      INTO:vSaldoEntradaMovDia;
     
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      JOIN ANIMAL A ON A.ID=MA.ID_ANIMAL
      JOIN CATEGORIAS CA ON CA.ID=A.ID_CATEGORIA AND CA.SEXO='M'
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_ORIGEM=:idPasto
      AND TIPO=0
      INTO:vSaldoSaidaMovDia;
      
      
      SELECT COUNT(*) FROM ANIMAL MA 
      JOIN CATEGORIAS CA ON CA.ID=MA.ID_CATEGORIA AND CA.SEXO='M'
      WHERE MA.STATUS<>-1 AND MA.DATA_SAIDA=:vDataControle AND  MA.ID_LOCAL=:idPasto
      INTO:vSaldoSaidaDia;
      
      TOTAL_ENT    = :vSaldoEntradaMovDia+:vSaldoEntradaDia; 
      TOTAL_SAI    = :vSaldoSaidaDia+:vSaldoSaidaMovDia;
      SALDO_FINAL  = :SALDO_INI +(:TOTAL_ENT-:TOTAL_SAI);
      DATA_DIA  = :vDataControle;
      i=i+1;   
      vDataControle =vDataControle+1;
      SUSPEND;
    END 
  END  
END^

SET TERM ; ^

CREATE GENERATOR GEN_HIST_OBS_ANIMAL_ID;

CREATE TABLE HIST_OBS_ANIMAL (
    ID          INTEGER NOT NULL,
    ID_ANIMAL   INTEGER NOT NULL,
    DATA        DATE DEFAULT CURRENT_DATE NOT NULL,
    HORA        TIME DEFAULT CURRENT_TIME NOT NULL,
    ID_USUARIO  INTEGER NOT NULL,
    OBSERVACAO  VARCHAR(200)
);
ALTER TABLE HIST_OBS_ANIMAL ADD CONSTRAINT PK_HIST_OBS_ANIMAL PRIMARY KEY (ID);

ALTER TABLE HIST_OBS_ANIMAL
ADD CONSTRAINT FK_HIST_OBS_ANIMAL_1
FOREIGN KEY (ID_ANIMAL)
REFERENCES ANIMAL(ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE HIST_OBS_ANIMAL
ADD CONSTRAINT FK_HIST_OBS_ANIMAL_2
FOREIGN KEY (ID_USUARIO)
REFERENCES USERS(ID);


SET TERM ^ ;
 CREATE OR ALTER TRIGGER HIST_OBS_ANIMAL_BI FOR HIST_OBS_ANIMAL
 ACTIVE BEFORE INSERT POSITION 0
 as
 begin
   if (new.id is null) then
     new.id = gen_id(gen_hist_obs_animal_id,1); 
 end
 ^
SET TERM ; ^

SET TERM ^ ;

CREATE OR ALTER trigger animal_ai_gta for animal
active after insert position 0
AS
begin
  if (NEW.gta_id>0) then
  begin
    update gta s set s.total_brincados=(select count(*) from animal where STATUS<>-1 AND gta_id=NEW.gta_id)
    where s.id=NEW.gta_id;
    EXECUTE PROCEDURE ATUALIZA_PROC_GTA(NEW.gta_id);
  end
  if(NEW.observacao<>'') then
  begin
    insert into HIST_OBS_ANIMAL(ID_ANIMAL,ID_USUARIO,OBSERVACAO)values(
    new.id,new.ID_USUARIO,new.OBSERVACAO);
  end
end^

SET TERM ; ^


INSERT INTO HIST_OBS_ANIMAL
SELECT 
 NULL ID,
 A.ID IDANIMAL,
 CAST(DATA_PROC AS DATE) DATA ,
 CAST(DATAREG AS TIME) HORA,
 ID_USUARIO,
 OBSERVACAO
FROM ANIMAL A
WHERE OBSERVACAO IS NOT NULL AND OBSERVACAO<>'';


SET TERM ^ ;

CREATE or ALTER trigger animal_bu0 for animal
active before update position 0
AS
begin
  if (OLD.observacao<>NEW.observacao  AND  NEW.observacao<>'') then
  begin
    insert into HIST_OBS_ANIMAL(ID_ANIMAL,ID_USUARIO,OBSERVACAO)values(
    new.id,new.ID_USUARIO,new.OBSERVACAO);
  end
end^

SET TERM ; ^

ALTER TABLE ANIMAL_PESO
ADD ULTIMA_PESAGEM DATE;

ALTER TABLE ANIMAL_PESO
ADD ULTIMO_PESO DECIMAL(15,2);

ALTER TABLE ANIMAL_PESO
ADD DIAS_ULTIMO_PESO INTEGER;

ALTER TABLE ANIMAL_PESO
ADD GMD DECIMAL(15,2);


SET TERM ^ ;

CREATE OR ALTER trigger animal_peso_ai0 for animal_peso
active after insert position 0
as
 declare variable  dataultimoPeso date;
 declare variable  ultimoPeso decimal(15,2);
 declare variable  dias integer;
 declare variable  gmd decimal(15,2);
begin
  update animal a set ultimo_peso=new.peso,
  a.data_ultimo_peso=new.data
  where a.id=new.id_animal;

  select first 1 data,peso from animal_peso a
  where status=1 and id_animal=new.id_animal
  and a.id<new.id
  order by data desc,ID DESC
  into:dataultimoPeso,ultimoPeso;

  if (dataultimoPeso is not null) then
  begin
    dias =(new.data-dataultimoPeso)+1;
    GMD  =(new.peso-ultimoPeso)/dias;

    update animal_peso set ULTIMA_PESAGEM=:dataultimoPeso,
    ULTIMO_PESO=:ultimoPeso,DIAS_ULTIMO_PESO=:dias,
    GMD=:GMD
    where id=new.id;
  end
end^

SET TERM ; ^

CREATE TABLE AUX_REBANHO (
    ID INTEGER NOT NULL,
    NOME VARCHAR(20) NOT NULL,
    OBSERVACAO VARCHAR(100),
    DATAREG TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    STATUS INTEGER DEFAULT 1 NOT NULL,
    ID_USUARIO INTEGER NOT NULL,
    DATA_ALTERACAO TIMESTAMP,
    ID_USUARIO_ALTERACAO INTEGER);

ALTER TABLE AUX_REBANHO
ADD CONSTRAINT PK_AUX_REBANHO
PRIMARY KEY (ID);

CREATE SEQUENCE GEN_AUX_REBANHO_ID;

SET TERM ^ ;

create trigger aux_rebanho_bi for aux_rebanho
active before insert position 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_aux_rebanho_id,1);
end^

SET TERM ; ^

ALTER TABLE ANIMAL
ADD ID_REBANHO INTEGER;

ALTER TABLE ANIMAL
ADD CONSTRAINT FK_ANIMAL_5
FOREIGN KEY (ID_REBANHO)
REFERENCES AUX_REBANHO(ID);

CREATE GENERATOR GEN_HIST_MOV_REBANHO_ID;
CREATE TABLE HIST_MOV_REBANHO (
    ID                  INTEGER NOT NULL,
    ID_ANIMAL           INTEGER NOT NULL,
    ID_REBANHO_ORIGEM   INTEGER NOT NULL,
    ID_REBANHO_DESTINO  INTEGER NOT NULL,
    DATA                DATE NOT NULL,
    DATAREG             TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ID_USUARIO          INTEGER NOT NULL
);
ALTER TABLE HIST_MOV_REBANHO ADD CONSTRAINT PK_HIST_MOV_REBANHO PRIMARY KEY (ID);
SET TERM ^ ;
CREATE OR ALTER TRIGGER HIST_MOV_REBANHO_BI FOR HIST_MOV_REBANHO
ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_hist_mov_rebanho_id,1);
end
^
SET TERM ; ^

ALTER TABLE TMP_ANIMAL
ADD REBANHO VARCHAR(20);

ALTER TABLE TMP_ANIMAL
ADD PASTO VARCHAR(100);

ALTER TABLE TMP_ANIMAL
ADD CATEGORIA VARCHAR(100);

ALTER TABLE TMP_ANIMAL
ADD DATA_ENTRADA DATE;

ALTER TABLE TMP_ANIMAL
ADD RACA VARCHAR(100);


