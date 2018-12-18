unit AExportacaoFisco;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, StdCtrls, Mask, DBCtrls, Tabela, Buttons, ComCtrls,
  Componentes1, ImportaDado, Grids, DBGrids, ExtCtrls, PainelGradiente, formularios,
  QuickRpt, Qrctrls, ShellAPI, Localizacao, CheckLst;

type
  TFExportacaoFisco = class(TFormularioPermissao)
    Salvar: TSaveDialog;
    CadFilial: TQuery;
    DataCadFiliais: TDataSource;
    f10_02: TImportaDadoString;
    f10_03: TImportaDadoString;
    f10_04: TImportaDadoString;
    f10_05: TImportaDadoString;
    f10_06: TImportaDadoString;
    f10_07: TImportaDadoString;
    Notas: TQuery;
    MovNotas: TQuery;
    f50_04: TImportaDadoData;
    f54_08: TImportaDadoTexto;
    f54_10: TImportaDadoNumerico;
    f54_15: TImportaDadoNumerico;
    f54_16: TImportaDadoNumerico;
    ms15: TImportaDadoNumerico;
    f54_11: TImportaDadoNumerico;
    f50_14: TImportaDadoNumerico;
    f50_12: TImportaDadoNumerico;
    f50_10: TImportaDadoString;
    f50_09: TImportaDadoNumerico;
    f50_13: TImportaDadoNumerico;
    f50_16: TImportaDadoNumerico;
    ss4: TImportaDadoString;
    ms10: TImportaDadoString;
    NotasI_COD_CLI: TIntegerField;
    NotasC_TIP_NOT: TStringField;
    NotasD_DAT_EMI: TDateField;
    NotasC_END_DES: TStringField;
    NotasN_BAS_CAL: TFloatField;
    NotasN_VLR_ICM: TFloatField;
    NotasN_BAS_SUB: TFloatField;
    NotasN_VLR_SUB: TFloatField;
    NotasN_TOT_PRO: TFloatField;
    NotasN_VLR_FRE: TFloatField;
    NotasN_VLR_SEG: TFloatField;
    NotasN_OUT_DES: TFloatField;
    NotasN_TOT_IPI: TFloatField;
    NotasN_TOT_NOT: TFloatField;
    NotasI_NRO_NOT: TIntegerField;
    NotasC_NOT_IMP: TStringField;
    NotasC_NOT_CAN: TStringField;
    CadFilialI_EMP_FIL: TIntegerField;
    CadFilialI_COD_EMP: TIntegerField;
    CadFilialI_COD_FIL: TIntegerField;
    CadFilialC_NOM_FIL: TStringField;
    CadFilialC_END_FIL: TStringField;
    CadFilialI_NUM_FIL: TIntegerField;
    CadFilialC_BAI_FIL: TStringField;
    CadFilialC_CID_FIL: TStringField;
    CadFilialC_EST_FIL: TStringField;
    CadFilialI_CEP_FIL: TIntegerField;
    CadFilialC_CGC_FIL: TStringField;
    CadFilialC_INS_FIL: TStringField;
    CadFilialC_GER_FIL: TStringField;
    CadFilialC_DIR_FIL: TStringField;
    CadFilialC_FON_FIL: TStringField;
    CadFilialC_FAX_FIL: TStringField;
    CadFilialC_OBS_FIL: TStringField;
    CadFilialD_DAT_MOV: TDateField;
    CadFilialC_WWW_FIL: TStringField;
    CadFilialC_END_ELE: TStringField;
    CadFilialD_DAT_INI_ATI: TDateField;
    CadFilialD_DAT_FIM_ATI: TDateField;
    CadFilialC_NOM_FAN: TStringField;
    CadFilialC_PIC_CLA: TStringField;
    CadFilialC_PIC_PRO: TStringField;
    f54_09: TImportaDadoString;
    s17: TImportaDadoNumerico;
    f11_02: TImportaDadoString;
    f11_03: TImportaDadoNumerico;
    f11_05: TImportaDadoString;
    f11_06: TImportaDadoNumerico;
    f11_07: TImportaDadoString;
    f11_08: TImportaDadoString;
    t1: TImportaDadoTexto;
    t2: TImportaDadoTexto;
    t3: TImportaDadoTexto;
    f50_02: TImportaDadoString;
    NotasC_CGC_CLI: TStringField;
    NotasC_INS_CLI: TStringField;
    f50_03: TImportaDadoString;
    f50_05: TImportaDadoString;
    NotasC_EST_CLI: TStringField;
    NotasI_EMP_FIL: TIntegerField;
    NotasI_SEQ_NOT: TIntegerField;
    t4: TImportaDadoTexto;
    ms5: TImportaDadoString;
    Aux: TQuery;
    Rel: TQuickRep;
    DetailBand1: TQRBand;
    QRMemo1: TQRMemo;
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    padrao: TComboBoxColor;
    ComboEstados: TComboBoxColor;
    Data2: TCalendario;
    Data1: TCalendario;
    Finalidade: TComboBoxColor;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PanelColor2: TPanelColor;
    texto: TRichEdit;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Lista: TMemoColor;
    BExportar: TBitBtn;
    Label4: TLabel;
    ms11: TImportaDadoString;
    Label12: TLabel;
    f11_04: TImportaDadoTexto;
    f50_11: TImportaDadoNumerico;
    NotasC_COD_NAT: TStringField;
    PanelColor3: TPanelColor;
    Label11: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BValidar: TBitBtn;
    BImprimir: TBitBtn;
    Label13: TLabel;
    F54_02: TImportaDadoString;
    MovNotasC_CGC_Cli: TStringField;
    MovNotasI_Nro_Not: TIntegerField;
    MovNotasC_Cod_Nat: TStringField;
    MovNotasC_Cod_Pro: TStringField;
    MovNotasN_Qtd_Pro: TFloatField;
    MovNotasN_Tot_Pro: TFloatField;
    MovNotasN_Des_Acr: TFloatField;
    MovNotasN_Vlr_Ipi: TFloatField;
    MovNotasN_Per_Icm: TFloatField;
    F54_06: TImportaDadoNumerico;
    F54_07: TImportaDadoString;
    MovNotasC_COD_UNI: TStringField;
    MovNotasC_Nom_Pro: TStringField;
    F75_04: TImportaDadoString;
    F75_06: TImportaDadoString;
    F75_07: TImportaDadoString;
    F75_11: TImportaDadoNumerico;
    MovNotasN_Red_Icm: TFloatField;
    EListaFilial: TComboBoxColor;
    Eserie: TEditColor;
    Label14: TLabel;
    f50_02_1: TImportaDadoString;
    NotasC_TIP_PES: TStringField;
    NotasC_CPF_CLI: TStringField;
    MovNotasc_tip_pes: TStringField;
    MovNotasc_cpf_cli: TStringField;
    F54_02_1: TImportaDadoString;
    Barra: TProgressBar;
    Arquivo: TLabel;
    BitBtn3: TBitBtn;
    BSalvar: TBitBtn;
    procedure a2Valida(var Conteudo: String);
    procedure A3Valida(var Conteudo: String);
    procedure FormCreate(Sender: TObject);
    procedure f10_02Valida(var Conteudo: String);
    procedure f10_03Valida(var Conteudo: String);
    procedure f10_07Valida(var Conteudo: String);
    procedure BExportarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure f11_08Valida(var Conteudo: String);
    procedure f50_02Valida(var Conteudo: String);
    procedure f10_04Valida(var Conteudo: String);
    procedure Data1CloseUp(Sender: TObject);
    procedure ComboEstadosChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TipoEmpFilClick(Sender: TObject);
    procedure EListaFilialExit(Sender: TObject);
    procedure textoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BValidarClick(Sender: TObject);
    procedure EListaFilialChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BSalvarClick(Sender: TObject);
  private
    contaItem, conta54, conta50, conta75 : integer;
    Drives : TStringList;
    NomeDiretorio, NomePasta, NomeArquivo : string;

    procedure CarregaFiliais;
    function LimpaCaracter( frase : string ) : string;
    function LimpaFone( frase : string ) : string;
    function RetornaNomeArquivoEstado(VpaNomArquivo : String) : String;
    procedure PosicionaRegistro50(VpaTabela : TQuery);
    procedure PosicionaRegistro54(VpaTabela : TQuery);
    procedure PosicionaRegistro75(VpaTabela : TQuery);
    procedure ExportaFilial;
    procedure ExportaComplementoFilial;
    function ExportaRegistro50 : Integer;
    function ExportaRegistro54 : Integer;
    function ExportaRegistro75 : Integer;
    function RetornaCodigoFilial : integer;
    procedure InicializaFilial( CodigoEmpFil : Integer);
    procedure VerificaEstados;
    procedure Documento;
    procedure CarregaDrives;
    function ValidaNota : boolean;
    procedure LocalizaCadNotas;
    procedure barra10_11_90(Texto : string);
    procedure GeraArquivos;
  public
    { Public declarations }
  end;

  type
    TDadosfilial = class
      CodigoEmpFil : integer;
    end;

var
  FExportacaoFisco: TFExportacaoFisco;

implementation

  uses FunData, funstring, funObjeto, constMsg, APrincipal, constantes, funsql,
  AValidaNotaExportacao, FunHardware, AConvenio, funarquivos, ASalvaArquivo;

{$R *.DFM}
{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          formulario
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ***************************** na criacao do formulario *********************}
procedure TFExportacaoFisco.FormCreate(Sender: TObject);
begin
  // inicializa as cores dos campos não EditColor's
   EListaFilial.Color := padrao.color;
   texto.Color := padrao.color;
   Lista.Color := padrao.Color;

   Data1.Date := DecMes(date,3);
   data2.Date := date;
   finalidade.ItemIndex := 0;
   padrao.ItemIndex := 0;
   Drives := TStringList.create;
   Eserie.Text := Varia.SerieNota;
   CarregaFiliais;
end;

{****************** na destruicao do formulario *******************************}
procedure TFExportacaoFisco.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Drives.free;
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                       Carrega Tabelas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************** carrega as filiais do sistema **************************}
procedure  TFExportacaoFisco.CarregaFiliais;
var
  Dados : TDadosfilial;
  item, ItemFilial : integer;
begin
  CadFilial.open;
  while not CadFilial.Eof do
  begin
    Dados := TDadosfilial.Create;
    dados.CodigoEmpFil := CadFilialI_EMP_FIL.AsInteger;
    item := EListaFilial.Items.AddObject(CadFilialI_EMP_FIL.AsString + '  -  '+ CadFilialC_NOM_FAN.AsString,dados);
    if varia.CodigoEmpFil = CadFilialI_EMP_FIL.AsInteger then
      ItemFilial := Item;
    CadFilial.Next;
  end;
  EListaFilial.ItemIndex := ItemFilial;
  InicializaFilial(RetornaCodigoFilial);
  VerificaEstados;
end;


{**************** no exit fa lista de filiais ******************************** }
procedure TFExportacaoFisco.EListaFilialExit(Sender: TObject);
begin
  VerificaEstados
end;

{********************* inicializa nota fiscal *********************************}
function TFExportacaoFisco.RetornaCodigoFilial : integer;
begin
  result := TDadosfilial(EListaFilial.Items.Objects[EListaFilial.ItemIndex]).CodigoEmpFil;
end;

{********************* inicializa nota fiscal *********************************}
procedure TFExportacaoFisco.InicializaFilial( CodigoEmpFil : Integer);
begin
  AdicionaSQLAbreTabela( CadFilial,
                       ' select * from "DBA".CADFILIAIS ' +
                       ' where ' +
                       ' I_EMP_FIL = ' + IntToStr(CodigoEmpFil) );
end;

{****************** carrega os estados que possue movimentacao *************** }
procedure TFExportacaoFisco.VerificaEstados;
begin
  AdicionaSQLAbreTabela( aux,
                       ' select CLI.C_EST_CLI from "DBA".CADNOTAFISCAIS as NF, cadClientes as CLI ' +
                       ' where ' +
                       ' NF.I_EMP_FIL = ' + Inttostr(RetornaCodigoFilial) +
                       ' and NF.D_DAT_EMI between ''' + DataToStrFormato(AAAAMMDD,Data1.Date,'/') + '''' +
                       ' and ''' + DataToStrFormato(AAAAMMDD,Data2.Date,'/') + '''' +
                       ' and NF.I_COD_CLI = CLI.I_COD_CLI ' +
                       ' and NF.C_SER_NOT = ''' + Eserie.Text + '''' +
                       ' and isnull(NF.C_FLA_ECF, ''N'') = ''N'' '+
                       ' and NF.I_NRO_NOT is not null ' +
                       ' group by  CLI.c_est_cli ');
  aux.open;
  ComboEstados.Items .Clear;
  while not aux.Eof do
  begin
    ComboEstados.Items.Add(aux.fieldByName('c_est_cli').AsString);
    aux.Next;
  end;
  aux.close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                       funcoes de limpesa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************* limpa caracteres *************************************}
function TFExportacaoFisco.LimpaCaracter( frase : string ) : string;
begin
  result := DeletaChars(frase,'.');
  result := DeletaChars(result,'/');
  result := DeletaChars(result,'-');
  result := DeletaChars(result,'\');
end;

{********************* limpa telefone *************************************}
function TFExportacaoFisco.LimpaFone( frase : string ) : string;
begin
  result := DeletaChars(frase,'-');
  result := DeletaChars(result,')');
  result := DeletaChars(result,'(');
  result := DeletaChars(result,' ');
  result := DeletaChars(result,'*');
end;


{************** retorna o nome do arquivo conforme o estado *******************}
function TFExportacaoFisco.RetornaNomeArquivoEstado(VpaNomArquivo : String) : String;
var
  VpfLaco : Integer;
begin
  Result := VpaNomArquivo;
  for VpfLaco := 1 to Length(result) do
  begin
    if Result[VpfLaco] = '.' then
    begin
      result := copy(result,1,VpfLaco-1);
      break;
    end;
  end;

  result := result + '.' + ComboEstados.Text;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                             valida textos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*********************** limpa o cgc fornecedor  ******************************}
procedure TFExportacaoFisco.a2Valida(var Conteudo: String);
begin
if conteudo <> '' then
  conteudo := LimpaCaracter(conteudo);
end;


{******************* limpa inscricao fornecedor *******************************}
procedure TFExportacaoFisco.A3Valida(var Conteudo: String);
begin
  conteudo := LimpaCaracter(conteudo);
end;

{*********************** limpa o cgc  filial **********************************}
procedure TFExportacaoFisco.f10_02Valida(var Conteudo: String);
begin
  if conteudo <> '' then
    conteudo := LimpaCaracter(conteudo);
end;

{*************** limpa a inscricao estadual do estabelecimento ****************}
procedure TFExportacaoFisco.f10_03Valida(var Conteudo: String);
begin
  if conteudo <> '' then
    conteudo := LimpaCaracter(conteudo);
end;

{****************** limpa o nome do contribuinte ******************************}
procedure TFExportacaoFisco.f10_04Valida(var Conteudo: String);
begin
if conteudo <> '' then
  conteudo := RetiraAcentuacao(conteudo);
end;

{**************** limpa o fax do estabelecimento ******************************}
procedure TFExportacaoFisco.f10_07Valida(var Conteudo: String);
begin
  if conteudo <> '' then
    conteudo := LimpaFone(conteudo);
end;

{*************** limpa o telefone do estabelecimento **************************}
procedure TFExportacaoFisco.f11_08Valida(var Conteudo: String);
begin
if conteudo <> '' then
  conteudo := LimpaFone(conteudo);
end;

{************************ limpa o cgc do cliente ******************************}
procedure TFExportacaoFisco.f50_02Valida(var Conteudo: String);
begin
if conteudo <> '' then
  conteudo := LimpaCaracter(conteudo);
end;

procedure TFExportacaoFisco.barra10_11_90(Texto : string);
var
  laco : integer;
begin
  Arquivo.Caption := Texto;
  Arquivo.Refresh;
  barra.Max := 6000;
  barra.Position := 0;
  for laco := 1 to 6000 do
    barra.Position := barra.Position + 1;
  barra.Position := 0;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                       cria arquivo
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** registro do tipo 10 - empresa *****************************}
procedure TFExportacaoFisco.ExportaFilial;
begin
  Texto.Lines.Add('10' + f10_02.texto + f10_03.texto + f10_04.texto +
                  f10_05.texto + f10_06.texto + f10_07.texto +
                  DataToStrFormato(AAAAMMDD,data1.date,#0)+
                  DataToStrFormato(AAAAMMDD,data2.date,#0) +
                  '1' + IntToStr(padrao.ItemIndex + 1) +
                  IntToStr(finalidade.ItemIndex + 1)  );
  barra10_11_90('Exportação do registro 10');
  Label1.Caption := IntTostr(texto.Lines.Count);
end;


{****************** registro do tipo 11 - empresa *****************************}
procedure TFExportacaoFisco.ExportaComplementoFilial;
var
  numero : string;
begin
  if CadFilialI_NUM_FIL.AsInteger <> 0 then  // caso o numero naum seja vazio
    numero :=  f11_04.texto('')
  else
    numero :=  f11_04.texto('s/n');

  Texto.Lines.Add('11' + f11_02.texto + f11_03.texto + numero +
                  f11_05.texto + f11_06.texto + f11_07.texto + f11_08.texto);
  barra10_11_90('Exportação do registro 11');
  Label1.Caption := IntTostr(texto.Lines.Count);
end;

{************** posiciona a tabela do registro 50 *****************************}
procedure TFExportacaoFisco.PosicionaRegistro50(VpaTabela : TQuery);
begin
  AdicionaSQLAbreTabela(VpaTabela,' Select * from  cadNotaFiscais as NF, CadClientes as cli ' +
               ' Where ' +
               SQLTextoDataEntreAAAAMMDD('NF.D_DAT_EMI',data1.date,data2.date,false) +
               ' and NF.I_COD_CLI = CLI.I_COD_CLI ' +
               ' and CLI.C_EST_CLI = ''' + ComboEstados.text + '''' +
               ' and NF.I_EMP_FIL = ' + Inttostr(RetornaCodigoFilial) +
               ' and isnull(C_FLA_ECF, ''N'') = ''N'' '+
               ' and NF.C_SER_NOT = ''' + Eserie.Text + '''' +
               ' and NF.I_NRO_NOT is not null ' +
               ' order by NF.D_Dat_Emi' );
end;

{***************** posiciona o registro do tipo 54 ****************************}
procedure TFExportacaoFisco.PosicionaRegistro54(VpaTabela : TQuery);
begin
  AdicionaSQLAbreTabela(VpaTabela,' Select Cli.C_CGC_Cli, NF.I_Nro_Not, NF.C_Cod_Nat, '+
               ' Mov.C_Cod_Pro, Mov.N_Qtd_Pro, Mov.N_Tot_Pro, NF.N_Des_Acr, Mov.N_Vlr_Ipi, '+
               ' Mov.N_Per_Icm, MOV.C_COD_UNI, Pro.C_Nom_Pro, Pro.N_Red_ICM, CLI.c_tip_pes, cli.c_cpf_cli '+
               ' from  cadNotaFiscais  NF, CadClientes cli, MovNotasFiscais Mov, '+
               ' CadProdutos Pro ' +
               ' Where ' +
               SQLTextoDataEntreAAAAMMDD('NF.D_DAT_EMI',data1.date,data2.date,false) +
               ' and CLI.C_EST_CLI = ''' + ComboEstados.text + '''' +
               ' and NF.I_EMP_FIL = ' + Inttostr(RetornaCodigoFilial) +
               ' and NF.I_Emp_Fil = Mov.I_Emp_Fil '+
               ' and NF.I_Seq_Not = Mov.I_Seq_Not '+
               ' and NF.I_COD_CLI = CLI.I_COD_CLI ' +
               ' and isnull(C_FLA_ECF, ''N'') = ''N'' ' +
               ' and NF.C_SER_NOT = ''' + Eserie.Text + '''' +
               ' and NF.I_NRO_NOT is not null ' +
               ' and pro.I_Seq_pro =  Mov.I_Seq_Pro '+
               ' order by Cli.C_Cgc_Cli, NF.I_Nro_Not');
end;

{*************** poisiciona o registro 75 para exportar ***********************}
procedure TFExportacaoFisco.PosicionaRegistro75(VpaTabela : TQuery);
begin
  AdicionaSQLAbreTabela(VpaTabela,' Select Cli.C_CGC_Cli, NF.I_Nro_Not, NF.C_Cod_Nat,'+
               ' Mov.C_Cod_Pro, Mov.N_Qtd_Pro, Mov.N_Tot_Pro, NF.N_Des_Acr, Mov.N_Vlr_Ipi, '+
               ' Mov.N_Per_Icm, MOV.C_COD_UNI, Pro.C_Nom_Pro, Pro.N_REd_Icm, CLI.c_tip_pes, cli.c_cpf_cli '+
               ' from  CadNotaFiscais  NF, CadClientes cli, MovNotasFiscais Mov, '+
               ' CadProdutos Pro ' +
               ' Where ' +
               SQLTextoDataEntreAAAAMMDD('NF.D_DAT_EMI',data1.date,data2.date,false) +
               ' and CLI.C_EST_CLI = ''' + ComboEstados.text + '''' +
               ' and NF.I_EMP_FIL = ' + Inttostr(RetornaCodigoFilial) +
               ' and NF.I_Emp_Fil = Mov.I_Emp_Fil '+
               ' and NF.I_Seq_Not = Mov.I_Seq_Not '+
               ' and NF.I_COD_CLI = CLI.I_COD_CLI ' +
               ' and isnull(C_FLA_ECF, ''N'') = ''N'' ' +
               ' and NF.C_SER_NOT = ''' + Eserie.Text + '''' +
               ' and NF.I_NRO_NOT is not null ' +
               ' and pro.I_Seq_pro =  Mov.I_Seq_Pro '+
               ' order by Mov.C_Cod_Pro');
end;

{************** exporta o registro do tipo 50-notas fiscais *******************}
function TFExportacaoFisco.ExportaRegistro50 : Integer;
var
  VpfRegistro, VpfCGC, VpfInsEst,VpfICMS,VpfUF : String;
begin
  result := 0;
  barra.Position := 0;
  Arquivo.Caption := 'Exportação dos registros 50';
  Arquivo.Refresh;
  PosicionaRegistro50(Notas);
  Barra.Max := ContaRegistro(Notas);

  while not Notas.Eof do
  begin
  // registro 50
    if NotasC_TIP_PES.AsString = 'J' then
    begin
      Vpfcgc := f50_02.texto;
      VpfInsEst := f50_03.texto;
    end
    else
    begin
      Vpfcgc := f50_02_1.texto;
      VpfInsEst := 'ISENTO        ';
    end;

    VpfUF := f50_05.texto;
    VpfICMS :=  f50_16.texto;

    VpfRegistro := '50' + Vpfcgc + VpfInsEst + f50_04.texto + VpfUF +
         '01' + '1  ' + '  ' + f50_09.texto + f50_10.texto + f50_11.texto +
         f50_12.texto +  f50_13.texto + '0000000000000' + '0000000000000' + VpfICMS;

    if NotasC_NOT_CAN.AsString = 'N' then   // para notas canceladas..
      VpfRegistro := VpfRegistro + 'N'
    else
      VpfRegistro := VpfRegistro + 'S';
    Texto.Lines.Add(VpfRegistro);
    inc(result);

    Notas.Next;
    Barra.Position := Barra.Position + 1;
  end;
end;

{****************** exporta o registro do tipo  54 ****************************}
function TFExportacaoFisco.ExportaRegistro54 : Integer;
var
  Vpfcgc : String;
  VpfConta,VpfNotaAnterior : Integer;
begin
  result := 0;
  VpfConta := 1;
  barra.Position := 0;
  Arquivo.Caption := 'Exportação dos registros 54';
  Arquivo.Refresh;

  PosicionaRegistro54(MovNotas);
  Barra.Max := ContaRegistro(MovNotas);

  VpfNotaAnterior := MovNotasI_Nro_Not.AsInteger;

    // registro 54
  While Not MovNotas.Eof do
  begin
    if VpfNotaAnterior <> MovNotasI_Nro_Not.AsInteger then
    begin
      VpfConta := 1;
      VpfNotaAnterior := MovNotasI_Nro_Not.AsInteger;
    end;

    if MovNotasC_TIP_PES.AsString = 'J' then
      Vpfcgc := F54_02.texto
    else
      Vpfcgc := f54_02_1.texto;

    Texto.Lines.Add('54' + Vpfcgc + '01' + '1  ' + '  ' +
                    f54_06.texto + f54_07.texto +  f54_08.texto(IntToStr(VpfConta)) +
                    f54_09.texto + f54_10.texto + f54_11.texto + '000000000000' +
                    '000000000000' + '000000000000' + f54_15.texto + f54_16.texto);
    inc(result);

    inc(VpfConta);
    MovNotas.Next;
    Barra.Position := Barra.Position + 1;
  end;
end;

{******************* exporta o registro de nro 75 *****************************}
function TFExportacaoFisco.ExportaRegistro75 : Integer;
var
  VpfProdutoAnterior, VpfUnidadeAnterior, VpfEspacos : String;
begin
  barra.Position := 0;
  Arquivo.Caption := 'Exportação dos registros 75';
  Arquivo.Refresh;

  PosicionaRegistro75(MovNotas);
  Barra.Max := ContaRegistro(MovNotas);

  result := 0;
  VpfEspacos := '';
  VpfProdutoAnterior := '';
  VpfUnidadeAnterior := '';
  MovNotas.First;
  while not MovNotas.Eof do
  begin
    if (VpfProdutoAnterior <> MovNotasC_Cod_Pro.AsString) or (VpfUnidadeAnterior <> MovNotasC_COD_UNI.AsString) then
    begin
      Texto.Lines.Add('75' + DeletaChars(DataToStrFormato(AAAAMMDD,DecMes(date,2),'/'),'/') +
                    DeletaChars(DataToStrFormato(AAAAMMDD,IncMes(date,2),'/'),'/') +
                    F75_04.Texto +  AdicionaCharD(' ',VpfEspacos,8) + F75_06.texto+
                    F75_07.texto + '000'+'0000'+f54_16.texto+F75_11.texto +'000000000000');
      inc(result);
      VpfProdutoAnterior := MovNotasC_Cod_Pro.AsString;
      VpfUnidadeAnterior := MovNotasC_COD_UNI.AsString;
    end;

    MovNotas.next;
    Barra.Position := Barra.Position + 1;
  end;
end;


procedure  TFExportacaoFisco.LocalizaCadNotas;
begin
     AdicionaSQLAbreTabela( Notas, ' Select * from  cadNotaFiscais as NF, CadClientes as cli ' +
                   ' Where ' +
                   SQLTextoDataEntreAAAAMMDD('NF.D_DAT_EMI',data1.date,data2.date,false) +
                   ' and NF.I_COD_CLI = CLI.I_COD_CLI ' +
                   ' and CLI.C_EST_CLI = ''' + ComboEstados.text + '''' +
                   ' and NF.I_EMP_FIL = ' + Inttostr(RetornaCodigoFilial) +
                   ' and NF.C_SER_NOT = ''' + Eserie.Text + '''' +
                   ' and NF.I_NRO_NOT is not null ' +
                   ' and isnull(C_FLA_ECF, ''N'') = ''N'' ' );
end;

{********************** Arquivo do tipo 50,54 - saida *************************}
procedure TFExportacaoFisco.BExportarClick(Sender: TObject);
var
  VpfNomArquivo : string;
begin
  GeraArquivos;
  if Eserie.Text <> '' then
  begin
    texto.Lines.Clear;
    Salvar.FileName := 'Sintegra';
    VpfNomArquivo := NomeDiretorio + '\' + RetornaNomeArquivoEstado(NomeArquivo);
    Label3.Caption := VpfNomArquivo;
    Label3.Refresh;
    // registro 10
    ExportaFilial;
    //registro 11
    ExportaComplementoFilial;
    //registro 50
    conta50 := ExportaRegistro50;
    //registro 54
    conta54 := ExportaRegistro54;
    conta75 := ExportaRegistro75;

    Texto.Lines.Add('90' + f10_02.texto + f10_03.texto +
                    '50' +  t1.texto(intToStr(conta50)) +
                    '54' +  t2.texto(intToStr(conta54)) +
                    '75' +  t3.texto(intToStr(conta75)) +
                    '99' +  t4.texto(intToStr(texto.Lines.Count + 1)) +
                    '                                                       ' +
                    '1' );
    barra10_11_90('Exportação do registro 90');
    texto.Lines.SaveToFile(VpfNomArquivo);
    Documento;
    Arquivo.Caption := 'Exportação concluida !!!';
    barra.Position := 0;
    Label1.Caption := IntTostr(texto.Lines.Count);
    BSalvar.Enabled := true;
  end
  else
    aviso('Série invalida ');
end;







procedure TFExportacaoFisco.Data1CloseUp(Sender: TObject);
begin
  VerificaEstados;
end;

procedure TFExportacaoFisco.ComboEstadosChange(Sender: TObject);
begin
if comboestados.Text <> '' then
  BExportar.Enabled := true
else
    BExportar.Enabled := false;
end;


procedure TFExportacaoFisco.BitBtn1Click(Sender: TObject);
begin
  self.close;
end;

procedure TFExportacaoFisco.Documento;
var
  laco : integer;
  mem : TMemoryStatus;
begin
Lista.Clear;
globalMemoryStatus(mem);
Lista.Lines.Add('CGC do Estabelecimento Informante : ' + CadFilial.fieldByname('C_CGC_FIL').AsString);
Lista.Lines.Add('Inscrição Estadual do Informante : ' + CadFilial.fieldByname('C_INS_FIL').AsString);
Lista.Lines.Add(' Razão Social do Estabelecimento : ' + CadFilial.fieldByname('C_NOM_FIL').AsString);
Lista.Lines.Add('Endereço : ' + CadFilial.fieldByname('C_END_FIL').AsString + ', ' +
                                CadFilial.fieldByname('I_NUM_FIL').AsString);
Lista.Lines.Add('CEP : ' + CadFilial.fieldByname('I_CEP_FIL').AsString + '     ' +
                'Cidade : ' + CadFilial.fieldByname('C_CID_FIL').AsString);
Lista.Lines.Add(' ');
Lista.Lines.Add('Equipamento : ' + retornaCPU );
Lista.Lines.Add('Memória RAM : ' + floatToStr(mem.dwTotalPhys) + ' Bytes ');
CarregaDrives;
for laco := 0 to drives.Count - 1 do
  Lista.Lines.Add( drives.Strings[laco] + ' - ' + floatToStr(RetornaTamanhoHD(chr(integer(drives.Objects[laco])))) + ' Bytes');
Lista.Lines.Add(' ');
Lista.Lines.Add('Periodo Solicitado : ' + DateToStr(data1.Date) + ' ate ' + DateToStr(data2.Date));
Lista.Lines.Add('  ');
Lista.Lines.Add('Total de Registros : ');
Lista.Lines.Add('               TIPO 10 : 0001');
Lista.Lines.Add('               TIPO 11 : 0001');
Lista.Lines.Add('               TIPO 50 : ' + AdicionaCharE('0',IntToStr(conta50), 4));
Lista.Lines.Add('               TIPO 54 : ' + AdicionaCharE('0',IntToStr(conta54), 4));
Lista.Lines.Add('               TIPO 75 : ' + AdicionaCharE('0',IntToStr(conta75), 4));
Lista.Lines.Add('               TIPO 90 : 0001');
Lista.Lines.Add(' ');
Lista.Lines.Add('Total de Registros do Arquivo : ' + AdicionaCharE( '0', IntTostr(texto.Lines.Count), 8));
end;


procedure TFExportacaoFisco.CarregaDrives;
var
  i: Integer;
  C: String;
  DType: Integer;
  Drive: String;
begin
  drives.Clear;
  { Loop from A..Z to determine available drives }
  for i := 65 to 90 do begin
    C := chr(i)+':\'; // Format a string to represent the root directory.
    { Call the GetDriveType() function which returns an integer
      value represent one of the types shown in the case statement
      below }
    DType := GetDriveType(PChar(C));
    { Based on the drive type returned, format a string to add to
      the listbox displaying the various drive types. }
    case DType of
      0: Drive := C; //+ ' The drive type cannot be determined.';
      1: Drive := C; //+ ' The root directory does not exist.';
      DRIVE_REMOVABLE: Drive :=
         C+' Disco Flexível';
      DRIVE_FIXED: Drive :=
         C+' Disco Rígido';
      DRIVE_REMOTE: Drive := '';
//         C;//+' The drive is a remote (network) drive.';
      DRIVE_CDROM: Drive := C+'  CD-ROM';
      DRIVE_RAMDISK: Drive := ''; //C; //+' The drive is a RAM disk.';
    end;
    { Only add drive types that can be determined. }
    if (not ((DType = 0) or (DType = 1))) and (Drive <> '') then
      drives.AddObject(Drive, Pointer(i));
  end;
end;


procedure TFExportacaoFisco.BitBtn2Click(Sender: TObject);
begin
  ShellExecute( handle, nil, Pchar(varia.PathSintegra + 'sintegra.exe'), nil, nil, SW_SHOWNORMAL);
end;


procedure TFExportacaoFisco.TipoEmpFilClick(Sender: TObject);
begin
VerificaEstados;
end;


procedure TFExportacaoFisco.textoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Label12.Caption := IntToStr(texto.CaretPos.x);
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                             eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************** chama a rotina para validar as notas fiscais ****************}
procedure TFExportacaoFisco.BValidarClick(Sender: TObject);
begin
  LocalizaCadNotas;
  ValidaNota;
end;

{********************** valida as notas fiscais *******************************}
function TFExportacaoFisco.ValidaNota : boolean;
begin
  FValidaNotaExportacao := TFValidaNotaExportacao.CriarSDI(application, '', true);
  FValidaNotaExportacao.Valida(Notas.sql.Text);
end;

{************************ imprime a exportacao ********************************}
procedure TFExportacaoFisco.Button1Click(Sender: TObject);
begin
  qrmemo1.Lines.Clear;
  qrmemo1.Lines := lista.Lines;
  rel.Preview;
end;

procedure TFExportacaoFisco.EListaFilialChange(Sender: TObject);
begin
  InicializaFilial(RetornaCodigoFilial);
end;

procedure TFExportacaoFisco.BitBtn3Click(Sender: TObject);
begin
  Fconvenio := TFConvenio.CriarSDI(application,'',true);
  FConvenio.ShowModal;
end;

procedure TFExportacaoFisco.GeraArquivos;
begin
  NomePasta := DeletaChars(DateToStr(data1.DateTime),'/') + '_' + DeletaChars(DateToStr(data2.DateTime),'/');
  NomeArquivo := AdicionaCharE('0', IntToStr(mes(data1.DateTime)),2) + IntToStr(ano(data1.DateTime)) + '_' + AdicionaCharE('0', IntToStr(mes(data2.DateTime)),2) + IntToStr(ano(data2.DateTime));
  NomeDiretorio :=  NormalDiretorio(Varia.PathInSig) + 'ExpFiscal\' + NomePasta;
  if not ExisteDiretorio(NomeDiretorio) then
    CriaDiretorio(NomeDiretorio);
end;

procedure TFExportacaoFisco.BSalvarClick(Sender: TObject);
begin
  FSalvaArquivo := TFSalvaArquivo.CriarSDI(application, '', true);
  FSalvaArquivo.CarregaCopia(NomeDiretorio);
end;

Initialization
 RegisterClasses([TFExportacaoFisco]);
end.

