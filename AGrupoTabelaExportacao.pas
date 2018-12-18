unit AGrupoTabelaExportacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, DBCtrls, Tabela, Db,
  DBTables, Buttons;

type
  TFGrupoTabelaExportacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BFechar: TBitBtn;
    BAdicionar: TBitBtn;
    BRemover: TBitBtn;
    Aux: TQuery;
    ETabelas: TListBoxColor;
    EGrupos: TListBoxColor;
    EGrupoTabela: TListBoxColor;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GrupoExportacaoAfterScroll(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure BAdicionarClick(Sender: TObject);
    procedure BRemoverClick(Sender: TObject);
    procedure ETabelasClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    VprTabelas, VprGrupos, VprGrupoTabela : TStringList;
    procedure PosicionaGrupoTabela(VpaCodGrupo : String);
    function ExisteTabelaGrupoExportacao(VpaCodGrupo,VpaSeqTabela : String):Boolean;
    procedure AdicionaTabelaGrupoExportacao(VpaCodGrupo,VpaSeqTabela : String);
    procedure ExcluiTabelaGrupo(VpaCodGrupo,VpaSeqTabela : String);
    procedure CarregaTabelas;
    procedure CarregaGrupos;
  public
    { Public declarations }
  end;

  Tdados = class
    codigo : integer;
    resetar : Boolean;
  end;

var
  FGrupoTabelaExportacao: TFGrupoTabelaExportacao;

implementation

uses APrincipal, FunSql, ConstMsg;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFGrupoTabelaExportacao.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
  VprTabelas := TStringList.Create;
  VprGrupos := TStringList.Create;
  VprGrupoTabela := TStringList.Create;
  CarregaTabelas;
  CarregaGrupos;
  PosicionaGrupoTabela(VprGrupos.Strings[EGrupos.itemIndex]);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFGrupoTabelaExportacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
  Aux.close;
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da consulta
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************* posiciona as tabelas do grupo de acordo com o grupo ************}
procedure TFGrupoTabelaExportacao.PosicionaGrupoTabela(VpaCodGrupo : String);
begin
  Cursor := crAppStart;
  VprGrupoTabela.clear;
  EGrupoTabela.Items.Clear;
  AdicionaSQLAbreTabela(Aux,'Select Tab.Nom_Tabela, Tab.Seq_Tabela '+
                      ' from grupo_tabela_exportacao Gru, Tabela_Exportacao Tab '+
                      ' Where Gru.Cod_Grupo = ' + VpaCodGrupo+
                      ' and Gru.Seq_Tabela = Tab.Seq_Tabela '+
                      ' order by Tab.Nom_Tabela');
  while not Aux.eof do
  begin
    EGrupoTabela.Items.Add(Aux.FieldByName('Nom_Tabela').Asstring);
    VprGrupoTabela.Add(Aux.FieldByName('Seq_Tabela').Asstring);
    Aux.next;
  end;
  Aux.Close;
  Cursor := crArrow;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos do cadastro
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********** retorna se ja existe a tabela no grupo de exportacao **************}
function TFGrupoTabelaExportacao.ExisteTabelaGrupoExportacao(VpaCodGrupo,VpaSeqTabela : String):Boolean;
begin
  AdicionaSQLAbreTabela(Aux,'Select * from Grupo_Tabela_Exportacao '+
                            ' Where Cod_grupo = '+ VpaCodGrupo +
                            ' and Seq_Tabela = ' + VpaSeqTabela);
  result := not aux.eof;
end;

{**************** adiciona a tabela no grupo de exportacao ********************}
procedure TFGrupoTabelaExportacao.AdicionaTabelaGrupoExportacao(VpaCodGrupo,VpaSeqTabela : String);
begin
  if not ExisteTabelaGrupoExportacao(VpaCodGrupo,VpaSeqTabela) then
  begin
    ExecutaComandoSql(Aux,'Insert into Grupo_Tabela_Exportacao '+
                          ' (Cod_Grupo,Seq_Tabela)'+
                          ' Values ('+VpaCodGrupo+ ','+VpaSeqTabela+ ')');
    PosicionaGrupoTabela(VpaCodGrupo);
  end;
end;

{**************** exclui a tabela do grupo de exportacao **********************}
procedure TFGrupoTabelaExportacao.ExcluiTabelaGrupo(VpaCodGrupo,VpaSeqTabela : String);
begin
  if Confirmacao('Tem certeza que deseja excluir a tabela do grupo de exportação???') Then
  begin
    ExecutaComandoSql(Aux,'Delete from Grupo_Tabela_Exportacao '+
                            ' Where Cod_grupo = '+ VpaCodGrupo +
                            ' and Seq_Tabela = ' + VpaSeqTabela);
    PosicionaGrupoTabela(VpaCodGrupo);
  end;

end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************** carrega as tabelas dos grupos *************************}
procedure TFGrupoTabelaExportacao.CarregaTabelas;
begin
  Cursor := crAppStart;
  VprTabelas.Clear;
  ETabelas.Items.Clear;
  AdicionaSQLAbreTabela(Aux,'Select * from Tabela_Exportacao '+
                            ' order by Nom_Tabela ');
  while not Aux.eof do
  begin
    ETabelas.Items.Add(Aux.FieldByName('Nom_Tabela').Asstring);
    VprTabelas.Add(Aux.FieldByName('Seq_Tabela').Asstring);
    Aux.next;
  end;
  Aux.close;
  Cursor := crArrow;
end;

{*************************** carrega os grupos ********************************}
procedure TFGrupoTabelaExportacao.CarregaGrupos;
var
  dados : Tdados;
begin
  Cursor := crAppStart;
  VprGrupos.clear;
  EGrupos.Items.Clear;
  AdicionaSQLAbreTabela(Aux,'Select * from Grupo_Exportacao '+
                            ' order by Nom_Grupo ');
  while not Aux.eof do
  begin
    dados := Tdados.create;
    dados.codigo := Aux.FieldByName('Cod_Grupo').AsInteger;
    dados.resetar := Aux.FieldByName('c_nao_res').AsString <> 'N';
    EGrupos.Items.AddObject(Aux.FieldByName('Nom_Grupo').Asstring,dados);
    VprGrupos.Add(Aux.FieldByName('Cod_Grupo').Asstring);
    Aux.next;
  end;
  Aux.Close;
  Cursor := crArrow;
end;

procedure TFGrupoTabelaExportacao.GrupoExportacaoAfterScroll(
  DataSet: TDataSet);
begin
end;

{******************** fecha o formulario corrente *****************************}
procedure TFGrupoTabelaExportacao.BFecharClick(Sender: TObject);
begin
  close;
end;

{************** chama a rotina que adiciona o grupo tabela ********************}
procedure TFGrupoTabelaExportacao.BAdicionarClick(Sender: TObject);
begin
  AdicionaTabelaGrupoExportacao(VprGrupos.Strings[EGrupos.itemIndex],VprTabelas.Strings[ETabelas.ItemIndex]);
end;

procedure TFGrupoTabelaExportacao.BRemoverClick(Sender: TObject);
begin
  ExcluiTabelaGrupo(VprGrupos.Strings[EGrupos.itemIndex],VprGrupoTabela.Strings[EGrupoTabela.ItemIndex]);
end;

{**************** apos reposicionar a tabela de grupos ************************}
procedure TFGrupoTabelaExportacao.ETabelasClick(Sender: TObject);
begin
  PosicionaGrupoTabela(VprGrupos.Strings[EGrupos.itemIndex]);
  CheckBox1.Checked := not tdados(EGrupos.Items.Objects[egrupos.ItemIndex]).resetar;
end;

{************ evita resetar o grupo ******************************************}
procedure TFGrupoTabelaExportacao.CheckBox1Click(Sender: TObject);
begin
  LimpaSQLTabela(aux);
  if CheckBox1.Checked then
  begin
    tdados(EGrupos.Items.Objects[egrupos.ItemIndex]).resetar := false;
    AdicionaSQLTabela(Aux, ' Update grupo_Exportacao set c_nao_res = ''N'' ' )
  end
  else
  begin
    tdados(EGrupos.Items.Objects[egrupos.ItemIndex]).resetar := true;
    AdicionaSQLTabela(Aux, ' Update grupo_Exportacao set c_nao_res = ''S'' ' );
  end;

  AdicionaSQLTabela(Aux, ' where cod_grupo = ' +
                          inttostr(tdados(EGrupos.Items.Objects[egrupos.ItemIndex]).codigo));
  aux.ExecSQL;
  aux.close;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFGrupoTabelaExportacao]);
end.
