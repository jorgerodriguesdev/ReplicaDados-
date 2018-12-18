unit AGruposExportacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  BotaoCadastro, StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente,
  Db, DBTables, Tabela, Mask, DBCtrls, Localizacao, Grids, DBGrids,
  DBKeyViolation;

type
  TFGruposExportacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    BFechar: TBitBtn;
    MoveBasico1: TMoveBasico;
    GrupoExportacao: TSQL;
    GrupoExportacaoCOD_GRUPO: TIntegerField;
    GrupoExportacaoNOM_GRUPO: TStringField;
    DataGrupoExportacao: TDataSource;
    Label5: TLabel;
    DBEdit2: TDBFilialColor;
    Label6: TLabel;
    DBEdit3: TDBEditColor;
    Bevel1: TBevel;
    Consulta: TLocalizaEdit;
    Label2: TLabel;
    GridIndice1: TGridIndice;
    GrupoExportacaoDAT_ULTIMA_EXPORTACAO: TDateField;
    DBEditColor2: TDBEditColor;
    Label4: TLabel;
    ValidaGravacao1: TValidaGravacao;
    Label1: TLabel;
    DBEditColor3: TDBEditColor;
    GrupoExportacaoIDE_TIPO_GRUPO: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure GrupoExportacaoAfterInsert(DataSet: TDataSet);
    procedure GrupoExportacaoAfterEdit(DataSet: TDataSet);
    procedure GrupoExportacaoBeforePost(DataSet: TDataSet);
    procedure GrupoExportacaoAfterPost(DataSet: TDataSet);
    procedure GridIndice1Ordem(Ordem: String);
    procedure DBEditColor1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGruposExportacao: TFGruposExportacao;

implementation

uses APrincipal,Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFGruposExportacao.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
  DBEdit2.ACodFilial := Varia.CodigoFilCadastro;
  Consulta.AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFGruposExportacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************* fecha o formulario corrente ****************************}
procedure TFGruposExportacao.BFecharClick(Sender: TObject);
begin
  Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************** apos a insercao da tabela *****************************}
procedure TFGruposExportacao.GrupoExportacaoAfterInsert(DataSet: TDataSet);
begin
  DBEdit2.ReadOnly := False;
  DBEdit2.ProximoCodigo;
end;

{********************** apos a edicao da tabela *******************************}
procedure TFGruposExportacao.GrupoExportacaoAfterEdit(DataSet: TDataSet);
begin
  DBEdit2.ReadOnly := True;
end;

{************* antes de gravar verifica os usuario da rede ********************}
procedure TFGruposExportacao.GrupoExportacaoBeforePost(DataSet: TDataSet);
begin
  if GrupoExportacao.State = dsinsert then
    DBEdit2.VerificaCodigoRede;
end;

{************************* apos ser gravado ***********************************}
procedure TFGruposExportacao.GrupoExportacaoAfterPost(DataSet: TDataSet);
begin
  Consulta.AtualizaConsulta;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************** atualiza a ordem da consulta **************************}
procedure TFGruposExportacao.GridIndice1Ordem(Ordem: String);
begin
  Consulta.AOrdem := ordem;
end;

{*********************** valida a gravacao ************************************}
procedure TFGruposExportacao.DBEditColor1Change(Sender: TObject);
begin
  if GrupoExportacao.State in [dsedit,dsinsert] then
    ValidaGravacao1.execute;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFGruposExportacao]);
end.
 