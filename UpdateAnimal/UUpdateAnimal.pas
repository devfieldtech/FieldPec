unit UUpdateAnimal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.IniFiles, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase;

type
  TUpdate = class(TForm)
    AnimalUpdate: TFDQuery;
    FCon: TFDConnection;
    AnimalUpdateID: TIntegerField;
    AnimalUpdateDATAREG: TSQLTimeStampField;
    AnimalUpdateQTD_ANIMAIS: TIntegerField;
    qryAux: TFDQuery;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    qryConfigPadrao: TFDQuery;
    qryConfigPadraoID: TIntegerField;
    qryConfigPadraoCUSTO_FIXO_PADRAO: TFMTBCDField;
    qryConfigPadraoTIPO_MEDIA_VALOR_KG: TIntegerField;
    qryConfigPadraoID_PROPRIEDADE: TIntegerField;
    qryConfigPadraoLOGO: TMemoField;
    qryConfigPadraoGMD: TIntegerField;
    qryConfigPadraoDATA_DIARIAS: TDateField;
    PropriedadePropria: TFDQuery;
    PropriedadePropriaID: TIntegerField;
    PropriedadePropriaNOME: TStringField;
    PropriedadePropriaCIDADE: TStringField;
    PropriedadePropriaUF: TStringField;
    PropriedadePropriaENDERECO: TStringField;
    PropriedadePropriaSTATUS: TIntegerField;
    PropriedadePropriaUSRER_ID: TIntegerField;
    PropriedadePropriaDATA_REG: TSQLTimeStampField;
    PropriedadePropriaPROPRIA: TIntegerField;
    PropriedadePropriaCOD_ESTAB_GTA: TStringField;
    PropriedadePropriaIE: TStringField;
    PropriedadePropriaGUID: TStringField;
    PropriedadePropriaRASTREADA: TIntegerField;
    PropriedadePropriaCOD_ERAS_BND: TStringField;
    PropriedadePropriaCIF: TStringField;
    CRIA_PROC_ATUALIZA_ANIMAL: TFDQuery;
    CRIA_PROC_ATUALIZA_VALOR_ESTOQUE: TFDQuery;
    procedure FormShow(Sender: TObject);
    procedure FConAfterConnect(Sender: TObject);
  private
    ArquivoLog:string;
  public
    procedure ConectaBD;
    function LerIni(Diretorio, Chave1, Chave2, ValorPadrao: String): String;
    procedure AtualizaSaldoAtualAlimento(idAlimento,IdPropriedade: string);
    procedure AtualizaSaldoAtualProduto(idAlimento,IdPropriedade: string);
    procedure AtualizaSaldoAtualInsumoeProduto(IdPropriedade: string);
    procedure AtualizaAliamentoEstoque;
  end;

var
  Update: TUpdate;

implementation

{$R *.fmx}

procedure TUpdate.ConectaBD;
var
  Arquivo, vDataBase, vServer: String;
begin
  FCon.Connected := false;
  Arquivo := ExtractFilePath(ParamStr(0))+ 'fieldconf.ini';
  if not FileExists(Arquivo) then
  begin
    ShowMessage('Arquivo fieldconf.ini n�o localizado no seguinte diretorio:' +
      #13 + Arquivo);
    Exit;
  end
  else
  begin
    try
      with FCon do
      begin
        Params.Clear;
        Params.Values['DriverID']  := 'FB';
        vDataBase := LerIni(Arquivo, 'FIREBIRD', 'Database', '');
        vServer := LerIni(Arquivo, 'FIREBIRD', 'Server', '');
        Params.Values['Server']    := LerIni(Arquivo, 'FIREBIRD', 'Server', '');
        Params.Values['Database']  := LerIni(Arquivo, 'FIREBIRD',
          'Database', '');
        Params.Values['User_name'] := LerIni(Arquivo, 'FIREBIRD', 'User', '');
        Params.Values['Port']      := LerIni(Arquivo, 'Porta', 'User', '');
        Params.Values['Password']  := LerIni(Arquivo, 'FIREBIRD',
          'Password', '');
        FDPhysFBDriverLink1.VendorLib := ExtractFilePath(ParamStr(0))+'fbclient_32.dll';
        Connected := True;
      end;
    except
      ShowMessage('Ocorreu uma Falha na configura��o no Banco Firebird!');
    end;
  end;
end;

procedure TUpdate.FConAfterConnect(Sender: TObject);
begin
  CRIA_PROC_ATUALIZA_ANIMAL.ExecSQL;
  CRIA_PROC_ATUALIZA_VALOR_ESTOQUE.ExecSQL;
end;

procedure TUpdate.FormShow(Sender: TObject);
var  arq: TextFile;
 i, n: integer;
begin
  ArquivoLog := ExtractFilePath(ParamStr(0))+'logUpdate';
  if not DirectoryExists(ArquivoLog) then
   CreateDir(ArquivoLog);
  ArquivoLog := ArquivoLog+'\'+FormatDateTime('yy_mm_dd_hh_mm',now)+'.txt';

  AssignFile(arq,ArquivoLog);
  Rewrite(arq);
  Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'Conectando no banco');
  ConectaBD;
  AnimalUpdate.Close;
  AnimalUpdate.Open;
  Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'AnimalUpdate.RecordCount');

  Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'Atualiza Alimentos Estoque');
  AtualizaAliamentoEstoque;

  if AnimalUpdate.RecordCount=0 then
  begin
   AnimalUpdate.Insert;
   AnimalUpdateDATAREG.AsDateTime    := now;
   AnimalUpdateQTD_ANIMAIS.AsInteger := 0;
   AnimalUpdate.ApplyUpdates(-1);
   FCon.Commit;
   Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'EXECUTE PROCEDURE ATUALIZA_ANIMAL');
   FCon.ExecSQL('EXECUTE PROCEDURE ATUALIZA_ANIMAL');
   FCon.Commit;
  end;
  with qryAux,qryAux.SQL do
  begin
    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'DELETE FROM HIST_ANIMAIS_PESO_QTD WHERE');
    Clear;
    Add('DELETE FROM HIST_ANIMAIS_PESO_QTD WHERE "DATA"=CURRENT_DATE');
    ExecSQL;
    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'insert into HIST_ANIMAIS_PESO_QTD');
    Clear;
    Add('insert into HIST_ANIMAIS_PESO_QTD(ID_CURRAL_PASTO,"DATA",QTD_CAB,PESO_PROJ,DIAS)');
    Add('SELECT ID_LOCAL,MAX(CURRENT_DATE),COUNT(*),AVG(COALESCE(PESO_ESTIMADO,PESO_ENTRADA)),');
    Add('AVG(datediff(DAY FROM data_proc TO coalesce(DATA_SAIDA,cast(CURRENT_DATE as date))))DIAS');
    Add('FROM ANIMAl');
    Add('WHERE STATUS=1');
    Add('GROUP BY ID_LOCAL');
    ExecSQL;

    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'DELETE FROM HIST_ANIMAL_LOCAL_DIA');

    Clear;
    Add('DELETE FROM HIST_ANIMAL_LOCAL_DIA WHERE "DATA"=CURRENT_DATE');
    ExecSQL;

    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'insert into HIST_ANIMAL_LOCAL_DIA');

    Clear;
    Add('insert into HIST_ANIMAL_LOCAL_DIA(id_animal,id_local)');
    Add('SELECT ID,ID_LOCAL');
    Add('FROM ANIMAl');
    Add('WHERE STATUS=1');
    ExecSQL;

    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'Atualiza Lote Animal');
    Clear;
    Add('EXECUTE PROCEDURE ATUALIZA_ID_LOTE_ANIMAL');
    ExecSQL;

    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'Atualiza  GMD Lote');
    Clear;
    Add('EXECUTE PROCEDURE ATUALIZA_GMD_ANIMAL_FAZ');
    ExecSQL;

    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'Atualiza  GMD Lote');
    Clear;
    Add('EXECUTE PROCEDURE ATUALIZA_GMD_ANIMAL_FAZ_CONF');
    ExecSQL;

    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'PropriedadePropria.Open');



    PropriedadePropria.Close;
    PropriedadePropria.Open;
    PropriedadePropria.First;
    Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'PropriedadePropria.eof');

    while not PropriedadePropria.eof do
    begin
      qryConfigPadrao.Close;
      qryConfigPadrao.Open;
      qryConfigPadrao.Filtered := false;
      qryConfigPadrao.Filter   := 'ID_PROPRIEDADE='+PropriedadePropriaID.AsString;
      qryConfigPadrao.Filtered := true;

      AtualizaSaldoAtualInsumoeProduto(PropriedadePropriaID.AsString);

      Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'qryConfigPadraoDATA_DIARIAS.AsDateTime');
//      if (qryConfigPadraoDATA_DIARIAS.AsDateTime<date)then
//      begin
//        Clear;
//        Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'delete from TMP_EXTRATO_ANIMAIS');
//        Add('delete from TMP_EXTRATO_ANIMAIS where ID_FAZENDA='+PropriedadePropriaID.AsString);
//        Add('and DATA_DIA>='+FormatDateTime('mm/dd/yyyy',(qryConfigPadraoDATA_DIARIAS.AsDateTime-30)).QuotedString);
//        ExecSQL;
//
//        Clear;
//        Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'delete from TMP_EXTRATO_ANIMAIS_SEXO');
//        Add('delete from TMP_EXTRATO_ANIMAIS_SEXO where ID_FAZENDA='+PropriedadePropriaID.AsString);
//        Add('and DATA_DIA>='+FormatDateTime('mm/dd/yyyy',(qryConfigPadraoDATA_DIARIAS.AsDateTime-30)).QuotedString);
//        ExecSQL;
//
//
//        Clear;
//        Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'INSERT INTO TMP_EXTRATO_ANIMAIS:'+PropriedadePropriaID.AsString);
//        Add('INSERT INTO TMP_EXTRATO_ANIMAIS');
//        Add('SELECT');
//        Add('NULL,');
//        Add('IDFazenda,');
//        Add('ID_lOCAL,');
//        Add('DATA_DIA,');
//        Add('SALDO_INI,');
//        Add('TOTAL_ENT,');
//        Add('TOTAL_SAI,');
//        Add('SALDO_FINAL');
//        Add('FROM EXTRATO_DIARIAS('+PropriedadePropriaID.AsString+')');
//        ExecSQL;
//
//        Clear;
//        Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'TMP_EXTRATO_ANIMAIS_SEXO F:'+PropriedadePropriaID.AsString);
//        Add('INSERT INTO TMP_EXTRATO_ANIMAIS_SEXO');
//        Add('SELECT');
//        Add('NULL ID,');
//        Add('IDFAZENDA,');
//        Add('ID_LOCAL,');
//        Add(QuotedStr('F')+',');
//        Add('DATA_DIA,');
//        Add('SALDO_INI,');
//        Add('TOTAL_ENT,');
//        Add('TOTAL_SAI,');
//        Add(' SALDO_FINAL');
//        Add('FROM EXTRATO_DIARIAS_F('+PropriedadePropriaID.AsString+')');
//        Add('UNION ALL');
//        Add('SELECT');
//        Add('NULL ID,');
//        Add('IDFAZENDA,');
//        Add('ID_LOCAL,');
//        Add(QuotedStr('M')+',');
//        Add('DATA_DIA,');
//        Add('SALDO_INI,');
//        Add('TOTAL_ENT,');
//        Add('TOTAL_SAI,');
//        Add(' SALDO_FINAL');
//        Add('FROM EXTRATO_DIARIAS_M('+PropriedadePropriaID.AsString+')');
//        ExecSQL;
//      end;
      PropriedadePropria.Next;
    end;
  end;
  PropriedadePropria.Close;
  PropriedadePropria.Open;
  PropriedadePropria.First;
  Writeln(arq,FormatDateTime('hh:mm',NOW)+' : '+'PropriedadePropria.eof');
  while not PropriedadePropria.eof do
  begin
    qryConfigPadrao.Close;
    qryConfigPadrao.Open;
    qryConfigPadrao.Filtered := false;
    qryConfigPadrao.Filter   := 'ID_PROPRIEDADE='+PropriedadePropriaID.AsString;
    qryConfigPadrao.Filtered := true;
    qryConfigPadrao.Edit;
    qryConfigPadraoDATA_DIARIAS.AsDateTime := date;
    qryConfigPadrao.ApplyUpdates(-1);
    PropriedadePropria.Next;
  end;
  CloseFile(arq);
  Close;
end;


procedure TUpdate.AtualizaAliamentoEstoque;
var
 vQry :TFDQuery;
begin
 vQry            := TFDQuery.Create(nil);
 vQry.Connection := FCon;
 with vQry,vQry.SQL do
 begin
   Clear;
   Add('SELECT * FROM  ATUALIZA_VALOR_ESTOQUE(4,0)');
   Open;
 end;
 vQry.Free;
end;

procedure TUpdate.AtualizaSaldoAtualAlimento(idAlimento,IdPropriedade: string);
var
 vQry :TFDQuery;
 vMaxId:string;
begin
 vQry            := TFDQuery.Create(nil);
 vQry.Connection := FCon;
 with vQry,vQry.SQL do
 begin
   Clear;
   Add('EXECUTE PROCEDURE ATUALIZA_SALDO_ATUAL_ALIMENTO(');
   Add(IdPropriedade+',');
   Add(idAlimento);
   Add(')');
   ExecSQL;
 end;
 vQry.Free;
end;

procedure TUpdate.AtualizaSaldoAtualInsumoeProduto(idPropriedade:string);
var
 vQryAux,vQry1 :TFDQuery;
begin
 vQryAux := TFDQuery.Create(nil);
 vQryAux.Connection := fCon;
 with vQryAux,vQryAux.SQL do
 begin
   Clear;
   Add('SELECT * FROM ALIMENTO WHERE STATUS=1');
   Open;
   while not Eof do
   begin
    AtualizaSaldoAtualAlimento(vQryAux.FieldByName('ID').AsString,idPropriedade);
    vQryAux.Next;
   end;

   Clear;
   Add('SELECT * FROM SUPLEMENTO_MINERAL WHERE STATUS=1');
   Open;
   while not Eof do
   begin
    AtualizaSaldoAtualProduto(vQryAux.FieldByName('ID').AsString,idPropriedade);
    vQryAux.Next;
   end;
 end;
 vQryAux.FREE;
end;

procedure TUpdate.AtualizaSaldoAtualProduto(idAlimento,IdPropriedade: string);
var
 vQry :TFDQuery;
 vMaxId:string;
begin
 vQry            := TFDQuery.Create(nil);
 vQry.Connection := FCon;
 with vQry,vQry.SQL do
 begin
   Clear;
   Add('EXECUTE PROCEDURE ATUALIZA_SALDO_ATUAL_PRODUTO(');
   Add(IdPropriedade+',');
   Add(idAlimento);
   Add(')');
   ExecSQL;
 end;
 vQry.Free;
end;

function TUpdate.LerIni(Diretorio, Chave1, Chave2, ValorPadrao: String): String;
var
  FileIni: TIniFile;
begin
  result := ValorPadrao;
  try
    FileIni := TIniFile.Create(Diretorio);
    if FileExists(Diretorio) then
      result := FileIni.ReadString(Chave1, Chave2, ValorPadrao);
  finally
    FreeAndNil(FileIni)
  end;
end;

end.
