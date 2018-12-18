unit AManutencaodePerfil;

{     Autor: JORGE EDUARDO
     Data da Criação: 08/11/2001
     Função: Perfil da Select(SQL)
     Alterado Por:
     Data da Alteração:
     Motivo da Alteração:}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  Grids, DBGrids, Tabela, DBKeyViolation, Localizacao, ComCtrls,
  BotaoCadastro, Mask, DBCtrls;

type
  TFManutencaodePerfil = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BtFechar: TBitBtn;
    PanelColor3: TPanelColor;
    Grade: TGridIndice;
    PanelColor1: TPanelColor;
    Data1: TCalendario;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    Data2: TCalendario;
    Label5: TLabel;
    ValidaGravacao1: TValidaGravacao;
    DataMovCampos: TDataSource;
    PainelGradiente1: TPainelGradiente;
    EditCodigo: TEditColor;
    Label1: TLabel;
    MovCampos: TSQL;
    MovCamposI_COD_SQL: TIntegerField;
    MovCamposI_COD_CAM: TIntegerField;
    MovCamposI_EMP_FIL: TIntegerField;
    MovCamposI_COD_ORD: TIntegerField;
    MovCamposC_NOM_CAM: TStringField;
    MovCamposI_TAM_CAM: TIntegerField;
    MovCamposI_CAR_INI: TIntegerField;
    MovCamposI_CAR_FIM: TIntegerField;
    MovCamposI_CAS_DEC: TIntegerField;
    MovCamposC_ALI_CAR: TStringField;
    MovCamposC_SEP_CAM: TStringField;
    MovCamposC_SEP_DEC: TStringField;
    MovCamposD_ULT_ALT: TDateField;
    MovCamposC_TIP_CAM: TStringField;
    Procura: TQuery;
    ProcuraI_EMP_FIL: TIntegerField;
    ProcuraI_COD_SQL: TIntegerField;
    ProcuraC_TEX_TAB: TMemoField;
    ProcuraC_TEX_SEL: TMemoField;
    ProcuraC_NOM_SEL: TStringField;
    ProcuraC_TIP_DAT: TStringField;
    ProcuraD_ULT_ALT: TDateField;
    ProcuraC_CAM_DAT1: TStringField;
    ProcuraC_CAM_DAT2: TStringField;
    ProcuraC_TIP_SIP: TStringField;
    ProcuraC_TIP_COP: TStringField;
    ProcuraC_TEX_JOI: TMemoField;
    LocalizaSelect: TDBEditLocaliza;
    CadCamposExportacao: TSQL;
    CadCamposExportacaoI_COD_SQL: TIntegerField;
    CadCamposExportacaoI_COD_CAM: TIntegerField;
    CadCamposExportacaoD_ULT_ALT: TDateField;
    CadCamposExportacaoC_NOM_PER: TStringField;
    CadCamposExportacaoI_TAM_LIN: TIntegerField;
    CadCamposExportacaoC_SEP_LIN: TStringField;
    CadCamposExportacaoI_EMP_FIL: TIntegerField;
    DataCadCamposExportacao: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtFecharClick(Sender: TObject);
    procedure EditCodigoExit(Sender: TObject);
    procedure MovCamposAfterScroll(DataSet: TDataSet);
    procedure MovCamposBeforeScroll(DataSet: TDataSet);
  private
    procedure LocalizaPerfis(EmpFil : integer);
  public
    procedure PosicionaPerfil(EmpFil,CodSQL : integer);
  end;

var
  FManutencaodePerfil: TFManutencaodePerfil;

implementation

uses  APrincipal, Constmsg, Constantes, FUNDATA,FunSql, FunObjeto, FunNumeros,
      AOrdemCampos;

{$R *.DFM}

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                      BASICO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFManutencaodePerfil.FormCreate(Sender: TObject);
begin
  MovCampos.Open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFManutencaodePerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MovCampos.Close;
  Action := CaFree;
end;

{ ***************** fecha o formulario corrente ****************************** }
procedure TFManutencaodePerfil.BtFecharClick(Sender: TObject);
begin
  Self.Close; //Fecha Formulário
end;

{************************* 1 LOCALIZA PERFIL DOS CAMPOS  ************************}
procedure TFManutencaodePerfil.LocalizaPerfis(EmpFil : integer);
Var
CodSql,CodCam : string;
begin
  CodSql := FOrdemCampos.LocalizaSelect.Text;
  CodCam := FOrdemCampos.DBFilialColor1.Text;
  AdicionaSQLAbreTabela(MovCampos,' SELECT * FROM MOVCAMPOSEXPORTACAO  AS  MOV ' +
                                  ' WHERE ' +
                                  ' MOV.I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                  ' AND MOV.I_COD_SQL = ' + (CodSql)  +
                                  ' AND MOV.I_COD_CAM = ' + (CodCam));
end;

{********************** 2 PASSA PROCEDURE COMO PARAMETRO *********************}
procedure TFManutencaodePerfil.EditCodigoExit(Sender: TObject);
begin
  LocalizaPerfis(MovCamposI_EMP_FIL.AsInteger);
end;

{************ PROCEDIMENTO QUE SERA EXEXUTADO PELO BOTAO ALTERAR **************}
procedure TFManutencaodePerfil.PosicionaPerfil(EmpFil,CodSQL : integer);
begin
  EditCodigo.Text := IntToStr(CodSQL);
  EditCodigo.Text := FOrdemCampos.LocalizaSelect.Text;
  Label1.Caption := FOrdemCampos.Nome.Text;
  EditCodigoExit(nil);
  MovCampos.Open;
  Self.ShowModal;
end;

{************* DEPOIS DE LOCALIZAR O PERFIL A TABELA RECEBE EDIT **************}
procedure TFManutencaodePerfil.MovCamposAfterScroll(DataSet: TDataSet);
begin
  MovCampos.Edit;
end;

{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
************************ EVITA PASSAR VAZIOS ANTES DE GRAVAR ****************
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

procedure TFManutencaodePerfil.MovCamposBeforeScroll(DataSet: TDataSet);
begin
  {VERIFICA SE HÁ CAMPOS VAZIOS NA MOV}
  if MovCamposI_EMP_FIL.IsNull or // FILIAL FOR VAZIO
    MovCamposI_COD_CAM.IsNull or  // CÓDIGO DO PERFIL
    MovCamposI_COD_SQL.IsNull or  // CÓDIGO DA SQL
    MovCamposI_COD_ORD.IsNull or  // CÓDIGO DA ORDEM
    MovCamposC_NOM_CAM.IsNull or  // NOME DO CAMPO
    MovCamposI_TAM_CAM.IsNull then  // TAMANHO DO CAMPO
  begin
    aviso('Dados do cadastro imcompletos!');
    Abort;
  end;
end;

Initialization
 RegisterClasses([TFManutencaodePerfil]);
end.
