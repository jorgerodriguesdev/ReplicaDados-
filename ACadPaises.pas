unit ACadPaises;

{          Autor: Douglas Thomas Jacobsen
    Data Criação: 19/10/1999;
          Função: Cadastrar um novo Pais
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
  TFCadPaises = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BAlterar: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    DATAPAISES: TDataSource;
    Label3: TLabel;
    ESiglaPais: TDBEditColor;
    Bevel1: TBevel;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CADPAISES: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    ValidaGravacao: TValidaGravacao;
    Label4: TLabel;
    DBEditColor1: TDBEditColor;
    CADPAISESCOD_PAIS: TStringField;
    CADPAISESDES_PAIS: TStringField;
    BBAjuda: TBitBtn;
    CADPAISESDAT_ULTIMA_ALTERACAO: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CADPAISESAfterInsert(DataSet: TDataSet);
    procedure CADPAISESAfterPost(DataSet: TDataSet);
    procedure CADPAISESAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CADPAISESAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure PaisChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure CADPAISESBeforePost(DataSet: TDataSet);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FCadPaises: TFCadPaises;

implementation

uses APrincipal;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFCadPaises.FormCreate(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MaGeral.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   CadPaises.open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadPaises.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadPaises.Close; { fecha tabelas }
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCadPaises.CADPAISESAfterInsert(DataSet: TDataSet);
begin
   ESiglaPais.ReadOnly := False;
   ConfiguraConsulta(False);
end;

{******************************Atualiza a tabela*******************************}
procedure TFCadPaises.CADPAISESAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFCadPaises.CADPAISESAfterEdit(DataSet: TDataSet);
begin
   ESiglaPais.ReadOnly := true;
   ConfiguraConsulta(False);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFCadPaises.CADPAISESAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCadPaises.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFCadPaises.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;

procedure TFCadPaises.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem := ordem;
end;

procedure TFCadPaises.PaisChange(Sender: TObject);
begin
  if (CadPaises.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

procedure TFCadPaises.BBAjudaClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,FCadPaises.HelpContext);
end;

{******************** antes de gravar a alteracao *****************************}
procedure TFCadPaises.CADPAISESBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CADPAISESDAT_ULTIMA_ALTERACAO.AsDateTime := Date;
end;

procedure TFCadPaises.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
 BotaoCadastrar1.Click;
end;

procedure TFCadPaises.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  ESiglaPais.SetFocus;
end;

Initialization
 RegisterClasses([TFCadPaises]);
end.
