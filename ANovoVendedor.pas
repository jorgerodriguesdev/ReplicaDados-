unit ANovoVendedor;
{          Autor: Rafael Budag
    Data Criação: 25/03/1999;
          Função: Cadastrar um novo vendedor
  Data Alteração: 03/07/2001;
    Alterado por: JORGE EDUARDO
Motivo alteração: Inserir Novos Campos
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, BotaoCadastro, StdCtrls, Buttons, Db,  DBTables,
  Tabela, Mask, DBCtrls, DBCidade, Componentes1, Grids, DBGrids,
  Localizacao, DBKeyViolation, LabelCorMove, PainelGradiente, constantes, constMsg;

type
  TFNovoVendedor = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    Label12: TLabel;
    Label13: TLabel;
    DBEditColor2: TDBEditColor;
    Label1: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    DBEditColor8: TDBEditColor;
    Label5: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    DBEditColor13: TDBEditColor;
    Label15: TLabel;
    DBEditColor4: TDBEditColor;
    Label3: TLabel;
    DBEditColor5: TDBEditColor;
    Label4: TLabel;
    DBEditColor6: TDBEditColor;
    PanelColor2: TPanelColor;
    Label2: TLabel;
    DBEditPos21: TDBEditPos2;
    DBEditPos22: TDBEditPos2;
    DBEditPos23: TDBEditPos2;
    DBMemoColor1: TDBMemoColor;
    Label9: TLabel;
    DBEditColor1: TDBEditColor;
    Label10: TLabel;
    DBEditColor3: TDBEditColor;
    Label17: TLabel;
    ValidaGravacao1: TValidaGravacao;
    BFechar: TBitBtn;
    ECidade: TDBEditLocaliza;
    BCidade: TSpeedButton;
    BRua: TSpeedButton;
    DBEditColor28: TDBEditColor;
    BBAjuda: TBitBtn;
    DBEditNumerico1: TDBEditNumerico;
    Label18: TLabel;
    Label20: TLabel;
    DBEditNumerico2: TDBEditNumerico;
    DBFilialColor1: TDBFilialColor;
    Localiza: TConsultaPadrao;
    Label21: TLabel;
    Label22: TLabel;
    DBEditLocaliza1: TDBEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label23: TLabel;
    DBEditChar2: TDBEditChar;
    PainelMetas: TPanel;
    Label27: TLabel;
    emeta1: TDBEditLocaliza;
    SpeedButton3: TSpeedButton;
    Label30: TLabel;
    Label28: TLabel;
    emeta2: TDBEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label31: TLabel;
    Label29: TLabel;
    emeta3: TDBEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label32: TLabel;
    TipoPessoa: TDBRadioGroup;
    DBEditColor44: TDBEditColor;
    Label97: TLabel;
    Label8: TLabel;
    DBEditColor10: TDBEditColor;
    DBEditCGC1: TDBEditCGC;
    Label7: TLabel;
    DBEditCPF1: TDBEditCPF;
    DBEditColor7: TDBEditInsEstadual;
    Label19: TLabel;
    Label24: TLabel;
    CADVENDEDORES: TQuery;
    DataCADVENDEDORES: TDataSource;
    CADVENDEDORESI_COD_VEN: TIntegerField;
    CADVENDEDORESCOD_CIDADE: TIntegerField;
    CADVENDEDORESC_NOM_VEN: TStringField;
    CADVENDEDORESC_END_VEN: TStringField;
    CADVENDEDORESC_BAI_VEN: TStringField;
    CADVENDEDORESC_CID_VEN: TStringField;
    CADVENDEDORESI_NUM_VEN: TIntegerField;
    CADVENDEDORESC_CEP_VEN: TStringField;
    CADVENDEDORESC_EST_VEN: TStringField;
    CADVENDEDORESC_FON_VEN: TStringField;
    CADVENDEDORESC_FAX_VEN: TStringField;
    CADVENDEDORESC_CEL_VEN: TStringField;
    CADVENDEDORESC_CPF_VEN: TStringField;
    CADVENDEDORESC_IDE_VEN: TStringField;
    CADVENDEDORESD_DAT_CAD: TDateField;
    CADVENDEDORESC_OBS_VEN: TMemoField;
    CADVENDEDORESC_CON_VEN: TStringField;
    CADVENDEDORESN_PER_COM: TFloatField;
    CADVENDEDORESI_TIP_COM: TIntegerField;
    CADVENDEDORESC_COM_END: TStringField;
    CADVENDEDORESC_APE_VEN: TStringField;
    CADVENDEDORESN_PER_VIS: TFloatField;
    CADVENDEDORESN_PER_PRA: TFloatField;
    CADVENDEDORESN_PER_SER: TFloatField;
    CADVENDEDORESD_ULT_ALT: TDateField;
    CADVENDEDORESC_ATI_VEN: TStringField;
    CADVENDEDORESI_EMP_FIL: TIntegerField;
    CADVENDEDORESI_IND_VEN: TIntegerField;
    CADVENDEDORESI_COD_MET: TIntegerField;
    CADVENDEDORESI_COD_ME2: TIntegerField;
    CADVENDEDORESI_COD_ME3: TIntegerField;
    CADVENDEDORESC_TIP_VEN: TStringField;
    CADVENDEDORESC_INS_VEN: TStringField;
    CADVENDEDORESC_CGC_VEN: TStringField;
    CADVENDEDORESC_VEN_FAN: TStringField;
    BGravar: TBitBtn;
    BCancelar: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadVendedores1AfterInsert(DataSet: TDataSet);
    procedure CadVendedores1AfterPost(DataSet: TDataSet);
    procedure ChaveVendedorChange(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure BRuaClick(Sender: TObject);
    procedure ECidadeCadastrar(Sender: TObject);
    procedure ECidadeRetorno(Retorno1, Retorno2: String);
    procedure DBEditColor28KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BBAjudaClick(Sender: TObject);
    procedure emeta1Retorno(Retorno1, Retorno2: String);
    procedure emeta2Retorno(Retorno1, Retorno2: String);
    procedure emeta3Retorno(Retorno1, Retorno2: String);
    procedure emeta1Select(Sender: TObject);
    procedure emeta2Select(Sender: TObject);
    procedure emeta3Select(Sender: TObject);
    procedure TipoPessoaChange(Sender: TObject);
    procedure BGravarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure CADVENDEDORESBeforePost(DataSet: TDataSet);
    procedure CADVENDEDORESAfterInsert(DataSet: TDataSet);
    procedure CADVENDEDORESAfterEdit(DataSet: TDataSet);
  private
    Function ValidaVendedor : String;
  public
    { Public declarations }
  end;

var
  FNovoVendedor: TFNovoVendedor;

implementation

uses APrincipal, AVendedores, AConsultaRuas, ACadCidades, Funstring, FunValida, funsql,
     FunObjeto ;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFNovoVendedor.FormCreate(Sender: TObject);
begin
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
   CadVendedores.Open;
   Self.HelpFile := Varia.PathHelp + 'MAGERAL.HLP>janela';  // Indica o Paph e o nome do arquivo de Help

   if varia.UsarMeta <> 2 then
     painelmetas.enabled := true
   else
     painelmetas.enabled := false;
  BGravar.Enabled := true;
  BCancelar.Enabled := true;
  TipoPessoa.ItemIndex := 0;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFNovoVendedor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadVendedores.close;
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações das Tabelas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************Carrega os dados default do cadastro********************}
procedure TFNovoVendedor.CadVendedores1AfterInsert(DataSet: TDataSet);
begin

end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}
procedure TFNovoVendedor.CadVendedores1AfterPost(DataSet: TDataSet);
begin
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ******************** valida a gravacao do cadastro ************************ }
procedure TFNovoVendedor.ChaveVendedorChange(Sender: TObject);
begin
if CadVendedores.State in [ dsinsert, dsedit ] then
  ValidaGravacao1.execute;
end;

{***************************** fecha o formulario *************************** }
procedure TFNovoVendedor.BFecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFNovoVendedor.BRuaClick(Sender: TObject);
var
  VpfCodCidade,
  VpfCEP,
  VpfRua,
  VpfBairro,
  VpfDesCidade: string;
begin
  if CadVendedores.State in [ dsEdit, dsInsert] then
  begin
    VpfCEP := SubstituiStr( VpfCEP,'-','');
    FConsultaRuas := TFConsultaRuas.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FConsultaRuas'));
    if FConsultaRuas.BuscaEndereco(VpfCodCidade, VpfCEP,
         VpfRua, VpfBairro, VpfDesCidade)
    then
    begin
      // Preenche os campos;
      CadVendedoresCOD_CIDADE.AsInteger:=StrToInt(VpfCodCidade);
      CadVendedoresC_CEP_VEN.AsString:=VpfCEP;
      CadVendedoresC_CID_VEN.AsString:=VpfDesCidade;
      CadVendedoresC_END_VEN.AsString:=VpfRua;
      CadVendedoresC_BAI_VEN.AsString:=VpfBairro;
      ECidade.Atualiza;
    end;
  end;
end;

procedure TFNovoVendedor.ECidadeCadastrar(Sender: TObject);
begin
  FCidades := TFCidades.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FCidades'));
  FCidades.ShowModal;
end;

procedure TFNovoVendedor.ECidadeRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') then
    if (CadVendedores.State in [dsInsert, dsEdit]) then
    begin
      CadVendedoresCOD_CIDADE.AsInteger:=StrToInt(Retorno1); // Grava a cidade;
      CadVendedoresC_EST_VEN.AsString:=Retorno2; // Grava o Estado;
    end;
end;

procedure TFNovoVendedor.DBEditColor28KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 114 then // F3 abre a localizacao dos endereços.
    BRua.Click;
end;

procedure TFNovoVendedor.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FNovoVendedor.HelpContext);
end;

procedure TFNovoVendedor.emeta1Retorno(Retorno1, Retorno2: String);
begin
  if retorno1 = '' then
    abort;
end;

procedure TFNovoVendedor.emeta2Retorno(Retorno1, Retorno2: String);
begin
  if retorno1 <> '' then
    if emeta1.text = '' then
      begin
        aviso('Meta 1 não pode estar vazia');
        abort;
      end;
end;

procedure TFNovoVendedor.emeta3Retorno(Retorno1, Retorno2: String);
begin
  if retorno1 <> '' then
    if (emeta1.text = '') or (emeta2.text = '') then
      begin
        aviso('Meta 1 ou Meta 2 não podem estar vazias');
        abort;
      end;
end;

procedure TFNovoVendedor.emeta1Select(Sender: TObject);
begin
   emeta1.ASelectLocaliza.Clear;
   emeta1.ASelectLocaliza.Add(' Select * from cadmetacomissao' +
                              ' where c_nom_met like ''@%''' +
                              ' order by C_nom_met');
   eMeta1.ASelectValida.Clear;
   eMeta1.ASelectValida.Add(' select * from cadmetacomissao'+
                            ' where i_cod_met = @');
end;



procedure TFNovoVendedor.emeta2Select(Sender: TObject);
begin
  if emeta1.text <> '' then
  begin
   emeta2.ASelectLocaliza.Clear;
   emeta2.ASelectLocaliza.Add(' Select * from cadmetacomissao' +
                              ' where c_nom_met like ''@%''' +
                              ' and i_cod_met <> ' + emeta1.text +
                              ' order by C_nom_met');
   eMeta2.ASelectValida.Clear;
   eMeta2.ASelectValida.Add(' select * from cadmetacomissao'+
                            ' and i_cod_met <> ' + emeta1.text +
                            ' where i_cod_met = @');
  end
  else
    abort;
end;

procedure TFNovoVendedor.emeta3Select(Sender: TObject);
begin
  if emeta2.text <> '' then
  begin
   emeta3.ASelectLocaliza.Clear;
   emeta3.ASelectLocaliza.Add(' Select * from cadmetacomissao' +
                              ' where c_nom_met like ''@%''' +
                              ' and i_cod_met <> ' + emeta1.text +
                              ' and i_cod_met <> ' + emeta2.text +
                              ' order by C_nom_met');
   eMeta3.ASelectValida.Clear;
   eMeta3.ASelectValida.Add(' select * from cadmetacomissao'+
                            ' and i_cod_met <> ' + emeta1.text +
                            ' and i_cod_met <> ' + emeta2.text +
                            ' where i_cod_met = @');
  end
  else
    abort;
end;

procedure TFNovoVendedor.TipoPessoaChange(Sender: TObject);
begin
  if TipoPessoa.ItemIndex = 0 then
  begin
     Label19.Visible := False;
     DBEditCGC1.Visible := False;
     Label24.Visible := False;
     DBEditColor7.Visible := false;
     Label8.Visible := true;
     DBEditColor10.Visible := true;
     LabeL7.Visible := True;
     DBEditCPF1.Visible := True;
  end
  else
  begin
     Label19.Visible := True;
     DBEditCGC1.Visible := True;
     Label24.Visible := True;
     DBEditColor7.Visible := True;
     Label8.Visible := False;
     DBEditColor10.Visible := False;
     LabeL7.Visible := False;
     DBEditCPF1.Visible := False;
  end;
end;

procedure TFNovoVendedor.BGravarClick(Sender: TObject);
begin
  if CadVendedores.State in [ dsEdit, dsInsert] then
  CadVendedores.Post;
end;

procedure TFNovoVendedor.BCancelarClick(Sender: TObject);
begin
  if CadVendedores.State in [ dsEdit, dsInsert] then
  CadVendedores.Cancel;
end;

procedure TFNovoVendedor.CADVENDEDORESBeforePost(DataSet: TDataSet);
begin
  CadVendedoresD_ULT_ALT.AsDateTime := Date;
   if CadVendedores.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;

  if varia.usarmeta <> 2 then
    if (emeta2.text <> '') and (emeta1.text = '') or
       (emeta3.text <> '') and (emeta2.text = '')then
      begin
       aviso('Falta selecionar Meta');
       abort;
      end;
end;

procedure TFNovoVendedor.CADVENDEDORESAfterInsert(DataSet: TDataSet);
begin
  DBFilialColor1.ProximoCodigo;
  DBFilialColor1.ReadOnly := false;
  DBEditColor13.Field.Value := date;
  CadVendedoresI_TIP_COM.AsInteger := 0;
  CadVendedoresC_ATI_VEN.AsString := 'S';
  TipoPessoa.ItemIndex :=0 ;
  CADVENDEDORESC_TIP_VEN.AsString := 'F';

end;

procedure TFNovoVendedor.CADVENDEDORESAfterEdit(DataSet: TDataSet);
begin
  DBEditLocaliza1.Atualiza;
end;

// Funcao que valida o CGC e CPF 
function TFNovoVendedor.ValidaVendedor : string;
begin
  // cgc
  try
    StrToInt(DBEditCGC1.Text[1]);
    if not VerificaCGC(DBEditCGC1.Text) then
    begin
      DBEditCPF1.SetFocus;
      aviso(CT_ErroCGC);
    end
    else
      result := result + ' and C_CGC_EMI = ''' + DBEditCGC1.Text + '''';
   except
   end;

   // cpf
   try
    StrToInt(DBEditCPF1.Text[1]);
    if not VerificaCPF(DBEditCPF1.Text) then
    begin
      DBEditCPF1.SetFocus;
      aviso(CT_ErroCPF);
    end
    else
      result := result +  ' and C_CPF_EMI = ''' + DBEditCPF1.Text + '''';
  except
  end;
end;

Initialization
 RegisterClasses([TFNovoVendedor]);
end.
