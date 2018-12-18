unit AExportaSCIECFAX;
{          Autor: JORGE EDUARDO RODRIGUES
    Data Criação: 24 DE OUTUBRO DE 2001;
          Função: GERAR TEXTO PARA SCI/ECFAX
  Data Alteração:
    Alterado por:
Motivo alteração:
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, StdCtrls, Mask, DBCtrls, Tabela, Buttons, ComCtrls,
  Componentes1, ImportaDado, Grids, DBGrids, ExtCtrls, PainelGradiente, formularios,
  QuickRpt, Qrctrls, ShellAPI, Localizacao, CheckLst, DBKeyViolation;

type FormatoData =  (MMAAAA);

type
  TFExportaSciEcfax = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    Label5: TLabel;
    Label6: TLabel;
    Data2: TCalendario;
    Data1: TCalendario;
    Aux: TQuery;
    DsContasRec: TDataSource;
    Tempo: TPainelTempo;
    Salvar: TSaveDialog;
    PanelColor2: TPanelColor;
    Label3: TLabel;
    PanelColor3: TPanelColor;
    BitBtn1: TBitBtn;
    ContasRec: TQuery;
    ContasRecI_COD_CLI: TIntegerField;
    ContasRecI_COD_PRF: TIntegerField;
    ContasRecC_NOM_CLI: TStringField;
    ContasRecD_DAT_CAD: TDateField;
    ContasRecD_DAT_ALT: TDateField;
    ContasRecC_END_CLI: TStringField;
    ContasRecC_BAI_CLI: TStringField;
    ContasRecC_CEP_CLI: TStringField;
    ContasRecC_FON_RES: TStringField;
    ContasRecC_EST_CLI: TStringField;
    ContasRecC_CID_CLI: TStringField;
    ContasRecC_CID_ANT: TStringField;
    ContasRecC_EST_ANT: TStringField;
    ContasRecD_DAT_NAS: TDateField;
    ContasRecC_REG_CLI: TStringField;
    ContasRecC_CPF_CLI: TStringField;
    ContasRecC_CGC_CLI: TStringField;
    ContasRecC_INS_CLI: TStringField;
    ContasRecC_NAT_CLI: TStringField;
    ContasRecC_EST_NAT: TStringField;
    ContasRecC_NOM_EMP: TStringField;
    ContasRecC_END_EMP: TStringField;
    ContasRecC_BAI_EMP: TStringField;
    ContasRecC_CEP_EMP: TStringField;
    ContasRecC_FON_EMP: TStringField;
    ContasRecC_EST_EMP: TStringField;
    ContasRecC_CID_EMP: TStringField;
    ContasRecD_ADM_CLI: TDateField;
    ContasRecN_LIM_CLI: TFloatField;
    ContasRecN_REN_CLI: TFloatField;
    ContasRecC_PAI_CLI: TStringField;
    ContasRecC_MAE_CLI: TStringField;
    ContasRecC_REF_COM: TMemoField;
    ContasRecC_NOM_CON: TStringField;
    ContasRecC_EMP_CON: TStringField;
    ContasRecC_FON_CON: TStringField;
    ContasRecD_DAT_CON: TDateField;
    ContasRecC_REF_PES: TMemoField;
    ContasRecC_OBS_CLI: TMemoField;
    ContasRecC_EST_CIV: TStringField;
    ContasRecC_SEX_CLI: TStringField;
    ContasRecC_TIP_END: TStringField;
    ContasRecC_TIP_RES: TStringField;
    ContasRecI_PRO_CON: TIntegerField;
    ContasRecC_END_ELE: TStringField;
    ContasRecC_WWW_CLI: TStringField;
    ContasRecI_NUM_END: TIntegerField;
    ContasRecI_NUM_ANT: TIntegerField;
    ContasRecI_NUM_EMP: TIntegerField;
    ContasRecC_LGR_ANT: TStringField;
    ContasRecC_CEP_ANT: TStringField;
    ContasRecC_TIP_PES: TStringField;
    ContasRecC_FO1_CLI: TStringField;
    ContasRecC_FO2_CLI: TStringField;
    ContasRecC_FO3_CLI: TStringField;
    ContasRecC_TIP_CAD: TStringField;
    ContasRecC_ORG_EXP: TStringField;
    ContasRecC_FON_FAX: TStringField;
    ContasRecC_CON_CLI: TStringField;
    ContasRecC_FON_CEL: TStringField;
    ContasRecC_NOM_REP: TStringField;
    ContasRecC_CON_REP: TStringField;
    ContasRecC_FAX_REP: TStringField;
    ContasRecC_FON_REP: TStringField;
    ContasRecC_COM_END: TStringField;
    ContasRecI_COD_SIT: TIntegerField;
    ContasRecCOD_CIDADE: TIntegerField;
    ContasRecC_PRA_CLI: TStringField;
    ContasRecC_END_ANT: TStringField;
    ContasRecC_ELE_REP: TStringField;
    ContasRecI_COD_REG: TIntegerField;
    ContasRecN_DES_VEN: TFloatField;
    ContasRecC_END_COB: TStringField;
    ContasRecI_COD_USU: TIntegerField;
    ContasRecC_IMP_BOL: TStringField;
    ContasRecN_DES_BOL: TFloatField;
    ContasRecI_COD_FRM: TIntegerField;
    ContasRecI_COD_PAG: TIntegerField;
    ContasRecC_NOM_FAN: TStringField;
    ContasRecI_LAN_REC: TIntegerField;
    ContasRecI_COD_PAG_1: TIntegerField;
    ContasRecI_EMP_FIL: TIntegerField;
    ContasRecI_COD_CLI_1: TIntegerField;
    ContasRecD_DAT_MOV: TDateField;
    ContasRecN_VLR_TOT: TFloatField;
    ContasRecI_QTD_PAR: TIntegerField;
    ContasRecI_NRO_NOT: TIntegerField;
    ContasRecD_DAT_EMI: TDateField;
    ContasRecI_COD_USU_1: TIntegerField;
    ContasRecI_ULT_DUP: TIntegerField;
    ContasRecI_SEQ_NOT: TIntegerField;
    ContasRecC_CLA_PLA: TStringField;
    ContasRecI_COD_EMP: TIntegerField;
    ContasRecC_CON_TEF: TStringField;
    ContasRecD_ULT_ALT: TDateField;
    ContasRecI_COD_VEN: TIntegerField;
    ContasRecI_COD_MAT: TIntegerField;
    ContasRecI_SEQ_MAT: TIntegerField;
    ContasRecI_EMP_FIL_1: TIntegerField;
    ContasRecI_LAN_REC_1: TIntegerField;
    ContasRecI_NRO_PAR: TIntegerField;
    ContasRecI_COD_FRM_1: TIntegerField;
    ContasRecD_DAT_VEN: TDateField;
    ContasRecD_DAT_PAG: TDateField;
    ContasRecN_VLR_PAR: TFloatField;
    ContasRecN_VLR_DES: TFloatField;
    ContasRecN_VLR_ACR: TFloatField;
    ContasRecN_TOT_PAR: TFloatField;
    ContasRecN_VLR_PAG: TFloatField;
    ContasRecN_PER_MOR: TFloatField;
    ContasRecN_PER_JUR: TFloatField;
    ContasRecN_PER_MUL: TFloatField;
    ContasRecN_PER_COR: TFloatField;
    ContasRecI_COD_USU_2: TIntegerField;
    ContasRecN_VLR_ENT: TFloatField;
    ContasRecC_NRO_DUP: TStringField;
    ContasRecN_DES_VEN_1: TFloatField;
    ContasRecC_FLA_PAR: TStringField;
    ContasRecL_OBS_REC: TMemoField;
    ContasRecI_PAR_FIL: TIntegerField;
    ContasRecI_PAR_MAE: TIntegerField;
    ContasRecI_DIA_CAR: TIntegerField;
    ContasRecN_PER_ACR: TFloatField;
    ContasRecN_PER_DES: TFloatField;
    ContasRecI_FIL_PAG: TIntegerField;
    ContasRecC_DUP_CAN: TStringField;
    ContasRecI_LAN_BAC: TIntegerField;
    ContasRecN_VLR_ADI: TFloatField;
    ContasRecI_COD_SIT_1: TIntegerField;
    ContasRecI_NUM_BOR: TIntegerField;
    ContasRecC_FLA_CAR: TStringField;
    ContasRecC_FLA_BOL: TStringField;
    ContasRecC_FLA_DUP: TStringField;
    ContasRecI_COD_MOE: TIntegerField;
    ContasRecI_SEQ_TEF: TIntegerField;
    ContasRecD_ULT_ALT_1: TDateField;
    ContasRecD_DAT_EST: TDateField;
    ContasRecI_USU_EST: TIntegerField;
    JuriRazao: TImportaDadoString;
    JuriCgc: TImportaDadoString;
    JuriCid: TImportaDadoString;
    JuriEst: TImportaDadoString;
    JuriEmail: TImportaDadoString;
    JuriCep: TImportaDadoString;
    JuriNomFan: TImportaDadoString;
    JuriValorTran: TImportaDadoNumerico;
    JuriDataVen: TImportaDadoData;
    JuriDatPag: TImportaDadoData;
    JuriDataVecto: TImportaDadoData;
    BExportar: TBitBtn;
    JuriValIntPag: TImportaDadoNumerico;
    Arquivo: TLabel;
    Barra: TProgressBar;
    TextoFisico: TRichEdit;
    textoJuridico: TRichEdit;
    JuriEndereco: TImportaDadoTexto;
    ContasRecddd: TStringField;
    ContasRecfone: TStringField;
    ContasRecdddFax: TStringField;
    ContasRecfoneFax: TStringField;
    JuriIdentrans: TImportaDadoTexto;
    FisicaCPF: TImportaDadoString;
    FisicaRG: TImportaDadoString;
    FisicaORGEMI: TImportaDadoString;
    FisicaEnder: TImportaDadoString;
    FisicaCep: TImportaDadoString;
    FisicaDDD: TImportaDadoString;
    FisicaFone: TImportaDadoString;
    FisicaDDDFax: TImportaDadoString;
    FisicaFonFax: TImportaDadoString;
    FisicaEmail: TImportaDadoString;
    FisicaNroDoc: TImportaDadoTexto;
    FisicaValorTrans: TImportaDadoNumerico;
    FisicaValorIntPag: TImportaDadoNumerico;
    FisicaDataVenda: TImportaDadoData;
    FisicaDataVencto: TImportaDadoData;
    FisicaDataPagto: TImportaDadoData;
    FisicaNome: TImportaDadoString;
    FisicaCidad: TImportaDadoString;
    FisicaEstado: TImportaDadoString;
    Label4: TLabel;
    Label7: TLabel;
    LabelFisico: TLabel;
    LabelJuridico: TLabel;
    FisicaTipoDoc: TImportaDadoTexto;
    JuriTipoTrans: TImportaDadoTexto;
    Label13: TLabel;
    Label12: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    JuriDDD: TImportaDadoString;
    JuriFone: TImportaDadoString;
    JuriDDDFax: TImportaDadoString;
    JuriFoneFax: TImportaDadoString;
    Localiza: TConsultaPadrao;
    Label24: TLabel;
    EditLocaliza5: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    Label25: TLabel;
    JuriClienteDesde: TImportaDadoTexto;
    FisicaClientedesde: TImportaDadoTexto;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BExportarClick(Sender: TObject);
    procedure JuriCgcValida(var Conteudo: String);
    procedure JuriNomFanValida(var Conteudo: String);
    procedure JuriFone1Valida(var Conteudo: String);
    procedure JuriRazaoValida(var Conteudo: String);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure textoJuridicoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextoFisicoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FisicaORGEMIValida(var Conteudo: String);
    procedure Data1Change(Sender: TObject);
    procedure EditLocaliza5Select(Sender: TObject);
  private
    function DataClienteFormato(Formato : FormatoData; data : TDateTime; charSeparador : char) : string;
    function LimpaCaracter( frase : string ) : string;
    function LimpaFone( frase : string ) : string;
    function GeraAnoMes(data : TdateTime) : string;
    function ValidaDadosJuridicos : boolean;
    function ValidaDadosFisicos: boolean;
    procedure PosicionaRegistros (VpaTabela : TQuery);
    procedure ExportaPessoaJuridica;
    procedure ExportaPessoaFisica;
  public
    { Public declarations }
  end;

var
  FExportaSciEcfax: TFExportaSciEcfax;

implementation
uses APrincipal, FunData, funstring, funObjeto, constMsg, constantes, funsql,
     FunHardware,Funvalida, funarquivos;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFExportaSciEcfax.FormCreate(Sender: TObject);
begin
  Data1.Date := PrimeiroDiaMes(DATE);
  data2.Date := UltimoDiaMes(Date);
  EditLocaliza5.Text := inttostr(varia.CodigoEmpFil);
  PosicionaRegistros(ContasRec);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFExportaSciEcfax.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFExportaSciEcfax.BitBtn1Click(Sender: TObject);
begin
  self.close;
end;

{******************* abre a tabela de contas *********************************}
procedure TFExportaSciEcfax.PosicionaRegistros(VpaTabela : TQuery);
begin
  ContasRec.close;
  ContasRec.sql.clear;
  ContasRec.sql.add(' SELECT substr(c_fo1_cli,5,2) ddd,  right( c_fo1_cli,9) fone,  ' +
                    ' substr(c_fon_fax,5,2) dddFax,  right( c_fon_fax,9) foneFax,  '+
                    ' CADCLI.I_COD_CLI,CADCLI.I_COD_PRF,CADCLI.C_NOM_CLI,CADCLI.D_DAT_CAD, ' +
                    ' CADCLI.D_DAT_ALT,CADCLI.C_END_CLI,CADCLI.C_BAI_CLI,CADCLI.C_CEP_CLI, ' +
                    ' CADCLI.C_FON_RES,CADCLI.C_EST_CLI,CADCLI.C_CID_CLI,CADCLI.C_CID_ANT, ' +
                    ' CADCLI.C_EST_ANT,CADCLI.D_DAT_NAS,CADCLI.C_REG_CLI,CADCLI.C_CPF_CLI, ' +
                    ' CADCLI.C_CGC_CLI,CADCLI.C_INS_CLI,CADCLI.C_NAT_CLI,CADCLI.C_EST_NAT, ' +
                    ' CADCLI.C_NOM_EMP,CADCLI.C_END_EMP,CADCLI.C_BAI_EMP,CADCLI.C_CEP_EMP, ' +
                    ' CADCLI.C_FON_EMP,CADCLI.C_EST_EMP,CADCLI.C_CID_EMP,CADCLI.D_ADM_CLI, ' +
                    ' CADCLI.N_LIM_CLI,CADCLI.N_REN_CLI,CADCLI.C_PAI_CLI,CADCLI.C_MAE_CLI, ' +
                    ' CADCLI.C_REF_COM,CADCLI.C_NOM_CON,CADCLI.C_EMP_CON,CADCLI.C_FON_CON, ' +
                    ' CADCLI.D_DAT_CON,CADCLI.C_REF_PES,CADCLI.C_OBS_CLI,CADCLI.C_EST_CIV, ' +
                    ' CADCLI.C_SEX_CLI,CADCLI.C_TIP_END,CADCLI.C_TIP_RES,CADCLI.I_PRO_CON, ' +
                    ' CADCLI.C_END_ELE,CADCLI.C_WWW_CLI,CADCLI.I_NUM_END,CADCLI.I_NUM_ANT, ' +
                    ' CADCLI.I_NUM_EMP,CADCLI.C_LGR_ANT,CADCLI.C_CEP_ANT,CADCLI.C_TIP_PES, ' +
                    ' CADCLI.C_FO1_CLI,CADCLI.C_FO2_CLI,CADCLI.C_FO3_CLI,CADCLI.C_TIP_CAD, ' +
                    ' CADCLI.C_ORG_EXP,CADCLI.C_FON_FAX,CADCLI.C_CON_CLI,CADCLI.C_FON_CEL, ' +
                    ' CADCLI.C_NOM_REP,CADCLI.C_CON_REP,CADCLI.C_FAX_REP,CADCLI.C_FON_REP, ' +
                    ' CADCLI.C_COM_END,CADCLI.I_COD_SIT,CADCLI.COD_CIDADE,CADCLI.C_PRA_CLI,' +
                    ' CADCLI.C_END_ANT,CADCLI.C_ELE_REP,CADCLI.I_COD_REG,CADCLI.N_DES_VEN, ' +
                    ' CADCLI.C_END_COB,CADCLI.I_COD_USU,CADCLI.C_IMP_BOL,CADCLI.N_DES_BOL, ' +
                    ' CADCLI.I_COD_FRM,CADCLI.I_COD_PAG,CADCLI.C_NOM_FAN, ' +
                    ' CAD.I_LAN_REC,CAD.I_COD_PAG,CAD.I_EMP_FIL,CAD.I_COD_CLI, ' +
                    ' CAD.D_DAT_MOV,CAD.N_VLR_TOT,CAD.I_QTD_PAR,CAD.I_NRO_NOT, ' +
                    ' CAD.D_DAT_EMI,CAD.I_COD_USU,CAD.I_ULT_DUP,CAD.I_SEQ_NOT, ' +
                    ' CAD.C_CLA_PLA,CAD.I_COD_EMP,CAD.C_CON_TEF,CAD.D_ULT_ALT, ' +
                    ' CAD.I_COD_VEN,CAD.I_COD_MAT,CAD.I_SEQ_MAT, ' +
                    ' MOV.I_EMP_FIL,MOV.I_LAN_REC,MOV.I_NRO_PAR,MOV.I_COD_FRM, ' +
                    ' MOV.D_DAT_VEN,MOV.D_DAT_PAG,MOV.N_VLR_PAR,MOV.N_VLR_DES, ' +
                    ' MOV.N_VLR_ACR,MOV.N_TOT_PAR,MOV.N_VLR_PAG,MOV.N_PER_MOR, ' +
                    ' MOV.N_PER_JUR,MOV.N_PER_MUL,MOV.N_PER_COR,MOV.I_COD_USU, ' +
                    ' MOV.N_VLR_ENT,MOV.C_NRO_DUP,MOV.N_DES_VEN,MOV.C_FLA_PAR, ' +
                    ' MOV.L_OBS_REC,MOV.I_PAR_FIL,MOV.I_PAR_MAE,MOV.I_DIA_CAR, ' +
                    ' MOV.N_PER_ACR,MOV.N_PER_DES,MOV.I_FIL_PAG,MOV.C_DUP_CAN, ' +
                    ' MOV.I_LAN_BAC,MOV.N_VLR_ADI,MOV.I_COD_SIT,MOV.I_NUM_BOR, ' +
                    ' MOV.C_FLA_CAR,MOV.C_FLA_BOL,MOV.C_FLA_DUP,MOV.I_COD_MOE, ' +
                    ' MOV.I_SEQ_TEF,MOV.D_ULT_ALT,MOV.D_DAT_EST,MOV.I_USU_EST ' +
                    ' FROM ' +
                    ' CADCONTASARECEBER  AS CAD, ' +
                    ' MOVCONTASARECEBER AS MOV, ' +
                    ' CADCLIENTES AS CADCLI ' +
                    ' WHERE ' +
                    SQLTextoDataEntreAAAAMMDD('CAD.D_DAT_EMI',Data1.Date,Data2.Date,False) +
                    ' AND CAD.I_EMP_FIL = ' + EditLocaliza5.Text +
                    ' AND CAD.I_EMP_FIL = MOV.I_EMP_FIL ' +
                    ' AND CAD.I_LAN_REC = MOV.I_LAN_REC ' +
                    ' AND CAD.I_COD_CLI = CADCLI.I_COD_CLI ' +
                    ' AND CADCLI.C_EST_CLI IN (''SC'',''RS'',''PR'',''SP'',''RJ'',''ES'',''MG'',''MT'',''GO'',''DF'',''BA'',''CE'',''MA'',' +
                                               '''PE'',''PB'',''AL'',''SE'',''PI'',''RN'',''PA'',''AM'',''RO'',''RR'',''AC'',''TO'',''AP'')');
  ContasRec.open;

end;

{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
{{{{{{{{{{{{{{{{{{{{{{{{{ FUNÇÕES DE LIMPEZA }{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

{*********************** LIMPA TELEFONE **************************************}
function TFExportaSciEcfax.LimpaFone( frase : string ) : string;
begin
  result := DeletaChars(result,')');
  result := DeletaChars(result,'(');
  result := DeletaChars(result,' ');
  result := DeletaChars(result,'*');
end;

{********************* LIMPA CARACTERES  *************************************}
function TFExportaSciEcfax.LimpaCaracter( frase : string ) : string;
begin
  result := DeletaChars(frase,'.');
  result := DeletaChars(result,'/');
  result := DeletaChars(result,' ');
  result := DeletaChars(result,'-');
  result := DeletaChars(result,'\');
end;

function  TFExportaSciEcfax.GeraAnoMes(data : TdateTime) : string;
var
  aux : string;
begin
   result := '';
   if mes(data) < 10 then
     result := '0' + inttostr(mes(data))
   else
    result := inttostr(mes(data));

   aux := inttostr(ano(data));
   if Length(aux) > 2 then
     result := result + aux
   else
     if StrtoInt(aux) >= 00 then
       result := result + '20' + aux
     else
       result := result + '19' + aux;
end;


{************** CRIA TEXTO DAS PESSOAS JURIDICAS PARA EXPORTAÇAO **************}
procedure TFExportaSciEcfax.ExportaPessoaJuridica;
var
  VpfRegistroJuridica, Endereco, Data, NroDoc, TipoDoc : string; //VALIDA ENDERECO E IDENTIFICADOR DA TRANSACAO
begin
  NroDoc := ContasRecI_NRO_NOT.AsString;   //IDENTFICADOR RECEBE NRO DA NOTA
  Endereco := ContasRecC_END_CLI.AsString;   // PASSA ENDEREÇO JUNTO COM LOGRADOURO

  if ContasRecI_NUM_END.AsString <> '' then
    Endereco := Endereco + ' ' + ContasRecI_NUM_END.AsString;
  if ContasRecC_COM_END.AsString <> '' then
    Endereco := Endereco + ' ' + ContasRecC_COM_END.AsString;

  if ContasRecI_NRO_NOT.AsString <> '' then   //SE NRO DA NOTA DIFERENTE DE  VAZIO
    NroDoc :=  ContasRecI_NRO_NOT.AsString;   //RECEBE NRO DA NOTA
  if ContasRecI_NRO_NOT.AsString = '' then    //SE NRO DA NOTA IGUAL A VAZIO
    NroDoc :=  ContasRecC_NRO_DUP.AsString;   //RECEBE NRO DA DUPLICATA
  if (ContasRecI_NRO_NOT.AsString = '') and (ContasRecC_NRO_DUP.AsString = '')  then   //SE NRO DA NOTA E DUPLICATA IGUAIS A VAZIOS
    NroDoc := ContasRecI_LAN_REC.AsString;   // RECEBE NRO DO LANÇAMENTO DA CONTA A RECEBER

 // IDENTIFICA O TIPO DE DOCUMENTO
  if NroDoc = ContasRecI_NRO_NOT.AsString then  // SE RECEBER NRO DA NOTA
    TipoDoc := 'N';                             // SE RECEBER NRO DA NOTA

  if NroDoc = ContasRecC_NRO_DUP.AsString then  // SE RECEBER NRO DA DUPLICATA
    TipoDoc := 'D';                             // SE RECEBER NRO DA DUPLICATA

  if NroDoc = ContasRecI_LAN_REC.AsString then   // SE RECEBER NRO DA CONTA A RECEBER
    TipoDoc := 'F';

 // SE RECEBER NRO DA FATURA
//  if ContasRecfone.AsString = '' then
//  begin
//    ContasRecddd.AsString := '';
//  end;

  Data := DataClienteFormato(MMAAAA,ContasRecD_DAT_CAD.AsDateTime,#0); // PASSA A FUNCAO PARA DATA CLIENTE DESDE

  // VARIAVEL RECEBE COMPONENTES COM SEUS CAMPOS
  VpfRegistroJuridica := 'J' + JuriCgc.texto + JuriRazao.texto + UpperCase(JuriNomFan.texto) + 'M' +
  UpperCase(JuriEndereco.texto(Endereco)) + UpperCase(JuriCid.texto) + UpperCase(JuriEst.texto) +  JuriCep.texto +
  JuriDDD.texto + JuriFone.texto + JuriDDDFax.texto + JuriFoneFax.texto + JuriEmail.texto +
  JuriClienteDesde.texto(data) + JuriIdentrans.texto(NroDoc) + JuriTipoTrans.texto(TipoDoc) + 'R$  ' + JuriValorTran.texto +
  '00' + JuriValIntPag.texto + '00' + JuriDataVen.texto + JuriDataVecto.texto + JuriDatPag.texto + #13 + #10;
  textoJuridico.Lines.Add(VpfRegistroJuridica); // PASSA VARIAVEL CARREGADA PARA CRIAR TEXTO
end;

{************** CRIA TEXTO DAS PESSOAS FISICAS PARA EXPORTAÇAO **************}
procedure TFExportaSciEcfax.ExportaPessoaFisica;
var
  VpfRegistroFisica ,NroDoc, Data,TipoDoc: string;
begin
  if ContasRecI_NRO_NOT.AsString <> '' then   //SE NRO DA NOTA DIFERENTE DE  VAZIO
    NroDoc :=  ContasRecI_NRO_NOT.AsString;   //RECEBE NRO DA NOTA
  if ContasRecI_NRO_NOT.AsString = '' then    //SE NRO DA NOTA IGUAL A VAZIO
    NroDoc :=  ContasRecC_NRO_DUP.AsString;   //RECEBE NRO DA DUPLICATA
  if (ContasRecI_NRO_NOT.AsString = '') and (ContasRecC_NRO_DUP.AsString = '')  then   //SE NRO DA NOTA E DUPLICATA IGUAIS A VAZIOS
    NroDoc := ContasRecI_LAN_REC.AsString;   // RECEBE NRO DO LANÇAMENTO DA CONTA A RECEBER

 // IDENTIFICA O TIPO DE DOCUMENTO
  if NroDoc = ContasRecI_NRO_NOT.AsString then  // SE RECEBER NRO DA NOTA
    TipoDoc := 'N';                             // SE RECEBER NRO DA NOTA

  if NroDoc = ContasRecC_NRO_DUP.AsString then  // SE RECEBER NRO DA DUPLICATA
    TipoDoc := 'D';                             // SE RECEBER NRO DA DUPLICATA

  if NroDoc = ContasRecI_LAN_REC.AsString then   // SE RECEBER NRO DA CONTA A RECEBER
    TipoDoc := 'F';                             // SE RECEBER NRO DA FATURA

  Data := DataClienteFormato(MMAAAA,ContasRecD_DAT_CAD.AsDateTime,#0); // PASSA A FUNCAO PARA DATA CLIENTE DESDE

  // VARIAVEL RECEBE COMPONENTES COM SEUS CAMPOS
  VpfRegistroFisica := 'F' + FisicaCPF.texto + FisicaRG.texto + FisicaORGEMI.texto +
    FisicaNome.texto + 'R' + FisicaEnder.texto + FisicaCidad.texto + UPPERCASE(FisicaEstado.texto) +
    FisicaCep.texto + FisicaDDD.texto + FisicaFone.texto + FisicaDDDFax.texto + FisicaFonFax.texto +
    FisicaEmail.texto + FisicaClientedesde.texto(Data) + FisicaNroDoc.texto(NroDoc) + FisicaTipoDoc.texto(TipoDoc) + 'R$  ' +
    FisicaValorTrans.texto + '00' + FisicaValorIntPag.texto + '00' +
    FisicaDataVenda.texto + FisicaDataVencto.texto + FisicaDataPagto.texto + #13 + #10;
    TextoFisico.Lines.Add(VpfRegistroFisica);// PASSA VARIAVEL CARREGADA PARA CRIAR TEXTO
end;

{******************************************************************************}
{       PASSA AS PROCEDIMENTOS COMO PARAMETRO DEPENDENDO O TIPO DE PESSOA      }
{******************************************************************************}
procedure TFExportaSciEcfax.BExportarClick(Sender: TObject);
begin
  if ContasRec.IsEmpty then
  begin
    aviso('Não há dados na tabela para "Exportar"!');
    abort;
  end;

  textoJuridico.Clear;  // LIMPA TEXTO JURIDICO
  ContasRec.First;   // VAI PARA O PRIMEIRO REGISTTRO

  while not ContasRec.Eof do  // ENQUANTO NAUM ESTA NO FIM DO ARQUIVO
  begin
    if ContasRecC_TIP_PES.AsString = 'J' then  // PARA PESSOA JURIDICA
      if ValidaDadosJuridicos then
        ExportaPessoaJuridica;    // PROCEDIMENTO CRIADO COMO PARAMETRO
    ContasRec.Next;  // TABELA VAI AOS PROXIMOS REGISTROS
    LabelJuridico.Caption := IntToStr(textoJuridico.Lines.Count);//CONTA REGISTROS
    Barra.Position := Barra.Position + 5;// POSIÇAO DA BARRA DE PROGRESSO
  end;
  if textoJuridico.Lines.Count <> 0 then
    if Salvar.Execute then
      textoJuridico.Lines.SaveToFile(Salvar.FileName); // SALVA ARQUIVO
      TextoFisico.Clear;   // LIMPA TEXTO FISICO
      Barra.Position := 0; // BARRA DE PROGRESSO VOLTA ZERADA
      ContasRec.First;  // VAI PARA O PRIMEIRO REGISTTRO

  while not ContasRec.Eof do // ENQUANTO NAUM ESTA NO FIM DO ARQUIVO
  begin
    if ContasRecC_TIP_PES.AsString = 'F' then // PARA PESSOA FISICA
      if ValidaDadosFisicos then
        ExportaPessoaFisica;  // PROCEDIMENTO CRIADO COMO PARAMETRO
        ContasRec.Next; // TABELA VAI AOS PROXIMOS REGISTROS
        LabelFisico.Caption := IntToStr(TextoFisico.Lines.Count);  //CONTA REGISTROS
        Barra.Position := Barra.Position + 5;// POSIÇAO DA BARRA DE PROGRESSO
  end;
  if TextoFisico.Lines.Count <> 0 then
    if Salvar.Execute then
      TextoFisico.Lines.SaveToFile(Salvar.FileName); // SALVA ARQUIVO
end;

{**********************  LIMPA CGC    *****************************************}
procedure TFExportaSciEcfax.JuriCgcValida(var Conteudo: String);
begin
  if Conteudo <> '' then
    Conteudo := RetiraAcentuacao(Conteudo);
    Conteudo := LimpaCaracter(Conteudo);
end;

{******************* RETIRA ACENTUACAO DO NOME ********************************}
procedure TFExportaSciEcfax.JuriNomFanValida(var Conteudo: String);
begin
  if Conteudo <> '' then
    Conteudo := RetiraAcentuacao(Conteudo); // RETIRA ACENTUACAO
    Conteudo := LimpaCaracter(Conteudo);
end;

{*****************   LIMPA TELEFONE  ******************************************}
procedure TFExportaSciEcfax.JuriFone1Valida(var Conteudo: String);
begin
  if Conteudo <> '' then
    Conteudo := LimpaFone(Conteudo); // LIMPA TELEFONE
end;

{************ PERMITE GERAR OS DADOS SOMENTE SE ESTIVEREM COMPLETOS ***********}
function TFExportaSciEcfax.ValidaDadosJuridicos : boolean ; //PESSOA JURIDICA
begin
  Result := true;
  if ContasRecC_TIP_PES.AsString = 'J' then    // PESSOA FISICA
    begin
    if (ContasRecC_CGC_CLI.AsString = '') then   //CGC
      Result := false
    else
    if (ContasRecC_CGC_CLI.AsString <> '')  then
       if not VerificaCGC(ContasRecC_CGC_CLI.AsString) then
         result := false
    else
    if length(ContasRecC_NOM_CLI.AsString) < 7 then   //RAZAO SOCIAL
      Result := false
    else
    if (ContasRecC_CID_CLI.AsString = '') then // ENDEREÇO
      Result := False
    else
    if (ContasRecC_EST_CLI.AsString = '') then  // ESTADO
      Result := False
    else
    if (ContasRecN_VLR_PAR.AsString = '') then  // VALOR DA PARCELA
      Result := False
    else
    if (ContasRecD_DAT_EMI.AsString = '') then  // DATA DA VENDA
      Result := False
    else
    if (ContasRecD_DAT_VEN.AsString = '') then  //DATA DE VENCIMENTO
      Result := False
  end;
end;

{************ PERMITE GERAR OS DADOS SOMENTE SE ESTIVEREM COMPLETOS ***********}
function TFExportaSciEcfax.ValidaDadosFisicos: boolean; // PESSOA FISICA
begin
  Result := true;
  if ContasRecC_TIP_PES.AsString = 'F' then    // PESSOA FISICA
    begin
      if (ContasRecC_CPF_CLI.AsString <> '')  then
        if not VerificaCPF(ContasRecC_CPF_CLI.AsString) then
          result := false;
      if (ContasRecC_CPF_CLI.AsString = '') then     //CPF
        Result := false
      else
      if length(ContasRecC_NOM_CLI.AsString) < 4 then    // RAZAO SOCIAL
        Result := false
      else
      if (ContasRecC_CID_CLI.AsString = '' ) then  //CIDADE
        Result := false
      else
      if (ContasRecC_EST_CLI.AsString = '') then //ESTADO
        Result := false
      else
      if (ContasRecN_VLR_PAR.AsString = '') then // VALOR DA PARCELA
        Result := False
      else
      if (ContasRecD_DAT_EMI.AsString = '') then // DATA DA VENDA
        Result := false
      else
      if (ContasRecD_DAT_VEN.AsString = '') then // DATA VENCIMENTO
        Result := false
  end;
end;

{*********************** RETIRA A ACENTUAÇÃO DA RAZAO SOCIAL ******************}
procedure TFExportaSciEcfax.JuriRazaoValida(var Conteudo: String);
begin
  if Conteudo <> '' then
    Conteudo := RetiraAcentuacao(Conteudo);
    Conteudo := LimpaCaracter(Conteudo);
end;

{**************** DISPARA PROCESSO DE EXPORTAÇÃO VIA TECLA F9 ****************}
procedure TFExportaSciEcfax.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if BExportar.Enabled then   // SE BOTAO HABILITADO
  begin
    if key = vk_F9 then
    BExportar.Click;
  end;
end;

{********* MOSTRA N° DO CARACTER DEPENDENDO POSIÇÃO DO CURSOR ****************}
procedure TFExportaSciEcfax.textoJuridicoKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Label12.Caption := IntToStr(textoJuridico.CaretPos.x);
end;

{********* MOSTRA N° DO CARACTER DEPENDENDO POSIÇÃO DO CURSOR ****************}
procedure TFExportaSciEcfax.TextoFisicoKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Label2.Caption := IntToStr(textoFisico.CaretPos.x);
end;

{********************* FUNÇÃO DE LIMPEZA ***********************************}
procedure TFExportaSciEcfax.FisicaORGEMIValida(var Conteudo: String);
begin
  if Conteudo <> '' then
    Conteudo := RetiraAcentuacao(Conteudo);
    Conteudo := LimpaCaracter(Conteudo);
end;

{********************** FAZENDO FILTRO POR DATA *****************************}
procedure TFExportaSciEcfax.Data1Change(Sender: TObject);
begin
  PosicionaRegistros(ContasRec);
end;

{*************** PROCEDIMENTO PARA CRIAR A DATA DO CLIENTE DESDE **************}
function TFExportaSciEcfax.DataClienteFormato(Formato : FormatoData; data : TDateTime; charSeparador : char) : string;
var
  m,aa : string;
begin
  m := InttoStr(mes(data));
  aa :=InttoStr(ano(data));
  if StrtoInt(m) < 10 then
    m := '0' + m;
  if CharSeparador <> #0 then
    case formato of
      MMAAAA : begin result := m + charSeparador + aa  end;
    end
    else
    case formato of
      MMAAAA : begin result := m + aa end;
    end
end;

///////////////////////////////////////////////////////////////////////////////
////////////////////////  VERIFICA A FILIAL QUE SERA EXPORTADA  //////////////
///////////////////////////////////////////////////////////////////////////////
procedure TFExportaSciEcfax.EditLocaliza5Select(Sender: TObject);
begin
   EditLocaliza5.ASelectLocaliza.Text := ' Select * from CadFiliais as fil ' +
                                         ' where c_nom_fan like ''@%'' ' +
                                         ' and i_cod_emp = ' + IntTostr(varia.CodigoEmpresa);
   EditLocaliza5.ASelectValida.Text := ' Select * from CadFiliais where I_EMP_FIL = @% ' +
                                       ' and i_cod_emp = ' + IntTostr(varia.CodigoEmpresa);
   if Varia.FilialUsuario <> '' then
   begin
     EditLocaliza5.ASelectValida.add(' and i_emp_fil not in ( ' + Varia.FilialUsuario + ')');
     EditLocaliza5.ASelectLocaliza.add(' and i_emp_fil not in ( ' + Varia.FilialUsuario + ')');
   end;
end;

initialization
 RegisterClasses([TFExportaSciEcfax]);
end.
