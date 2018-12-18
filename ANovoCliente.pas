unit ANovoCliente;
{    Data Criação: 25/03/1999;
          Função: Cadastrar um NOVO CLIENTE.
  Data Alteração: 14/12/1999;
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Tabela, Constantes,ConstMsg,
  StdCtrls, DBCtrls, Mask, Db, DBTables, DBCidade, BotaoCadastro, Buttons,
  Localizacao, ComCtrls, Grids, DBGrids, DBKeyViolation;

type
  TFNovoCliente = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    DataCadClientes: TDataSource;
    MoveBasico1: TMoveBasico;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    CadClientes: TTabela;
    CadClientesI_COD_CLI: TIntegerField;
    CadClientesC_NOM_CLI: TStringField;
    CadClientesD_DAT_CAD: TDateField;
    CadClientesD_DAT_ALT: TDateField;
    CadClientesC_END_CLI: TStringField;
    CadClientesC_BAI_CLI: TStringField;
    CadClientesC_FON_RES: TStringField;
    CadClientesC_EST_CLI: TStringField;
    CadClientesC_CID_CLI: TStringField;
    CadClientesC_END_ANT: TStringField;
    CadClientesC_CID_ANT: TStringField;
    CadClientesC_EST_ANT: TStringField;
    CadClientesD_DAT_NAS: TDateField;
    CadClientesC_REG_CLI: TStringField;
    CadClientesC_CPF_CLI: TStringField;
    CadClientesC_NAT_CLI: TStringField;
    CadClientesC_EST_NAT: TStringField;
    CadClientesC_NOM_EMP: TStringField;
    CadClientesC_END_EMP: TStringField;
    CadClientesC_BAI_EMP: TStringField;
    CadClientesC_FON_EMP: TStringField;
    CadClientesC_EST_EMP: TStringField;
    CadClientesC_CID_EMP: TStringField;
    CadClientesD_ADM_CLI: TDateField;
    CadClientesN_LIM_CLI: TFloatField;
    CadClientesN_REN_CLI: TFloatField;
    CadClientesC_PAI_CLI: TStringField;
    CadClientesC_MAE_CLI: TStringField;
    CadClientesC_REF_COM: TMemoField;
    CadClientesC_NOM_CON: TStringField;
    CadClientesC_EMP_CON: TStringField;
    CadClientesC_FON_CON: TStringField;
    CadClientesD_DAT_CON: TDateField;
    CadClientesC_REF_PES: TMemoField;
    CadClientesC_OBS_CLI: TMemoField;
    CadClientesC_EST_CIV: TStringField;
    CadClientesC_SEX_CLI: TStringField;
    CadClientesC_TIP_END: TStringField;
    CadClientesC_TIP_RES: TStringField;
    CadClientesI_PRO_CON: TIntegerField;
    CadClientesC_END_ELE: TStringField;
    CadClientesI_NUM_END: TIntegerField;
    CadClientesI_NUM_ANT: TIntegerField;
    CadClientesI_NUM_EMP: TIntegerField;
    Localiza: TConsultaPadrao;
    Aux: TQuery;
    Paginas: TPageControl;
    Basicos: TTabSheet;
    Label1: TLabel;
    Label4: TLabel;
    Label44: TLabel;
    Label54: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    Label52: TLabel;
    Label48: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    DBEditColor1: TDBEditColor;
    DBEditColor9: TDBEditColor;
    DBEditPos21: TDBEditPos2;
    DBEditColor8: TDBEditColor;
    DBEditColor10: TDBEditColor;
    Crediario: TTabSheet;
    Label55: TLabel;
    Label13: TLabel;
    Label51: TLabel;
    Label14: TLabel;
    Label49: TLabel;
    Label15: TLabel;
    Label58: TLabel;
    Label34: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label10: TLabel;
    Label35: TLabel;
    DBEditColor14: TDBEditColor;
    DBEditColor13: TDBEditColor;
    DBEditColor16: TDBEditColor;
    DBEditColor17: TDBEditColor;
    DBEditPos22: TDBEditPos2;
    DBEditColor20: TDBEditColor;
    DBEditColor18: TDBEditColor;
    Gerais1: TTabSheet;
    Label60: TLabel;
    Label30: TLabel;
    Label41: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label40: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    DBComboBoxColor1: TDBComboBoxColor;
    DBEditColor3: TDBEditColor;
    DBEditColor4: TDBEditColor;
    DBComboBoxColor3: TDBComboBoxColor;
    DBEditColor6: TDBEditColor;
    DBComboBoxUF1: TDBComboBoxUF;
    Label59: TLabel;
    Label21: TLabel;
    DBEditColor21: TDBEditColor;
    Label22: TLabel;
    Label23: TLabel;
    DBEditColor24: TDBEditColor;
    Label27: TLabel;
    Label25: TLabel;
    DBEditPos23: TDBEditPos2;
    Label3: TLabel;
    Label28: TLabel;
    DBEditColor19: TDBEditColor;
    Label50: TLabel;
    DBEditColor23: TDBEditColor;
    DBEditColor25: TDBEditColor;
    Label24: TLabel;
    Label26: TLabel;
    DBEditColor27: TDBEditColor;
    Label33: TLabel;
    DBMemoColor1: TDBMemoColor;
    DBMemoColor3: TDBMemoColor;
    DBMemoColor2: TDBMemoColor;
    Label38: TLabel;
    Label39: TLabel;
    PanelColor3: TBevel;
    PanelColor4: TBevel;
    PanelColor5: TBevel;
    PanelColor6: TBevel;
    PanelColor7: TBevel;
    PanelColor8: TBevel;
    DBEditLocaliza1: TDBEditLocaliza;
    Label53: TLabel;
    SpeedButton1: TSpeedButton;
    DBEditLocaliza2: TDBEditLocaliza;
    Label47: TLabel;
    SpeedButton2: TSpeedButton;
    CadClientesI_COD_PRF: TIntegerField;
    CadClientesC_CGC_CLI: TStringField;
    CadClientesC_INS_CLI: TStringField;
    CadClientesC_WWW_CLI: TStringField;
    CadClientesC_TIP_PES: TStringField;
    CadClientesC_FO1_CLI: TStringField;
    CadClientesC_FO2_CLI: TStringField;
    CadClientesC_FO3_CLI: TStringField;
    CadClientesC_TIP_CAD: TStringField;
    Pessoa: TDBRadioGroup;
    CadClientesC_ORG_EXP: TStringField;
    Gerais2: TTabSheet;
    Label63: TLabel;
    PanelColor9: TBevel;
    Label74: TLabel;
    DBMemoColor5: TDBMemoColor;
    DBEditPos24: TDBEditPos2;
    DBEditPos25: TDBEditPos2;
    Label68: TLabel;
    DBEditPos26: TDBEditPos2;
    CadClientesC_CON_CLI: TStringField;
    CadClientesC_FON_CEL: TStringField;
    CadClientesC_FON_FAX: TStringField;
    Eventos: TQuery;
    DataEventos: TDataSource;
    CadEventos: TTable;
    EventosI_COD_EVE: TIntegerField;
    EventosI_COD_CLI: TIntegerField;
    EventosNomeEventos: TStringField;
    TipoCad: TDBRadioGroup;
    rep: TGroupBox;
    Label56: TLabel;
    Label57: TLabel;
    DBEditColor37: TDBEditColor;
    DBEditColor38: TDBEditColor;
    Label69: TLabel;
    Label70: TLabel;
    DBEditPos29: TDBEditPos2;
    DBEditPos210: TDBEditPos2;
    CadClientesC_NOM_REP: TStringField;
    CadClientesC_CON_REP: TStringField;
    CadClientesC_FAX_REP: TStringField;
    CadClientesC_FON_REP: TStringField;
    DBEditColor39: TDBEditColor;
    Label75: TLabel;
    CadClientesC_COM_END: TStringField;
    CadClientesI_COD_SIT: TIntegerField;
    DBEditNumerico1: TDBEditNumerico;
    ECidade: TDBEditLocaliza;
    BCidade: TSpeedButton;
    BRua: TSpeedButton;
    DBEditColor28: TDBEditColor;
    CadClientesCOD_CIDADE: TIntegerField;
    DBEditColor11: TDBEditColor;
    DBEditColor29: TDBEditColor;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    ECidadeAnterior: TDBEditLocaliza;
    SpeedButton8: TSpeedButton;
    ECidadeEmpresa: TDBEditLocaliza;
    SpeedButton9: TSpeedButton;
    validagravacao: TValidaGravacao;
    BFechar: TBitBtn;
    CheckBox1: TCheckBox;
    CadClientesC_CEP_CLI: TStringField;
    CadClientesC_CEP_EMP: TStringField;
    CadClientesC_CEP_ANT: TStringField;
    BBAjuda: TBitBtn;
    CadClientesC_PRA_CLI: TStringField;
    Label80: TLabel;
    DBEditColor15: TDBEditColor;
    DBFilialColor1: TDBFilialColor;
    EventosD_ULT_ALT: TDateField;
    Label81: TLabel;
    DBEditColor26: TDBEditColor;
    CadClientesC_ELE_REP: TStringField;
    Label82: TLabel;
    DBEditLocaliza4: TDBEditLocaliza;
    SpeedButton10: TSpeedButton;
    Label83: TLabel;
    CadClientesI_COD_REG: TIntegerField;
    Label76: TLabel;
    SpeedButton5: TSpeedButton;
    Label78: TLabel;
    PainelRG: TPanelColor;
    Label17: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label62: TLabel;
    Label67: TLabel;
    DBEditColor5: TDBEditColor;
    DBEditCPF1: TDBEditCPF;
    DBEditColor2: TMaskEditColor;
    DBEditColor32: TDBEditColor;
    DBEditPos28: TDBEditPos2;
    PainelCGC: TPanelColor;
    Label61: TLabel;
    Label2: TLabel;
    Label42: TLabel;
    Label66: TLabel;
    DBEditCGC1: TDBEditCGC;
    DBEditColor7: TDBEditInsEstadual;
    DBEditColor22: TDBEditColor;
    DBEditPos27: TDBEditPos2;
    PanelColor10: TPanelColor;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    EditLocaliza1: TEditLocaliza;
    DBGridColor1: TDBGridColor;
    DBEditLocaliza3: TDBEditLocaliza;
    PanelColor11: TBevel;
    Label84: TLabel;
    DBEditUF1: TDBEditUF;
    SpeedButton11: TSpeedButton;
    CadClientesN_DES_VEN: TFloatField;
    Label43: TLabel;
    DBEditColor12: TDBEditColor;
    CadClientesC_END_COB: TStringField;
    EVendedor: TBitBtn;
    CadClientesI_COD_USU: TIntegerField;
    CadClientesC_IMP_BOL: TStringField;
    CadClientesN_DES_BOL: TFloatField;
    Complemento: TTabSheet;
    Bevel1: TBevel;
    Label90: TLabel;
    Label29: TLabel;
    Label6: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    DBEditColor34: TDBEditColor;
    DBEditNumerico2: TDBEditNumerico;
    DBEditNumerico5: TDBEditNumerico;
    DBEditChar1: TDBEditChar;
    Label5: TLabel;
    DBEditColor33: TDBEditColor;
    Label71: TLabel;
    DBEditColor40: TDBEditColor;
    DBEditColor41: TDBEditColor;
    Label72: TLabel;
    Label85: TLabel;
    DBEditNumerico4: TDBEditNumerico;
    CadClientesI_COD_FRM: TIntegerField;
    CadClientesI_COD_PAG: TIntegerField;
    Label45: TLabel;
    EPagamento: TDBEditLocaliza;
    SpeedButton12: TSpeedButton;
    Label46: TLabel;
    Label65: TLabel;
    EdcFormaPgto: TDBEditLocaliza;
    SpeedButton13: TSpeedButton;
    Label77: TLabel;
    Label79: TLabel;
    DBEditColor30: TDBEditColor;
    Label88: TLabel;
    DBEditColor31: TDBEditColor;
    Label89: TLabel;
    DBEditColor36: TDBEditColor;
    Label91: TLabel;
    DBEditColor42: TDBEditColor;
    Label92: TLabel;
    DBEditLocaliza5: TDBEditLocaliza;
    Label93: TLabel;
    DBEditColor43: TDBEditColor;
    SpeedButton14: TSpeedButton;
    Bevel2: TBevel;
    Label94: TLabel;
    Label95: TLabel;
    DBEditCGC2: TDBEditCGC;
    Label73: TLabel;
    SpeedButton15: TSpeedButton;
    Label96: TLabel;
    TipoEst: TDBEditLocaliza;
    Label97: TLabel;
    DBEditColor44: TDBEditColor;
    CadClientesC_NOM_FAN: TStringField;
    Label64: TLabel;
    DBEditColor35: TDBEditColor;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadClientesAfterInsert(DataSet: TDataSet);
    procedure CadClientesBeforeEdit(DataSet: TDataSet);
    procedure CadClientesBeforePost(DataSet: TDataSet);
    procedure CadClientesAfterEdit(DataSet: TDataSet);
    procedure DBEditLocaliza1Cadastrar(Sender: TObject);
    procedure PessoaChange(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBEditPos26Exit(Sender: TObject);
    procedure DBEditColor19Exit(Sender: TObject);
    procedure TipoCadChange(Sender: TObject);
    procedure DBEditLocaliza3Cadastrar(Sender: TObject);
    procedure DBEditCGC1Exit(Sender: TObject);
    procedure DBEditColor5Exit(Sender: TObject);
    procedure BRuaClick(Sender: TObject);
    procedure ECidadeCadastrar(Sender: TObject);
    procedure ECidadeRetorno(Retorno1, Retorno2: String);
    procedure DBEditColor28KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ECidadeAnteriorRetorno(Retorno1, Retorno2: String);
    procedure ECidadeEmpresaRetorno(Retorno1, Retorno2: String);
    procedure SpeedButton7Click(Sender: TObject);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure EventosBeforePost(DataSet: TDataSet);
    procedure DBEditLocaliza4Cadastrar(Sender: TObject);
    procedure DBEditLocaliza3Exit(Sender: TObject);
    procedure EVendedorClick(Sender: TObject);
    procedure EPagamentoSelect(Sender: TObject);
    procedure CadClientesBeforeDelete(DataSet: TDataSet);
    procedure PessoaExit(Sender: TObject);
    procedure DBEditColor2Exit(Sender: TObject);
  private
    codigoEventos : TStringList;
    procedure AdicionaEventos( codigoEvento : Integer );
    function LocalizaCodigoEvento( codigoEvento : string ) : Boolean;
    procedure DeletaCodigoEvento( codigoEvento : string);
    procedure CarregaCodigoEventos;
    function LocalizaCliente( cgc_Cpf : string; cgc : Boolean) :  Boolean;
  public
    TipoCadastro : integer;
  end;

var
  FNovoCliente: TFNovoCliente;

implementation

uses APrincipal, AClientes, AProfissoes, ASituacoesClientes, funsql,
  AConsultaRuas, ACadCidades, Funstring, ARegiaoVenda, AMovVendedorCliente, fundata;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFNovoCliente.FormCreate(Sender: TObject);
begin
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
   CadClientes.open;
   Self.HelpFile := Varia.PathHelp + 'MaGeral.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   CadEventos.open;
   CodigoEventos := TStringList.Create;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFNovoCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FechaTabela(CadClientes);
   FechaTabela(CadEventos);
   FechaTabela(Eventos);
   CodigoEventos.Destroy;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 Ações que controlam o Cadastro de Eventos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************************Procura o codigo do evento**************************}
function TFNovoCliente.LocalizaCodigoEvento( codigoEvento : string ) : Boolean;
var
  laco : integer;
begin
  result := false;
  for laco := 0 to CodigoEventos.Count - 1 do
    if CodigoEventos.Strings[laco] = CodigoEvento then
       result := true;
end;

{**********************Adiciona um evento na movimentação**********************}
procedure TFNovoCliente.AdicionaEventos( codigoEvento : Integer );
begin
  CodigoEventos.Add(IntToStr(CodigoEvento));
  Eventos.Insert;
  Eventos.FieldByName('I_COD_CLI').AsInteger := CadClientesI_COD_CLI.AsInteger;
  Eventos.FieldByName('I_COD_EVE').AsInteger := CodigoEvento;
  Eventos.Post;
end;

{************************Deleta um evento na movimentação**********************}
procedure TFNovoCliente.DeletaCodigoEvento( codigoEvento : string);
var
  laco : integer;
begin
  for laco := 0 to CodigoEventos.Count - 1 do
     if CodigoEventos.Strings[laco] = CodigoEvento then
     begin
        CodigoEventos.Delete(laco);
        break;
     end;
end;

{************************Carrega os Eventos do cliente*************************}
procedure TFNovoCliente.CarregaCodigoEventos;
var
  laco : integer;
begin
  codigoEventos.Clear;
  aux.close;
  aux.sql.clear;
  aux.sql.Add('select * from MovEventos where I_COD_CLI = '+ CadClientesI_COD_CLI.AsString);
  aux.open;
  for laco := 0 to aux.RecordCount - 1 do
  begin
     CodigoEventos.Add(aux.fieldByName('I_COD_EVE').AsString);
     aux.next;
  end;
  aux.close;
end;

{*********************Chama a rotina para Excluir o Evento*********************}
procedure TFNovoCliente.SpeedButton4Click(Sender: TObject);
begin
   if Confirmacao(CT_DeletarItem) Then
      if Eventos.RecordCount > 0 then
      begin
        DeletaCodigoEvento(EventosI_COD_EVE.AsString);
        Eventos.Delete;
      end;
end;



procedure TFNovoCliente.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  Eventos.CommitUpdates;
  if not BotaoGravar1.AFecharAposOperacao Then
  begin
    if CheckBox1.Checked then
    begin
      CadClientes.Insert;
      DBFilialColor1.SetFocus;
    end;  
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Eventos da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************Carrega os dados default do cadastro********************}
procedure TFNovoCliente.CadClientesAfterInsert(DataSet: TDataSet);
begin

  DBFilialColor1.ProximoCodigo;
  CadClientesD_DAT_CAD.AsDateTime := Date;
  CadClientesC_TIP_PES.Value := 'J';
  CadClientesC_IMP_BOL.AsString := 'N';
  case TipoCadastro of
    1 : CadClientesC_TIP_CAD.Value := 'F';
    2 :  CadClientesC_TIP_CAD.Value := 'A';
  else
    CadClientesC_TIP_CAD.Value := 'C';
  end;
  DBFilialColor1.ReadOnly := False;
  DBEditLocaliza1.Limpa;
  DBEditLocaliza2.Limpa;
  EVendedor.Enabled := false;
end;

{**********************Não permite alterar o código do cliente*****************}
procedure TFNovoCliente.CadClientesBeforeEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := True;
end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}
procedure TFNovoCliente.CadClientesBeforePost(DataSet: TDataSet);
begin
   CadClientesD_DAT_ALT.AsDateTime := Date;
   CadClientesI_COD_USU.AsInteger := Varia.CodigoUsuario;
   if CadClientes.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
  EVendedor.Enabled := true;
end;

{*************Atualiza os localiza e carrega os Eventos************************}
procedure TFNovoCliente.CadClientesAfterEdit(DataSet: TDataSet);
begin
   if CadClientesC_TIP_PES.AsString = 'F'then
   begin
     DBEditLocaliza1.Atualiza;
     DBEditLocaliza2.Atualiza;
   end
   else
     TipoEst.Atualiza;  
   CadClientesD_DAT_ALT.Value := date;
   CarregaCodigoEventos;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações dos Localizas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************Cadastra uma nova profissão*****************************}
procedure TFNovoCliente.DBEditLocaliza1Cadastrar(Sender: TObject);
begin
   FProfissoes := TFProfissoes.criarSDI(Application,'',FPrincipal.VerificaPermisao('FProfissoes'));
   FProfissoes.BotaoCadastrar1.Click;
   FProfissoes.ShowModal;
   Localiza.AtualizaConsulta;
end;

{********Chama a rotina para Verificar se o codigo do evento é duplicado*******}
procedure TFNovoCliente.EditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> ''then
     if not LocalizaCodigoEvento(Retorno1) then
        AdicionaEventos(StrToInt(Retorno1))
     else
        Aviso(CT_CodigoDuplicado)
end;

{***********************Cadastra uma nova situação*****************************}
procedure TFNovoCliente.DBEditLocaliza3Cadastrar(Sender: TObject);
begin
   FSituacoesClientes := TFSituacoesClientes.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FSituacoesClientes'));
   FSituacoesClientes.BotaoCadastrar1.Click;
   FSituacoesClientes.ShowModal;
   Localiza.AtualizaConsulta;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************* verifica cgc ou cpf repetidos na base ************************ }
function TFNovoCliente.LocalizaCliente( cgc_Cpf : string; cgc : Boolean) :  Boolean;
begin
result := false;
if cgc_Cpf <> '' then
begin
  LimpaSQLTabela(aux);
  AdicionaSQLTabela(aux,'Select * from cadClientes');
  if cgc then
    AdicionaSQLTabela(aux,' where c_cgc_cli = ''' + cgc_Cpf + '''')
  else
    AdicionaSQLTabela(aux,' where c_cpf_cli = ''' + cgc_Cpf + '''');

  AbreTabela(aux);

  if not Aux.eof then
  begin
   result := true;
   aviso('Ja existe um cadastro com este cgc/cpf, Código ' +
          aux.fieldByName('I_COD_CLI').AsString + ' - Nome ' +
          aux.fieldByName('C_NOM_CLI').AsString );
  end;
  Aux.close;
end;
end;

{***************Modifica os cadastro conforme o tipo de pessoa*****************}
procedure TFNovoCliente.PessoaChange(Sender: TObject);
begin
  if pessoa.ItemIndex = 0 then
  begin
    PainelCGC.Visible := true;
    PainelRG.Visible := false;
    crediario.TabVisible := false;
    gerais1.TabVisible := false;
    gerais2.TabVisible := true;
  end
  else
  begin
    PainelCGC.Visible := false;
    PainelRG.Visible := true;
    crediario.TabVisible := true;
    gerais1.TabVisible := true;
    gerais2.TabVisible := false;
  end;
end;

{**********************Abre o movimento dos eventos do cliente*****************}
procedure TFNovoCliente.FormShow(Sender: TObject);
var
  ano,mes,dia : word;
begin
   Eventos.sql.Clear;
   Eventos.sql.add('select * from moveventos where I_COD_CLI = ' + CadClientesI_COD_CLI.AsString);
   Eventos.Open;
   if CadClientes.Active then
     if not CadClientesD_DAT_NAS.IsNull then
     begin
       DecodeDate( CadClientesD_DAT_NAS.AsDateTime,ano,mes,dia);
       dbeditcolor2.text := inttostr(dia) +'/'+ inttostr(mes) + '/'+ inttostr(ano);
     end;
end;

{*******Dependendo do tipo de pessoa F ou J pula para paginas diferentes*******}
procedure TFNovoCliente.DBEditPos26Exit(Sender: TObject);
begin

end;

{******************Pula para a pagina geral da pessoal física******************}
procedure TFNovoCliente.DBEditColor19Exit(Sender: TObject);
begin
  paginas.ActivePage := Gerais1;
  DBEditNumerico1.SetFocus;
end;

{***************Mostra o representante se nao for do tipo física***************}
procedure TFNovoCliente.TipoCadChange(Sender: TObject);
begin
  if tipocad.ItemIndex = 0 then
    rep.Visible := false
  else
    rep.Visible := true;
  evendedor.Enabled := TipoCad.ItemIndex <> 1;  
end;

{ ************* Verifica cgc repetido *************************************** }
procedure TFNovoCliente.DBEditCGC1Exit(Sender: TObject);
begin
  if CadClientes.State in [ dsInsert ] then
    LocalizaCliente(DBEditCGC1.Field.AsString, true);
end;

{ ************* Verifica cpf repetido *************************************** }
procedure TFNovoCliente.DBEditColor5Exit(Sender: TObject);
begin
  if CadClientes.State in [ dsInsert ] then
    LocalizaCliente(DBEditCPF1.Field.AsString, false);
end;

procedure TFNovoCliente.BRuaClick(Sender: TObject);
var
  VpfCodCidade,
  VpfCEP,
  VpfRua,
  VpfBairro,
  VpfDesCidade: string;
begin
  if CadClientes.State in [ dsEdit, dsInsert ] then
  begin
    VpfCEP := SubstituiStr( VpfCEP,'-','');
    FConsultaRuas := TFConsultaRuas.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FConsultaRuas'));
    if FConsultaRuas.BuscaEndereco( VpfCodCidade, VpfCEP,
        VpfRua, VpfBairro, VpfDesCidade)
    then
    begin
      // Preenche os campos;
      CadClientesCOD_CIDADE.AsInteger := StrToInt(VpfCodCidade);
      CadClientesC_CEP_CLI.AsString := VpfCEP;
      CadClientesC_CID_CLI.AsString := VpfDesCidade;
      CadClientesC_END_CLI.AsString := VpfRua;
      CadClientesC_BAI_CLI.AsString := VpfBairro;
      ECidade.Atualiza;
    end;
  end;  
end;

procedure TFNovoCliente.ECidadeCadastrar(Sender: TObject);
begin
  FCidades := TFCidades.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FCidades'));
  FCidades.ShowModal;
end;

procedure TFNovoCliente.ECidadeRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') then
    if (CadClientes.State in [dsInsert, dsEdit]) then
    begin
      CadClientesCOD_CIDADE.AsInteger:=StrToInt(Retorno1); // Grava a cidade;
      CadClientesC_EST_CLI.AsString:=Retorno2; // Grava o Estado;
    end;
end;

procedure TFNovoCliente.DBEditColor28KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 114 then // F3 abre a localizacao dos endereços.
    BRua.Click;
end;

procedure TFNovoCliente.SpeedButton6Click(Sender: TObject);
var
  VpfCodCidade,
  VpfCEP,
  VpfRua,
  VpfBairro,
  VpfDesCidade: string;
begin
 VpfCEP := SubstituiStr( VpfCEP,'-','');
  FConsultaRuas := TFConsultaRuas.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FConsultaRuas'));
  if FConsultaRuas.BuscaEndereco(VpfCodCidade, VpfCEP,
       VpfRua, VpfBairro, VpfDesCidade)
  then
  begin
    // Preenche os campos;
    CadClientesC_CEP_ANT.AsString := VpfCEP;
    CadClientesC_END_ANT.AsString := VpfRua + ' - ' + VpfBairro;
  end;
  ECidadeAnterior.Atualiza;
end;

procedure TFNovoCliente.ECidadeAnteriorRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') then
    if (CadClientes.State in [dsInsert, dsEdit]) then
      CadClientesC_EST_ANT.AsString:=Retorno2; // Grava o Estado;
end;

procedure TFNovoCliente.ECidadeEmpresaRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') then
    if (CadClientes.State in [dsInsert, dsEdit]) then
      CadClientesC_EST_EMP.AsString:=Retorno2; // Grava o Estado;
end;

procedure TFNovoCliente.SpeedButton7Click(Sender: TObject);
var
  VpfCodCidade,
  VpfCEP,
  VpfRua,
  VpfBairro,
  VpfDesCidade: string;
begin
  VpfCEP := SubstituiStr( VpfCEP,'-','');
  FConsultaRuas := TFConsultaRuas.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FConsultaRuas'));
  if FConsultaRuas.BuscaEndereco(VpfCodCidade, VpfCEP,
       VpfRua, VpfBairro, VpfDesCidade)
  then
  begin
    // Preenche os campos;
    CadClientesC_CEP_EMP.AsString := VpfCEP;
    CadClientesC_END_EMP.AsString := VpfRua;
    CadClientesC_BAI_EMP.AsString := VpfBairro;
    ECidadeEmpresa.Atualiza;
  end;
end;

procedure TFNovoCliente.DBKeyViolation1Change(Sender: TObject);
begin
  if CadClientes.state in [dsEdit, dsInsert] then
    ValidaGravacao.Execute;
end;

{****************** fecha formulario *************************************** }
procedure TFNovoCliente.BFecharClick(Sender: TObject);
begin
self.close;
end;


procedure TFNovoCliente.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FNovoCliente.HelpContext);
end;

{****************** antes de gravar o evento **********************************}
procedure TFNovoCliente.EventosBeforePost(DataSet: TDataSet);
begin
  EventosD_ULT_ALT.AsDateTime := Date;
end;

procedure TFNovoCliente.DBEditLocaliza4Cadastrar(Sender: TObject);
begin
  FRegiaoVenda := TFRegiaoVenda.criarSDI(Application,'',FPrincipal.VerificaPermisao('FRegiaoVenda'));
  FRegiaoVenda.ShowModal;
  Localiza.AtualizaConsulta;
end;

procedure TFNovoCliente.DBEditLocaliza3Exit(Sender: TObject);
begin
if Pessoa.ItemIndex = 1 then
  paginas.ActivePage := Crediario
else
  paginas.ActivePage := Gerais2;
end;

procedure TFNovoCliente.EVendedorClick(Sender: TObject);
begin
  FMovVendedorCliente := TFMovVendedorCliente.CriarSDI(application, '', FPrincipal.VerificaPermisao('FMovVendedorCliente'));
  FMovVendedorCliente.AbreConsulta(CadClientesI_COD_CLI.AsString);
end;

procedure TFNovoCliente.EPagamentoSelect(Sender: TObject);
begin
   EPagamento.ASelectValida.Add(' select I_Cod_Pag, C_Nom_Pag, I_Qtd_Par From dba.CadCondicoesPagto ' +
                                ' where I_Cod_Pag = @ and D_VAL_CON > ''' + DataToStrFormato(AAAAMMDD,date,'/') + '''' );

   EPagamento.ASelectLocaliza.add(' select I_Cod_Pag, C_Nom_Pag, I_Qtd_Par From dba.CadCondicoesPagto ' +
                                  ' where c_Nom_Pag like ''@%'' and D_VAL_CON > ''' +
                                  DataToStrFormato(AAAAMMDD,date,'/') + '''' +
                                  ' order by c_Nom_Pag asc');
end;

procedure TFNovoCliente.CadClientesBeforeDelete(DataSet: TDataSet);
begin
   ExecutaComandoSql(Aux,  ' delete from cadcontatos ' +
                           ' where i_cod_cli = '+ inttostr(CadClientesI_Cod_Cli.asinteger));
end;

procedure TFNovoCliente.PessoaExit(Sender: TObject);
begin
  if Pessoa.ItemIndex = 0 then
    CadClientesC_NOM_EMP.EditMask := '99\.999\.999\/9999\-99;1;'
  else
    CadClientesC_NOM_EMP.EditMask := '';
end;

procedure TFNovoCliente.DBEditColor2Exit(Sender: TObject);
begin
  if CadClientes.State in [ dsEdit, dsInsert ] then
    try
      CadClientesD_DAT_NAS.AsDateTime := strtodate(dbeditcolor2.text);
     except
       aviso('Data inválida');
     end;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFNovoCliente]);
end.
