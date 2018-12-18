unit AEnviarCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Mask,
  numericos, ComCtrls, Db, DBTables, Grids, DBGrids, Tabela, DBKeyViolation,
  Localizacao, DBCtrls, ArchiverRoot, CustExtractor, CustArchiver, Archiver, UnExportacao;

type
  TFEnviarCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    ESerie: TEditColor;
    BAdicionar: TBitBtn;
    BNovo: TBitBtn;
    Label1: TLabel;
    Tabela: TTable;
    DataTabela: TDataSource;
    Aux: TQuery;
    Label2: TLabel;
    GridIndice2: TGridIndice;
    EditLocaliza1: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    Localiza: TConsultaPadrao;
    Label5: TLabel;
    Data: TCalendario;
    Notas: TQuery;
    DataNotas: TDataSource;
    Label3: TLabel;
    Notasi_nro_not: TIntegerField;
    Notasc_nom_cli: TStringField;
    Notasn_tot_not: TFloatField;
    DBText1: TDBText;
    Notasc_ser_not: TStringField;
    MarcaCaixa: TQuery;
    Archiver1: TArchiver;
    Info: TTable;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BNovoClick(Sender: TObject);
    procedure BAdicionarClick(Sender: TObject);
    procedure DataCloseUp(Sender: TObject);
    procedure Archiver1WriteUserData(Sender: TObject;
      var UserData: TUserData);
  private
    NomeArquivo : string;
    PathArquivo : string;
    UnExp :  TFuncoesExportacao;
    procedure LocalizaNotas( CodNat : string );
    procedure MarcaCaixaEnviadas( SequencialNota, NroNota : integer; Serie : string );
  public
    { Public declarations }
  end;

var
  FEnviarCaixa: TFEnviarCaixa;

implementation

uses APrincipal, constantes, funArquivos, funstring, funsql, constmsg;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFEnviarCaixa.FormCreate(Sender: TObject);
begin
  UnExp :=  TFuncoesExportacao.Cria;
  if not FileExists(varia.PathExportacao + 'caixas\Saida') then
    CriaDiretorio(varia.PathExportacao + 'caixas\Saida');
  if not FileExists(varia.PathExportacao + 'caixas\Enviados') then
    CriaDiretorio(varia.PathExportacao + 'caixas\Enviados');
  Data.DateTime := date;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFEnviarCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnExp.free;
  Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFEnviarCaixa.BFecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFEnviarCaixa.BNovoClick(Sender: TObject);
begin
  PathArquivo := RetornaDiretorioTemp(varia.PathImportacao); //varia.PathImportacao + 'Saida\';
  NomeArquivo := 'Caixa_' + DeletaChars(Datetostr(date),'/') + '_' + DeletaChars(TimeTostr(time), ':') + '.sig';
  Label1.Caption := 'Arquivo : '  + NomeArquivo;

    with TTable.Create(nil) do
    begin
      Active := false;
      DataBaseName := PathArquivo;
      TableName := NomeArquivo;
      TableType := ttParadox;
      //cria os campos
       FieldDefs.add('NroNota',ftInteger,0,false);
       FieldDefs.add('SerieNota',ftstring,2,false);
       FieldDefs.add('NroCaixa',ftInteger,0,false);
       FieldDefs.add('Peso',ftFloat,0,false);
       FieldDefs.add('CodProduto',ftString,20,false);
       FieldDefs.add('SeqProduto',ftInteger,0,false);
      CreateTable;
    end;
    tabela.Active := false;
    tabela.DataBaseName := PathArquivo;
    tabela.TableName := NomeArquivo;
    Tabela.open;
    BAdicionar.Enabled := true;
    Bnovo.Enabled := false;
end;

procedure TFEnviarCaixa.BAdicionarClick(Sender: TObject);
begin
  Notas.First;
  while not notas.eof do
  begin

    LimpaSQLTabela(aux);
    AdicionaSQLTabela(Aux, ' select nota.i_seq_not, nota.i_nro_not, nota.c_ser_not, cai.i_nro_cai,cai.i_pes_cai, cai.c_cod_pro, cai.i_seq_pro ' +
                           ' from cadnotafiscais nota, movcaixaestoque cai '+
                           ' where nota.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil)  +
                           ' and nota.i_seq_not = cai.i_seq_not ' +
                           ' and cai.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil)  +
                           ' and nota.i_nro_not = ' + Notasi_nro_not.AsString  +
                           ' and nota.c_ser_not = ' + Notasc_ser_not.AsString);
    Aux.Open;
    if not aux.eof then
    begin
      while not aux.eof do
      begin
        Tabela.insert;
        tabela.FieldByName('NroNota').AsInteger := Aux.FieldByname('i_nro_not').AsInteger;
        tabela.FieldByName('SerieNota').AsString := Aux.FieldByname('c_ser_not').AsString;
        tabela.FieldByName('NroCaixa').AsInteger := Aux.FieldByname('i_nro_cai').AsInteger;
        tabela.FieldByName('Peso').AsFloat := Aux.FieldByname('i_pes_cai').AsFloat;
        tabela.FieldByName('CodProduto').AsString := Aux.FieldByname('c_cod_pro').AsString;
        tabela.FieldByName('SeqProduto').Asinteger := Aux.FieldByname('i_seq_pro').AsInteger;
        tabela.post;
        MarcaCaixaEnviadas(Aux.FieldByname('i_seq_not').AsInteger,Aux.FieldByname('i_nro_not').AsInteger, Aux.FieldByname('c_ser_not').AsString);
        aux.next;
      end;
    end
    else
      aviso('Nota inexistente ou sem caixas');

     notas.Next;
  end;

  UnExp.CriaArquivoPerfil(PathArquivo);
  UnExp.CriaArquivoInfo(PathArquivo);
  Info.DatabaseName := PathArquivo;
  Info.TableName := 'Info';
  Info.Open;
  info.Insert;
  info.FieldByName('Versao_Banco').AsInteger := varia.VersaoBanco;
  info.FieldByName('Nome_perfil').AsString := 'Envio de Caixa';
  info.FieldByName('Data_Inicio').AsDateTime := Data.DateTime;
  info.FieldByName('Data_fim').AsDateTime := Data.DateTime;
  info.FieldByName('Nome_Fil_Emi').AsString := Varia.NomeFilial;
  info.FieldByName('Nome_Usuario').AsString := Varia.NomeUsuario;
  info.FieldByName('Qdade_Registo').AsInteger := 0;
  info.FieldByName('Cod_Filial_Emi').AsInteger := varia.CodigoFilCadastro;
  info.FieldByName('Cod_Perfil_Emi').AsString := '0';
  info.FieldByName('Tipo_Importacao').AsInteger := 2;
  info.Post;
  info.close;

  tabela.close;
  Archiver1.FileName := varia.PathImportacao + 'Saida\' + NomeArquivo;   // novo arq compactado
  Archiver1.open;
  Archiver1.AddDirectory(PathArquivo);  // local a compactar
  Archiver1.close;
  Archiver1.DeleteDirectory(PathArquivo);  // exclui temporaria
  self.close;
end;


procedure  TFEnviarCaixa.LocalizaNotas( CodNat : string );
begin
  LimpaSQLTabela(Notas);
  AdicionaSQLTabela(Notas, ' Select cad.i_nro_not, cli.c_nom_cli, cad.n_tot_not, cad.c_ser_not from cadnotafiscais cad, cadclientes cli ' +
                           ' where cad.d_dat_emi = ' + SQLTextoDataAAAAMMMDD(data.DateTime) +
                           ' and cad.c_cod_nat = ''' + CodNat + '''' +
                           ' and cad.c_fla_ecf = ''N'' '+
                           ' and cad.i_nro_not is not null ' +
                           ' and cad.c_not_dev = ''N'' ' +
                           ' and cad.c_not_can = ''N'' ' +
                           ' and cad.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil)  +
                           ' and cad.i_cod_cli = cli.i_cod_cli ' );
  if ESerie.Text <> '' then
    AdicionaSQLTabela(Notas, ' and cad.c_ser_not = ''' + ESerie.Text + '''' );
  notas.open;
end;

procedure TFEnviarCaixa.DataCloseUp(Sender: TObject);
begin
  if (EditLocaliza1.text <> '' )  then
    LocalizaNotas(EditLocaliza1.text);
end;

procedure  TFEnviarCaixa.MarcaCaixaEnviadas( SequencialNota, NroNota : integer; Serie : string );
begin
  ExecutaComandoSql(MarcaCaixa, ' update movcaixaestoque '+
                                ' set d_dat_sai = '+ SQLTextoDataAAAAMMMDD(date)  +',  ' +
                                ' c_tip_cai = ''E'', ' +
                                ' c_sit_cai = ''E'', ' +
                                ' i_seq_not = ' + inttostr(SequencialNota) + ',  ' +
                                ' i_nro_not = ' + inttostr(NroNota) + ', ' +
                                ' c_ser_not = ''' + Serie + '''' +
                                ' where i_seq_not = ' + inttostr(SequencialNota)  +
                                ' and i_emp_fil =  ' + inttostr(varia.CodigoEmpFil) );
end;

procedure TFEnviarCaixa.Archiver1WriteUserData(Sender: TObject;
  var UserData: TUserData);
begin
  with UserData do
  begin
    UserName         := 'Sergio Luis Censi';
    Company          := 'Indata Sistemas';
    SerialNumber     := '123456789-ABCD';
    BackupName       := 'Caixas';
    Date             := Now;
    ProductId        := 1234;
    ProductVersion   := 1;
  end;
end;

Initialization
 RegisterClasses([TFEnviarCaixa]);
end.
