unit AExportacaoDeMascaras;
{          Autor: JORGE EDUARDO RODRIGUES
    Data Criação: 27 DE OUTUBRO DE 2001;
          Função: GERAR TEXTO PARA PERFIL DAS MASCARAS
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

type
  TFExportacaoDeMascaras = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    Label5: TLabel;
    Label6: TLabel;
    Data2: TCalendario;
    Data1: TCalendario;
    CadSql: TQuery;
    DSCadSql: TDataSource;
    Tempo: TPainelTempo;
    PanelColor2: TPanelColor;
    Label1: TLabel;
    Label3: TLabel;
    Label11: TLabel;
    ListaTexto: TRichEdit;
    BExportar: TBitBtn;
    PanelColor3: TPanelColor;
    BitBtn1: TBitBtn;
    Cadfilial: TQuery;
    CadfilialI_EMP_FIL: TIntegerField;
    CadfilialI_COD_EMP: TIntegerField;
    CadfilialI_COD_FIL: TIntegerField;
    CadfilialC_NOM_FIL: TStringField;
    CadfilialC_END_FIL: TStringField;
    CadfilialI_NUM_FIL: TIntegerField;
    CadfilialC_BAI_FIL: TStringField;
    CadfilialC_CID_FIL: TStringField;
    CadfilialC_EST_FIL: TStringField;
    CadfilialI_CEP_FIL: TIntegerField;
    CadfilialC_CGC_FIL: TStringField;
    CadfilialC_INS_FIL: TStringField;
    CadfilialC_GER_FIL: TStringField;
    CadfilialC_DIR_FIL: TStringField;
    CadfilialC_FON_FIL: TStringField;
    CadfilialC_FAX_FIL: TStringField;
    CadfilialC_OBS_FIL: TStringField;
    CadfilialD_DAT_MOV: TDateField;
    CadfilialC_WWW_FIL: TStringField;
    CadfilialC_END_ELE: TStringField;
    CadfilialD_DAT_INI_ATI: TDateField;
    CadfilialD_DAT_FIM_ATI: TDateField;
    CadfilialC_NOM_FAN: TStringField;
    CadfilialC_PIC_CLA: TStringField;
    CadfilialC_PIC_PRO: TStringField;
    CadfilialCOD_CIDADE: TIntegerField;
    CadfilialI_COD_TAB: TIntegerField;
    CadfilialC_CEP_FIL: TStringField;
    CadfilialI_DOC_NOT: TIntegerField;
    CadfilialC_DAD_ADI: TStringField;
    CadfilialC_TEX_RED: TStringField;
    CadfilialC_NOT_PAD: TIntegerField;
    CadfilialI_TAB_SER: TIntegerField;
    CadfilialD_ULT_ALT: TDateField;
    CadfilialC_PER_CAD: TStringField;
    CadfilialC_COR_FIL: TStringField;
    CadfilialL_TEX_CAB: TMemoField;
    Procurador: TConsultaPadrao;
    MovCampos: TQuery;
    DSMovCampos: TDataSource;
    Grade: TGridIndice;
    MovCamposI_COD_SQL: TIntegerField;
    MovCamposI_EMP_FIL: TIntegerField;
    MovCamposI_COD_CAM: TIntegerField;
    MovCamposD_ULT_ALT: TDateField;
    MovCamposC_NOM_PER: TStringField;
    MovCamposI_TAM_LIN: TIntegerField;
    MovCamposC_SEP_LIN: TStringField;
    MovCamposI_COD_SQL_1: TIntegerField;
    MovCamposI_COD_CAM_1: TIntegerField;
    MovCamposI_EMP_FIL_1: TIntegerField;
    MovCamposI_COD_ORD: TIntegerField;
    MovCamposC_NOM_CAM: TStringField;
    MovCamposI_TAM_CAM: TIntegerField;
    MovCamposI_CAR_INI: TIntegerField;
    MovCamposI_CAR_FIM: TIntegerField;
    MovCamposI_CAS_DEC: TIntegerField;
    MovCamposC_ALI_CAR: TStringField;
    MovCamposC_SEP_CAM: TStringField;
    MovCamposC_SEP_DEC: TStringField;
    MovCamposD_ULT_ALT_1: TDateField;
    MovCamposC_TIP_CAM: TStringField;
    CodSQL: TImportaDadoNumerico;
    CodPerfil: TImportaDadoNumerico;
    NroFilial: TImportaDadoNumerico;
    Sequencial: TImportaDadoNumerico;
    UltimaAlteracao: TImportaDadoData;
    NomeCampo: TImportaDadoString;
    Alinhamento: TImportaDadoString;
    SeparadorCampo: TImportaDadoString;
    SeparadorDecimal: TImportaDadoString;
    NomePerfil: TImportaDadoString;
    SeparadorLinha: TImportaDadoString;
    TipoDoCampo: TImportaDadoString;
    Tamanho: TImportaDadoNumerico;
    CaracterIni: TImportaDadoNumerico;
    CaracterFinal: TImportaDadoNumerico;
    CasasDecimais: TImportaDadoNumerico;
    Salvar: TSaveDialog;
    Arquivo: TLabel;
    Barra: TProgressBar;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BExportarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NomePerfilValida(var Conteudo: String);
  private
    function LimpaCaracter( frase : string ) : string;
    function LimpaFone( frase : string ) : string;
    function VerificaCampoVazio : boolean;
    procedure ExportaCampos;
    procedure LocalizaPerfis(VpaTabela : TQuery);
  public
    { Public declarations }
  end;

var
  FExportacaoDeMascaras: TFExportacaoDeMascaras;

implementation
uses APrincipal, FunData, funstring, funObjeto, constMsg, constantes, funsql,
     FunHardware;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFExportacaoDeMascaras.FormCreate(Sender: TObject);
begin
  Data1.Date := DecMes(date,3);
  data2.Date := date;
  LocalizaPerfis(MovCampos);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFExportacaoDeMascaras.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFExportacaoDeMascaras.BitBtn1Click(Sender: TObject);
begin
  self.close;
end;

{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
{{{{{{{{{{{{{{{{{{{{{{{{{ FUNÇÕES DE LIMPEZA }{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

{********************* LIMPA CARACTERES  *************************************}
function TFExportacaoDeMascaras.LimpaCaracter( frase : string ) : string;
begin
  result := DeletaChars(frase,'.');
  result := DeletaChars(result,'/');
  result := DeletaChars(result,'-');
  result := DeletaChars(result,'\');
end;

{*********************** LIMPA TELEFONE **************************************}
function TFExportacaoDeMascaras.LimpaFone( frase : string ) : string;
begin
  result := DeletaChars(frase,'-');
  result := DeletaChars(result,')');
  result := DeletaChars(result,'(');
  result := DeletaChars(result,' ');
  result := DeletaChars(result,'*');
end;

{********************* PROCEDIMENTO QUE GERA O TEXTO **************************}
procedure TFExportacaoDeMascaras.ExportaCampos;
var
  VPFLerRegistros : string;
begin
  VPFLerRegistros := Sequencial.texto + ' ' + NroFilial.texto + ' ' + CodSQL.texto + ' ' +
                     NomePerfil.texto + ' ' + CodPerfil.texto + ' ' + NomeCampo.texto + ' ' + TipoDoCampo.texto + ' ' +
                     Tamanho.texto + ' ' + CaracterIni.texto + ' ' + CaracterFinal.texto + ' ' + CasasDecimais.texto + ' ' +
                     Alinhamento.texto + ' ' + SeparadorCampo.texto + ' ' + SeparadorDecimal.texto + ' ' +
                     SeparadorLinha.texto + ' ' + UltimaAlteracao.texto;
  ListaTexto.Lines.Add(VPFLerRegistros);
end;

{**************** LOCALIZA PERFIL DOS CAMPOS QUE FORAM GERADOS ****************}
procedure TFExportacaoDeMascaras.LocalizaPerfis(VpaTabela : TQuery);
begin
  MovCampos.Close;
  MovCampos.SQL.Clear;
  MovCampos.SQL.Add(' SELECT  CAD.I_COD_SQL,CAD.I_EMP_FIL,CAD.I_COD_CAM, ' +
                    ' CAD.D_ULT_ALT,CAD.C_NOM_PER,CAD.I_TAM_LIN,CAD.C_SEP_LIN, ' +
                    ' MOV.I_COD_SQL,MOV.I_COD_CAM,MOV.I_EMP_FIL,I_COD_ORD, ' +
                    ' MOV.C_NOM_CAM,MOV.I_TAM_CAM,MOV.I_CAR_INI,MOV.I_CAR_FIM, ' +
                    ' MOV.I_CAS_DEC,MOV.C_ALI_CAR,MOV.C_SEP_CAM,MOV.C_SEP_DEC, ' +
                    ' MOV.D_ULT_ALT,MOV.C_TIP_CAM ' +
                    ' FROM ' +
                    ' MOVCAMPOSEXPORTACAO  AS  MOV, ' +
                    ' CADCAMPOSEXPORTACAO   AS  CAD ' +
                    ' WHERE ' +
                    SQLTextoDataEntreAAAAMMDD('CAD.D_ULT_ALT',Data1.Date,Data2.Date,False) +
                    ' AND CAD.I_EMP_FIL = MOV.I_EMP_FIL ' +
                    ' AND CAD.I_COD_SQL = MOV.I_COD_SQL ' +
                    ' AND CAD.I_COD_CAM = MOV.I_COD_CAM ');
  MovCampos.Open;
end;

{*********************** AÇÃO DO BOTÃO EXPORTAR  ******************************}
procedure TFExportacaoDeMascaras.BExportarClick(Sender: TObject);
begin
  if MovCampos.IsEmpty then
  begin
    aviso('Não há dados na tabela para "Exportar"!');
    abort;
  end;
  BExportar.Enabled := False;
  BitBtn1.SetFocus;
  ListaTexto.Clear; // LIMPA A LISTA
  MovCampos.First;         //TABELA VAI AO PRIMEIRO REGISTRO
  while not MovCampos.Eof do  // ENQUANTO NAUM FOR FIM DE ARQUIVO FAZER
  begin
  if VerificaCampoVazio then
    ExportaCampos; // PROCEDIMENTO QUE GERA O TEXTO PASSADO COMO PARÂMETRO
    MovCampos.Next; // VAI CONTANDO ATÉ O ULTIMO REGISTRO
    Label2.Caption := IntToStr(ListaTexto.Lines.Count);  //CONTA REGISTROS
    Barra.Position := Barra.Position + 2;// POSIÇAO DA BARRA DE PROGRESSO
  end;
    if ListaTexto.Lines.Count <> 0 then
    if Salvar.Execute then
      ListaTexto.Lines.SaveToFile(Salvar.FileName); // SALVA ARQUIVO
end;

{******************* FUNCAO QUE VERIFICA SE HÁ CAMPO VAZIO ******************}
function TFExportacaoDeMascaras.VerificaCampoVazio : boolean ;
begin
  Result := true;
  begin
    if MovCamposI_EMP_FIL.AsString = '' then   // FILIAL
      Result := False
    else
    if MovCamposI_COD_SQL.AsString = '' then  //CODIGO DA SQL
      Result := False
    else
    if MovCamposI_COD_CAM.AsString = '' then  //CODIGO PERFIL
      Result := False
    else
    if MovCamposC_NOM_PER.AsString = '' then // NOME PERFIL
      Result := False
    else
    if MovCamposI_TAM_LIN.AsString = '' then  //TAMANHO
      Result := False
    else
    if MovCamposC_SEP_LIN.AsString = '' then //SEPARADOR LINHA
      Result := False
    else
    if MovCamposI_COD_ORD.AsString = '' then // CODIGO DA ORDEM
      Result := False
    else
    if MovCamposC_NOM_CAM.AsString = '' then  //NOME DO CAMPO
      Result := False
    else
    if MovCamposI_CAR_INI.AsString = '' then  //CARACTER INICIAL
      Result := False
    else
    if MovCamposI_CAR_FIM.AsString = '' then //CARACTER FINAL
      Result := False
    else
    if MovCamposI_CAS_DEC.AsString = '' then // CASAS DECIMAIS
      Result := False
    else
    if MovCamposC_ALI_CAR.AsString = '' then //ALINHAMENTO
      Result := False
    else
    if MovCamposC_SEP_CAM.AsString = '' then // SEPARADOR DE CAMPO
      Result := False
    else
    if MovCamposC_SEP_DEC.AsString = '' then // SEPARADOR DECIMAL
      Result := False
    else
    if MovCamposC_TIP_CAM.AsString = '' then // TIPO DE DADO
      Result := False
    else
    if MovCamposD_ULT_ALT.AsString = '' then  //ULTIMA ALTERAÇÃO
      Result := False
  end;
end;

{**************** DISPARA PROCESSO DE EXPORTAÇÃO VIA TECLA F9 ****************}
procedure TFExportacaoDeMascaras.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if BExportar.Enabled then
  begin
    if Key = vk_F9 then
    BExportar.Click;
  end;
end;

{**************** RETIRA ACENTUAÇÃO DO NOME DO PERFIL *************************}
procedure TFExportacaoDeMascaras.NomePerfilValida(var Conteudo: String);
begin
  if Conteudo <> '' then
    Conteudo := RetiraAcentuacao(Conteudo);
end;

Initialization
 RegisterClasses([TFExportacaoDeMascaras]);
end.
