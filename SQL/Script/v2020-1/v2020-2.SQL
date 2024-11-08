ALTER TABLE ANIMAL_PESO ADD ID_LOCAL INTEGER;
ALTER TABLE MOVIMENTACAO_ANIMAL ADD TIPO INTEGER DEFAULT 0 NOT NULL;

ALTER TABLE CONFIG ADD DATA_DIARIAS DATE;

CREATE OR ALTER trigger animal_ai_mov for animal
active after insert position 0
AS
begin
 INSERT INTO MOVIMENTACAO_ANIMAL
 (ID_USUARIO,ID_ANIMAL,ID_PASTO_ORIGEM,ID_PASTO_DESTINO,"DATA",ID_MOTIVO,TIPO)
 VALUES(NEW.id_usuario,NEW.id,NEW.id_local,NEW.id_local,NEW.data_proc,'0',1);
end;

CREATE OR ALTER trigger animal_ai_peso_ent for animal
active after insert position 0
AS
begin
  if (NEW.peso_entrada>0) then
  begin
    insert into animal_peso(id_animal,id_usuario,data,peso,tipo,id_produtor, id_local)values(
    new.id, new.id_usuario,new.data_proc,new.peso_entrada,'ENTRADA',new.id_produtor,new.id_local);
  end
end;

DESCRIBE FIELD TIPO TABLE MOVIMENTACAO_ANIMAL
'0= Mov Local
1= Entrada
2= Saida';

ALTER TABLE CONFIG ADD GMD INTEGER DEFAULT 0;
DESCRIBE FIELD GMD TABLE CONFIG
'0=CURVA
1=SUPLEMENTO';

CREATE OR ALTER trigger animal_ai_peso_ent for animal
active after insert position 0
AS
begin
  if (NEW.peso_entrada>0) then
  begin
    insert into animal_peso(id_animal,id_usuario,data,peso,tipo,id_produtor,id_local)values(
    new.id, new.id_usuario,new.data_proc,new.peso_entrada,'ENTRADA',new.id_produtor,new.id_local);
  end
end

SET TERM ^;
create or alter procedure ATUALIZA_PESO_MEDIO_ATUAL (
    DATA_BASE date,
    ID_ANIMAL integer)
as
declare variable VID_CAT integer;
declare variable GMD_CONFIG integer;
declare variable I integer;
declare variable VID_RACA integer;
declare variable VDATAENT date;
declare variable VDATANASCIMENTO date;
declare variable VFAIXAATUAL varchar(20);
declare variable VDIAS integer;
declare variable VIDADEATUAL integer;
declare variable VDATACONTROLE date;
declare variable VPESOCONTROLE decimal(15,2);
declare variable VGMD decimal(15,2);
declare variable ID_CAT_ENT integer;
declare variable CUSTOFIXO decimal(15,2);
declare variable VSEXO char(1);
declare variable VPESOENT decimal(15,2);
declare variable MES_ATUAL integer;
declare variable ID_FASE_ATUAL integer;
declare variable ID_LOCAL integer;
declare variable ID_MINERAL integer;
declare variable ID_PROPRIEDADE integer;
BEGIN
  SELECT
     A.peso_entrada,
     A.data_nascimento,
     a.data_proc,
     trunc(coalesce(A.data_saida,:DATA_BASE)-cast(a.data_proc AS date)) DIAS,
     d.sexo,
     A.id_raca,
     A.id_categoria,
     a.ID_LOCAL,
     a.id_propriedade
  FROM animal A
  join currais c on a.id_local=c.id
  join categorias d on d.id=a.id_categoria
  WHERE A.ID=:id_animal
  INTO:vpesoent,:vdatanascimento,:vdataent,:vdias,:vsexo,:vid_raca,:id_cat_ent,:ID_LOCAL,
  ID_PROPRIEDADE;
  I =1;
  vdatacontrole = vdataent;
  vPesoControle = vpesoent;
  while(I<=vdias)do
  begin
    SELECT GMD FROM CONFIG C
    WHERE C.id_propriedade=:ID_PROPRIEDADE
    INTO:GMD_CONFIG;

    vidadeatual = TRUNC((vdatacontrole-vdatanascimento)/30.4573);
    MES_ATUAL   = EXTRACT(month FROM vdatacontrole);
    SELECT ID_FASE_ATUAL FROM RETORNA_FASE_ATUAL(:MES_ATUAL)
    INTO:id_fase_atual;

    if (id_fase_atual IS NULL) then
    begin
     SELECT ID FROM aux_fases A
     WHERE (:MES_ATUAL=a.mes_fim)
     INTO:id_fase_atual;
    end

    vdatacontrole =vdatacontrole+1;

    SELECT FIRST 1 CA.id FROM categorias CA
    join faixa_etaria fe on fe.id=ca.id_faixa
    WHERE CA.sexo=:vsexo AND (fe.idade_minima<=:vidadeatual) and (fe.idade_maxima>=:vidadeatual)
    INTO:vid_cat;
    
    IF (GMD_CONFIG=0) THEN
    BEGIN      
     select first 1 pn.GMD from plan_nutri pn
     where pn.id_categoria=:vid_cat and
     pn.id_raca=:vid_raca
     AND PN.id_fase= :id_fase_atual
     INTO:VGMD;
    END
    ELSE
    BEGIN
       SELECT first 1 PLU.ID_MINERAL FROM plan_uso_mineral plu
       JOIN COCHO O ON O.ID=PLU.ID_COCHO
       WHERE plu.STATUS=1 AND O.ID_PASTO=:ID_LOCAL
      INTO:ID_MINERAL;
      
      SELECT GANHO_ESPERADO FROM SUPLEMENTO_MINERAL
      where id=:ID_MINERAL
      INTO:VGMD;
    END
    I=I+1;
    vPesoControle = vPesoControle+VGMD;
  end
  if (vPesoControle is null) then vPesoControle=vpesoent;
  if (vid_cat is null) then vid_cat=:id_cat_ent;

  update animal a set a.peso_estimado=:vPesoControle,a.data_peso_estimado=:data_base,
  A.id_categoria_atual=:vid_cat
  where a.id=:id_animal;
end;
^
SET TERM ; ^

CREATE OR ALTER VIEW VIEW_RESUMO_ATIVOS_GERAL_SEXO(
    PASTO,
    SEXO,
    QTD_CAB,
    DIAS_MEDIO,
    PESO_ENT,
    ARR_ENTRADA,
    PESO_ATUAL,
    ARR_ATUAL,
    CONSUMO_ACUMULADO,
    CUSTO_ALIMENTAR,
    CUSTOFIXOACUMULADO,
    CUSTOTOTALMAISCOMPRA,
    CUSTOTOTAL,
    ID_PROPRIEDADE,
    CUSTO_ARR_PROD,
    DATA_ENTRADA_MEDIA,
    ARR_PRODUZIDA,
    CUSTO_ALIMENTAR_CAB,
    CUSTO_FIXO_CAB_DIA,
    GTP,
    GMD,
    CONSUMO_CAB_DIA,
    IMS_PV)
AS
SELECT
 w.*,
 (CONSUMO_CAB_DIA*100)/PESO_ATUAL IMS_PV
FROM
(SELECT
 Y.*,
 CAST(CASE
 WHEN (ARR_ATUAL-ARR_ENTRADA)>0 THEN
   CUSTOTOTAL/((ARR_ATUAL-ARR_ENTRADA)*QTD_CAB)
  ELSE
   '0'
 END AS DECIMAL(15,2))  CUSTO_ARR_PROD,
 CURRENT_DATE-DIAS_MEDIO DATA_ENTRADA_MEDIA,
 CAST((ARR_ATUAL-ARR_ENTRADA) AS DECIMAL(15,2))ARR_PRODUZIDA,
 CAST((CUSTO_ALIMENTAR/QTD_CAB) AS DECIMAL(15,2))CUSTO_ALIMENTAR_CAB,
 CAST((CUSTOFIXOACUMULADO/QTD_CAB) AS DECIMAL(15,2)) CUSTO_FIXO_CAB_DIA,
 (PESO_ATUAL-PESO_ENT) GTP,
  round(((PESO_ATUAL-PESO_ENT)/TRUNC(DIAS_MEDIO)),1)GMD,
 (CONSUMO_ACUMULADO/QTD_CAB)/DIAS_MEDIO CONSUMO_CAB_DIA
FROM
(SELECT
 C.codigo PASTO,
 CA.SEXO,
 COUNT(*) QTD_CAB,
 AVG(DATEDIFF(DAY FROM A.data_proc TO coalesce(A.data_saida,current_date))+1)DIAS_MEDIO,
 AVG(PESO_ENTRADA) PESO_ENT,
 AVG(PESO_ENTRADA/30)ARR_ENTRADA,
 AVG(PESO_ESTIMADO)PESO_ATUAL,
 AVG(PESO_ESTIMADO/30)ARR_ATUAL,
 SUM(A.consumo_acu)CONSUMO_ACUMULADO,
 SUM(COALESCE(A.valor_custo_alimentar,0))CUSTO_ALIMENTAR,
 SUM(COALESCE(A.valor_custo_fixo_acu,0))CUSTOFIXOACUMULADO,
 SUM(COALESCE((VALOR_CUSTO_ALIMENTAR+VALOR_CUSTO_FIXO_ACU+VALOR_COMPRA),0)) CUSTOTOTALMAISCOMPRA,
 SUM(COALESCE((VALOR_CUSTO_ALIMENTAR+VALOR_CUSTO_FIXO_ACU),0))CUSTOTOTAL,
 A.ID_PROPRIEDADE
FROM ANIMAL A
JOIN CURRAIS C ON A.ID_LOCAL=C.ID
JOIN RACA R ON R.id=A.id_raca
JOIN categorias CA ON CA.ID=coalesce(A.id_categoria,A.id_categoria)
WHERE A.STATUS=1
GROUP BY C.codigo,CA.SEXO,A.ID_PROPRIEDADE)Y)w
;

CREATE SEQUENCE GEN_TMP_EXTRATO_ANIMAIS_ID;

CREATE TABLE TMP_EXTRATO_ANIMAIS (
    ID INTEGER NOT NULL,
    ID_FAZENDA INTEGER NOT NULL,
    ID_LOCAL INTEGER NOT NULL,
    DATA_DIA DATE NOT NULL,
    SALDO_INI INTEGER NOT NULL,
    TOTAL_ENTRADA INTEGER NOT NULL,
    TOTAL_SAIDA INTEGER NOT NULL,
    SALDO_FINAL INTEGER NOT NULL)
	
ALTER TABLE TMP_EXTRATO_ANIMAIS
ADD CONSTRAINT PK_TMP_EXTRATO_ANIMAIS
PRIMARY KEY (ID);

SET TERM ^ ;
create trigger tmp_extrato_animais_bi for tmp_extrato_animais
active before insert position 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_tmp_extrato_animais_id,1);
end
^
SET TERM ; ^

CREATE INDEX TMP_EXTRATO_ANIMAIS_IDX3
ON TMP_EXTRATO_ANIMAIS (DATA_DIA);


CREATE INDEX TMP_EXTRATO_ANIMAIS_IDX2
ON TMP_EXTRATO_ANIMAIS (ID_LOCAL);


CREATE INDEX TMP_EXTRATO_ANIMAIS_IDX1
ON TMP_EXTRATO_ANIMAIS (ID_FAZENDA);

CREATE INDEX MOVIMENTACAO_ANIMAL_IDX2
ON MOVIMENTACAO_ANIMAL (ID_PASTO_DESTINO);

CREATE INDEX MOVIMENTACAO_ANIMAL_IDX1
ON MOVIMENTACAO_ANIMAL (ID_PASTO_ORIGEM);

CREATE INDEX MOVIMENTACAO_ANIMAL_IDX4
ON MOVIMENTACAO_ANIMAL (DATA);

CREATE INDEX MOVIMENTACAO_ANIMAL_IDX3
ON MOVIMENTACAO_ANIMAL (ID_ANIMAL);

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
  SELECT min(DATA_PROC) FROM ANIMAL
  WHERE STATUS=1
  INTO:DATAINICIO;
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
END
^
CREATE OR ALTER procedure EXTRATO_DIARIAS_PASTO (
    ID_PASTO integer)
returns (
    ID_LOCAL integer,
    PASTO varchar(200),
    DATA_DIA date,
    SALDO_INI integer,
    TOTAL_ENT integer,
    TOTAL_SAI integer,
    SALDO_FINAL integer)
as
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
    SELECT min(DATA_PROC) FROM ANIMAL
    WHERE STATUS=1
    INTO:DATAINICIO;
    DATAFIM = CURRENT_DATE;
  
    ID_lOCAL      = :ID_PASTO; 
    vDataControle = :DATAINICIO;     
    /*TODOS ANIMAIS QUE ENTRARAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
    SELECT  COUNT(DISTINCT(AN.ID_ANIMAL))  FROM MOVIMENTACAO_ANIMAL AN
    WHERE AN.ID_PASTO_ORIGEM=:id_Pasto AND AN."DATA"<:vDataControle
    AND TIPO=1
    INTO:vSaldoIniEntrada;   
   
    SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
    WHERE AN.ID_PASTO_DESTINO=:id_Pasto AND AN."DATA"<:vDataControle
    AND TIPO=0
    INTO:vSaldoEntradaMovDia; 
      
    /*TODOS ANIMAIS QUE SAIRAM E NAO FORAM MOVIMENTADOS ANTES DA DATA DE INICIO*/
    SELECT COUNT(DISTINCT(AN.ID_ANIMAL)) TOTAL_ENTRADA FROM MOVIMENTACAO_ANIMAL AN
    WHERE AN.ID_PASTO_ORIGEM=:id_Pasto AND AN."DATA"<:vDataControle
    AND TIPO=0 
    INTO:vSaldoSaidaMovDia;

    SELECT COUNT(*) FROM ANIMAL
    WHERE ID_LOCAL=:id_Pasto AND DATA_SAIDA<:vDataControle
    AND ID NOT IN(SELECT ID_ANIMAL FROM MOVIMENTACAO_ANIMAL
    WHERE DATA<:vDataControle)
    INTO:vSaldoIniSAIDA;    
    
    vSaldoIniGeral =(vSaldoIniEntrada+vSaldoEntradaMovDia)-(vSaldoIniSAIDA+vSaldoSaidaMovDia);       
    
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
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_DESTINO=:id_Pasto
      INTO:vSaldoEntradaMovDia;
     
      
      SELECT COUNT(DISTINCT(MA.ID_ANIMAL)) FROM MOVIMENTACAO_ANIMAL MA 
      WHERE DATA=:vDataControle AND  MA.ID_PASTO_ORIGEM=:id_Pasto
      AND TIPO=0
      INTO:vSaldoSaidaMovDia;
      
      
      SELECT COUNT(*) FROM ANIMAL MA 
      WHERE STATUS<>-1 AND MA.DATA_SAIDA=:vDataControle AND  MA.ID_LOCAL=:id_Pasto
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
^
create or alter procedure SELECT_CONSUMO_DIA (
    IDPASTO integer,
    DATA_INI date,
    DATA_FIM date)
returns (
    DATA_CONSUMO date,
    PASTO varchar(100),
    CONSUMO decimal(15,2),
    QTD_ANIMAIS integer,
    CONSUMO_CAB decimal(15,2))
as
declare variable CONSUMOINI decimal(18,2);
declare variable CONSUMOPROX decimal(18,2);
declare variable CONSUMODIA decimal(18,2);
declare variable DATACONSUMOINI date;
declare variable DATACONTROLE date;
declare variable DATACONTROLE2 date;
declare variable VDATA_INI date;
declare variable DATAPROX date;
declare variable I integer;
declare variable X integer;
declare variable DIAS integer;
BEGIN
 DELETE FROM TMP_EXTRATO_DIARIAS_PASTO_T;
 INSERT INTO TMP_EXTRATO_DIARIAS_PASTO_T
 SELECT * FROM EXTRATO_DIARIAS_PASTO(:IDPASTO);

 SELECT CODIGO FROM CURRAIS WHERE ID=:IDPASTO
 INTO PASTO;

 SELECT MIN(DATA_DIA),MAX(DATA_DIA) FROM TMP_EXTRATO_DIARIAS_PASTO_T
 WHERE SALDO_FINAL>0 AND DATA_DIA BETWEEN :DATA_INI AND :DATA_FIM
 AND ID_LOCAL=:idpasto
 INTO:DATA_INI,:DATA_FIM;
 if (DATA_INI is not null and DATA_FIM is not null )then
 begin
     SELECT FIRST 1 DATA_FORNECIMENTO,REALIZADO_COCHO_KG FROM FORNECIMENTO
     WHERE STATUS=1 AND ID_PASTO=:IDPASTO AND REALIZADO_COCHO_KG>0
     AND DATA_FORNECIMENTO between :DATA_INI AND :DATA_FIM
     ORDER BY DATA_FORNECIMENTO
     INTO:DataConsumoIni,ConsumoIni;
    
     if (DataConsumoIni IS NULL) then
     BEGIN
       SELECT MAX(DATA_FORNECIMENTO)FROM FORNECIMENTO
       WHERE STATUS=1 AND ID_PASTO=:IDPASTO AND REALIZADO_COCHO_KG>0
       AND DATA_FORNECIMENTO <= :data_fim
       INTO:DataConsumoIni;

       SELECT SUM(REALIZADO_COCHO_KG) FROM FORNECIMENTO  A
       WHERE STATUS=1 AND ID_PASTO=:IDPASTO AND REALIZADO_COCHO_KG>0
       AND DATA_FORNECIMENTO = :DataConsumoIni
       INTO:ConsumoIni;
       

    
       DIAS = (DATEDIFF(DAY FROM :DataConsumoIni TO :data_fim));
       if (DIAS>0) then
        CONSUMODIA = ConsumoIni/DIAS;
       else
         CONSUMODIA = ConsumoIni/1;
    
       DataControle2 =:DATA_INI;
       while(DataControle2<=:DATA_FIM) do
       begin
         SELECT SALDO_FINAL FROM TMP_EXTRATO_DIARIAS_PASTO_T
         WHERE ID_LOCAL=:idpasto AND DATA_DIA=:DataControle2
         INTO:qtd_animais;

         DATA_CONSUMO=:DataControle2;
         consumo = CONSUMODIA;
         if (qtd_animais>0) then
          CONSUMO_CAB =consumo/cast(qtd_animais as double precision);
         SUSPEND;
         DataControle2 =DataControle2+1;
       end
     end
     else
     begin
         if (DataConsumoIni IS NOT NULL) then
         BEGIN
             DataControle = :DataConsumoIni;
             I=0;
             X=1;
             while (:DataControle<=:DATA_FIM) DO
             BEGIN
               SELECT FIRST 1 DATA_FORNECIMENTO,REALIZADO_COCHO_KG
               FROM FORNECIMENTO   A
               WHERE STATUS=1 AND ID_PASTO=:IDPASTO AND REALIZADO_COCHO_KG>0
               AND DATA_FORNECIMENTO>:DataControle
               INTO:DataProx,ConsumoProx;
               if (DataProx is not null) then
               begin
                DataControle2=:DataControle;
            
               IF(I=0)THEN
               BEGIN
                 DIAS        = (DATEDIFF(DAY FROM :DataConsumoIni TO :DataProx));
                 if (DIAS>0) then
                  CONSUMODIA = ConsumoIni/DIAS;
                 else 
                  CONSUMODIA = ConsumoIni/1;
               END
               ELSE
               BEGIN
                 DIAS       = (DATEDIFF(DAY FROM :DataControle TO :DataProx));
                 if (DIAS>0) then
                  CONSUMODIA = ConsumoProx/DIAS;
                 ELSE
                  CONSUMODIA = ConsumoProx/1;
               END
               I=I+1;
            
               while(:DataControle2<:DataProx)DO
               BEGIN
                 SELECT SALDO_FINAL FROM TMP_EXTRATO_DIARIAS_PASTO_T
                 WHERE ID_LOCAL=:idpasto AND DATA_DIA=:DataControle2
                 INTO:qtd_animais;
                 DATA_CONSUMO=:DataControle2;
                 consumo = CONSUMODIA;
                 DataControle2 =DataControle2+1;
                 CONSUMO_CAB =consumo/cast(qtd_animais as double precision);
                 SUSPEND;
                 X=X+1;
               END
               if(:DataControle=:DataProx) then
               BEGIN
                 DIAS       = (DATEDIFF(DAY FROM :dataprox TO :data_fim));
                 CONSUMODIA  =:ConsumoProx/DIAS;
                 WHILE (dataprox<=:data_fim) DO
                 BEGIN
                  SELECT SALDO_FINAL FROM TMP_EXTRATO_DIARIAS_PASTO_T
                  WHERE ID_LOCAL=:idpasto AND DATA_DIA=:dataprox
                  INTO:qtd_animais;
        
                  DATA_CONSUMO=:dataprox;
                  consumo = CONSUMODIA;
                  if (qtd_animais>0) then
                   CONSUMO_CAB =consumo/cast(qtd_animais as double precision);
                  SUSPEND;
                  dataprox =dataprox+1;
                 END
                 DataControle =:data_fim+1;
               END
               ELSE
                 DataControle =DataControle2;
              END
              else
              begin
               datacontrole = DataConsumoIni;
               DIAS=(DATEDIFF(DAY FROM :DataControle TO :DATA_FIM));
               if (DIAS>0) then
                CONSUMODIA = ConsumoIni/DIAS;
               ELSE
                CONSUMODIA = ConsumoIni/1;
            
               while(:DataControle<=:DATA_FIM) DO
               BEGIN
                SELECT SALDO_FINAL FROM TMP_EXTRATO_DIARIAS_PASTO_T
                WHERE ID_LOCAL=:idpasto AND DATA_DIA=:DataControle
                INTO:qtd_animais;
        
                CONSUMO_CAB =CONSUMODIA/cast(qtd_animais as double precision);
                DataControle =DataControle+1;
               END
               break;
            
              end
             end
          END
       end
   end
END
^
SET TERM ; ^

ALTER TABLE ANIMAL 
 ADD FLAG_SYNC_TERCEIROS          INTEGER DEFAULT 0 NOT NULL;

ALTER TABLE ANIMAL
ADD DATA_SYNC_TERCEIROS DATE;

 CREATE TABLE TMP_EXTRATO_DIARIAS_PASTO_T(
  ID_LOCAL    INTEGER NOT NULL,
  PASTO       VARCHAR(100),
  DATA_DIA    DATE NOT NULL,
  SALDO_INI   INTEGER NOT NULL,
  TOTAL_ENT   INTEGER NOT NULL,
  TOTAL_SAI   INTEGER NOT NULL,
  SALDO_FINAL INTEGER NOT NULL
  );

CREATE INDEX TMP_EXTRATO_DIARIAS_PASTO_IDX1T
ON TMP_EXTRATO_DIARIAS_PASTO_T (ID_LOCAL,DATA_DIA)






