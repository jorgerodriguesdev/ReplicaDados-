unit ARecebeBaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  ImgList, ComCtrls, FileCtrl, Gauges, Grids, Outline, DirOutln, UnImportacao,
  ArchiverRoot, CustExtractor, CustArchiver, Archiver;

Const
  CT_SelecioneArquivo = 'FALTA SELECIONAR ARQUIVO!!! Selecione o arquivo que você deseja importar...';
type
  TFRecebeBaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    GMostrador: TGauge;
    Label2: TLabel;
    LTabela: TLabel;
    LQtd: TLabel;
    Atualiza: TQuery;
    Archiver1: TArchiver;
    Aux: TQuery;
    Info: TQuery;
    CadCR: TQuery;
    Barra: TProgressBar;
    Perfil: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    DataInicio, DataFim : TDateTime;
    Importacao : TFuncoesImportacao;
    function ChamaImportacao(VpaDiretorio,VpaArquivo : String)  : Boolean;
    procedure ImportaTabelasCR(VpaAlias : String);
    procedure ImportaTabelasCP(VpaAlias : String);
    function ValidaImportacao(Alias : string; var ContasARceber : Boolean) : Boolean;
  public
      function Importar(Path_Nome_Importacao, NomeArquivo : String; CopiarAntes : Boolean) : Boolean;
  end;

var
  FRecebeBaixa: TFRecebeBaixa;

implementation

uses APrincipal, FunSql, FunString,ConstMsg, Constantes, FunArquivos,
     AMostraErro, UnNotaFiscal, UnContasAReceber,
     UnContasAPagar;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFRecebeBaixa.FormCreate(Sender: TObject);
begin
  Importacao := TFuncoesImportacao.Cria(self);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFRecebeBaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 aux.close;
 Atualiza.close;
 Importacao.free;
 info.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da importação
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************** chama a rotina de importacao *******************************}
function TFRecebeBaixa.ChamaImportacao(VpaDiretorio, VpaArquivo : String) : Boolean;
var
  ContasaReceber : Boolean;
begin
  Archiver1.FileName := VpaArquivo;
  Archiver1.ExtractPath := VpaDiretorio;
  Archiver1.Open;
  Archiver1.ExtractFiles;
  Archiver1.close;
  result := false;

  // verifica se pode ser importado os dados
  if ValidaImportacao(VpaDiretorio, ContasaReceber) then
  begin
    if ContasAReceber then
      ImportaTabelasCR(VpaDiretorio)
    else
      ImportaTabelasCP(VpaDiretorio);
    result := true;
  end;

  Archiver1.DeleteDirectory(VpaDiretorio);
end;

{*********************** importa as baixa contas a receber *******************}
procedure TFRecebeBaixa.ImportaTabelasCR(VpaAlias : String);
var
  PathArq : string;
  laco : integer;
  UnCR : TFuncoesContasAReceber;
begin
  GMostrador.Progress := 0;
  barra.max := 4;
  barra.Position := 0;

  // movimento
  LTabela.Caption := 'Atualizando movimento . . .                        ';
  LTabela.Refresh;

  Perfil.Close;
  Perfil.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Perfil,'Select * from Perfil  order by Num_Ordem');
  While not Perfil.eof do
  begin
    if (trim(Uppercase(Perfil.FieldByname('Nom_Tabela').AsString)) <> 'MOVCONTASARECEBER') and
       (trim(Uppercase(Perfil.FieldByname('Nom_Tabela').AsString)) <> 'MOVFORMA') and
       (trim(Uppercase(Perfil.FieldByname('Nom_Tabela').AsString)) <> 'MOVCOMISSOES')  then
          Importacao.ImportaTabela(Perfil,VpaAlias,LQtd);
    Perfil.Next;
  end;
  Perfil.close;

  Aux.RequestLive := true;
  Atualiza.Close;
  Atualiza.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Atualiza,' Select * from MovcontasAReceber ');

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Atualiza.RecordCount;

  While not Atualiza.eof do
  begin
    AdicionaSQLAbreTabela(aux,' Select * from MovContasaReceber ' +
                              ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                              ' and i_lan_rec = ' + atualiza.fieldByname('I_LAN_REC').AsString +
                              ' and i_nro_par = ' + atualiza.fieldByname('I_NRO_PAR').AsString );

    if not aux.Eof then
    begin
      aux.edit;
      for Laco := 0 to Atualiza.FieldCount -1 do
        aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
      aux.post;
    end
    else
    begin
      // verifica se existe cad  parciais
      AdicionaSQLAbreTabela(CadCR,' Select * from CadContasaReceber ' +
                                  ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                                  ' and i_lan_rec = ' + atualiza.fieldByname('I_LAN_REC').AsString );
      if not CadCR.eof then
      begin
        aux.insert;
        for Laco := 0 to Atualiza.FieldCount -1 do
          aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
        aux.post;
      end;
    end;

    Atualiza.Next;
    GMostrador.AddProgress(1);
  end;

  barra.Position := barra.Position + 1;
  // mov forma
  LTabela.Caption := 'Atualizando baixas . . .                         ';
  LTabela.Refresh;
  Atualiza.Close;
  Atualiza.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Atualiza,' Select * from MovForma ' );

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Atualiza.RecordCount;

  While not Atualiza.eof do
  begin
    AdicionaSQLAbreTabela(aux,' Select * from MovForma ' +
                              ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                              ' and i_lan_rec = ' + atualiza.fieldByname('I_LAN_REC').AsString +
                              ' and i_nro_par = ' + atualiza.fieldByname('I_NRO_PAR').AsString +
                              ' and i_nro_lot = ' + atualiza.fieldByname('I_NRO_LOT').AsString);

    if not aux.Eof then
    begin
      aux.edit;
      for Laco := 0 to Atualiza.FieldCount -1 do
        aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
      aux.post;
    end
    else
    begin
      // verifica se existe mov
      AdicionaSQLAbreTabela(CadCR,' Select * from MovContasaReceber ' +
                                  ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                                  ' and i_lan_rec = ' + atualiza.fieldByname('I_LAN_REC').AsString +
                                  ' and i_nro_par = ' + atualiza.fieldByname('I_NRO_PAR').AsString );
      if not CadCR.eof then
      begin
        aux.insert;
        for Laco := 0 to Atualiza.FieldCount -1 do
          aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
          aux.post;
      end;
    end;

    Atualiza.Next;
    GMostrador.AddProgress(1);
  end;

  // Comissoes
  barra.Position := barra.Position + 1;
  LTabela.Caption :=  'Atualizando comissoes . . .                   ';
  LTabela.Refresh;
  Atualiza.Close;
  Atualiza.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Atualiza,' Select * from MovComissoes ' );

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Atualiza.RecordCount;

  While not Atualiza.eof do
  begin
    AdicionaSQLAbreTabela(aux,' Select * from MovComissoes ' +
                              ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                              ' and i_lan_rec = ' + atualiza.fieldByname('I_LAN_REC').AsString +
                              ' and i_lan_con = ' + atualiza.fieldByname('I_LAN_CON').AsString );

    if not aux.Eof then
    begin
      aux.edit;
      for Laco := 0 to Atualiza.FieldCount -1 do
        aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
      aux.post;
    end
    else
    begin
      // verifica se existe mov
      AdicionaSQLAbreTabela(CadCR,' Select * from MovContasaReceber ' +
                                  ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                                  ' and i_lan_rec = ' + atualiza.fieldByname('I_LAN_REC').AsString +
                                  ' and i_nro_par = ' + atualiza.fieldByname('I_NRO_PAR').AsString );
      if not CadCR.eof then
      begin
        aux.insert;
        for Laco := 0 to Atualiza.FieldCount -1 do
          aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
        aux.post;
      end;
    end;

    Atualiza.Next;
    GMostrador.AddProgress(1);
  end;


  // Estornos
  barra.Position := barra.Position + 1;
  LTabela.Caption :=  'Atualizando estornos . . .';
  LTabela.Refresh;
  Atualiza.Close;
  Atualiza.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Atualiza,' Select * from Estorno order by data_vencimento desc' );

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Atualiza.RecordCount;

  While not Atualiza.eof do
  begin
    UnCR := TFuncoesContasAReceber.criar(self, FPrincipal.BaseDados);
    AdicionaSQLAbreTabela(CadCR,' Select * from MovContasaReceber ' +
                                ' where i_emp_fil = ' + atualiza.fieldByname('EMPRESA_FILIAL').AsString +
                                ' and i_lan_rec = ' + atualiza.fieldByname('LANCAMENTO').AsString +
                                ' and i_nro_par = ' + atualiza.fieldByname('PARCELA').AsString );
//-------> aqui
    UnCR.EstornaParcela( CadCR.FieldByName('I_LAN_REC').AsInteger, CadCR.FieldByName('I_NRO_PAR').AsInteger,
                         CadCR.FieldByName('I_LAN_BAC').AsInteger,
                         CadCR.FieldByName('I_PAR_FIL').AsInteger,
                          0,
                         CadCR.FieldByName('D_DAT_VEN').AsDateTime,
                         CadCR.FieldByName('C_FLA_PAR').AsString, false);
    Atualiza.Next;
    GMostrador.AddProgress(1);
  end;

  barra.Position := barra.Position + 1;
  aux.close;
  CadCR.close;
  Aux.RequestLive := false;
  LTabela.Caption := '';
  LQtd.Caption := '';
  Barra.Position := 0;
end;


{*********************** importa as baixa contas a pagar *******************}
procedure TFRecebeBaixa.ImportaTabelasCP(VpaAlias : String);
var
  PathArq : string;
  laco : integer;
  UnCP : TFuncoesContasAPagar;
begin
  GMostrador.Progress := 0;
  barra.max := 4;
  barra.Position := 0;

  // movimento
  LTabela.Caption := 'Atualizando movimento . . .                        ';
  LTabela.Refresh;

  Perfil.Close;
  Perfil.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Perfil,'Select * from Perfil  order by Num_Ordem');
  While not Perfil.eof do
  begin
    if (trim(Uppercase(Perfil.FieldByname('Nom_Tabela').AsString)) <> 'MOVCONTASAPAGAR') then
        Importacao.ImportaTabela(Perfil,VpaAlias,LQtd);
    Perfil.Next;
  end;
  Perfil.close;

  Aux.RequestLive := true;
  Atualiza.Close;
  Atualiza.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Atualiza,' Select * from MovcontasAPagar ');

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Atualiza.RecordCount;

  While not Atualiza.eof do
  begin
    AdicionaSQLAbreTabela(aux,' Select * from MovContasaPagar ' +
                              ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                              ' and i_lan_apg = ' + atualiza.fieldByname('I_LAN_APG').AsString +
                              ' and i_nro_par = ' + atualiza.fieldByname('I_NRO_PAR').AsString );

    if not aux.Eof then
    begin
      aux.edit;
      for Laco := 0 to Atualiza.FieldCount -1 do
        aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
      aux.post;
    end
    else
    begin
      // verifica se existe cad  parciais
      AdicionaSQLAbreTabela(CadCR,' Select * from CadContasaPagar ' +
                                  ' where i_emp_fil = ' + atualiza.fieldByname('I_EMP_FIL').AsString +
                                  ' and i_lan_apg = ' + atualiza.fieldByname('I_LAN_APG').AsString );
      if not CadCR.eof then
      begin
        aux.insert;
        for Laco := 0 to Atualiza.FieldCount -1 do
          aux.FieldByName(atualiza.Fields[Laco].DisplayName).Value := atualiza.Fields[Laco].Value;
        aux.post;
      end;
    end;

    Atualiza.Next;
    GMostrador.AddProgress(1);
  end;

  // Estornos
  barra.Position := barra.Position + 1;
  LTabela.Caption :=  'Atualizando estornos . . .';
  LTabela.Refresh;
  Atualiza.Close;
  Atualiza.DatabaseName := VpaAlias;
  AdicionaSQLAbreTabela(Atualiza,' Select * from Estorno order by data_vencimento desc' );

  GMostrador.Progress := 0;
  GMostrador.MaxValue := Atualiza.RecordCount;

  While not Atualiza.eof do
  begin
    UnCP := TFuncoesContasAPagar.criar(self, FPrincipal.BaseDados);
    AdicionaSQLAbreTabela(CadCR,' Select * from MovContasaPagar ' +
                                ' where i_emp_fil = ' + atualiza.fieldByname('EMPRESA_FILIAL').AsString +
                                ' and i_lan_apg = ' + atualiza.fieldByname('LANCAMENTO').AsString +
                                ' and i_nro_par = ' + atualiza.fieldByname('PARCELA').AsString );
//-------> aqui
    UnCP.EstornaParcela(CadCR.FieldByName('I_LAN_APG').AsInteger, 0, CadCR.FieldByName('I_NRO_PAR').AsInteger,
                        CadCR.FieldByName('I_PAR_FIL').AsInteger,
                        0,
                         CadCR.FieldByName('D_DAT_VEN').AsDateTime,
                        CadCR.FieldByName('C_FLA_PAR').AsString, false);
    Atualiza.Next;
    GMostrador.AddProgress(1);
  end;

  barra.Position := barra.Position + 1;
  aux.close;
  CadCR.close;
  Aux.RequestLive := false;
  LTabela.Caption := '';
  LQtd.Caption := '';
  Barra.Position := 0;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{************************ importa as tabelas **********************************}
function TFRecebeBaixa.Importar(Path_Nome_Importacao, NomeArquivo : String; CopiarAntes : Boolean) : Boolean;
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
function TFRecebeBaixa.ValidaImportacao(Alias : string; var ContasARceber : Boolean) : Boolean;
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

      if info.fieldByname('Tipo_Importacao').AsInteger in [3,4] then
      begin
        ContasARceber := info.fieldByname('Tipo_Importacao').AsInteger = 3;
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
 RegisterClasses([TFRecebeBaixa]);
end.
