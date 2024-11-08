unit UdmReportConf;

interface

uses
  System.SysUtils, System.Classes, Data.DB,Vcl.Imaging.pngimage,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,fmx.Dialogs,
  ppDB, ppParameter,
  ppDesignLayer, ppCtrls, ppVar, ppBands,ppPrnabl,
  ppClass, ppCache, ppProd,  ppComm, ppRelatv, ppDBPipe,System.Variants,
  ppDBBDE,ppStrtch, ppSubRpt, ppReport;

type
  TdmRelConf = class(TDataModule)
    ppFichaForneciemnto: TppReport;
    ppHeaderBand6: TppHeaderBand;
    ppImage7: TppImage;
    ppLine12: TppLine;
    ppLabel79: TppLabel;
    ppDetailBand6: TppDetailBand;
    ppFooterBand6: TppFooterBand;
    ppLabel80: TppLabel;
    ppSystemVariable11: TppSystemVariable;
    ppSystemVariable12: TppSystemVariable;
    ppDesignLayers6: TppDesignLayers;
    ppDesignLayer6: TppDesignLayer;
    ppParameterList6: TppParameterList;
    ppDBFicha: TppDBPipeline;
    dsFichaForn: TDataSource;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppDBText3: TppDBText;
    ppShape9: TppShape;
    ppShape10: TppShape;
    ppDBText4: TppDBText;
    ppShape11: TppShape;
    ppLine1: TppLine;
    ppLabel1: TppLabel;
    ppDBText1: TppDBText;
    FichaForn: TFDQuery;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppGroup3: TppGroup;
    ppGroupHeaderBand3: TppGroupHeaderBand;
    ppGroupFooterBand3: TppGroupFooterBand;
    ppShape1: TppShape;
    ppLabel2: TppLabel;
    ppShape2: TppShape;
    ppShape3: TppShape;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppLabel4: TppLabel;
    ppLabel6: TppLabel;
    ppShape4: TppShape;
    ppLabel3: TppLabel;
    ppLabel5: TppLabel;
    ppLabel7: TppLabel;
    ppDBCalc1: TppDBCalc;
    ppShape7: TppShape;
    FichaFab: TFDQuery;
    dsFichaFab: TDataSource;
    ReportFichaFab: TppReport;
    ppParameterList1: TppParameterList;
    ppHeaderBand1: TppHeaderBand;
    ppImage1: TppImage;
    ppLine2: TppLine;
    ppLabel8: TppLabel;
    ppShape8: TppShape;
    ppLabel11: TppLabel;
    ppLabel9: TppLabel;
    ppLabel18: TppLabel;
    ppShape16: TppShape;
    ppShape17: TppShape;
    ppShape18: TppShape;
    ppLabel13: TppLabel;
    ppShape19: TppShape;
    ppLabel14: TppLabel;
    ppLabel15: TppLabel;
    ppLabel16: TppLabel;
    ppDetailBand1: TppDetailBand;
    ppShape12: TppShape;
    ppShape14: TppShape;
    ppFooterBand1: TppFooterBand;
    ppLabel10: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    ppLine3: TppLine;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppDBText2: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppGroupFooterBand4: TppGroupFooterBand;
    ppShape13: TppShape;
    ppDBText7: TppDBText;
    ppDBText11: TppDBText;
    ppDBText10: TppDBText;
    ppShape15: TppShape;
    ppLabel12: TppLabel;
    ppLine4: TppLine;
    FichaLeitura: TFDQuery;
    dsFichaLeitura: TDataSource;
    ppDBPFichaLeitura: TppDBPipeline;
    ReportFichaLeitura: TppReport;
    ppHeaderBand2: TppHeaderBand;
    ppImage2: TppImage;
    ppLine5: TppLine;
    ppLabel17: TppLabel;
    ppShape20: TppShape;
    ppLabel19: TppLabel;
    ppShape21: TppShape;
    ppLabel22: TppLabel;
    ppLine6: TppLine;
    ppDetailBand2: TppDetailBand;
    ppShape22: TppShape;
    ppShape23: TppShape;
    ppShape24: TppShape;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppFooterBand2: TppFooterBand;
    ppLabel23: TppLabel;
    ppSystemVariable3: TppSystemVariable;
    ppSystemVariable4: TppSystemVariable;
    ppLine7: TppLine;
    ppShape26: TppShape;
    ppShape27: TppShape;
    ppShape28: TppShape;
    ppLabel25: TppLabel;
    ppLabel26: TppLabel;
    ppLabel27: TppLabel;
    ppDesignLayers2: TppDesignLayers;
    ppDesignLayer2: TppDesignLayer;
    ppParameterList2: TppParameterList;
    FichaLeituraCODIGO: TStringField;
    FichaLeituraPESO_MEDIO: TFMTBCDField;
    FichaLeituraDIAS_MEDIO: TIntegerField;
    FichaLeituraQTDE_CAB: TIntegerField;
    ppLblDataLeitura: TppLabel;
    ppShape29: TppShape;
    ppDBText12: TppDBText;
    ppShape30: TppShape;
    ppLabel21: TppLabel;
    ppShape31: TppShape;
    ppDBText13: TppDBText;
    ppShape32: TppShape;
    ppLabel28: TppLabel;
    ppShape33: TppShape;
    ppLabel20: TppLabel;
    ppShape34: TppShape;
    ppDBText14: TppDBText;
    dsRelLoteAtivo: TDataSource;
    ppDBRelLoteAtivo: TppDBPipeline;
    ppRepLoteAtivo: TppReport;
    ppParameterList3: TppParameterList;
    TUltimasLeiturasRel: TFDQuery;
    dsUltimasLeiturasRel: TDataSource;
    ppDBUltimasLeiturasRel: TppDBPipeline;
    TUltimasLeiturasRelULTIMO_AJUSTE: TFMTBCDField;
    TUltimasLeiturasRelPNULTIMO_AJUSTE: TFMTBCDField;
    TUltimasLeiturasRelANTIPNULTIMO_AJUSTE: TFMTBCDField;
    FichaFornDATA_FORN: TDateField;
    FichaFornRACAO: TStringField;
    FichaFornTRATO: TIntegerField;
    FichaFornCURRAL: TStringField;
    FichaFornPREVISTO_KG: TFMTBCDField;
    FichaLeituraULTIMA_NOTA: TFMTBCDField;
    FichaFornLOTE: TIntegerField;
    FichaFornORDEM: TIntegerField;
    FichaFornQTD_ANIMAIS: TIntegerField;
    FichaFornHORARIO: TTimeField;
    ppLabel69: TppLabel;
    ppShape37: TppShape;
    ppDBText43: TppDBText;
    ppLabel68: TppLabel;
    ppDBText42: TppDBText;
    qryAux: TFDQuery;
    TRelZoo: TFDQuery;
    TRelZooID: TIntegerField;
    TRelZooLOTE: TIntegerField;
    TRelZooCURRAL: TStringField;
    TRelZooQTDE_CAB: TIntegerField;
    TRelZooENTRADA: TDateField;
    TRelZooPESO_ENTRADA: TFMTBCDField;
    TRelZooARROENT: TFMTBCDField;
    TRelZooDIAS_MEDIO: TIntegerField;
    TRelZooPESO_PROJ: TFMTBCDField;
    TRelZooARROPROJ: TFMTBCDField;
    TRelZooGPT: TFMTBCDField;
    TRelZooARROBAPRODMED: TFMTBCDField;
    TRelZooARROBAPRODTOTAL: TFMTBCDField;
    TRelZooGMD: TFMTBCDField;
    TRelZooCONSUMO_MN_GERAL: TFMTBCDField;
    TRelZooCONSUMO_MS_GERAL: TFMTBCDField;
    TRelZooIMS_PV_GERAL: TFMTBCDField;
    TRelZooCONSUMO_MN: TFMTBCDField;
    TRelZooCONSUMO_MS: TFMTBCDField;
    TRelZooIMS_PV: TFMTBCDField;
    TRelZooCONSUMO_MN_1D: TFMTBCDField;
    TRelZooCONSUMO_MS_1D: TFMTBCDField;
    TRelZooIMS_PV_1D: TFMTBCDField;
    TRelZooCONSUMO_MN_5D: TFMTBCDField;
    TRelZooCONSUMO_MS_5D: TFMTBCDField;
    TRelZooIMS_PV_5D: TFMTBCDField;
    TRelZooDATA_BASE_REL: TDateField;
    TRelZooID_PROPRIEDADE: TIntegerField;
    TRelZooGrid: TFDQuery;
    TRelZooGridID: TIntegerField;
    TRelZooGridLOTE: TIntegerField;
    TRelZooGridCURRAL: TStringField;
    TRelZooGridQTDE_CAB: TIntegerField;
    TRelZooGridENTRADA: TDateField;
    TRelZooGridPESO_ENTRADA: TFMTBCDField;
    TRelZooGridARROENT: TFMTBCDField;
    TRelZooGridDIAS_MEDIO: TIntegerField;
    TRelZooGridPESO_PROJ: TFMTBCDField;
    TRelZooGridARROPROJ: TFMTBCDField;
    TRelZooGridGPT: TFMTBCDField;
    TRelZooGridARROBAPRODMED: TFMTBCDField;
    TRelZooGridARROBAPRODTOTAL: TFMTBCDField;
    TRelZooGridGMD: TFMTBCDField;
    TRelZooGridCONSUMO_MN_GERAL: TFMTBCDField;
    TRelZooGridCONSUMO_MS_GERAL: TFMTBCDField;
    TRelZooGridIMS_PV_GERAL: TFMTBCDField;
    TRelZooGridCONSUMO_MN: TFMTBCDField;
    TRelZooGridCONSUMO_MS: TFMTBCDField;
    TRelZooGridIMS_PV: TFMTBCDField;
    TRelZooGridCONSUMO_MN_1D: TFMTBCDField;
    TRelZooGridCONSUMO_MS_1D: TFMTBCDField;
    TRelZooGridIMS_PV_1D: TFMTBCDField;
    TRelZooGridCONSUMO_MN_5D: TFMTBCDField;
    TRelZooGridCONSUMO_MS_5D: TFMTBCDField;
    TRelZooGridIMS_PV_5D: TFMTBCDField;
    TRelZooGridDATA_BASE_REL: TDateField;
    TRelZooGridID_PROPRIEDADE: TIntegerField;
    RelGMDGrid: TFDQuery;
    RelGMDGridR_SISBOV: TStringField;
    RelGMDGridR_CURRAL_ATUAL: TStringField;
    RelGMDGridPESO_ANTERIOR: TFMTBCDField;
    RelGMDGridDATA_PESO_ANTERIOR: TDateField;
    RelGMDGridPESO_ATUAL: TFMTBCDField;
    RelGMDGridDATA_PESO: TDateField;
    RelGMDGridDIAS: TIntegerField;
    RelGMDGridGMD: TFMTBCDField;
    RelGMD: TFDQuery;
    RelGMDR_SISBOV: TStringField;
    RelGMDR_CURRAL_ATUAL: TStringField;
    RelGMDPESO_ANTERIOR: TFMTBCDField;
    RelGMDDATA_PESO_ANTERIOR: TDateField;
    RelGMDPESO_ATUAL: TFMTBCDField;
    RelGMDDATA_PESO: TDateField;
    RelGMDDIAS: TIntegerField;
    RelGMDGMD: TFMTBCDField;
    dsRelGmd: TDataSource;
    ppDBRelGMD: TppDBPipeline;
    ppRepgmd: TppReport;
    ppHeaderBand4: TppHeaderBand;
    ppImage4: TppImage;
    ppLabel77: TppLabel;
    ppLine17: TppLine;
    ppImage5: TppImage;
    ppShape5: TppShape;
    ppLabel82: TppLabel;
    ppLabel95: TppLabel;
    ppDetailBand4: TppDetailBand;
    ppShape6: TppShape;
    ppFooterBand4: TppFooterBand;
    ppLine24: TppLine;
    ppLabel116: TppLabel;
    ppSystemVariable7: TppSystemVariable;
    ppSystemVariable8: TppSystemVariable;
    ppDesignLayers4: TppDesignLayers;
    ppDesignLayer4: TppDesignLayer;
    ppParameterList4: TppParameterList;
    ppLabel83: TppLabel;
    ppLabel84: TppLabel;
    ppLabel85: TppLabel;
    ppLabel86: TppLabel;
    ppLabel87: TppLabel;
    ppLabel88: TppLabel;
    RelGMDGTP: TFMTBCDField;
    RelGMDGridGTP: TFMTBCDField;
    ppDBText47: TppDBText;
    ppDBText49: TppDBText;
    ppDBText50: TppDBText;
    ppDBText51: TppDBText;
    ppDBText52: TppDBText;
    ppDBText53: TppDBText;
    ppDBText54: TppDBText;
    ppDBText55: TppDBText;
    ppShape38: TppShape;
    ppLabel89: TppLabel;
    ppDBText56: TppDBText;
    ppSummaryBand1: TppSummaryBand;
    ppShape39: TppShape;
    ppShape40: TppShape;
    ppShape41: TppShape;
    ppShape42: TppShape;
    ppDBCalc2: TppDBCalc;
    ppDBCalc3: TppDBCalc;
    ppLabel92: TppLabel;
    ppLabel93: TppLabel;
    ppDBCalc4: TppDBCalc;
    ppLabel94: TppLabel;
    ppDBCalc5: TppDBCalc;
    ppLabel90: TppLabel;
    RealEstoqueAtual: TFDQuery;
    RealEstoqueAtualINSUMO: TStringField;
    RealEstoqueAtualTIPO: TStringField;
    RealEstoqueAtualTOTAL_ENTRADA: TFMTBCDField;
    RealEstoqueAtualVALOR_TOTAL_ENTRADA: TFMTBCDField;
    RealEstoqueAtualTOTAL_SAIDA: TFMTBCDField;
    RealEstoqueAtualSALDO_ATUAL: TFMTBCDField;
    RealEstoqueAtualCUSTO_MEDIO: TFMTBCDField;
    dsRelEstoqueAtual: TDataSource;
    ppDBPEstoqueAtual: TppDBPipeline;
    ppRepEstoqueAtual: TppReport;
    ppHeaderBand5: TppHeaderBand;
    ppImage6: TppImage;
    ppLabel91: TppLabel;
    ppLine18: TppLine;
    ppImage8: TppImage;
    ppShape44: TppShape;
    ppLabel104: TppLabel;
    ppDetailBand5: TppDetailBand;
    ppShape45: TppShape;
    ppFooterBand5: TppFooterBand;
    ppLine19: TppLine;
    ppLabel105: TppLabel;
    ppSystemVariable9: TppSystemVariable;
    ppSystemVariable10: TppSystemVariable;
    ppDesignLayers5: TppDesignLayers;
    ppDesignLayer5: TppDesignLayer;
    ppParameterList5: TppParameterList;
    ppLabel96: TppLabel;
    ppLabel97: TppLabel;
    ppLabel98: TppLabel;
    ppLabel99: TppLabel;
    ppLabel100: TppLabel;
    ppDBText64: TppDBText;
    ppDBText48: TppDBText;
    ppDBText57: TppDBText;
    ppDBText58: TppDBText;
    ppDBText59: TppDBText;
    ppDBText60: TppDBText;
    ppGroup5: TppGroup;
    ppGroupHeaderBand5: TppGroupHeaderBand;
    ppGroupFooterBand5: TppGroupFooterBand;
    ppShape43: TppShape;
    ppLabel101: TppLabel;
    ppLabel102: TppLabel;
    ppLabel103: TppLabel;
    ppLabel106: TppLabel;
    ppDBCalc6: TppDBCalc;
    ppDBCalc7: TppDBCalc;
    ppDBCalc8: TppDBCalc;
    ppDBCalc9: TppDBCalc;
    RelGMDTIPO: TStringField;
    RelGMDGridTIPO: TStringField;
    ppLabel107: TppLabel;
    ppDBText61: TppDBText;
    qryRelFinanceiro: TFDQuery;
    dsRelFinanceiro: TDataSource;
    ppRepRelFinanceiro: TppReport;
    ppParameterList17: TppParameterList;
    ppDBRelFinanceiro: TppDBPipeline;
    qryRelFinanceiroLOTE: TIntegerField;
    qryRelFinanceiroCURRAL: TStringField;
    qryRelFinanceiroQTDE_CAB: TIntegerField;
    qryRelFinanceiroENTRADA: TDateField;
    qryRelFinanceiroPESO_ENTRADA: TBCDField;
    qryRelFinanceiroARROENT: TBCDField;
    qryRelFinanceiroDIARIAS: TIntegerField;
    qryRelFinanceiroDIAS_MEDIO: TIntegerField;
    qryRelFinanceiroPESO_PROJ: TBCDField;
    qryRelFinanceiroARROPROJ: TBCDField;
    qryRelFinanceiroGPT: TBCDField;
    qryRelFinanceiroARROBAPRODMED: TBCDField;
    qryRelFinanceiroARROBAPRODTOTAL: TBCDField;
    qryRelFinanceiroGMD: TBCDField;
    qryRelFinanceiroVALOR_COMPRA: TBCDField;
    qryRelFinanceiroVALOR_ARR_COMPRA: TBCDField;
    qryRelFinanceiroCUSTO_MN_TOTAL: TBCDField;
    qryRelFinanceiroCUSTO_FIXO_TOTAL: TBCDField;
    qryRelFinanceiroCUSTO_SANIDADE_TOTAL: TBCDField;
    qryRelFinanceiroCUSTO_MN_CAB: TBCDField;
    qryRelFinanceiroCUSTO_FIXO_CAB: TBCDField;
    qryRelFinanceiroCUSTO_SANIDADE_CAB: TBCDField;
    qryRelFinanceiroCUSTO_FIXO_CAB_DIA: TBCDField;
    qryRelFinanceiroCUSTO_MN_CAB_DIA: TBCDField;
    qryRelFinanceiroCUSTO_MN_CAB_0D: TBCDField;
    qryRelFinanceiroCUSTO_MN_CAB_1D: TBCDField;
    qryRelFinanceiroCUSTO_MN_CAB_5D: TBCDField;
    qryRelFinanceiroCUSTO_PRODUCAO_CAB_PERIODO: TBCDField;
    qryRelFinanceiroCUSTO_ARR_PRODUZIDA: TBCDField;
    qryBaixaInsumo: TFDQuery;
    dsBaixaInsumo: TDataSource;
    ppDBPBaixaInsumo: TppDBPipeline;
    ppRepBaixaInsumo: TppReport;
    ppHeaderBand7: TppHeaderBand;
    ppImage9: TppImage;
    ppLine20: TppLine;
    ppLabel108: TppLabel;
    ppDetailBand7: TppDetailBand;
    ppShape48: TppShape;
    ppShape49: TppShape;
    ppShape50: TppShape;
    ppDBText66: TppDBText;
    ppDBText67: TppDBText;
    ppFooterBand7: TppFooterBand;
    ppLabel113: TppLabel;
    ppSystemVariable13: TppSystemVariable;
    ppSystemVariable14: TppSystemVariable;
    ppLine22: TppLine;
    ppDesignLayers7: TppDesignLayers;
    ppDesignLayer7: TppDesignLayer;
    ppParameterList7: TppParameterList;
    qryBaixaInsumoALIMENTO: TStringField;
    qryBaixaInsumoFABRICADO: TBCDField;
    qryBaixaInsumoVALORKG: TFMTBCDField;
    ppDBText62: TppDBText;
    ppSummaryBand3: TppSummaryBand;
    ppShape47: TppShape;
    ppDBCalc10: TppDBCalc;
    FichaFabDATA_FAB_R: TDateField;
    FichaFabRACAO: TStringField;
    FichaFabPREVISTO_KG_R: TFMTBCDField;
    FichaFabFABRICACAO_NUMERO: TIntegerField;
    FichaFabINSUMO: TStringField;
    FichaFabPREV_INSUMO: TFMTBCDField;
    FichaFabREAL_INSUMO: TFMTBCDField;
    ppDBReportFichaFab: TppDBPipeline;
    qryBaixaInsumoCENTRO_CUSTO: TStringField;
    ppGroup6: TppGroup;
    ppGroupHeaderBand6: TppGroupHeaderBand;
    ppGroupFooterBand6: TppGroupFooterBand;
    ppShape46: TppShape;
    ppRelBaixaLblDe: TppLabel;
    ppLabel109: TppLabel;
    ppLabel110: TppLabel;
    ppRelBaixaLblAte: TppLabel;
    ppLabel111: TppLabel;
    ppRelBaixaLblTipoBaixa: TppLabel;
    ppLabel112: TppLabel;
    ppLabel119: TppLabel;
    ppRelBaixaLblRacao: TppLabel;
    ppRelBaixaLblOperador: TppLabel;
    ppLabel121: TppLabel;
    ppShape52: TppShape;
    ppShape53: TppShape;
    ppShape54: TppShape;
    ppLabel115: TppLabel;
    ppLabel117: TppLabel;
    ppLabel118: TppLabel;
    ppDBText63: TppDBText;
    ppShape51: TppShape;
    ppDBCalc11: TppDBCalc;
    ppDBText65: TppDBText;
    ppLabel114: TppLabel;
    RealEstoqueAtualCUSTO_MEDIO_MS: TFMTBCDField;
    RelGMDR_CHIP: TStringField;
    RelGMDGridR_CHIP: TStringField;
    ppHeaderBand17: TppHeaderBand;
    ppImage18: TppImage;
    ppShape133: TppShape;
    ppLabel198: TppLabel;
    ppLabel199: TppLabel;
    ppLine40: TppLine;
    ppLabel200: TppLabel;
    ppLabel202: TppLabel;
    ppLabel203: TppLabel;
    ppLabel206: TppLabel;
    ppLabel207: TppLabel;
    ppLabel208: TppLabel;
    ppLabel201: TppLabel;
    ppLabel209: TppLabel;
    ppLabel210: TppLabel;
    ppLabel211: TppLabel;
    ppLabel212: TppLabel;
    ppLabel213: TppLabel;
    ppLabel214: TppLabel;
    ppLabel215: TppLabel;
    ppLabel216: TppLabel;
    ppLabel217: TppLabel;
    ppLabel218: TppLabel;
    ppLabel219: TppLabel;
    ppLabel220: TppLabel;
    ppLabel221: TppLabel;
    ppLabel222: TppLabel;
    ppLabel223: TppLabel;
    ppLine42: TppLine;
    ppDetailBand17: TppDetailBand;
    ppShape134: TppShape;
    ppDBText117: TppDBText;
    ppDBText118: TppDBText;
    ppDBText119: TppDBText;
    ppDBText120: TppDBText;
    ppDBText121: TppDBText;
    ppDBText122: TppDBText;
    ppDBText123: TppDBText;
    ppDBText124: TppDBText;
    ppDBText125: TppDBText;
    ppDBText126: TppDBText;
    ppDBText127: TppDBText;
    ppDBText128: TppDBText;
    ppDBText129: TppDBText;
    ppDBText130: TppDBText;
    ppDBText131: TppDBText;
    ppDBText132: TppDBText;
    ppDBText133: TppDBText;
    ppDBText134: TppDBText;
    ppDBText135: TppDBText;
    ppDBText136: TppDBText;
    ppDBText137: TppDBText;
    ppDBText138: TppDBText;
    ppPageSummaryBand3: TppPageSummaryBand;
    ppShape135: TppShape;
    ppLabel204: TppLabel;
    ppDBCalc59: TppDBCalc;
    ppFooterBand17: TppFooterBand;
    ppLine41: TppLine;
    ppLabel205: TppLabel;
    ppSystemVariable33: TppSystemVariable;
    ppSystemVariable34: TppSystemVariable;
    ppDesignLayers17: TppDesignLayers;
    ppDesignLayer17: TppDesignLayer;
    ppLabel120: TppLabel;
    ppDBText68: TppDBText;
    ppLabel122: TppLabel;
    qryRelFinanceiroVALOR_DIARIA_TOTAL: TBCDField;
    qryRelFinanceiroVALOR_DIARIA_ALIMENTAR: TBCDField;
    ppDBText69: TppDBText;
    TRelZooTIPOLOTENOME: TStringField;
    TRelZooGridTIPOLOTENOME: TStringField;
    ppHeaderBand3: TppHeaderBand;
    imgCli: TppImage;
    ppLabel29: TppLabel;
    ppLine8: TppLine;
    ppImage3: TppImage;
    ppShape36: TppShape;
    ppLabel45: TppLabel;
    ppLabel46: TppLabel;
    ppLabel47: TppLabel;
    ppLabel48: TppLabel;
    ppLabel49: TppLabel;
    ppLabel50: TppLabel;
    ppLabel56: TppLabel;
    ppLabel57: TppLabel;
    ppLabel58: TppLabel;
    ppLabel59: TppLabel;
    ppLabel24: TppLabel;
    ppLine10: TppLine;
    ppLabel81: TppLabel;
    ppLabel62: TppLabel;
    ppLabel63: TppLabel;
    ppLabel64: TppLabel;
    ppLabel52: TppLabel;
    ppLine11: TppLine;
    ppLabel53: TppLabel;
    ppLabel54: TppLabel;
    ppLabel55: TppLabel;
    ppLabel44: TppLabel;
    ppLabel61: TppLabel;
    ppLabel70: TppLabel;
    ppLine13: TppLine;
    ppLabel71: TppLabel;
    ppLine14: TppLine;
    ppLabel72: TppLabel;
    ppLabel73: TppLabel;
    ppLabel74: TppLabel;
    ppLine15: TppLine;
    ppLabel75: TppLabel;
    ppLabel76: TppLabel;
    ppLabel78: TppLabel;
    ppLabel51: TppLabel;
    ppLabel60: TppLabel;
    ppLine16: TppLine;
    ppLabel65: TppLabel;
    ppLabel66: TppLabel;
    ppLabel67: TppLabel;
    ppDetailBand3: TppDetailBand;
    ppShape25: TppShape;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppDBText22: TppDBText;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    ppDBText30: TppDBText;
    ppDBText31: TppDBText;
    ppDBText33: TppDBText;
    ppDBText35: TppDBText;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppDBText29: TppDBText;
    ppDBText25: TppDBText;
    ppDBText28: TppDBText;
    ppDBText32: TppDBText;
    ppDBText34: TppDBText;
    ppDBText36: TppDBText;
    ppDBText44: TppDBText;
    ppDBText45: TppDBText;
    ppDBText26: TppDBText;
    ppDBText27: TppDBText;
    ppDBText37: TppDBText;
    ppDBText38: TppDBText;
    ppDBText39: TppDBText;
    ppDBText40: TppDBText;
    ppDBText41: TppDBText;
    ppDBText46: TppDBText;
    ppFooterBand3: TppFooterBand;
    ppLine9: TppLine;
    ppLabel30: TppLabel;
    ppSystemVariable5: TppSystemVariable;
    ppSystemVariable6: TppSystemVariable;
    ppSummaryBand2: TppSummaryBand;
    ppShape35: TppShape;
    ppLabel31: TppLabel;
    ppLabel32: TppLabel;
    ppLabel33: TppLabel;
    ppLabel34: TppLabel;
    ppLabel35: TppLabel;
    ppLabel36: TppLabel;
    ppLabel37: TppLabel;
    ppLabel38: TppLabel;
    ppDBCalc33: TppDBCalc;
    ppDBCalc35: TppDBCalc;
    ppDBCalc36: TppDBCalc;
    ppDBCalc37: TppDBCalc;
    ppLabel39: TppLabel;
    ppDBCalc38: TppDBCalc;
    ppLabel40: TppLabel;
    ppDBCalc39: TppDBCalc;
    ppDBCalc40: TppDBCalc;
    ppDBCalc41: TppDBCalc;
    ppLabel41: TppLabel;
    ppDBCalc42: TppDBCalc;
    ppLabel43: TppLabel;
    ppDBCalc44: TppDBCalc;
    ppDBCalc45: TppDBCalc;
    ppLabel42: TppLabel;
    pLblPesoEntrada: TppLabel;
    ppDesignLayers3: TppDesignLayers;
    ppDesignLayer3: TppDesignLayer;
    ppLabel123: TppLabel;
    ppDBText70: TppDBText;
    procedure ppDetailBand3AfterPrint(Sender: TObject);
    procedure ppFichaForneciemntoPreviewFormClose(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AbreFichaForne(vData,Trato,vFiltro:string);
    procedure AbreFichaFabricacao(dataFab,previstoKg,QtdeBatida,idRacao:string);
    function  AbreFichaLeituraCocho(DataLeitura:TDate):Boolean;

    procedure AbreLeituraLote(idLote:string);
    procedure AbreRelatorioZootecnico(vData: Tdate;vOrdem,TipoLote:integer);
    procedure GeraRelZoo(vData:TDate);
    procedure GeraRelGMD(vIdLocal,vDataDe,vDataAte,vFiltro:string);
    procedure RelEstoqueAtualCustoMedio;
    procedure RelFinanceiro(DataBase:TDate);
    procedure GeraRelBaixaInsumo(DateDe,DataAte,TipoBaixa,CentroCusto,Racao,
     Operador:String);

  end;

var
  dmRelConf: TdmRelConf;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses USeviceConfinamento, UServiceDB, URelGMD, UPrincipal;

{$R *.dfm}

{ TdmRelConf }

procedure TdmRelConf.AbreFichaFabricacao(dataFab, previstoKg, QtdeBatida,
  idRacao: string);
begin
 with FichaFab,FichaFab.SQL do
 begin
  Clear;
  Add('SELECT * FROM FICHA_FABRICACAO(');
  Add(FormatDateTime('mm/dd/yyyy',strToDate(dataFab)).QuotedString+',');
  Add(idRacao+',');
  Add(previstoKg+',');
  Add(QtdeBatida+')');
  Open;
 end;
end;

procedure TdmRelConf.AbreFichaForne(vData,Trato,vFiltro: string);
begin
 with FichaForn,FichaForn.SQL do
 begin
   Clear;
   Add('SELECT * FROM FICHA_FORN('+vData+','+Trato+')');
   Add('where 1=1');
   Add(vFiltro);
   Add('ORDER BY RACAO,TRATO,');
   Add('SUBSTRING(CURRAL FROM 1 FOR (POSITION(''-''IN CURRAL)-1)),ORDEM');
   Open;
   try
//    ppReport1.PrintReport;
    ppFichaForneciemnto.PrintReport;
   finally

   end;
 end;
end;

function TdmRelConf.AbreFichaLeituraCocho(DataLeitura:TDate):Boolean;
begin
 with FichaLeitura,FichaLeitura.SQL do
 begin
   Clear;
   Add('SELECT');
   Add('B.CODIGO,');
   Add('A.PESO_MEDIO,');
   Add('A.DIAS_MEDIO,');
   Add('A.QTDE_CAB,');
   Add('(SELECT FIRST 1  L.NOTA FROM LEITURA_COCHO L');
   Add('WHERE L.ID_LOTE=A.ID');
   Add('ORDER BY L.DATA_LEITURA DESC)ULTIMA_NOTA');
   Add('FROM LOTE_NUTRICIONAL A');
   Add('JOIN CURRAIS B ON A.ID_LOCAL=B.ID');
   Add('WHERE A.STATUS=1 AND A.ID_PROPRIEDADE='+serviceDB.vIdPropriedade);
   Add('ORDER BY SUBSTRING(b.codigo FROM 1 FOR (POSITION(''-''IN b.codigo)-1)),ORDERM_FORN');
   Open;
   if not IsEmpty then
   begin
     ppLblDataLeitura.Text := FormatDateTime('dd/mm/yyyy',DataLeitura);
     ReportFichaLeitura.Print;
     Result := false;
   end
   else
    Result := true;
 end;
end;

procedure TdmRelConf.AbreLeituraLote(idLote: string);
begin
 with TUltimasLeiturasRel,TUltimasLeiturasRel.SQL do
 begin
  Clear;
  Add('SELECT');
  Add('FIRST 1 NOTA ULTIMO_AJUSTE,');
  Add('(SELECT');
  Add('FIRST 1 SKIP 1 NOTA FROM LEITURA_COCHO');
  Add('WHERE ID_LOTE=LT.ID_LOTE');
  Add('ORDER BY DATA_LEITURA DESC) PNULTIMO_AJUSTE,');
  Add('(SELECT');
  Add('FIRST 1 SKIP 2 NOTA FROM LEITURA_COCHO');
  Add('WHERE ID_LOTE=LT.ID_LOTE');
  Add('ORDER BY DATA_LEITURA DESC) ANTIPNULTIMO_AJUSTE');
  Add('FROM LEITURA_COCHO LT');
  Add('WHERE ID_LOTE='+idLote);
  Add('ORDER BY DATA_LEITURA DESC');
  Open;
 end;
end;

procedure TdmRelConf.GeraRelBaixaInsumo(DateDe, DataAte, TipoBaixa, CentroCusto,
  Racao, Operador: String);
begin
 with qryBaixaInsumo,qryBaixaInsumo.SQL do
 begin
   Clear;
   Add('SELECT');
   Add(' COALESCE(A.NOME,SP.NOME)Alimento,');
   Add(' SUM(F.KG_FABRICADO)FABRICADO,');
   Add(' AVG(F.VALOR_KG)ValorKG,');
   Add(' C.NOME CENTRO_CUSTO');
   Add('FROM FABRICACAO_INSUMOS F');
   Add('JOIN FABRICACAO FA ON FA.ID=F.ID_FABRICACAO');
   Add('JOIN users U ON U.ID=FA.ID_OPERADOR');
   Add('LEFT JOIN RACAO R ON FA.IDRACAO=R.ID');
   Add('LEFT JOIN AUX_CENTRO_CUSTO C ON C.ID=FA.ID_CENTROCUSTO');
   Add('LEFT JOIN ALIMENTO A ON F.ID_ALIMENTO = A.ID');
   Add('LEFT JOIN SUPLEMENTO_MINERAL SP ON SP.ID = F.ID_CONCENTRADO');
   Add('WHERE FA.STATUS >-1 AND FA.ID_PROPRIEDADE='+frmPrincipal.vIDPropriedadePropria);
   Add('AND FA.DATA_FAB BETWEEN '+
    FormatDateTime('mm/dd/yyyy',strToDate(DateDe)).QuotedString+' AND '+
     FormatDateTime('mm/dd/yyyy',strToDate(DataAte)).QuotedString);
   if strToInt(TipoBaixa)>0 then
    Add('AND FA.TIPO_BAIXA='+TipoBaixa);
   if StringReplace(CentroCusto,'''','',[rfReplaceAll])<>'Todos' then
    Add(' AND C.NOME = '+CentroCusto);
   if StringReplace(Racao,'''','',[rfReplaceAll]).Length>0 then
    Add(' AND R.NOME = '+Racao);
   if StringReplace(Operador,'''','',[rfReplaceAll]).Length>0 then
    Add(' AND U.NAME = '+Operador);
   Add('GROUP BY COALESCE(A.NOME,SP.NOME),C.NOME');
   Add('ORDER BY C.NOME');
   Open;
   if not IsEmpty then
   begin
     ppRelBaixaLblDe.Text   := DateDe;
     ppRelBaixaLblAte.Text  := DataAte;
     if strToInt(TipoBaixa)=0 then
      ppRelBaixaLblTipoBaixa.Text := 'Todas';
     if strToInt(TipoBaixa)=1 then
      ppRelBaixaLblTipoBaixa.Text := 'Consumo';
     if strToInt(TipoBaixa)=2 then
      ppRelBaixaLblTipoBaixa.Text := 'Acerto';
     if strToInt(TipoBaixa)=3 then
      ppRelBaixaLblTipoBaixa.Text := 'Transferencia';

//     if StringReplace(CentroCusto,'''','',[rfReplaceAll])<>'Todos' then
//      ppRelBaixaLblCentroCusto.Text := StringReplace(CentroCusto,'''','',[rfReplaceAll])
//     else
//      ppRelBaixaLblCentroCusto.Text := 'Todos';

     if StringReplace(Racao,'''','',[rfReplaceAll]).Length>0 then
      ppRelBaixaLblRacao.Text := StringReplace(Racao,'''','',[rfReplaceAll])
     else
      ppRelBaixaLblRacao.Text := 'Todas';

     if StringReplace(Operador,'''','',[rfReplaceAll]).Length>0 then
      ppRelBaixaLblOperador.Text := StringReplace(Operador,'''','',[rfReplaceAll])
     else
      ppRelBaixaLblOperador.Text := 'Todos';

      ppRepBaixaInsumo.print;
   end;
 end;
end;

procedure TdmRelConf.GeraRelGMD(vIdLocal,vDataDe,vDataAte,vFiltro: string);
begin
 with RelGMDGrid,RelGMDGrid.SQL do
 begin
   Clear;
   Add('select * from PROC_GMD_CURRAL(:vIdLocal,:DATA_INI,:DATA_FIM,:ID_PROP)');
   Add('where 1=1');
   if vFiltro.Length>0 then
   Add(vFiltro);
   ParamByName('vIdLocal').AsString  := vIdLocal;
   ParamByName('DATA_INI').AsString  := vDataDe;
   ParamByName('DATA_FIM').AsString  := vDataAte;
   ParamByName('ID_PROP').AsString   := serviceDB.vIdPropriedade;
   Open;
 end;

 with RelGMD,RelGMD.SQL do
 begin
   Clear;
   Add('select * from PROC_GMD_CURRAL(:vIdLocal,:DATA_INI,:DATA_FIM,:ID_PROP)');
   Add('where 1=1');
    if vFiltro.Length>0 then
   Add(vFiltro);
   ParamByName('vIdLocal').AsString  := vIdLocal;
   ParamByName('DATA_INI').AsString  := vDataDe;
   ParamByName('DATA_FIM').AsString  := vDataAte;
   ParamByName('ID_PROP').AsString   := serviceDB.vIdPropriedade;
   Open;
 end;
end;

procedure TdmRelConf.GeraRelZoo(vData:TDate);
begin
 with qryAux,qryAux.SQL DO
 begin
   Clear;
   Add('insert into REL_ZOO_CONF');
   Add('SELECT');
   Add('NULL,');
   Add('LOTE,');
   Add('CURRAL,');
   Add('QTDE_CAB,');
   Add('ENTRADA,');
   Add('PESO_ENTRADA,');
   Add('ARROENT,');
   Add('DIAS_MEDIO,');
   Add('PESO_PROJ,');
   Add('ARROPROJ,');
   Add('GPT,');
   Add('ARROBAPRODMED,');
   Add('ARROBAPRODTOTAL,');
   Add('GMD,');
   Add('CONSUMO_MN_GERAL,');
   Add('CONSUMO_MS_GERAL,');
   Add('IMS_PV_GERAL,');
   Add('CONSUMO_MN,');
   Add('CONSUMO_MS,');
   Add('IMS_PV,');
   Add('CONSUMO_MN_1D,');
   Add('CONSUMO_MS_1D,');
   Add('IMS_PV_1D,');
   Add('CONSUMO_MN_5D,');
   Add('CONSUMO_MS_5D,');
   Add('IMS_PV_5D,');
   Add(':vData,');
   Add(':vIdProp');
   Add('from RELATORIO_ZOOTEC(:vIdProp,:vData)');
   ParamByName('vIDProp').AsString := serviceDB.vIdPropriedade;
   ParamByName('vData').AsDate     := vData;
   ExecSQL;
 end;
 with TRelZooGrid,TRelZooGrid.SQL do
 begin
   Clear;
   Add('SELECT * from REL_ZOO_CONF');
   Add('WHERE ID_PROPRIEDADE=:vIdProp');
   Add('AND DATA_BASE_REL=:vData');
   ParamByName('vIDProp').AsString := serviceDB.vIdPropriedade;
   ParamByName('vData').AsDate   := vData;
   Open;
 end;
 with TRelZoo,TRelZoo.SQL do
 begin
   Clear;
   Add('SELECT * from REL_ZOO_CONF');
   Add('WHERE ID_PROPRIEDADE=:vIdProp');
   Add('AND DATA_BASE_REL=:vData');
   ParamByName('vIDProp').AsString := serviceDB.vIdPropriedade;
   ParamByName('vData').AsDate   := vData;
   Open;
 end;
end;


procedure TdmRelConf.AbreRelatorioZootecnico(vData: Tdate;vOrdem,TipoLote:integer);
begin
 with TRelZooGrid,TRelZooGrid.SQL do
 begin
  Clear;
  Add('SELECT a.*,');
  Add('CASE');
  Add('	WHEN TIPOLOTE =0 THEN ''Confinamento''');
  Add('	WHEN TIPOLOTE =1 THEN ''Semi-confi.''');
  Add('	WHEN TIPOLOTE =2 THEN ''Sequestro''');
  Add('END tipoLotenome');
  Add('FROM  REL_ZOO_CONF a');
  Add('JOIN LOTE_NUTRICIONAL ln2 ON ln2.id=a.lote');
  Add('JOIN CURRAIS c ON c.id=LN2.ID_LOCAL');
  Add('where a.id_propriedade=:id_propriedade');
  Add('and a.data_base_rel=:vData');
  if TipoLote>-1 then
   Add('and TipoLote='+TipoLote.ToString);

  if vOrdem=1 then
  begin
   Add('ORDER BY SUBSTRING(curral FROM 1 FOR POSITION(''-'' IN curral)-1),');
   Add('SUBSTRING(curral FROM (POSITION(''-'' IN curral)+1) FOR CHAR_LENGTH(curral))');
  end
  else
  begin
    Add('ORDER BY C.ORDERM_FORN ');
  end;
  ParamByName('id_propriedade').AsString := serviceDB.vIdPropriedade;
  ParamByName('vData').AsDate := vData;
  Open;
 end;
 with TRelZoo,TRelZoo.SQL do
 begin
   Clear;
   Add('SELECT a.*,');
   Add('CASE');
   Add('	WHEN TIPOLOTE =0 THEN ''Confinamento''');
   Add('	WHEN TIPOLOTE =1 THEN ''Semi-confi.''');
   Add('	WHEN TIPOLOTE =2 THEN ''Sequestro''');
   Add('END tipoLotenome');
   Add('FROM  REL_ZOO_CONF a');
   Add('JOIN LOTE_NUTRICIONAL ln2 ON ln2.id=A.lote');
   Add('JOIN CURRAIS c ON c.id=LN2.ID_LOCAL');
   Add('WHERE A.ID_PROPRIEDADE=:vIdProp');
   Add('AND A.DATA_BASE_REL=:vData');
   if TipoLote>-1 then
    Add('and TipoLote='+TipoLote.ToString);
   if vOrdem=1 then
   begin
    Add('ORDER BY SUBSTRING(curral FROM 1 FOR POSITION(''-'' IN curral)-1),');
    Add('SUBSTRING(curral FROM (POSITION(''-'' IN curral)+1) FOR CHAR_LENGTH(curral))');
   end
   else
   begin
    Add('ORDER BY C.ORDERM_FORN');
   end;
   ParamByName('vIDProp').AsString := serviceDB.vIdPropriedade;
   ParamByName('vData').AsDate   := vData;
   Open;
 end;
end;

procedure TdmRelConf.ppDetailBand3AfterPrint(Sender: TObject);
begin
  AbreLeituraLote(ppDBText18.Text);
end;

procedure TdmRelConf.ppFichaForneciemntoPreviewFormClose(Sender: TObject);
begin
  ShowMessage('Relatorio Gerado com sucesso!')
end;

procedure TdmRelConf.RelEstoqueAtualCustoMedio;
begin
 with RealEstoqueAtual,RealEstoqueAtual.sql do
 begin
  Clear;
  Add('select * from SELECT_ESTOQUE_ATUAL_CM('+serviceDB.vIdPropriedade+')');
  Open;
 end;
end;

procedure TdmRelConf.RelFinanceiro(DataBase:TDate);
begin
 with qryRelFinanceiro,qryRelFinanceiro.SQL do
 begin
   Clear;
   Add('SELECT * FROM  RELATORIO_FINANCEIRO (');
   Add(serviceDB.vIdPropriedade);
   Add(',:vcurrent_date');
   Add(')');
   ParamByName('vcurrent_date').AsDate := DataBase;
   try
     OPen;
   except
     on e : Exception do
      ShowMessage ('Erro ao Editar Curral: '+e.Message)
   end;

 end;
end;

end.
