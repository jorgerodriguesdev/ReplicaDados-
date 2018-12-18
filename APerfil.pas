unit APerfil;

{  falta adicionar  ate atualizacao 320
   MOVFORMAS, CADMARCAS, CADCOR, CADMODELO, CADTIPO
   CADORDEMSERVICO, MOVTERCEIROOS, CADEQUIPAMENTOS, MOVEQUIPAMENTOOS,
   MOVESTOUROOS, CADTIPOENTREGA, MOVCOMPOSICAOPRODUTO,
   MOVGRUPOUSUARIO, CADTURNOS, MOVORDEMPRODUCAO,
   MOVREQUISICAOMATERIAL, CADREQUISICAOMATERIAL,
   CADCONTATOS, CADCICLOPRODUTO, CADMAQUINAS, CADORDEMPRODUCAO}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ImgList, StdCtrls, CheckLst, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Buttons, Mask, DBCtrls, Tabela, Db, DBTables,
  Localizacao, UnPerfil;

Const
  CT_NOMEINVALIDO = 'NOME PERFIL INVÁLIDO!!!Nome do perfil inválido ou repedito ....';

type
  TDadosfilial = class
    CodigoEmpFil : integer;
end;

type
  TFPerfil = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    AGrupos: TListView;
    ImageList1: TImageList;
    BNovo: TBitBtn;
    Label3: TLabel;
    BAbrir: TBitBtn;
    BGravar: TBitBtn;
    BCancelar: TBitBtn;
    BFechar: TBitBtn;
    Grupos: TQuery;
    Aux: TQuery;
    EPerfil: TEditLocaliza;
    Localiza: TConsultaPadrao;
    BExcluir: TBitBtn;
    BResetar: TBitBtn;
    Verifica: TQuery;
    ListaFilial: TCheckListBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BNovoClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure BGravarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure EPerfilSelect(Sender: TObject);
    procedure EPerfilEnter(Sender: TObject);
    procedure BAbrirClick(Sender: TObject);
    procedure EPerfilRetorno(Retorno1, Retorno2: String);
    procedure BExcluirClick(Sender: TObject);
    procedure BResetarClick(Sender: TObject);
  private
    { Private declarations }
    VprAlterando,VprExcluindo : boolean;
    VprCodPerfil : String;
    procedure CarregaGrupos;
    procedure LimpaArvore;
    procedure EstadoInsercao(VpaEstado : Boolean);
    function GravaPerfil : Boolean;
    function RetornaNomePerfil : String;
    function ExisteNomePerfil(VpaNome : String) : Boolean;
    function RetornaCodigoDisponivel : Integer;
    procedure GravaPerfilItem(VpaCodPerfil : String);
    function RetornaCodGrupo(VpaNomGrupo : String) : String;
    procedure CarregaPerfil(VpaCodPerfil : string);
    procedure GravaAlteracaoPerfil;
    procedure ExcluiPerfil(VpaPerfil : String);
    procedure CarregaNomesFiliais( Codfilial : string);
    function TextoCodFiliais : string;

  public
    { Public declarations }
  end;

var
  FPerfil: TFPerfil;

implementation

uses APrincipal, FunSql, Constantes, ConstMsg, FunString;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFPerfil.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
  CarregaGrupos;
  CarregaNomesFiliais('');
  EPerfilSelect(eperfil);
  VprExcluindo := false;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da arvore
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** carrega os grupos para a arvore ***************************}
procedure TFPerfil.CarregaGrupos;
var
  No : TListItem;
  VpfTipoAtual : String;
begin
  //tem que tirar de read only senao nao permite adiconar ou remover itens na arvore
  AGrupos.ReadOnly := false;

  AGrupos.Items.Clear;
  AdicionaSQLAbreTabela(Grupos,'Select * from Grupo_exportacao '+
                               ' order by IDE_TIPO_GRUPO, nom_Grupo ');
  VpfTipoAtual := Grupos.FieldByName('Ide_Tipo_Grupo').Asstring;
  While not Grupos.Eof do
  begin
    if VpfTipoAtual <> Grupos.FieldByName('Ide_Tipo_Grupo').Asstring then
    begin
      No := AGrupos.Items.Add;
      No.ImageIndex := 0;
      No.Caption := '---------------------';
      VpfTipoAtual := Grupos.FieldByName('Ide_Tipo_Grupo').Asstring;
    end;
    No := AGrupos.Items.Add;
    No.ImageIndex := 0;
    No.Caption := Grupos.FieldByName('Nom_Grupo').Asstring;
    Grupos.Next;
  end;
  // coloca em read-only para o usuario na poder alterar o nome do grupo;
  AGrupos.ReadOnly := True;
end;

{********************* limpa a arvore dos grupos ******************************}
procedure TFPerfil.LimpaArvore;
var
  VpfLaco : Integer;
begin
  for VpfLaco := 0 to AGrupos.Items.Count -1 do
  begin
    AGrupos.Selected := AGrupos.Items[VpfLaco];
    AGrupos.Selected.Checked := False;
  end;

  for VpfLaco := 0 to ListaFilial.Items.Count -1 do
    ListaFilial.Checked[Vpflaco] := false;
end;

{************** coloca os controles em estado de insercao *********************}
procedure TFPerfil.EstadoInsercao(VpaEstado : Boolean);
begin
  BNovo.Enabled := VpaEstado;
  BAbrir.Enabled := VpaEstado;
  BFechar.Enabled := VpaEstado;
  BExcluir.Enabled := VpaEstado;
  BResetar.Enabled  := VpaEstado;
  BGravar.Enabled := not VpaEstado;
  BCancelar.Enabled := not VpaEstado;
  AGrupos.Enabled := not VpaEstado;
  ListaFilial.Enabled := not VpaEstado;
  if AGrupos.Enabled then
  begin
    AGrupos.Color := EPerfil.Color;
    ListaFilial.Color := EPerfil.Color;
  end
  else
  begin
    AGrupos.Color := clSilver;
    ListaFilial.Color := clSilver;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos do perfil
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************* grava o perfil de exportacao ***************************}
function  TFPerfil.GravaPerfil : Boolean;
var
  VpfNomePerfil : String;
  VpfCodPerfil : Integer;
begin
  VpfNomePerfil := RetornaNomePerfil;
  result := (VpfNomePerfil <>'') and (AGrupos.Selected.Caption <> '---------------------');
  if result Then
  begin
    VpfCodPerfil := RetornaCodigoDisponivel;
    ExecutaComandoSql(Aux,'Insert Into Perfil_Exportacao(Cod_Empresa,Cod_Perfil,FILIAL_EXPORTACAO,Nom_Perfil) '+
                          ' values(' + IntToStr(Varia.codigoEmpresa)+',' +
                          IntToStr(VpfCodPerfil)+ ',''' + TextoCodFiliais + ''','''+VpfNomePerfil+''')');
    GravaPerfilItem(Inttostr(VpfCodPerfil));
  end;
end;

{********************* retorna o nome do perfil *******************************}
function TFPerfil.RetornaNomePerfil : String;
var
  VpfNomeCorreto : Boolean;
begin
  repeat
    VpfNomeCorreto := true;
    if Entrada('Nome do Perfil','Nome do Perfil : ',Result,false,AGrupos.Color,Color) then
    begin
      if DeletaChars(Result,' ') = '' then
        VpfNomeCorreto := false;
      if VpfNomeCorreto then
        VpfNomeCorreto := not ExisteNomePerfil(Result);
    end
    else
     result := '';
    if not VpfNomeCorreto Then
      Aviso(CT_NOMEINVALIDO);
  until VpfNomeCorreto;
end;

{************* verifica se o nome do perfil já existe *************************}
function TFPerfil.ExisteNomePerfil(VpaNome : String) : Boolean;
begin
  AdicionaSQLAbreTabela(Aux,'Select * from Perfil_Exportacao '+
                            ' Where Cod_Empresa = ' + IntToStr(Varia.CodigoEmpresa) +
                            ' and Nom_perfil = ''' + VpaNome+'''');
  result := not Aux.Eof;
end;

{****************** retorna o codigo disponivel *******************************}
function TFPerfil.RetornaCodigoDisponivel : Integer;
begin
  AdicionaSQLAbreTabela(Aux,'Select max(Cod_Perfil) Ultimo from Perfil_Exportacao '+
                            ' Where Cod_empresa = '+ IntTostr(Varia.CodigoEmpresa));
  result := Aux.FieldByName('ultimo').AsInteger + 1;
end;

{******************** grava os itens do perfil *******************************}
procedure TFPerfil.GravaPerfilItem(VpaCodPerfil : String);
var
  VpfLaco : Integer;
begin
  for VpfLaco := 0 to AGrupos.Items.Count -1 do
  begin
    AGrupos.Selected := AGrupos.Items[VpfLaco];
    if AGrupos.Selected.Checked Then
      ExecutaComandoSql(Aux,'Insert Into Perfil_Item_Exportacao(Cod_Empresa,Cod_Perfil,Cod_Grupo) '+
                         ' Values ( '+ IntToStr(Varia.CodigoEmpresa) + ','+
                          VpaCodPerfil+ ','+ RetornaCodGrupo(AGrupos.Selected.Caption)+ ')');
  end;

end;

{*********************** retorna o codigo do grupo ****************************}
function TFPerfil.RetornaCodGrupo(VpaNomGrupo : String) : String;
begin
  AdicionaSQLAbreTabela(Aux,'Select Cod_Grupo from Grupo_Exportacao '+
                            ' Where Nom_Grupo = ''' + VpaNomGrupo+'''');
  result := aux.FieldByName('Cod_Grupo').Asstring
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            eventos da alteraca do perfil
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************ carrega o perfil ************************************}
procedure TFPerfil.CarregaPerfil(VpaCodPerfil : string);
var
  VpfLaco : Integer;
begin
  AdicionaSQLAbreTabela(Grupos,'Select Nom_Grupo, PEX.Filial_Exportacao from Perfil_exportacao PEX, Perfil_Item_Exportacao Per, Grupo_Exportacao Gru' +
                              ' Where Per.Cod_Perfil = '+ VpaCodPerfil +
                              ' and Per.Cod_Empresa = '+ IntToStr(Varia.Codigoempresa) +
                              ' and PEX.Cod_empresa = Per.Cod_Empresa ' +
                              ' and PEX.Cod_Perfil = Per.Cod_Perfil ' +
                              ' and PEX.Cod_Empresa = ' + IntToStr(Varia.Codigoempresa) +
                              ' and Per.Cod_Grupo = Gru.Cod_Grupo '+
                              ' order by Nom_Grupo');
  While not Grupos.Eof do
  begin
    for VpfLaco := 0 to AGrupos.Items.Count -1 do
    begin
      AGrupos.Selected := AGrupos.Items[VpfLaco];
      if Grupos.FieldByName('Nom_Grupo').Asstring = AGrupos.Selected.Caption then
      begin
        AGrupos.Selected.Checked := true;
        break;
      end;
    end;
    Grupos.Next;
  end;
  CarregaNomesFiliais(Grupos.FieldByName('Filial_exportacao').Asstring)
end;

{******************* grava a alteracao do perfil ******************************}
procedure TFPerfil.GravaAlteracaoPerfil;
begin
  ExecutaComandoSql(Aux,' update Perfil_Exportacao '+
                        ' set filial_exportacao = ''' + TextoCodFiliais + '''' +
                        ' Where Cod_Empresa = '+ IntToStr(Varia.codigoEmpresa)+
                        ' and Cod_Perfil = '+ VprCodPerfil);

  ExecutaComandoSql(Aux,' delete from Perfil_ITem_Exportacao '+
                        ' Where Cod_Empresa = '+ IntToStr(Varia.codigoEmpresa)+
                        ' and Cod_Perfil = '+ VprCodPerfil);
  GravaPerfilItem(VprCodPerfil);
end;

{******************* exclui o perfil escolhido ********************************}
procedure TFPerfil.ExcluiPerfil(VpaPerfil : String);
begin
  ExecutaComandoSql(Aux,'Delete from Perfil_Item_exportacao '+
                        ' Where Cod_Empresa = '  + IntToStr(Varia.CodigoEmpresa)+
                        ' and Cod_Perfil = '+ VpaPerfil+
                        '; Delete from Perfil_Exportacao '+
                        ' Where Cod_Empresa = '  + IntToStr(Varia.CodigoEmpresa)+
                        ' and Cod_Perfil = '+ VpaPerfil);
end;

{**************** retorno do perfil escolhido ********************************}
procedure TFPerfil.EPerfilRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> ''then
  begin
    if VprExcluindo then
    begin
      ExcluiPerfil(Retorno1);
    end
    else
    begin
      VprAlterando := true;
      EstadoInsercao(False);
      CarregaPerfil(Retorno1);
      VprCodPerfil := Retorno1;
      Caption := 'Perfil de Exportação  - ' + Retorno2;
    end;
  end;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************ gera um novo perfil *********************************}
procedure TFPerfil.BNovoClick(Sender: TObject);
begin
  VprAlterando := false;
  LimpaArvore;
  EstadoInsercao(False);
end;

{************************ fecha o formulario **********************************}
procedure TFPerfil.BFecharClick(Sender: TObject);
begin
  close;
end;

{*********************** grava o perfil ***************************************}
procedure TFPerfil.BGravarClick(Sender: TObject);
begin
  if TextoCodFiliais <> '' then
  begin
    if not VprAlterando then
    begin
      if  GravaPerfil  then
      begin
        LimpaArvore;
        EstadoInsercao(true);
      end;
    end
    else
    begin
      GravaAlteracaoPerfil;
      LimpaArvore;
      EstadoInsercao(true);
    end;
  end
  else
    aviso('Voce deve definir as filiais de esportação!');  
end;

{********************** cancela a alteracao ***********************************}
procedure TFPerfil.BCancelarClick(Sender: TObject);
begin
  LimpaArvore;
  EstadoInsercao(true);
end;

{******************** carrega a select do perfil ******************************}
procedure TFPerfil.EPerfilSelect(Sender: TObject);
begin
  EPerfil.ASelectValida.Text := 'Select * from Perfil_Exportacao '+
                                ' Where Cod_Empresa = ' +IntToStr(Varia.CodigoEmpresa) +
                                ' and cod_perfil not in(999999,888888) ' +
                                ' and Cod_Perfil = @';
  EPerfil.ASelectLocaliza.Text := 'Select * from Perfil_Exportacao '+
                                ' Where Cod_Empresa = '+ IntToStr(Varia.CodigoEmpresa) +
                                ' and cod_perfil not in(999999,888888) ' +
                                ' and Nom_Perfil like ''@%''';
end;

procedure TFPerfil.EPerfilEnter(Sender: TObject);
begin
  ActiveControl := BFechar;
end;

{********************** abre a localizacao do perfil **************************}
procedure TFPerfil.BAbrirClick(Sender: TObject);
begin
  VprExcluindo := false;
  EPerfil.clear;
  EPerfil.AInfo.TituloForm := '  Localizando Perfil   ';
  EPerfil.AAbreLocalizacao;
end;

{********************* excluio o perfil Selecionado ***************************}
procedure TFPerfil.BExcluirClick(Sender: TObject);
begin
  VprExcluindo := True;
  EPerfil.clear;
  EPerfil.AInfo.TituloForm := '  Excluir Perfil   ';
  EPerfil.AAbreLocalizacao;
  VprExcluindo := false;
end;

procedure TFPerfil.BResetarClick(Sender: TObject);
var
  UnPerfilAtu : TFuncoesPerfil;
begin
  UnPerfilAtu := TFuncoesPerfil.criar(self, FPrincipal.BaseDados);
  UnPerfilAtu.AtualizaGruposPerfil;
  UnPerfilAtu.free;
  CarregaGrupos;
end;

{******************** carrega o nome das filiais ******************************}
procedure TFPerfil.CarregaNomesFiliais( Codfilial : string);
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

{************ gera o  texto das filiais *************************************}
function TFPerfil.TextoCodFiliais : string;
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


Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFPerfil]);
end.
