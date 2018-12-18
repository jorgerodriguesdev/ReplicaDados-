unit ACadEstados;

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
  TFCadEstados = class(TFormularioPermissao)
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
    Label3: TLabel;
    ESiglaEstado: TDBEditColor;
    Bevel1: TBevel;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CadEstados: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    ValidaGravacao: TValidaGravacao;
    EPais: TDBEditLocaliza;
    Label4: TLabel;
    BPais: TSpeedButton;
    Label5: TLabel;
    Localiza: TConsultaPadrao;
    Label6: TLabel;
    DBEditColor1: TDBEditColor;
    CadEstadosCOD_ESTADO: TStringField;
    CadEstadosCOD_PAIS: TStringField;
    CadEstadosDES_ESTADO: TStringField;
    BitBtn1: TBitBtn;
    BBAjuda: TBitBtn;
    CadEstadosDAT_ULTIMA_ALTERACAO: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadEstadosAfterInsert(DataSet: TDataSet);
    procedure CadEstadosAfterPost(DataSet: TDataSet);
    procedure CadEstadosAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadEstadosAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure EstadoChange(Sender: TObject);
    procedure CadEstadosAfterScroll(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure EPaisCadastrar(Sender: TObject);
    procedure CadEstadosBeforePost(DataSet: TDataSet);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FCadEstados: TFCadEstados;

implementation

uses APrincipal, ACadPaises;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFCadEstados.FormCreate(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MaGeral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
   CadEstados.open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadEstados.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadEstados.close; { fecha tabelas }
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCadEstados.CadEstadosAfterInsert(DataSet: TDataSet);
begin
   ESiglaEstado.ReadOnly := False;
   ConfiguraConsulta(False);
end;

{******************************Atualiza a tabela*******************************}
procedure TFCadEstados.CadEstadosAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFCadEstados.CadEstadosAfterEdit(DataSet: TDataSet);
begin
   ESiglaEstado.ReadOnly := true;
   ConfiguraConsulta(False);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFCadEstados.CadEstadosAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCadEstados.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFCadEstados.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;

procedure TFCadEstados.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem := ordem;
end;

procedure TFCadEstados.EstadoChange(Sender: TObject);
begin
  if (CadEstados.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

procedure TFCadEstados.CadEstadosAfterScroll(DataSet: TDataSet);
begin
  EPais.Atualiza;
end;

procedure TFCadEstados.BitBtn1Click(Sender: TObject);
begin
  FCadPaises := TFCadPaises.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FCadPaises'));
  FCadPaises.ShowModal;
end;

procedure TFCadEstados.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FCadEstados.HelpContext);
end;

procedure TFCadEstados.EPaisCadastrar(Sender: TObject);
begin
  FCadPaises := TFCadPaises.CriarSDI(application, '', true );
  FCadPaises.ShowModal;
  Localiza.AtualizaConsulta;
end;

{******************* antes de gravar o registro *******************************}
procedure TFCadEstados.CadEstadosBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadEstadosDAT_ULTIMA_ALTERACAO.AsDateTime := Date;
end;

procedure TFCadEstados.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  BotaoCadastrar1.click;
end;

procedure TFCadEstados.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  ESiglaEstado.SetFocus;
end;

Initialization
 RegisterClasses([TFCadEstados]);
end.
