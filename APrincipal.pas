unit APrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, DBTables, ComCtrls, ExtCtrls, StdCtrls, Constantes, Buttons,  formulariosFundo, Formularios,
  ExtDlgs, Inifiles, constMsg, FunObjeto, Db, DBCtrls, Grids,
  DBGrids, Componentes1, Tabela, Localizacao, UnRegistro,
  Mask, PainelGradiente, UnPrincipal, ToolWin, LabelCorMove;

const
  CampoPermissaoModulo = 'C_MOD_TRX';
  CampoFormModulos = 'C_MOD_TRX';
  NomeModulo = 'Transferência';

type
  TFPrincipal = class(TFormulariofundo)
    Menu: TMainMenu;
    MAjuda: TMenuItem;
    BaseDados: TDatabase;
    BarraStatus: TStatusBar;
    MArquivo: TMenuItem;
    MSair: TMenuItem;
    MSobre: TMenuItem;
    CorFoco: TCorFoco;
    CorForm: TCorForm;
    CorPainelGra: TCorPainelGra;
    N1: TMenuItem;
    Contexto1: TMenuItem;
    Indice1: TMenuItem;
    Cadatros1: TMenuItem;
    Grupos1: TMenuItem;
    TabelasExportao1: TMenuItem;
    Enviar: TMenuItem;
    Perfil1: TMenuItem;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    BMFClientes: TSpeedButton;
    BMFContasaReceber: TSpeedButton;
    BSaida: TSpeedButton;
    GerarArquivosFiscais1: TMenuItem;
    SpeedButton1: TSpeedButton;
    GrupoTabela1: TMenuItem;
    MFPerfil: TMenuItem;
    MFExcluiPerfil: TMenuItem;
    AlterarFilialemUso1: TMenuItem;
    N2: TMenuItem;
    MFMostraErro: TMenuItem;
    MFEnviarReceber: TMenuItem;
    MFExportaSciEcfax: TMenuItem;
    N3: TMenuItem;
    MFCadastraSQL: TMenuItem;
    MFExportaoMascarasdoProduto1: TMenuItem;
    MFOrdemCampos: TMenuItem;
    N4: TMenuItem;
    MFExecutaPerfilSQL: TMenuItem;
    procedure MostraHint(Sender : TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    procedure Contexto1Click(Sender: TObject);
    procedure Indice1Click(Sender: TObject);
  private
     UnPri : TFuncoesPrincipal;
     TipoSistema : string;
  public
     Function  VerificaPermisao( nome : string ) : Boolean;
     procedure Abre(var Msg: TMsg; var Handled: Boolean);
     function AbreBaseDados( Alias : string ) : Boolean;
     procedure OrganizaBotoes;
     procedure AlteraNomeEmpresa;
     procedure erro(Sender: TObject; E: Exception);
     procedure ConfiguracaoModulos;
end;


var
  FPrincipal: TFPrincipal;
  Ini : TInifile;

implementation

uses ASobre, funIni, AGruposExportacao, ATabelasExportacao, AExportacao,funsistema,
  AImportacao, APerfil, AExportacaoFisco, AGrupoTabelaExportacao,
  AExcluiPerfil, AAlterarFilialUso, AInicio,
  AMostraErro, AMostraMensages, AEntradaSaida, AExportaSCIECFAX,
  ACadastroSQL, AExportacaoDeMascaras, AOrdemCampos, AExecutaSQL;


{$R *.DFM}

// ----- Verifica a permissão do formulários conforme tabela MovGrupoForm -------- //
Function TFPrincipal.VerificaPermisao( nome : string ) : Boolean;
begin
  result := UnPri.VerificaPermisao(nome);
  if not result then
    abort;
end;


// -------------Quando é enviada a menssagem de criação de um formulario------------- //
procedure TFPrincipal.abre(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = CT_CRIAFORM) or (Msg.message = CT_DESTROIFORM) then
  begin
    if (Msg.message = CT_CRIAFORM) and (config.AtualizaPermissao) then
      UnPri.CarregaNomeForms(Screen.ActiveForm.Name, Screen.ActiveForm.Hint,CampoFormModulos, Screen.ActiveForm.Tag);
    if (Msg.message = CT_CRIAFORM) then
      Screen.ActiveForm.Caption := Screen.ActiveForm.Caption + ' [ ' + varia.NomeFilial + ' ] ';
  end;
end;


// ------------------ Mostra os comentarios ma barra de Status ---------------- }
procedure TFPrincipal.MostraHint(Sender : TObject);
begin
  BarraStatus.Panels[3].Text := Application.Hint;
end;

// ------------------ Na criação do Formulário -------------------------------- }
procedure TFPrincipal.FormCreate(Sender: TObject);
begin
 UnPri := TFuncoesPrincipal.criar(self, BaseDados, NomeModulo);
 Varia := TVariaveis.Create;   // classe das variaveis principais
 Config := TConfig.Create;     // Classe das variaveis Booleanas
 ConfigModulos := TConfigModulo.create; // classes das configuracoes dos modulos
 Application.OnHint := MostraHint;
  Self.HelpFile := Varia.PathHelp + 'MaConfAmbiente.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
 Application.HintColor := $00EDEB9E;        // cor padrão dos hints
 Application.Title := 'Transferência';  // nome a ser mostrado na barra de tarefa do Windows
 Application.OnException := Erro;
 Application.OnMessage := Abre;
end;

{************ abre base de dados ********************************************* }
function TFPrincipal.AbreBaseDados( Alias : string ) : Boolean;
begin
  result := AbreBancoDadosAlias(BaseDados, alias);
end;

procedure TFPrincipal.erro(Sender: TObject; E: Exception);
begin
  FMostraMensagens := TFMostraMensagens.CriarSDI(application,'',true);
  FMostraMensagens.MostraErro(E.Message);
end;

// ------------------- Quando o formulario e fechado -------------------------- }
procedure TFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BaseDados.Close;
  Varia.Free;
  Config.Free;
  ConfigModulos.Free;
  UnPri.free;
  Action := CaFree;
end;

// -------------------- Quando o Formulario é Iniciado ------------------------ }
procedure TFPrincipal.FormShow(Sender: TObject);
begin
 // configuracoes do usuario
 UnPri.ConfigUsu(varia.CodigoUsuario, CorFoco, CorForm, CorPainelGra, Self );
 // configura modulos
 ConfiguracaoModulos;
 AlteraNomeEmpresa;
 FPrincipal.WindowState := wsMaximized;  // coloca a janela maximizada;

  UnPri.EliminaItemsMenu(self, Menu);
  OrganizaBotoes;

 VerificaVersaoSistema(CampoPermissaoModulo);
 if VerificaFormCriado('TFInicio') then
 begin
   finicio.close;
   finicio.free;
 end; 

end;

{****************** organiza os botoes do formulario ************************ }
procedure TFPrincipal.OrganizaBotoes;
begin
 UnPri.OrganizaBotoes(0, [ BMFClientes, BMFContasaReceber, SpeedButton1,
                           bsaida]);
end;

// -------------------- Altera o Caption da Jabela Proncipal ------------------ }
procedure TFPrincipal.AlteraNomeEmpresa;
begin
  UnPri.AlteraNomeEmpresa( fprincipal, BarraStatus, NomeModulo, TipoSistema );
end;

{************************  M E N U   D O   S I S T E M A  ********************* }
procedure TFPrincipal.MenuClick(Sender: TObject);
begin
if  ValidaDataFormulario(date) then
  if Sender is TComponent  then
  case ((Sender as TComponent).Tag) of
   1100 : begin
             FAlterarFilialUso := TFAlterarFilialUso.CriarSDI(application,'',true);// VerificaPermisao('FAlterarFilialUso'));
             FAlterarFilialUso.ShowModal;
           end;
    1200 : Close;
    2100 : begin
             FSobre := TFSobre.CriarSDI(application,'', true);
             FSobre.ShowModal;
           end;
    3100 : begin
             FGruposExportacao := TFGruposExportacao.criarSDI(Application,'',true);
             FGruposExportacao.ShowModal;
           end;
    3200 : begin
            FTabelasExportacao := TFTabelasExportacao.criarSDI(Application,'',true);
            FTabelasExportacao.ShowModal;
           end;
    3300 : begin
            FGrupoTabelaExportacao := TFGrupoTabelaExportacao.criarSDI(Application,'',true);
            FGrupoTabelaExportacao.ShowModal;
           end;
    4000 : begin
            FExportacao := TFExportacao.criarSDI(Application,'',true);
            FExportacao.ShowModal;
           end;
    4200 : begin
            FEntradaSaida := TFEntradaSaida.criarSDI(Application,'',true);
            FEntradaSaida.ShowModal;
           end;
    5000 : begin
            FImportacao := TFImportacao.criarSDI(Application,'',true);
            FImportacao.ShowModal;
           end;
    5200 : begin
            FMostraErro := TFMostraErro.criarSDI(Application,'',true);
            FMostraErro.MostraLog;
           end;
    5300 : begin
            FExportaSciEcfax := TFExportaSciEcfax.criarSDI(Application,'',true);
            FExportaSciEcfax.ShowModal
           end;
    6000 : begin
             FPerfil := TFPerfil.criarSDI(Application,'',true);
             FPerfil.ShowModal;
           end;
    6100 : begin
             FExcluiPerfil := TFExcluiPerfil.criarSDI(Application,'',true);
             FExcluiPerfil.ShowModal;
           end;
    7000 : begin
             FExportacaoFisco := TFExportacaoFisco.criarSDI(Application,'',true);
             FExportacaoFisco.ShowModal;
           end;
    7100 : begin
             FCadastroSQL := TFCadastroSQL.criarSDI(Application,'',true);
             FCadastroSQL.ShowModal;
           end;
    7200 : begin
             FExportacaoDeMascaras := TFExportacaoDeMascaras.criarSDI(Application,'',true);
             FExportacaoDeMascaras.ShowModal;
           end;
    7300 : begin
             FOrdemCampos := TFOrdemCampos.criarSDI(Application,'',true);
             FOrdemCampos.ShowModal;
           end;
    7400 : begin
             FExecutaSQL := TFExecutaSQL.criarSDI(Application,'',true);
             FExecutaSQL.ShowModal;
           end;

  end;
end;

{******************* configura os modulos do sistema ************************* }
procedure TFPrincipal.ConfiguracaoModulos;
var
  Reg : TRegistro;
begin
  Reg := TRegistro.create;
  reg.ValidaModulo( TipoSistema, [Cadatros1, Enviar] );
  reg.Free;
end;

procedure TFPrincipal.Contexto1Click(Sender: TObject);
begin
   Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TFPrincipal.Indice1Click(Sender: TObject);
begin
   Application.HelpCommand(HELP_PARTIALKEY, 4);
end;


end.
