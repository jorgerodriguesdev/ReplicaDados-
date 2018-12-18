unit AImportacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  ImgList, ComCtrls, FileCtrl, Gauges, Grids, Outline, DirOutln, UnImportacao,
  ArchiverRoot, CustExtractor, CustArchiver, Archiver;

Const
  CT_SelecioneArquivo = 'FALTA SELECIONAR ARQUIVO!!! Selecione o arquivo que você deseja importar...';
type
  TFImportacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    GMostrador: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    LTabela: TLabel;
    LQtd: TLabel;
    Perfil: TQuery;
    Archiver1: TArchiver;
    Aux: TQuery;
    Tempo: TPainelTempo;
    Info: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    DataInicio, DataFim : TDateTime;
    Importacao : TFuncoesImportacao;
    function ChamaImportacao(VpaDiretorio,VpaArquivo : String)  : Boolean;
    procedure ImportaTabelas(VpaAlias : String);
    procedure ConsisteImportacao;
    function ValidaImportacao(Alias : string) : Boolean;
  public
      function Importar(Path_Nome_Importacao, NomeArquivo : String; CopiarAntes : Boolean) : Boolean;
  end;

var
  FImportacao: TFImportacao;

implementation

uses APrincipal, FunSql, FunString,ConstMsg, Constantes, FunArquivos,
     AMostraErro, UnNotaFiscal;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImportacao.FormCreate(Sender: TObject);
begin
  Importacao := TFuncoesImportacao.Cria(self);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImportacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 aux.close;
 Perfil.close;
 Importacao.free;
 info.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da importação
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************** chama a rotina de importacao *******************************}
function TFImportacao.ChamaImportacao(VpaDiretorio, VpaArquivo : String) : Boolean;
begin
  Archiver1.FileName := VpaArquivo;
  Archiver1.ExtractPath := VpaDiretorio;
  Archiver1.Open;
  Archiver1.ExtractFiles;
  Archiver1.close;
  result := false;

  // verifica se pode ser importado os dados
  if ValidaImportacao(VpaDiretorio) then
  begin
    ImportaTabelas(VpaDiretorio);
    ConsisteImportacao;  // organiza produtos etc
    result := true;
  end;

  Archiver1.DeleteDirectory(VpaDiretorio);
end;

{*********************** importa as tabelas ***********************************}
procedure TFImportacao.ImportaTabelas(VpaAlias : String);
var
  PathArq : string;
begin
  Perfil.Close;
  Perfil.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Perfil,'Select * from Perfil  order by Num_Ordem');

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Perfil.RecordCount;
  Importacao.IniciaLog(DataInicio, DataFim);
  While not Perfil.eof do
  begin
    LTabela.Caption := Perfil.FieldByName('Nom_Tabela').Asstring+'                          ';
    LTabela.Refresh;
    Importacao.ImportaTabela(Perfil,VpaAlias,LQtd);
    Perfil.Next;
    GMostrador.AddProgress(1);
  end;
  if Importacao.FechaLog(PathArq) then
  begin
    FMostraErro := TFMostraErro.CriarSDI(application,'',true);
    FMostraErro.AbreErro(PathArq);
  end;
  LTabela.Caption := '';
  LQtd.Caption := '';
end;


procedure TFImportacao.ConsisteImportacao;
var
  NF : TFuncoesNotaFiscal;
begin
  Tempo.execute('Atualizando...');
  // produtos
  Aux.sql.Clear;
  Aux.sql.Add(' insert into movqdadeproduto(i_emp_fil,i_seq_pro,n_qtd_pro,d_ult_alt)  ' );
  Aux.sql.Add(' select ' + inttostr(varia.CodigoEmpFil) + ', i_seq_pro, 0, ' +
              SQLTextoDataAAAAMMMDD(date) + ' from cadprodutos ' );
  Aux.sql.Add(' where i_seq_pro not in ( select i_seq_pro from movqdadeproduto where i_emp_fil = ' + inttostr(varia.CodigoEmpFil) + ') ' );
  Aux.ExecSQL;

  // notas fiscais
  Aux.sql.Clear;
  Aux.sql.Add(' select * from cadnotafiscais cad ' +
              ' where (c_not_can = ''S'' or c_not_dev = ''S'') ' +
              ' and  i_seq_not  in ( select i_seq_not from ' +
              ' cadcontasareceber cr where  cad.i_emp_fil = cr.i_emp_fil) ');
  aux.open;

  if not aux.eof then
  begin
    NF := TFuncoesNotaFiscal.criar(self, FPrincipal.BaseDados);
    while not aux.eof do
    begin
      NF.Exclui_cancelaNotaFiscalDireto(aux.fieldByname('I_SEQ_NOT').AsInteger,
                                        aux.fieldByName('I_EMP_FIL').AsInteger, false);
      aux.next;
    end;
    NF.Free;
  end;
  Tempo.Fecha;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{************************ importa as tabelas **********************************}
function TFImportacao.Importar(Path_Nome_Importacao, NomeArquivo : String; CopiarAntes : Boolean) : Boolean;
var
   VpfDiretorioTabelas : String;
   VpfLaco : Integer;
begin
  if not DirectoryExists(Varia.PathImportacao + 'Recebidos') then
    CriaDiretorio(Varia.PathImportacao + 'Recebidos');

  if copiarAntes then
  begin
    CopiaArquivo( Path_Nome_Importacao, Varia.PathImportacao + 'Recebidos\' + NomeArquivo);
    Path_Nome_Importacao := Varia.PathImportacao + 'Recebidos\' + NomeArquivo;
  end;

  VpfDiretorioTabelas := RetornaDiretorioCorrente;

  result := ChamaImportacao( VpfDiretorioTabelas, Path_Nome_Importacao);

  Archiver1.DeleteDirectory(VpfDiretorioTabelas);
  self.close;
end;


{******************* Valida a mportacao das tabelas *************************}
function TFImportacao.ValidaImportacao(Alias : string) : Boolean;
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
    AdicionaSQLAbreTabela(Aux,' Select * from perfil_recebido ' +
                               ' where emp_fil = ' + info.fieldByname('Cod_Filial_Emi').AsString +
                               ' and cod_perfil = '  + info.fieldByname('Cod_PERFIL_Emi').AsString);

    if not aux.eof then
    begin

      if info.fieldByname('Tipo_Importacao').AsInteger = 1 then
      begin
        // valida data de importacao
        if info.fieldByname('Data_Inicio').AsDateTime  <=  aux.fieldByname('Dat_importacao').AsDateTime then
        begin
           PodeImportar := true;
           // valida a versao do banco
           if info.fieldByname('Versao_Banco').AsInteger  > varia.VersaoBanco  then
              PodeImportar := confirmacao(' Impotação Inválida, a versão do sistema que originou os dados é '+
                                          ' superior a está, deseja continuar sendo que podera haver problemas na importação ?  ');
            if PodeImportar then
            begin
              if Confirmacao( '_______ DETALHES DA IMPORTAÇÃO _______' + #13 + #13 +
                              ' Tipo de Importação.......: ' + info.fieldByname('Tipo_Importacao').AsString + ' Movimento ' +  #13 +
                              ' Filial de origem.........: ' + info.fieldByname('Cod_Filial_Emi').AsString + ' - ' + info.fieldByname('Nome_Fil_Emi').AsString + #13 +
                              ' Nome da importação ......: ' + info.fieldByname('Nome_perfil').AsString + #13 +
                              ' Data de inicio...........: ' + info.fieldByname('Data_Inicio').AsString + #13 +
                              ' Data de final............: ' + info.fieldByname('Data_fim').AsString + #13 +
                              ' Usuário emitente.........: ' + info.fieldByname('Nome_Usuario').AsString + #13 +
                              ' Quantidade de registros..: ' + info.fieldByname('Qdade_Registo').AsString + #13 + #13 +
                              ' DESEJA IMPORTAR AGORA ? ' ) then
                begin
                  DataInicio := info.fieldByname('Data_Inicio').AsDateTime;
                  DataFim := info.fieldByname('Data_Fim').AsDateTime;
                  result := true;
                  Importacao.MudaDataImportacao( aux.fieldByname('COD_PERFIL').AsString,
                                                 aux.fieldByname('EMP_FIL').AsString,
                                                 info.fieldByname('Data_Fim').AsDateTime);
                end;
           end;
        end
        else
          erro('Impotação Inválida, a última importação recebida foi do dia ' +
               aux.fieldByname('Dat_importacao').AsString + ', esta teve início dia ' +
               info.fieldByname('Data_Inicio').AsString + ', desta forma suas informações ' +
               ' ficarão inconsitentes. Peça uma nova exportação à filial de origem a partir do dia ' +
               aux.fieldByname('Dat_importacao').AsString );
      end
      else
        Aviso('Está importação não pode ser efetuada por está operação.');
    end
    else
    begin
      //caso nao exista
      ExecutaComandoSql(Aux, ' insert into perfil_recebido(emp_fil, Cod_perfil, dat_importacao) ' +
                             ' Values(' + info.fieldByname('Cod_Filial_Emi').AsString +
                             ' , ' + info.fieldByname('Cod_PERFIL_Emi').AsString +
                             ', ' + SQLTextoDataAAAAMMMDD(date)  + ')' );
      result := true;
    end;
  end
  else
    aviso('Não foi possível encontrar o arquivo de informções sobre a importação, a importação poderá causar algum erro! ');
  aux.close;
  Info.close;
end;


Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFImportacao]);
end.
