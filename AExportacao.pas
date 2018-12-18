unit AExportacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, Buttons,UnExportacao,
  Db, DBTables, FileCtrl, Gauges, ComCtrls, ArchiverRoot, CustExtractor,
  CustArchiver, Archiver, CheckLst;

Const
  CT_NomeVazio = 'NOME INVÁLIDO!!!Nome do arquivo é invalido.....';

type
  TDadosfilial = class
    CodigoEmpFil : integer;
end;

type
  TFExportacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    BExportar: TBitBtn;
    GMostrador: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    EData: TCalendario;
    Label6: TLabel;
    LTabela: TLabel;
    LQtd: TLabel;
    Perfil: TTable;
    Aux: TQuery;
    Label7: TLabel;
    EPerfil: TComboBoxColor;
    Archiver1: TArchiver;
    Label8: TLabel;
    ListaFilial: TCheckListBox;
    Info: TTable;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BExportarClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure Archiver1WriteUserData(Sender: TObject;
      var UserData: TUserData);
    procedure EPerfilChange(Sender: TObject);
    procedure EDataCloseUp(Sender: TObject);
  private
    { Private declarations }
    Exportacao : TFuncoesExportacao;
    VprFiliais : TStringList;
    DataExp : TDateTime;
    procedure Exportar(VpaAlias : String);
    procedure ExportaTabelas(VpaTabelas : TStringList;VpaDiretorio : String);
    procedure AbrePerfil_Info(VpaAlias : String);
    procedure AdicionaPerfil(VpaNomeTabela : String;VpaOrdem : Integer);
    procedure CarregaPerfils;
    function DataExportacao(VpaSistema : String): TDateTime;
    procedure CarregaNomesFiliais( codFilial : string);
    function TextoCodFiliais : string;
  public
    { Public declarations }
  end;

var
  FExportacao: TFExportacao;

implementation

uses APrincipal, FunSql, Constantes, FunArquivos, ConstMsg, FunString;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFExportacao.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
  Exportacao := TFuncoesExportacao.Cria;
  CarregaPerfils;
  //carrega as cores para os componentes nao color
  ListaFilial.Color := EData.Color;
  VprFiliais := TStringList.Create;
  EPerfilChange(nil);
//  CarregaNomesFiliais('');

end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFExportacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 VprFiliais.free;
 Perfil.close;
 Aux.close;
 Info.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                             eventos da exportacao
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*********************** exporta as tabelas ***********************************}
procedure TFExportacao.Exportar(VpaAlias : String);
Var
  VpfNomesTabelas : TStringList;
begin
  VpfNomesTabelas := Exportacao.RetornaNomesTabelas(EPerfil.TExt);
  Exportacao.CriaTabelasExportacao(VpfNomesTabelas,VpaAlias, true);
  Exportacao.CriaArquivoPerfil(VpaAlias); // informacoes dobre as tabela
  Exportacao.CriaArquivoInfo(VpaAlias); // informacaoes da exportacao
  AbrePerfil_Info(VpaAlias);
  ExportaTabelas(VpfNomesTabelas,VpaAlias);
  VpfNomesTabelas.Free;
  ExecutaComandoSql(Aux,' Update PERFIL_EXPORTACAO '+
                        ' SET Dat_Exportacao = '+ SQLTextoDataAAAAMMMDD(Date)+
                        ' Where Cod_Empresa = ' + InttoStr(Varia.CodigoEmpresa) +
                        ' and Nom_Perfil = '''+ EPerfil.Text +'''');
  Perfil.Close;
  EData.DateTime := date;
end;

{************************** exporta as tabelas ********************************}
procedure TFExportacao.ExportaTabelas(VpaTabelas : TStringList;VpaDiretorio : String);
Var
  VpfLaco,VpfOrdem, SomaRegistro : Integer;
  VpfFiliais : String;
begin
  SomaRegistro := 0;
  VpfFiliais := TextoCodFiliais;
  // ordem de exportacao
  VpfOrdem := 0;
  GMostrador.Progress := 0;
  GMostrador.MaxValue := VpaTabelas.Count;
  For VpfLaco := 0 to VpaTabelas.Count - 1 do
  begin
     //incrementa a variavel que indica a ordem que esta sendo exportado;
    inc(VpfOrdem,10);

    LTabela.Caption := VpaTabelas.Strings[VpfLaco]+ '                           ';
    LTabela.Refresh;
    // exporta tabela
    SomaRegistro := SomaRegistro + Exportacao.ExportaTabela(VpaDiretorio,VpaTabelas.Strings[VpfLaco],EData.DateTime,VpfFiliais,LQtd);
    GMostrador.AddProgress(1);
    AdicionaPerfil(VpaTabelas.Strings[VpfLaco],VpfOrdem);
  end;

  info.Insert;
  info.FieldByName('Versao_Banco').AsInteger := varia.VersaoBanco;
  info.FieldByName('Nome_perfil').AsString := EPerfil.Items.Strings[EPerfil.ItemIndex];
  info.FieldByName('Data_Inicio').AsDateTime := EData.DateTime;
  info.FieldByName('Data_fim').AsDateTime := date;
  info.FieldByName('Nome_Fil_Emi').AsString := Varia.NomeFilial;
  info.FieldByName('Nome_Usuario').AsString := Varia.NomeUsuario;
  info.FieldByName('Qdade_Registo').AsInteger := SomaRegistro;
  info.FieldByName('Cod_Filial_Emi').AsInteger := varia.CodigoFilCadastro;
  info.FieldByName('Cod_Perfil_Emi').AsString := Exportacao.RetornaCodPerfil(EPerfil.Items.Strings[EPerfil.ItemIndex]);
  info.FieldByName('Tipo_Importacao').AsInteger := 1;

  info.Post;
  info.close;
  LTabela.Caption := '                                       ';
  LQtd.Caption := ' ';
  LTabela.Refresh;
end;

{********************** abre o arquivo de perfil ******************************}
procedure TFExportacao.AbrePerfil_Info(VpaAlias : String);
begin
  Perfil.DatabaseName := VpaAlias;
  Perfil.TableName := 'Perfil';
  Perfil.Open;
  Info.DatabaseName := VpaAlias;
  Info.TableName := 'Info';
  Info.Open;
end;

{****************** adiciona ao arquivo de perfil *****************************}
procedure TFExportacao.AdicionaPerfil(VpaNomeTabela : String;VpaOrdem : Integer);
begin
  AdicionaSQLAbreTabela(Aux,'Select * from Tabela_Exportacao ' +
                            ' Where Nom_Tabela = ''' + VpaNomeTabela + '''');
  Perfil.Append;
  Perfil.FieldByName('Num_Ordem').AsInteger := VpaOrdem;
  Perfil.FieldByName('Nom_Tabela').Asstring := VpaNomeTabela;
  Perfil.FieldByName('Nom_CAMPO_FILIAL').Asstring := Aux.FieldByName('Nom_CAMPO_FILIAL').Asstring;
  Perfil.FieldByName('Nom_Chave1').Asstring := Aux.FieldByName('Nom_Chave1').Asstring;
  Perfil.FieldByName('Nom_Chave2').Asstring := Aux.FieldByName('Nom_Chave2').Asstring;
  Perfil.FieldByName('Nom_Chave3').Asstring := Aux.FieldByName('Nom_Chave3').Asstring;
  Perfil.FieldByName('Nom_Chave4').Asstring := Aux.FieldByName('Nom_Chave4').Asstring;
  Perfil.FieldByName('Nom_Chave5').Asstring := Aux.FieldByName('Nom_Chave5').Asstring;
  Perfil.post;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************* chama a rotina de exportação ***************************}
procedure TFExportacao.BExportarClick(Sender: TObject);
var
 VpaAliasTabelas : String;
 VpfPathArquivo, VpfNomeArquivo : String;
begin
  VpfNomeArquivo := EPerfil.Text + '_' +  IntToStr(Varia.CodigoEmpFil) + '_' + DeletaChars(Datetostr(date),'/') + '_' + DeletaChars(TimeTostr(time), ':') ;
  if Entrada('Nome do Arquivo','Digite o nome do Arquivo : ',VpfNomeArquivo,false,EPerfil.Color,PanelColor1.Color) then
  begin
    if DeletaEspaco(VpfNomeArquivo) = '' Then
      Erro(CT_NomeVazio)
    else
    begin
      VpfNomeArquivo := DeletaChars(VpfNomeArquivo,'.'); // Nome do arquivo
      VpaAliasTabelas := RetornaDiretorioCorrente; // pasta temporaria
      VpfPathArquivo := varia.PathImportacao + 'Saida\' + VpfNomeArquivo + '.sig'; //path do novo arquivo

      Exportar(VpaAliasTabelas); // gera exportacao

      DeletaArquivo(VpfPathArquivo); // exclui arquivos da pasta temporaria

      Archiver1.FileName := VpfPathArquivo;   // novo arq compactado
      Archiver1.open;
      Archiver1.AddDirectory(VpaAliasTabelas);  // local a compactar
      Archiver1.close;
      Archiver1.DeleteDirectory(VpaAliasTabelas);  // exclui temporaria

      ExecutaComandoSql(aux, 'update cfg_geral set d_ult_exp = ' + SQLTextoDataAAAAMMMDD(date));
      self.close;
    end;
  end;
end;

{***************** fecha o formulario corrente *******************************}
procedure TFExportacao.BFecharClick(Sender: TObject);
begin
  close;
end;

{************************* carrega os perfils *********************************}
procedure TFExportacao.CarregaPerfils;
begin
  AdicionaSQLAbreTabela(Aux,'Select * from Perfil_Exportacao '+
                            ' Where Cod_Empresa = ' + IntToStr(Varia.CodigoEmpresa)+
                            ' and cod_perfil not in(999999,888888) ' + // baixas do cr e cp
                            ' order by Nom_Perfil');
  While not aux.Eof do
  begin
    EPerfil.Items.Add(Aux.FieldByName('Nom_Perfil').Asstring);
    Aux.next;
  end;
  EPerfil.ItemIndex := 0;
  EPerfilChange(EPerfil);
end;

{****************** retorna a data de exportacao ******************************}
function TFExportacao.DataExportacao(VpaSistema : String): TDateTime;
begin
  AdicionaSQLAbreTabela(Aux,'Select Dat_Exportacao from Perfil_Exportacao '+
                            ' Where Cod_Empresa = ' + IntToStr(Varia.CodigoEmpresa) +
                            ' and Nom_Perfil = ''' + VpaSistema+ '''');
  result := Aux.FieldByName('Dat_Exportacao').AsDateTime;
end;

{******************** carrega o nome das filiais ******************************}
procedure TFExportacao.CarregaNomesFiliais(CodFilial : string);
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
  AdicionaSQLTabela(Aux,'Select I_Emp_fil , C_Nom_Fil from CadFiliais '+
                        ' Where I_cod_Emp = ' +  IntToStr(Varia.CodigoEmpresa));
  if SomentePadrao then
    AdicionaSQLTabela(Aux,' and i_emp_fil = ' + IntToStr(varia.CodigoEmpFil));
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

  if Codfilial <> '' then
  begin
    LimpaSQLTabela(Aux);
    AdicionaSQLTabela(Aux,'Select I_Emp_fil , C_Nom_Fil from CadFiliais '+
                          ' Where I_cod_Emp = ' +  IntToStr(Varia.CodigoEmpresa));
    AdicionaSQLTabela(Aux,' and i_emp_fil in (' + Codfilial + ')');
    AbreTabela(Aux);

    while not Aux.Eof do
    begin
      for laco := 0 to ListaFilial.Items.count -1 do
        if aux.FieldByname('I_Emp_Fil').AsInteger = TDadosfilial(ListaFilial.Items.Objects[laco]).CodigoEmpFil then
          ListaFilial.Checked[laco] := true;
      Aux.Next;
    end;
    Aux.Close;

  end;
end;

{************ Monta o texto com os codigo das filiais marcadas ***************}
function  TFExportacao.TextoCodFiliais : string;
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
end;


{***************** carrega as propriedades dos arquivos ***********************}
procedure TFExportacao.Archiver1WriteUserData(Sender: TObject;
  var UserData: TUserData);
begin
  with UserData do
    begin
      UserName         := 'Sergio Luis Censi';
      Company          := 'Indata Sistemas';
      SerialNumber     := '123456789-ABCD';
      BackupName       := 'Clientes';
      Date             := Now;
      ProductId        := 1234;
      ProductVersion   := 1;
    end;
end;

procedure TFExportacao.EPerfilChange(Sender: TObject);
begin
  EData.DateTime := DataExportacao(EPerfil.Text);
  DataExp := EData.DateTime;
  AdicionaSQLAbreTabela(Aux,' Select * from PERFIL_EXPORTACAO '+
                            ' Where Cod_Empresa = ' + InttoStr(Varia.CodigoEmpresa) +
                            ' and Nom_Perfil = '''+ EPerfil.Text +'''');
  CarregaNomesFiliais(aux.fieldByName('filial_exportacao').AsString);
  Perfil.Close;
end;

procedure TFExportacao.EDataCloseUp(Sender: TObject);
begin
  if (EData.DateTime > DataExp) and (EPerfil.text <> '' ) then
  begin
    EData. DateTime := DataExp;
    aviso('Data Invalida, a data não pode ser maior que ultima esportada');
    EData.SetFocus;
  end;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFExportacao]);
end.
