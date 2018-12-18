unit AEnviarBaixas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Db, DBTables, Buttons, Componentes1, ExtCtrls, PainelGradiente,
  Grids, DBGrids, Tabela, DBKeyViolation, ComCtrls, UnEXportacao,
  ArchiverRoot, CustExtractor, CustArchiver, Archiver, Gauges, CheckLst;

type
  TDadosfilial = class
    CodigoEmpFil : integer;
end;

type
  TFEnviarBaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    PanelColor3: TPanelColor;
    Label1: TLabel;
    Data1: TCalendario;
    Tabela: TTable;
    Aux: TQuery;
    info: TTable;
    Archiver1: TArchiver;
    BNovo: TBitBtn;
    ListaFilial: TCheckListBox;
    Contas: TRadioGroup;
    Label2: TLabel;
    Barra1: TGauge;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure Data1CloseUp(Sender: TObject);
    procedure BNovoClick(Sender: TObject);
    procedure Archiver1WriteUserData(Sender: TObject;
      var UserData: TUserData);
    procedure PageControl1Change(Sender: TObject);
  private
    PathArquivo : string;
    UnExp : TFuncoesExportacao;
    DataExp : TDateTime;
//    procedure LocalizaBaixaCR;
    function GeraRegistro( TabelaExp : TQuery; NomeTabelaExp : string) : Integer;
    function RetornaDataExportacao(CodPerfil : integer) : TDateTime;
    procedure GravaDataExportacao(CodPerfil : integer);
    procedure EnviaBaixaCR;
    procedure AdicionaFiltro(VPaSelect: Tstrings);
    procedure Gerainfo(QdadeReg : Integer; ContaaReceber : Boolean);
    Procedure Compactar(NomeArquivo : string);
    procedure EnviaBaixaCP;
//    procedure LocalizaBaixaCP;
    procedure AdicionaPerfil(VpaNomeTabela : String; VpaOrdem : Integer);
    procedure AdicionaTabela( Tabelas : TStringList; PathArquivo : string);
    procedure AdicionaEstorno(Tipo_Tabela : integer);
    procedure CarregaNomesFiliais( Codfilial : string);
    function TextoCodFiliais(Alias : string) : string;
  public
    { Public declarations }
  end;

var
  FEnviarBaixa: TFEnviarBaixa;

implementation

uses APrincipal, constantes, constmsg, funsql, fundata, funarquivos, funstring;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFEnviarBaixa.FormCreate(Sender: TObject);
begin
  UnExp := TFuncoesExportacao.Cria;
  Data1.DateTime := date;
  ListaFilial.Color := data1.Color;
  CarregaNomesFiliais('');
  DataExp := RetornaDataExportacao(999999);
  Data1.DateTime := DataExp;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFEnviarBaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnExp.free;
  Action := CaFree;
end;

{*********************** fecha formulario ************************************}
procedure TFEnviarBaixa.BFecharClick(Sender: TObject);
begin
  self.close;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            geral
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************** informacoes do compactador *********************************}
procedure TFEnviarBaixa.Archiver1WriteUserData(Sender: TObject;
  var UserData: TUserData);
begin
  with UserData do
    begin
      UserName         := 'Sergio Luis Censi';
      Company          := 'Indata Sistemas';
      SerialNumber     := '123456789-ABCD';
      BackupName       := 'baixas';
      Date             := Now;
      ProductId        := 1234;
      ProductVersion   := 1;
    end;
end;

{*********************** adiciona Filtro ************************************}
procedure  TFEnviarBaixa.AdicionaFiltro(VPaSelect: Tstrings);
begin
//  VPaSelect.add(' where mov.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) );
//  VPaSelect.add(SQLTextoDataEntreAAAAMMDD('Mov.D_ULT_ALT',data1.DateTime, data2. DateTime, true) );

  VPaSelect.add(' where ' + TextoCodFiliais('mov'));
  VPaSelect.add(' and ( mov.d_dat_pag >= ' + SQLTextoDataAAAAMMMDD(data1.DateTime));
  VPaSelect.add(' or (c_fla_par = ''S'' ' +
                      ' and mov.d_ult_alt >= ' + SQLTextoDataAAAAMMMDD(data1.DateTime) +
                      ' )) ' );
end;

{******************** carrega o nome das filiais ******************************}
procedure TFEnviarBaixa.CarregaNomesFiliais( Codfilial : string);
var
  Dados : TDadosfilial;
  item, laco : integer;
  SomentePadrao : boolean;
begin
  ListaFilial.Items.Clear;
  SomentePadrao := false;
  if Codfilial = '' then
  begin
    AdicionaSQLAbreTabela(Aux,'Select C_EXP_FIL from CFG_GERAL ');
    if Aux.fieldByName('C_EXP_FIL').AsString = 'T' then
      SomentePadrao := true;
    Aux.close;
  end;

  LimpaSQLTabela(Aux);
  AdicionaSQLTabela(Aux,'Select I_Emp_fil , C_Nom_Fil from CadFiliais Fil'+
                        ' Where fil.I_cod_Emp = ' +  IntToStr(Varia.CodigoEmpresa));
  if SomentePadrao then
    AdicionaSQLTabela(Aux,' and ' + TextoCodFiliais('Fil'));
  AbreTabela(Aux);

  while not Aux.Eof do
  begin
    Dados := TDadosfilial.Create;
    dados.CodigoEmpFil := aux.FieldByname('I_Emp_Fil').AsInteger;
    item := ListaFilial.Items.AddObject(aux.FieldByname('I_Emp_Fil').AsString + ' - '+ Aux.FieldByname('C_Nom_Fil').AsString,dados);
    ListaFilial.Checked[item] := SomentePadrao;
    Aux.Next;
  end;
  Aux.Close;
end;

{************ gera o  texto das filiais *************************************}
function TFEnviarBaixa.TextoCodFiliais(Alias : string) : string;
var
  laco : Integer;
begin
  result := '';
  for laco := 0 to ListaFilial.Items.Count - 1 do
    if ListaFilial.Checked[laco] then
    begin
      if result <> '' then
        result := result + ', ';
      result := result + IntToStr(TDadosfilial(ListaFilial.Items.Objects[laco]).CodigoEmpFil);
    end;
    if result <> '' then
      result := alias + '.i_emp_fil in ( ' + result + ') ';
end;

{*************** retorna a data exportacao **********************************}
function TFEnviarBaixa.RetornaDataExportacao(CodPerfil : integer) : TDateTime;
begin
  AdicionaSQLAbreTabela(Aux,'Select Dat_Exportacao from Perfil_Exportacao '+
                            ' Where Cod_Empresa = ' + IntToStr(Varia.CodigoEmpresa) +
                            ' and Cod_Perfil = ' + Inttostr(CodPerfil));
  result := Aux.FieldByName('Dat_Exportacao').AsDateTime;
end;

{****************** grava a data de exportacao ******************************* }
procedure TFEnviarBaixa.GravaDataExportacao(CodPerfil : integer);
begin
  AdicionaSQLAbreTabela(Aux,'Select Dat_Exportacao from Perfil_Exportacao '+
                            ' Where Cod_Empresa = ' + IntToStr(Varia.CodigoEmpresa) +
                            ' and Cod_Perfil = ' + Inttostr(CodPerfil));
  if not aux.eof then
  begin
    ExecutaComandoSql(Aux,' update Perfil_Exportacao '+
                          ' set Dat_Exportacao = ' +SQLTextoDataAAAAMMMDD(date) +
                          ' Where Cod_Empresa = ' + IntToStr(Varia.CodigoEmpresa) +
                          ' and Cod_Perfil = ' + inttostr(CodPerfil) );
  end
  else
  begin
    ExecutaComandoSql(Aux,' insert into Perfil_Exportacao(Cod_Empresa, Cod_Perfil, Nom_perfil, Dat_exportacao) ' +
                          ' values(' + Inttostr(varia.CodigoEmpresa) + ', ' +
                                    IntToStr(CodPerfil) + ',' + '''Baixa Contas a Receber'',' +
                           SQLTextoDataAAAAMMMDD(date) + ')' );
  end;
end;

{******************** localiza movimento ************************************}
procedure TFEnviarBaixa.Data1CloseUp(Sender: TObject);
begin
  if (Data1.DateTime > DataExp) then
  begin
    Data1. DateTime := DataExp;
    aviso('Data Invalida, a data não pode ser maior que ultima esportada');
    Data1.SetFocus;
  end;
end;

{ ************* gera arquivo ************************************************}
procedure TFEnviarBaixa.BNovoClick(Sender: TObject);
begin
  if TextoCodFiliais('') <> '' then
  begin
    if contas.itemIndex  = 0 then
      EnviaBaixaCR
    else
      EnviaBaixaCP;
  end
  else
    aviso('Selecione no mínimo uma filial');    
end;

{************************ gera arquivo de registro ****************************}
function TFEnviarBaixa.GeraRegistro( TabelaExp : TQuery; NomeTabelaExp : string) : Integer;
var
  conta, laco : integer;
begin
  // gera o mov contas a receber
  tabela.Active := false;
  tabela.DataBaseName := PathArquivo;
  tabela.TableName := NomeTabelaExp;
  Tabela.open;

  Conta := 0;
  TabelaExp.First;
    while not TabelaExp.eof do
    begin
      Tabela.Append;
      for Laco := 0 to Tabela.FieldCount -1 do
        Tabela.Fields[Laco].Value := TabelaExp.FieldByName(Tabela.Fields[Laco].DisplayName).Value;
      Tabela.post;
      TabelaExp.next;
      inc(conta);
    end;
    tabela.close;
    result := conta;
end;

procedure TFEnviarBaixa.AdicionaTabela( Tabelas : TStringList; PathArquivo : string);
var
  laco : integer;
begin
  UnExp.CriaArquivoPerfil(PathArquivo);
  Info.DatabaseName := PathArquivo;
  Info.TableName := 'Perfil';
  Info.Open;
  for Laco := 0 to tabelas.count -1 do
    AdicionaPerfil(tabelas.Strings[laco], laco+1);
  Info.close;
  aux.close;
end;

procedure TFEnviarBaixa.AdicionaPerfil(VpaNomeTabela : String; VpaOrdem : Integer);
begin
  AdicionaSQLAbreTabela(Aux,'Select * from Tabela_Exportacao ' +
                            ' Where Nom_Tabela = ''' + VpaNomeTabela + '''');
  Info.Append;
  Info.FieldByName('Num_Ordem').AsInteger := VpaOrdem;
  Info.FieldByName('Nom_Tabela').Asstring := VpaNomeTabela;
  Info.FieldByName('Nom_CAMPO_FILIAL').Asstring := Aux.FieldByName('Nom_CAMPO_FILIAL').Asstring;
  Info.FieldByName('Nom_Chave1').Asstring := Aux.FieldByName('Nom_Chave1').Asstring;
  Info.FieldByName('Nom_Chave2').Asstring := Aux.FieldByName('Nom_Chave2').Asstring;
  Info.FieldByName('Nom_Chave3').Asstring := Aux.FieldByName('Nom_Chave3').Asstring;
  Info.FieldByName('Nom_Chave4').Asstring := Aux.FieldByName('Nom_Chave4').Asstring;
  Info.FieldByName('Nom_Chave5').Asstring := Aux.FieldByName('Nom_Chave5').Asstring;
  Info.post;
end;


{***************** gera arquivo de informacao ********************************}
procedure TFEnviarBaixa.Gerainfo(QdadeReg : Integer; ContaaReceber : Boolean);
begin
  UnExp.CriaArquivoInfo(PathArquivo);
  Info.DatabaseName := PathArquivo;
  Info.TableName := 'Info';
  Info.Open;
  info.Insert;
  info.FieldByName('Versao_Banco').AsInteger := varia.VersaoBanco;
  info.FieldByName('Data_Inicio').AsDateTime := Data1.DateTime;
  info.FieldByName('Data_fim').AsDateTime := date;
  info.FieldByName('Nome_Fil_Emi').AsString := Varia.NomeFilial;
  info.FieldByName('Nome_Usuario').AsString := Varia.NomeUsuario;
  info.FieldByName('Qdade_Registo').AsInteger := QDadeReg;
  info.FieldByName('Cod_Filial_Emi').AsInteger := varia.CodigoFilCadastro;
  if ContaaReceber then
  begin
    info.FieldByName('Tipo_Importacao').AsInteger := 3;
    info.FieldByName('Cod_Perfil_Emi').AsInteger := 999999;   // contas a receber
    info.FieldByName('Nome_perfil').AsString := 'Baixa do Contas a Receber';
  end
  else
  begin
    info.FieldByName('Tipo_Importacao').AsInteger := 4;
    info.FieldByName('Cod_Perfil_Emi').AsInteger := 888888;   //contas a pagar
    info.FieldByName('Nome_perfil').AsString := 'Baixa do Contas a Pagar';
  end;
  info.Post;
  info.close;
end;

{********************* compacta baixa ***************************************}
Procedure TFEnviarBaixa.Compactar(NomeArquivo : string);
begin
  Archiver1.FileName := varia.PathImportacao + 'Saida\' + NomeArquivo;   // novo arq compactado
  Archiver1.open;
  Archiver1.AddDirectory(PathArquivo);  // local a compactar
  Archiver1.close;
  Archiver1.DeleteDirectory(PathArquivo);  // exclui temporaria
end;

procedure  TFEnviarBaixa.AdicionaEstorno(Tipo_Tabela : integer);
begin
  if Tipo_Tabela = 1 then // contas a receber
  Begin
    AdicionaSQLAbreTabela(Aux, ' Select * from MovContasareceber Mov ' +
                               ' where ' + TextoCodFiliais('mov') +
                               ' and  mov.d_dat_est >= ' + SQLTextoDataAAAAMMMDD(data1.DateTime) +
                               ' and d_dat_pag is null ');

    UnExp.CriaArquivoEstorno(PathArquivo);
    Info.DatabaseName := PathArquivo;
    Info.TableName := 'Estorno';
    Info.Open;
    while not aux.Eof do
    begin
      info.Insert;
      info.FieldByName('Empresa_filial').AsInteger := aux.fieldByname('i_emp_fil').AsInteger;
      info.FieldByName('Lancamento').AsInteger := aux.fieldByname('i_lan_rec').AsInteger;
      info.FieldByName('Parcela').AsInteger := aux.fieldByname('i_nro_par').AsInteger;
      info.FieldByName('Data_vencimento').AsDateTime := aux.fieldByname('d_dat_ven').AsDateTime;
      info.FieldByName('Tipo_cad').AsString := 'R';
      info.post;
      aux.next;
    end;
  end
  else
  begin
    AdicionaSQLAbreTabela(Aux, ' Select * from MovContasapagar Mov ' +
                               ' where ' + TextoCodFiliais('mov') +
                               ' and  mov.d_dat_est >= ' + SQLTextoDataAAAAMMMDD(data1.DateTime)+
                               ' and d_dat_pag is null ');

    UnExp.CriaArquivoEstorno(PathArquivo);
    Info.DatabaseName := PathArquivo;
    Info.TableName := 'Estorno';
    Info.Open;
    while not aux.Eof do
    begin
      info.Insert;
      info.FieldByName('Empresa_filial').AsInteger := aux.fieldByname('i_emp_fil').AsInteger;
      info.FieldByName('Lancamento').AsInteger := aux.fieldByname('i_lan_apg').AsInteger;
      info.FieldByName('Parcela').AsInteger := aux.fieldByname('i_nro_par').AsInteger;
      info.FieldByName('Data_vencimento').AsDateTime := aux.fieldByname('d_dat_ven').AsDateTime;
      info.FieldByName('Tipo_cad').AsString := 'P';
      info.post;
      aux.next;
    end;
  end;
  info.close;
  aux.close;
end;

{******************* muda pagina ********************************************}
procedure TFEnviarBaixa.PageControl1Change(Sender: TObject);
begin
  if contas.itemindex = 0 then
  begin
    DataExp := RetornaDataExportacao(999999);
    Data1.DateTime := DataExp;
  end
  else
  begin
    DataExp := RetornaDataExportacao(888888);
    Data1.DateTime := DataExp;
  end;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Contas a receber
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{ ********************** gera as baixa do contas a receber *******************}
procedure TFEnviarBaixa.EnviaBaixaCR;
var
  Tabelas : TstringList;
  Laco, ContaReg : Integer;
begin
    PathArquivo := RetornaDiretorioCorrente; //varia.PathImportacao + 'Saida\';
    Tabelas := TStringList.create;
    Tabelas.Clear;
    Tabelas.Add('CADBANCOS');
    Tabelas.Add('CADSITUACOES');  // gera mov contas a receber
    Tabelas.Add('CADFORMASPAGAMENTO');  // gera mov contas a receber
    Tabelas.Add('CADMOEDAS');  // gera mov contas a receber
    Tabelas.Add('CAD_PLANO_CONTA');

    Tabelas.Add('MOVCONTASARECEBER');  // gera mov contas a receber
    Tabelas.Add('MOVFORMA');  // gera mov formas de pagamento
    Tabelas.Add('MOVCOMISSOES');  // gera mov comissoes

    UnExp.CriaTabelasExportacao(Tabelas,PathArquivo, false);
    Bnovo.Enabled := false;

    barra1.MaxValue := 5;

    // gera o mov contas a receber
    LimpaSQLTabela(aux);
    AdicionaSQLTabela(Aux, ' Select * from MovContasareceber Mov' );
    AdicionaFiltro(Aux.sql);

    AbreTabela(Aux);

    ContaReg := 0;
    if not Aux.eof then
    begin
      contaReg := GeraRegistro(aux, 'MOVCONTASARECEBER.db');
      Aux.close;
      barra1.AddProgress(1);

      // gera o mov formas
      LimpaSQLTabela(aux);
      AdicionaSQLTabela(Aux, ' Select * from movforma frm where frm.i_lan_rec in (' );
      AdicionaSQLTabela(Aux, ' Select i_lan_rec from movContasareceber mov' );
      AdicionaFiltro(aux.sql);
      AdicionaSQLTabela(Aux, ' ) and ' + TextoCodFiliais('frm') );
      AbreTabela(Aux);
      contaReg := contaReg + GeraRegistro(aux, 'MOVFORMA.db');
      Aux.close;
      barra1.AddProgress(1);

      // gera o mov comissoes
      LimpaSQLTabela(aux);
      AdicionaSQLTabela(Aux, ' Select * from movcomissoes com where com.i_lan_rec in (' );
      AdicionaSQLTabela(Aux, ' Select i_lan_rec from movContasareceber mov' );
      AdicionaFiltro(aux.sql);
      AdicionaSQLTabela(Aux, ' ) and ' + TextoCodFiliais('com'));
      AbreTabela(Aux);
      contaReg := contaReg + GeraRegistro(aux, 'MOVCOMISSOES.db');
      Aux.close;
      barra1.AddProgress(1);

      AdicionaTabela(Tabelas, PathArquivo);

      barra1.AddProgress(1);


      UnExp.ExportaTabela(PathArquivo,'CadBancos',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CadSituacoes',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CadFormasPagamento',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CADMOEDAS',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CAD_PLANO_CONTA',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais

      // estornos
      AdicionaEstorno(1);
      barra1.AddProgress(1);
      GravaDataExportacao(999999);
    end
    else
      aviso('Não existe baixa a ser enviada!');
    tabela.close;
    Aux.close;

    Gerainfo(ContaReg, true);  // gera arquivo de informacao

    Compactar('BaixaCR_' + DeletaChars(Datetostr(date),'/') + '_' + DeletaChars(TimeTostr(time), ':') + '.sig');

    self.close;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Contas a Pagar
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{ ********************** gera as baixa do contas a receber *******************}
procedure TFEnviarBaixa.EnviaBaixaCP;
var
  Tabelas : TstringList;
  Laco, ContaReg : Integer;
begin
    PathArquivo := RetornaDiretorioCorrente; //varia.PathImportacao + 'Saida\';
    Tabelas := TStringList.create;
    Tabelas.Clear;
    Tabelas.Add('CADBANCOS');  // gera mov contas a receber
    Tabelas.Add('CADSITUACOES');  // gera mov contas a receber
    Tabelas.Add('CADFORMASPAGAMENTO');  // gera mov contas a receber
    Tabelas.Add('CADMOEDAS');  // gera mov contas a receber
    Tabelas.Add('CADCONTAS');  // gera mov contas a receber
    Tabelas.Add('CADOPERACAOBANCARIA');
    Tabelas.Add('CAD_PLANO_CONTA');
    Tabelas.Add('MOVBANCOS');  // gera mov contas a receber

    Tabelas.Add('MOVCONTASAPAGAR');  // gera mov contas a receber

  //  Tabelas.Add('MOVFORMA');  // gera mov formas de pagamento

    UnExp.CriaTabelasExportacao(Tabelas,PathArquivo, false);
    Bnovo.Enabled := false;

    // gera o mov contas a pagar
    LimpaSQLTabela(aux);
    AdicionaSQLTabela(Aux, ' Select * from MovContasapagar mov ' );
    AdicionaFiltro(aux.sql);
    AbreTabela(Aux);

    ContaReg := 0;
    if not Aux.eof then
    begin
      contaReg := GeraRegistro(aux, 'MOVCONTASAPAGAR.db');
      Aux.close;

      UnExp.ExportaTabela(PathArquivo,'CadBancos',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CadSituacoes',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CadFormasPagamento',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CADMOEDAS',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CADOPERACAOBANCARIA',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CAD_PLANO_CONTA',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'CADCONTAS',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais
      UnExp.ExportaTabela(PathArquivo,'MovBancos',data1.DateTime,'11',label3);  //pode ser usado a 11 porque estas tabelas nao posue filiais

      // estornos
      AdicionaEstorno(2);
      AdicionaTabela(Tabelas, PathArquivo);
      GravaDataExportacao(888888);

    end
    else
      aviso('Não existe baixa a ser enviada!');
    tabela.close;
    Aux.close;

    Gerainfo(ContaReg, false);  // gera arquivo de informacao

    Compactar('BaixaCP_' + DeletaChars(Datetostr(date),'/') + '_' + DeletaChars(TimeTostr(time), ':') + '.sig');
    self.close;
end;






Initialization
 RegisterClasses([TFEnviarBaixa]);
end.
