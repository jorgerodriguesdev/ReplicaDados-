unit AConsultaRuas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Mask, BotaoCadastro, numericos;

Const
  CT_FALTAENDERECO = 'FALTA CADASTRO DE ENDEREÇOS !!!O cadastro de endereços não está corretamente configurado ou instalado...';

type
  TFConsultaRuas = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    GConsulta: TGridIndice;
    ENDER: TQuery;
    DATAITECAIXA: TDataSource;
    PanelColor3: TPanelColor;
    Label3: TLabel;
    ECidade: TEditLocaliza;
    SpeedButton11: TSpeedButton;
    ENDERCOD_RUA: TIntegerField;
    ENDERCOD_CIDADE: TIntegerField;
    ENDERNUM_CEP: TIntegerField;
    ENDERCOD_LOGRADOURO: TStringField;
    ENDERDES_RUA: TStringField;
    ENDERDES_BAIRRO: TStringField;
    RConsulta: TRadioGroup;
    Label1: TLabel;
    ENDERCOD_PAIS: TStringField;
    ENDERDES_CIDADE: TStringField;
    BOk: TBitBtn;
    BCancela: TBitBtn;
    Label2: TLabel;
    BBAjuda: TBitBtn;
    ECep: Tnumerico;
    ERua: TEditColor;
    Aux: TQuery;
    ENDERCOD_ESTADO: TStringField;
    AuxEnder: TQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GConsultaOrdem(Ordem: String);
    procedure RConsultaClick(Sender: TObject);
    procedure EConsultaRuaSelect(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure ECidadeRetorno(Retorno1, Retorno2: String);
    procedure EConsultaRuaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EConsultaCepKeyPress(Sender: TObject; var Key: Char);
    procedure BBAjudaClick(Sender: TObject);
  {  procedure ECepEnter(Sender: TObject);  }
    procedure ECepExit(Sender: TObject);
    procedure ECepKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ERuaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ECidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    VprConfirmou: Boolean;
    CidadeAtual,
    VprOrdem: string;
    procedure AtualizaConsulta;
    procedure CadastraEndereco(VpaCodCidade, VpaCodEstado, VpaCodPais : String);
    procedure CadastraPais(VpaCodPais : String);
    procedure CadastraEstado(VpaCodPais,VpaCodEstado : String);
    procedure CadastraCidade(VpaCodPais,VpaCodEstado,VpaCodCidade : String);
  public
    function BuscaEndereco(var VpaCodCidade, VpaNumCEP,
      VpaRua, VpaBairro, VpaDesCidade: string): Boolean;
  end;

var
  FConsultaRuas: TFConsultaRuas;

implementation

{$R *.DFM}

uses
  constantes, fundata, funstring, funsql, APrincipal, ConstMsg;

procedure TFConsultaRuas.FormCreate(Sender: TObject);
begin
  Self.HelpFile := Varia.PathHelp + 'MaConfSistema.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  VprConfirmou:=False;
  VprOrdem := ' ORDER BY NUM_CEP ';
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaRuas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         eventos da consulta do endereco
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ *********************** atualiza a consulta ******************************** }
procedure TFConsultaRuas.AtualizaConsulta;
begin
  Ender.Sql.Clear;
  ENDER.SQL.ADD(' SELECT * FROM CAD_CEPS CAD, CAD_CIDADES CID ' +
                ' WHERE CAD.COD_CIDADE = CID.COD_CIDADE ');

  if (CidadeAtual  <> '') then
    ENDER.SQL.Add(' AND CAD.COD_CIDADE = ' + CidadeAtual );

  if ECep.Visible Then
    if ECep.AValor <> 0 then
      Ender.SQL.Add(' AND Cad.NUM_CEP like '''+ ECep.Text+'%''');

  if ERua.Visible Then
    if ERua.TExt <> '' then
      Ender.Sql.Add(' And cad.Des_Rua Like ''' + ERua.Text + '%''');
  ENDER.SQL.ADD(VprOrdem);
  GConsulta.ALinhaSQLOrderBy := ENDER.SQL.Count - 1;
  ENDER.open;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos do cadastro
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************** cadastra os enderecos *********************************}
procedure TFConsultaRuas.CadastraEndereco(VpaCodCidade, VpaCodEstado, VpaCodPais : String);
begin
  AdicionaSQLAbreTabela(Aux,'Select * from Cad_Cidades ' +
                        ' Where Cod_Cidade = ' + VpaCodCidade);
  if Aux.eof Then
  begin
    AdicionaSQLAbreTabela(Aux,'Select * From Cad_Estados ' +
                              ' Where Cod_Pais = ''' + VpaCodPais + ''''+
                              ' and Cod_Estado = ''' + VpaCodEstado+'''');
    if Aux.Eof then
    begin
      AdicionaSQLAbreTabela(Aux,'Select * from Cad_Paises '+
                                ' Where Cod_Pais = ''' + VpaCodPais+'''');
      if aux.Eof Then
        CadastraPais(VpaCodPais);

      CadastraEstado(VpaCodPais,VpaCodEstado);
    end;
    CadastraCidade(VpaCodPais,VpaCodEstado,VpaCodCidade);
  end;
end;

{************************ cadastra o pais *************************************}
procedure TFConsultaRuas.CadastraPais(VpaCodPais : String);
begin
  AdicionaSQLAbreTabela(AuxEnder,'Select * from Cad_Paises ' +  // tabela de enderecos
                              ' Where Cod_Pais = '' + VpaCodPais+ ''');
  ExecutaComandoSql(Aux,'Insert Into CAd_PAises (Cod_Pais, Des_Pais) values('''+ VpaCodPais+
                         ''','''+AuxENDER.FieldByName('Des_Pais').Asstring+''')');
end;

{************************* cadastra o estado **********************************}
procedure TFConsultaRuas.CadastraEstado(VpaCodPais,VpaCodEstado : String);
begin
  AdicionaSQLAbreTabela(AuxEnder,'Select * from Cad_Estados ' +  // tabela de enderecos
                              ' Where Cod_Pais = ''' + VpaCodPais+ ''''+
                              ' and Cod_Estado = ''' + VpaCodEstado+ '''');
  ExecutaComandoSql(Aux,'Insert Into CAd_Estados (Cod_Pais, Cod_Estado, Des_Estado) values('''+ VpaCodPais+
                         ''','''+AuxENDER.FieldByName('Cod_Estado').Asstring+''','''+AuxENDER.FieldByName('Des_Estado').Asstring+ ''')');
end;

{************************ cadastra a cidade ***********************************}
procedure TFConsultaRuas.CadastraCidade(VpaCodPais,VpaCodEstado,VpaCodCidade : String);
begin
  AdicionaSQLAbreTabela(AuxEnder,'Select * from Cad_Cidades ' +  // tabela de enderecos
                              ' Where Cod_Cidade = ' + VpaCodCidade);
  ExecutaComandoSql(Aux,'Insert Into CAd_Cidades (Cod_Cidade, Cod_Pais, Cod_Estado, Des_Cidade) values(' +VpaCodCidade +
                     ','''+ VpaCodPais+ ''','''+VpaCodEstado+''','''+AuxENDER.FieldByName('Des_Cidade').Asstring+ ''')');
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                     eventos dos filtros superiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************* quando alterado o tipo da consulta ***********************}
procedure TFConsultaRuas.RConsultaClick(Sender: TObject);
begin
  if (RConsulta.ItemIndex = 0) then
  begin
    ERua.Visible:=False;
    ECep.Visible:=True;
    ERua.Clear;
    ECep.Clear;
    ECep.SetFocus;
  end
  else
  begin
    ERua.Visible:=True;
    ECep.Visible:=False;
    ERua.Clear;
    ECep.Clear;
    ERua.SetFocus;
  end;
end;

{****************** chama a rotina para atualiza a consulta *******************}
procedure TFConsultaRuas.ECepExit(Sender: TObject);
begin
  AtualizaConsulta;
end;


procedure TFConsultaRuas.EConsultaRuaSelect(Sender: TObject);
begin
end;

{************************ retornos da cidade *********************************}
procedure TFConsultaRuas.ECidadeRetorno(Retorno1, Retorno2: String);
begin
  CidadeAtual:=Retorno1;   // retorna o codigo da cidade
  AtualizaConsulta;  // atualiza a consulta das ruas
end;

{******************* filtras as teclas pressionadas ***************************}
procedure TFConsultaRuas.EConsultaRuaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
end;

{********************* filtra as teclas pressionada ***************************}
procedure TFConsultaRuas.EConsultaCepKeyPress(Sender: TObject;
  var Key: Char);
begin
 if (not (Key in [ '0'..'9',#8,#13])) and ( RConsulta.ItemIndex = 0) then  // somente permite digitar numeros
   key := #;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************* fecha o formualario ********************************}
procedure TFConsultaRuas.BFecharClick(Sender: TObject);
begin
  Close;  // fecha o formulario sem confirmar a consulta
end;

{****************** quando alterado a ordem da grade **************************}
procedure TFConsultaRuas.GConsultaOrdem(Ordem: String);
begin
  VprOrdem:=Ordem;  // atualiza a ordem da consulta
end;

{******************* quando o botao ok for pressionado ***********************}
procedure TFConsultaRuas.BOkClick(Sender: TObject);
begin
  VprConfirmou:=True;  // confirma a consulta
  Close;  // fecha o formulario
end;

{****************** quando for pressionado o botao de ajuda *******************}
procedure TFConsultaRuas.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FConsultaRuas.HelpContext);
  // mostra a ajuda do sistema
end;

{******************* retorna o endereco selecionado ***************************}
function TFConsultaRuas.BuscaEndereco(var VpaCodCidade,
  VpaNumCEP, VpaRua, VpaBairro, VpaDesCidade: string): Boolean;
begin
 { try
    if not FPrincipal.baseEndereco.Connected Then
      FPrincipal.baseEndereco.Open;


  except
    Aviso(CT_FALTAENDERECO);
    result := false;
    close;
    exit;
  end;

  AtualizaConsulta;
  BFechar.Visible:=False;
  BCancela.Visible:=True;
  BOk.Visible:=True;
  Self.ShowModal;
  // Após a escolha do registro.
  if ENDER.EOF then
    Result:=False
  else
  begin
    VpaCodCidade:=ENDERCOD_CIDADE.AsString;
    VpaNumCEP:= AdicionaCharE('0',ENDERNUM_CEP.AsString,8);
    VpaRua:= ENDERCOD_LOGRADOURO.AsString + ' ' + ENDERDES_RUA.AsString;
    VpaBairro:=ENDERDES_BAIRRO.AsString;
    VpaDesCidade:=ENDERDES_CIDADE.AsString;
    Result:=VprConfirmou;
    CadastraEndereco(ENDERCOD_CIDADE.Asstring ,ENDERCOD_ESTADO.AsString,ENDERCOD_PAIS.Asstring);
  end;
end;


procedure TFConsultaRuas.ECepEnter(Sender: TObject);
begin
  if ECep.AValor =0 then
    ECep.Clear; }
end;

{********************** atera o tipo de consulta ******************************}
procedure TFConsultaRuas.ECepKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    115 :// F4 muda o tipo de consulta;
      begin
        // mostra a consulta por rua
        RConsulta.ItemIndex:=1;
        RConsultaClick(RConsulta);
      end;
    13 : AtualizaConsulta;
        vk_Up :
       begin
         GConsulta.SetFocus;
         AtualizaConsulta;
         ENDER.prior;
       end;
    Vk_Down:
       begin
         GConsulta.SetFocus;
         AtualizaConsulta;
         ENDER.next;
       end;
  end;
end;

{********************** atera o tipo de consulta ******************************}
procedure TFConsultaRuas.ERuaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    115 :// F4 muda o tipo de consulta;
      begin
        // mostra a consulta por rua
        RConsulta.ItemIndex:=0;
        RConsultaClick(RConsulta);
      end;
    13 : AtualizaConsulta;
    vk_Up :
       begin
         GConsulta.SetFocus;
         AtualizaConsulta;
         ENDER.prior;
       end;
    Vk_Down:
       begin
         GConsulta.SetFocus;
         AtualizaConsulta;
         ENDER.next;
       end;
  end;
end;

{******************* filtra as teclas pressionadas ****************************}
procedure TFConsultaRuas.ECidadeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
       13 : AtualizaConsulta;
    vk_Up :
       begin
         GConsulta.SetFocus;
         AtualizaConsulta;
         ENDER.prior;
       end;
    Vk_Down:
       begin
         GConsulta.SetFocus;
         AtualizaConsulta;
         ENDER.next;
       end;
  end;
end;

Initialization
  RegisterClasses([TFConsultaRuas]);
end.


