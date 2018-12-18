unit ATabelasExportacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, StdCtrls, Mask, DBCtrls, DBTables, Tabela, BotaoCadastro, Buttons,
  Componentes1, ExtCtrls, PainelGradiente, Localizacao, Grids, DBGrids,
  DBKeyViolation;

type
  TFTabelasExportacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    BFechar: TBitBtn;
    TabelaExportacao: TSQL;
    TabelaExportacaoSEQ_TABELA: TIntegerField;
    TabelaExportacaoNOM_TABELA: TStringField;
    DataTabelaExportacao: TDataSource;
    Label3: TLabel;
    DBEdit3: TDBEditColor;
    Label5: TLabel;
    DBEdit5: TDBEditColor;
    Localiza: TConsultaPadrao;
    Bevel1: TBevel;
    Label7: TLabel;
    Consulta: TLocalizaEdit;
    GridIndice1: TGridIndice;
    TabelaExportacaoNOM_CHAVE1: TStringField;
    TabelaExportacaoNOM_CHAVE2: TStringField;
    TabelaExportacaoNOM_CHAVE3: TStringField;
    TabelaExportacaoNOM_CHAVE4: TStringField;
    TabelaExportacaoNOM_CHAVE5: TStringField;
    DBEditColor1: TDBEditColor;
    DBEditColor2: TDBEditColor;
    DBEditColor3: TDBEditColor;
    Label4: TLabel;
    DBEditColor4: TDBEditColor;
    DBEditColor5: TDBEditColor;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    DBEditColor6: TDBEditColor;
    TabelaExportacaoNOM_CAMPO_DATA: TStringField;
    Label12: TLabel;
    ValidaGravacao1: TValidaGravacao;
    BitBtn1: TBitBtn;
    DBEditColor7: TDBEditColor;
    Label1: TLabel;
    TabelaExportacaoNOM_CAMPO_FILIAL: TStringField;
    TabelasBanco: TQuery;
    Campos: TQuery;
    Aux: TQuery;
    TabelaExportacaoC_PER_UPD: TStringField;
    Label2: TLabel;
    DBEditChar1: TDBEditChar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabelaExportacaoAfterInsert(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure TabelaExportacaoAfterPost(DataSet: TDataSet);
    procedure DBEdit3Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AdicionaCamposPrimarios;
  public
    { Public declarations }
  end;

var
  FTabelasExportacao: TFTabelasExportacao;

implementation

uses APrincipal, Constantes, FunSql;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFTabelasExportacao.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
  Consulta.AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFTabelasExportacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

procedure TFTabelasExportacao.TabelaExportacaoAfterInsert(
  DataSet: TDataSet);
begin
end;

{****************** fecha o formulario corrente *******************************}
procedure TFTabelasExportacao.BFecharClick(Sender: TObject);
begin
  close;
end;

{********************** apos gravar a consulta ********************************}
procedure TFTabelasExportacao.TabelaExportacaoAfterPost(DataSet: TDataSet);
var
  VpfPosicao : TBookmark;
begin
  VpfPosicao := TabelaExportacao.GetBookmark;
  Consulta.AtualizaConsulta;
  TabelaExportacao.GotoBookmark(VpfPosicao);
  TabelaExportacao.FreeBookmark(VpfPosicao);
end;

{******************* executa o valida gravação ********************************}
procedure TFTabelasExportacao.DBEdit3Change(Sender: TObject);
begin
  If TabelaExportacao.State in [dsedit,dsinsert] then
    ValidaGravacao1.Execute;
end;

{************* adiciona todas as tabelas do banco de dados ********************}
procedure TFTabelasExportacao.BitBtn1Click(Sender: TObject);
var
  VpfTabelas : TStringList;
  VpfLAco : Integer;
begin
  VpfTabelas := TStringList.Create;
  Session.GetTableNames('Sig','',false,false,VpfTabelas);
  for VpfLaco := 0 to VpfTabelas.Count -1 do
  begin
    ExecutaComandoSql(TabelaExportacao,'insert into Tabela_Exportacao(Seq_Tabela,Nom_Tabela,NOM_Campo_Data) '+
                                       ' Values('+IntToStr(100000 + VpfLAco)+','''+VpfTabelas.Strings[VpfLaco]+ ''',''D_ULT_ALT'')');

  end;
  AdicionaCamposPrimarios;
end;

{*********** Adiciona todos os campos primeiros do banco de dados *************}
procedure TFTabelasExportacao.AdicionaCamposPrimarios;
Var
  VpfNroCampo : Integer;
  VpfPosicao : TBookmark;
begin
   AdicionaSQLAbreTabela(TabelasBanco,'Select * from Tabela_exportacao ');
   While not TabelasBanco.Eof do
   begin
     AdicionaSQLAbreTabela(Campos,'SELECT * FROM SYSCOLUMNS '+
                                  ' WHERE IN_PRIMARY_KEY = ''Y'''+
                                  ' and TName = '''+TabelasBanco.FieldByname('NOM_TABELA').AsString+''''+
                                  ' AND CREATOR =''DBA''');
     VpfNroCampo := 1;
     While not Campos.Eof do
     begin
       if Campos.FieldByname('CName').AsString = 'I_EMP_FIL' THEN
         ExecutaComandoSql(Aux,'update Tabela_Exportacao '+
                             ' Set Nom_Campo_Filial= '''+ Campos.FieldByname('CName').AsString+''''+
                             ' Where Seq_Tabela = '+TabelasBanco.FieldByname('Seq_Tabela').AsString)
       else
       begin
         ExecutaComandoSql(Aux,'update Tabela_Exportacao '+
                             ' Set Nom_Chave'+IntToStr(VpfNroCampo)+ '= '''+ Campos.FieldByname('CName').AsString+''''+
                             ' Where Seq_Tabela = '+TabelasBanco.FieldByname('Seq_Tabela').AsString);
         Inc(VpfNroCampo);
       end;
       Campos.next;
     end;
     TabelasBanco.Next;
   end;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFTabelasExportacao]);
end.
