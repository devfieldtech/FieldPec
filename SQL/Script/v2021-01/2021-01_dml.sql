INSERT INTO VERSION(NUMERO)VALUES(20211);
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

INSERT INTO AUX_REBANHO(NOME,OBSERVACAO,ID_USUARIO)
VALUES('PROPRIO','ANIMAIS PROPRIO',(SELECT FIRST 1 ID FROM USERS WHERE STATUS=1));

UPDATE ANIMAL SET ID_REBANHO=1;

UPDATE OR INSERT INTO AUX_CARGO(ID,NOME,ID_USUARIO,PADRAO)VALUES(1,'GERENTE',1,1)MATCHING(ID);
UPDATE OR INSERT INTO AUX_CARGO(ID,NOME,ID_USUARIO,PADRAO)VALUES(2,'TECNICO',1,1)MATCHING(ID);
UPDATE OR INSERT INTO AUX_CARGO(ID,NOME,ID_USUARIO,PADRAO)VALUES(3,'MOTORISTA',1,1)MATCHING(ID);
UPDATE OR INSERT INTO AUX_CARGO(ID,NOME,ID_USUARIO,PADRAO)VALUES(4,'OPERADOR DE PA',1,1)MATCHING(ID);