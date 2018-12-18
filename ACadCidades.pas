unit ACadCidades;

{          Autor: Douglas Thomas Jacobsen
    Data Criação: 19/10/1999;
          Função: Cadastrar um novo Caixa
  Data Alteração:
    Alterado por:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro, Constantes,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Grids, DBGrids,
  DBKeyViolation, Localizacao;

type
  TFCidades = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BAlterar: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    DataCadCaixa: TDataSource;
    Label2: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CadCidades: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    ValidaGravacao: TValidaGravacao;
    EEstado: TDBEditLocaliza;
    Label4: TLabel;
    BPais: TSpeedButton;
    Label5: TLabel;
    Localiza: TConsultaPadrao;
    Label6: TLabel;
    DBEditColor1: TDBEditColor;
    CadCidadesCOD_CIDADE: TIntegerField;
    CadCidadesCOD_ESTADO: TStringField;
    CadCidadesCOD_PAIS: TStringField;
    CadCidadesDES_CIDADE: TStringField;
    BitBtn1: TBitBtn;
    BBAjuda: TBitBtn;
    DBFilialColor1: TDBFilialColor;
    CadCidadesDAT_ULTIMA_ALTERACAO: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadCidadesAfterInsert(DataSet: TDataSet);
    procedure CadCidadesBeforePost(DataSet: TDataSet);
    procedure CadCidadesAfterPost(DataSet: TDataSet);
    procedure CadCidadesAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadCidadesAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure CidadeChange(Sender: TObject);
    procedure EEstadoRetorno(Retorno1, Retorno2: String);
    procedure CadCidadesAfterScroll(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure EEstadoCadastrar(Sender: TObject);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FCidades: TFCidades;

implementation

uses APrincipal, ACadEstados;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFCidades.FormCreate(Sender: TObject);
begin
   CadCidades.open;
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
   Self.HelpFile := Varia.PathHelp + 'MaGeral.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCidades.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadCidades.close; { fecha tabelas }
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCidades.CadCidadesAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := False;
   DBFilialColor1.ProximoCodigo;
   ConfiguraConsulta(False);
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFCidades.CadCidadesBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadCidadesDAT_ULTIMA_ALTERACAO.AsDateTime := Date;
  if CadCidades.State = dsinsert then
    DBFilialColor1.VerificaCodigoRede;
end;

{******************************Atualiza a tabela*******************************}
procedure TFCidades.CadCidadesAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFCidades.CadCidadesAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(False);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFCidades.CadCidadesAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCidades.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFCidades.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;

procedure TFCidades.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem := ordem;
end;

procedure TFCidades.CidadeChange(Sender: TObject);
begin
  if (CadCidades.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

procedure TFCidades.EEstadoRetorno(Retorno1, Retorno2: String);
begin
  if ((Retorno1 <> '') and (CadCidades.State in [dsInsert, dsEdit])) then
    CadCidadesCOD_PAIS.AsString:=Trim(Retorno1);
end;

procedure TFCidades.CadCidadesAfterScroll(DataSet: TDataSet);
begin
  EEstado.Atualiza;
end;

procedure TFCidades.BitBtn1Click(Sender: TObject);
begin
  FCadEstados := TFCadEstados.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FCadEstados'));
  FCadEstados.ShowModal;
end;

procedure TFCidades.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FCidades.HelpContext);
end;

procedure TFCidades.EEstadoCadastrar(Sender: TObject);
begin
  FCadEstados := TFCadEstados.CriarSDI(application, '', true);
  FCadEstados.ShowModal;
  Localiza.AtualizaConsulta;
end;

procedure TFCidades.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
 BotaoCadastrar1.Click;
end;

procedure TFCidades.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  DBEditColor1.setfocus;
end;

Initialization
 RegisterClasses([TFCidades]);
end.
