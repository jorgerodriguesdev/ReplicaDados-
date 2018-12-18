unit AVendedores;
{          Autor: Rafael Budag
    Data Criação: 05/04/1999;
          Função: Cadastrar um novo Vendedor
  Data Alteração:
    Alterado por:
Motivo alteração: 
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, BotaoCadastro, StdCtrls, Buttons, Db,  DBTables,
  Tabela, Mask, DBCtrls, DBCidade, Componentes1, Grids, DBGrids,
  Localizacao, DBKeyViolation, LabelCorMove, PainelGradiente, constantes, constMsg;

type
  TFVendedores = class(TFormularioPermissao)
    DataCadVendedores: TDataSource;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    ProximoCodigoFaixa1: TProximoCodigoFaixa;
    DBGridColor1: TGridIndice;
    BFechar: TBitBtn;
    PanelColor1: TPanelColor;
    Consulta: TLocalizaEdit;
    CadVendedores: TQuery;
    CadVendedoresI_COD_VEN: TIntegerField;
    CadVendedoresC_NOM_VEN: TStringField;
    CadVendedoresC_CID_VEN: TStringField;
    CadVendedoresC_FON_VEN: TStringField;
    Label1: TLabel;
    BotaoConsultar: TBotaoConsultar;
    BBAjuda: TBitBtn;
    CadVendedoresI_COD_MET: TIntegerField;
    CadVendedoresI_COD_ME2: TIntegerField;
    CadVendedoresI_COD_ME3: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridColor1TitleClick(Column: TColumn);
    procedure BFecharClick(Sender: TObject);
    procedure BotaoCadastrar1AntesAtividade(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
    procedure BotaoAlterar1Atividade(Sender: TObject);
    procedure BotaoExcluir1Atividade(Sender: TObject);
    procedure BotaoExcluir1DepoisAtividade(Sender: TObject);
    procedure BotaoExcluir1DestroiFormulario(Sender: TObject);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure BBAjudaClick(Sender: TObject);
    procedure BotaoConsultar1AntesAtividade(Sender: TObject);
    procedure BotaoConsultarAntesAtividade(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVendedores: TFVendedores;

implementation

uses APrincipal, ANovoVendedor;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFVendedores.FormCreate(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MaGeral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
CadVendedores.Open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFVendedores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CadVendedores.close;
Action := CaFree;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********Altera a ordem da tabela e atualiza o indice do grid****************}
procedure TFVendedores.DBGridColor1TitleClick(Column: TColumn);
begin
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFVendedores.BFecharClick(Sender: TObject);
begin
   Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações dos Botões
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*****************Cria o formulario para cadastrar novo registro***************}
procedure TFVendedores.BotaoCadastrar1AntesAtividade(Sender: TObject);
begin
  FNovoVendedor := TFNovoVendedor.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FNovoVendedor'));
end;

{************Vai para o Novo registro e na volta atualiza a tabela*************}
procedure TFVendedores.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  FNovoVendedor.ShowModal;
  Consulta.AtualizaTabela;
end;

{**************Localiza o registro para que possa ser alterado*****************}
procedure TFVendedores.BotaoAlterar1Atividade(Sender: TObject);
begin
  { FNovoVendedor.CadVendedores.FindKey([CadVendedoresI_cod_Ven.AsInteger]);}
   FNovoVendedor.emeta1.Atualiza;
  // FNovoVendedor.emeta2.atualiza;
  // FNovoVendedor.emeta3.atualiza;
end;

procedure TFVendedores.BotaoExcluir1Atividade(Sender: TObject);
begin

end;

{*******************Mostra o registro que será excluído************************}
procedure TFVendedores.BotaoExcluir1DepoisAtividade(Sender: TObject);
begin
   FNovoVendedor.show;
end;

{*************Apos excluir fecha o formulario que mostrava o registro**********}
procedure TFVendedores.BotaoExcluir1DestroiFormulario(Sender: TObject);
begin
  FNovoVendedor.close;
  Consulta.AtualizaTabela;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFVendedores.DBGridColor1Ordem(Ordem: String);
begin
  Consulta.AOrdem := ordem;
end;

{***************** consultar clientes *************************************** }
procedure TFVendedores.BotaoConsultar1AntesAtividade(Sender: TObject);
begin
  FNovoVendedor := TFNovoVendedor.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FNovoVendedor'));
end;

procedure TFVendedores.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FVendedores.HelpContext);
end;


procedure TFVendedores.BotaoConsultarAntesAtividade(Sender: TObject);
begin
  FNovoVendedor := TFNovoVendedor.CriarSDI(Application,'',true);
end;

Initialization
 RegisterClasses([TFVendedores]);
end.
