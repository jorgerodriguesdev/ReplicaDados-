unit ARecebeCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, FileCtrl, Db,
  DBTables, Grids, DBGrids, Tabela, DBKeyViolation, ArchiverRoot,
  CustExtractor, CustArchiver, Archiver;

type
  TFRecebeCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    BNovo: TBitBtn;
    Tabela: TQuery;
    DataTabela: TDataSource;
    Aux: TQuery;
    GridIndice1: TGridIndice;
    Archiver1: TArchiver;
    Info: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BNovoClick(Sender: TObject);
  private
    PathTemp : string;
    acao : Boolean;
    procedure AtualizaCaixa;
    function ValidaImportacao(Alias : string) : Boolean;
  public
    function AbreImportacao(PathArquivo_nome, NomeArquivo : string) : Boolean;
  end;

var
  FRecebeCaixa: TFRecebeCaixa;

implementation

uses APrincipal, constmsg, constantes, funarquivos, funsql, funstring;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFRecebeCaixa.FormCreate(Sender: TObject);
begin
  if not FileExists(varia.PathImportacao + 'caixas\Entrada') then
    CriaDiretorio(varia.PathImportacao + 'caixas\Entrada');
  acao := false;  
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFRecebeCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFRecebeCaixa.BFecharClick(Sender: TObject);
begin
  self.close;
end;

function TFRecebeCaixa.AbreImportacao(PathArquivo_nome, NomeArquivo : string) : Boolean;
begin
  acao := false;
  PathTemp := RetornaDiretorioTemp(varia.PathImportacao);
  Archiver1.FileName := PathArquivo_nome;
  Archiver1.ExtractPath := PathTemp;
  Archiver1.Open;
  Archiver1.ExtractFiles;
  Archiver1.close;

  if ValidaImportacao(PathTemp) then
  begin
    tabela.active := false;
    tabela.DataBaseName := PathTemp; //temporaria;
    AdicionaSQLAbreTabela(tabela, ' Select * from ' + NomeArquivo +
                                  ' Order by NroCaixa asc ' );
    Tabela.open;
    self.showModal;
    result := acao;
  end
  else
  begin
    self.close;
    result := false;
  end
end;

procedure TFRecebeCaixa.AtualizaCaixa;
begin
  if not Tabela.IsEmpty then
  begin
    Tabela.First;
    while not Tabela.eof do
    begin
       AdicionaSQLAbreTabela(Aux, ' Select * from movCaixaEstoque where ' +
                                  ' i_emp_fil = ' +  Inttostr(varia.CodigoEmpFil)  +
                                  ' and i_nro_cai = ' + Tabela.fieldByName('NroCaixa').AsString +
                                  ' and i_seq_pro = ' + Tabela.fieldByName('SeqProduto').AsString +
                                  ' order by i_nro_cai asc ');
       if aux.Eof then
       begin
         aux.Insert;
         aux.FieldByName('I_emp_fil').AsInteger := varia.CodigoEmpFil;
         aux.FieldByName('I_NRO_CAI').AsInteger := tabela.fieldByname('NroCaixa').AsInteger;
         aux.FieldByName('I_SEQ_PRO').AsInteger := tabela.fieldByname('SeqProduto').AsInteger;
         aux.FieldByName('C_COD_PRO').AsString := tabela.fieldByname('CodProduto').AsString;
         aux.FieldByName('I_NRO_NOT').AsInteger := tabela.fieldByname('NroNota').AsInteger;
         aux.FieldByName('C_SER_NOT').AsString := tabela.fieldByname('SerieNota').AsString;
         aux.FieldByName('I_PES_CAI').AsFloat := tabela.fieldByname('Peso').AsFloat;
         aux.FieldByName('D_DAT_ENT').AsDateTime := date;
         aux.FieldByName('C_SIT_CAI').AsString := 'A';
         aux.FieldByName('C_TIP_CAI').AsString := 'I';
         aux.FieldByName('I_SEQ_CAI').AsInteger := ProximoCodigoFilial('MovCaixaEstoque','I_SEQ_CAI','I_EMP_FIL',varia.CodigoEmpFil,FPrincipal.BaseDados);
         aux.post;
       end;
       Tabela.Next;
    end;
    tabela.First;
  end;
  tabela.close;
  aux.close;
  Archiver1.DeleteDirectory(PathTemp);
  acao := true;
  self.close;
end;

procedure TFRecebeCaixa.BNovoClick(Sender: TObject);
begin
  AtualizaCaixa;
end;

{******************* Valida a mportacao das tabelas *************************}
function TFRecebeCaixa.ValidaImportacao(Alias : string) : Boolean;
var
  PodeImportar : Boolean;
begin
  result := false;
  Info.Close;
  Info.DatabaseName := Alias;
  try
    AdicionaSQLAbreTabela(Info,' Select * from Info ');
  except
    result := true;
  end;

  if not result then
  begin

      if info.fieldByname('Tipo_Importacao').AsInteger = 2 then
      begin
       // valida a versao do banco
        PodeImportar := true;
        // valida a versao do banco
        if info.fieldByname('Versao_Banco').AsInteger  > varia.VersaoBanco  then
           PodeImportar := confirmacao(' Impotação Inválida, a versão do sistema que originou os dados é '+
                                       ' superior a está, deseja continuar sendo que podera haver problemas na importação ?  ');
         if PodeImportar then
         begin
            if Confirmacao( '_______ DETALHES DA IMPORTAÇÃO _______' + #13 + #13 +
                            ' Tipo de Importação.......: ' + ' Caixas Enviadas ' +  #13 +
                            ' Filial de origem.........: ' + info.fieldByname('Cod_Filial_Emi').AsString + ' - ' + info.fieldByname('Nome_Fil_Emi').AsString + #13 +
                            ' Nome da importação ......: ' + info.fieldByname('Nome_perfil').AsString + #13 +
                            ' Data de emissão...........: ' + info.fieldByname('Data_Inicio').AsString + #13 +
                            ' Usuário emitente.........: ' + info.fieldByname('Nome_Usuario').AsString + #13 +
                            ' DESEJA IMPORTAR AGORA ? ' ) then
              begin
                result := true;
              end;
           end
           else
             Erro(' Impotação Inválida, a versão do sistema que originou os dados é '+
                  ' superior a está. ' );
      end;
  end
  else
    aviso('Não foi possível encontrar o arquivo de informções sobre a importação, a importação poderá causar algum erro! ');
  aux.close;
  Info.close;
end;

Initialization
 RegisterClasses([TFRecebeCaixa]);
end.
 