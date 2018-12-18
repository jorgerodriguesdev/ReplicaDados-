unit AOrdemCampos;
{     Autor: Leonardo Emanuel Pretti
     Data da Criação: 14/08/2001
     Função: Perfil da Select(SQL)
     Alterado Por: JORGE EDUARDO
     Data da Alteração:
     Motivo da Alteração:}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  Grids, DBGrids, Tabela, DBKeyViolation, Localizacao, ComCtrls,
  BotaoCadastro, Mask, DBCtrls;

type
  TFOrdemCampos = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BtFechar: TBitBtn;
    PanelColor3: TPanelColor;
    Grade: TGridIndice;
    Procura: TQuery;
    Label2: TLabel;
    SpeedLocaliza1: TSpeedButton;
    Label1: TLabel;
    Localiza: TConsultaPadrao;
    PainelGradiente1: TPainelGradiente;
    DataCadCamposExportacao: TDataSource;
    PanelColor1: TPanelColor;
    Data1: TCalendario;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    Data2: TCalendario;
    BtExportar: TBitBtn;
    MovCamposExportacao: TQuery;
    MovCamposExportacaoI_COD_SQL: TIntegerField;
    MovCamposExportacaoI_COD_CAM: TIntegerField;
    MovCamposExportacaoI_COD_ORD: TIntegerField;
    MovCamposExportacaoC_NOM_CAM: TStringField;
    MovCamposExportacaoI_TAM_CAM: TIntegerField;
    MovCamposExportacaoI_CAR_INI: TIntegerField;
    MovCamposExportacaoI_CAR_FIM: TIntegerField;
    MovCamposExportacaoI_CAS_DEC: TIntegerField;
    MovCamposExportacaoC_ALI_CAR: TStringField;
    MovCamposExportacaoC_SEP_CAM: TStringField;
    MovCamposExportacaoC_SEP_DEC: TStringField;
    MovCamposExportacaoD_ULT_ALT: TDateField;
    MovCamposExportacaoC_TIP_CAM: TStringField;
    CadCamposExportacao: TSQL;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoExcluir1: TBotaoExcluir;
    BtAlterar: TBitBtn;
    BtGravar: TBitBtn;
    BtCancelar: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    DBFilialColor1: TDBFilialColor;
    Nome: TDBEditColor;
    Executa: TQuery;
    CadCamposExportacaoI_COD_SQL: TIntegerField;
    CadCamposExportacaoI_COD_CAM: TIntegerField;
    CadCamposExportacaoD_ULT_ALT: TDateField;
    CadCamposExportacaoC_NOM_PER: TStringField;
    CadCamposExportacaoI_TAM_LIN: TIntegerField;
    CadCamposExportacaoC_SEP_LIN: TStringField;
    DBEditColor1: TDBEditColor;
    Label7: TLabel;
    DBEditColor2: TDBEditColor;
    Label8: TLabel;
    ValidaGravacao1: TValidaGravacao;
    LocalizaSelect: TDBEditLocaliza;
    DataMovCamposExportacao: TDataSource;
    CadCamposExportacaoI_EMP_FIL: TIntegerField;
    MovCamposExportacaoI_EMP_FIL: TIntegerField;
    ProcuraI_EMP_FIL: TIntegerField;
    ProcuraI_COD_SQL: TIntegerField;
    ProcuraC_TEX_TAB: TMemoField;
    ProcuraC_TEX_SEL: TMemoField;
    ProcuraC_NOM_SEL: TStringField;
    ProcuraC_TIP_DAT: TStringField;
    ProcuraD_ULT_ALT: TDateField;
    ProcuraC_CAM_DAT1: TStringField;
    ProcuraC_CAM_DAT2: TStringField;
    ProcuraC_TIP_SIP: TStringField;
    ProcuraC_TIP_COP: TStringField;
    ProcuraC_TEX_JOI: TMemoField;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    DataMovCampos: TDataSource;
    MovCampos: TSQL;
    MovCamposI_COD_SQL: TIntegerField;
    MovCamposI_COD_CAM: TIntegerField;
    MovCamposI_EMP_FIL: TIntegerField;
    MovCamposI_COD_ORD: TIntegerField;
    MovCamposC_NOM_CAM: TStringField;
    MovCamposI_TAM_CAM: TIntegerField;
    MovCamposI_CAR_INI: TIntegerField;
    MovCamposI_CAR_FIM: TIntegerField;
    MovCamposI_CAS_DEC: TIntegerField;
    MovCamposC_ALI_CAR: TStringField;
    MovCamposC_SEP_CAM: TStringField;
    MovCamposC_SEP_DEC: TStringField;
    MovCamposD_ULT_ALT: TDateField;
    MovCamposC_TIP_CAM: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtFecharClick(Sender: TObject);
    procedure BtExportarClick(Sender: TObject);
    procedure CadCamposExportacaoAfterInsert(DataSet: TDataSet);
    procedure CadCamposExportacaoBeforePost(DataSet: TDataSet);
    procedure BtGravarClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure BtAlterarClick(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
    procedure CadCamposExportacaoAfterPost(DataSet: TDataSet);
    procedure CadCamposExportacaoAfterCancel(DataSet: TDataSet);
    procedure CadCamposExportacaoAfterEdit(DataSet: TDataSet);
    procedure LocalizaSelectRetorno(Retorno1, Retorno2: String);
    procedure BotaoCadastrar1AntesAtividade(Sender: TObject);
    procedure MovCamposExportacaoAfterScroll(DataSet: TDataSet);
    procedure MovCamposExportacaoBeforePost(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    procedure PosicionaSelect;
    procedure ExportaCampos;
  public
    { Public declarations }
  end;

var
  FOrdemCampos: TFOrdemCampos;

implementation
uses  APrincipal,Constmsg,AManutencaodePerfil,Constantes,
      FunSql, FunData, FunObjeto, FunNumeros;
{$R *.DFM}

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                      BASICO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFOrdemCampos.FormCreate(Sender: TObject);
begin
  LocalizaSelect.Atualiza;//  ABRE CADCAMPO EXPORTACAO
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;//CHAMA PROCEDURE POSICIONASELECT
  Label9.Visible := false;
  CadCamposExportacao.Open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFOrdemCampos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadCamposExportacao.Close;
  MovCamposExportacao.Close;
  Action := CaFree;
end;

{ ***************** fecha o formulario corrente ****************************** }
procedure TFOrdemCampos.BtFecharClick(Sender: TObject);
begin
  Self.Close; //Fecha Formulário
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              EVENTOS DO CADASTRO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

procedure TFOrdemCampos.CadCamposExportacaoAfterInsert(DataSet: TDataSet);
begin
  CadCamposExportacaoI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
  CadCamposExportacaoI_COD_CAM.AsInteger := Varia.CodigoFilCadastro;
  BtGravar.Enabled := FALSE;
  BtExportar.Enabled := true;
  DBFilialColor1.ProximoCodigo;
  LocalizaSelect.SetFocus;
end;

{ ********** Verifica Código na Rede e Passa Data da Ultima Alteraçao ******** }
procedure TFOrdemCampos.CadCamposExportacaoBeforePost(DataSet: TDataSet);
begin                         {VERIFICA SE HÁ CAMPOS VAZIOS NA CAD}
  if CadCamposExportacaoC_NOM_PER.IsNull or   //NOME DO PERFIL
    CadCamposExportacaoI_TAM_LIN.IsNull or    //TAMANHO DA LINHA
    CadCamposExportacaoC_SEP_LIN.IsNull then  //SEPARADOR DE LINHA
    begin
      aviso('Dados do cadastro incompletos!');
      Abort;
    end;
    CadCamposExportacaoD_ULT_ALT.AsDateTime := Date; // Ultima Alteração Recebe "Data de Hoje"
    if CadCamposExportacao.State = dsinsert then     // Se a Tabela Estiver em Estado de Inserção
      DBFilialColor1.VerificaCodigoRede;             // Verifica Código
end;

{ ****************************** Grava Registro ****************************** }
procedure TFOrdemCampos.BtGravarClick(Sender: TObject);
begin                                         {VERIFICA SE HÁ CAMPOS VAZIOS NA MOV}
  if MovCamposExportacaoI_CAR_INI.IsNull or  // CARACTER INICIAL
    MovCamposExportacaoI_CAR_FIM.IsNull or  // CARACTER FINAL
    MovCamposExportacaoI_CAS_DEC.IsNull or  // Nº DE CASAS DECIMAIS
    MovCamposExportacaoC_ALI_CAR.IsNull or  // ALINHAMENTO DO CARACTER
    MovCamposExportacaoC_SEP_CAM.IsNull or  // SEPARADOR DE CAMPOS
    MovCamposExportacaoC_SEP_DEC.IsNull then // SEPARADOR DECIMAL  }
  begin
    aviso('Dados do cadstro incompletos!');
    Abort;
  end;
  if MovCamposExportacao.State in [dsInsert, dsEdit] then
    MovCamposExportacao.Post;    //SE ESTIVER INSERINDO OU EDITANDO , GRAVAR
end;

{ ***************************** Cancela Registro ***************************** }
procedure TFOrdemCampos.BtCancelarClick(Sender: TObject);
begin
  if CadCamposExportacao.State in [dsInsert,dsEdit] then
    CadCamposExportacao.Cancel;   //SE ESTIVER INSERINDO OU EDITANDO , CANCELAR
end;

{************ LOCALIZA O PERFIL E ALTERA O REGISTRO ************************** }
procedure TFOrdemCampos.BtAlterarClick(Sender: TObject);
begin
  if CadCamposExportacaoI_COD_SQL.AsInteger <> 0 then
  begin
    FManutencaodePerfil := TFManutencaodePerfil.CriarSDI(self,'',true);
    FManutencaodePerfil.PosicionaPerfil(CadCamposExportacaoI_EMP_FIL.AsInteger,CadCamposExportacaoI_COD_SQL.AsInteger);
  end;
end;

{ ************************* Altera Enable Após Gravar ************************ }
procedure TFOrdemCampos.CadCamposExportacaoAfterPost(DataSet: TDataSet);
begin
  AlterarEnabled([BtCancelar, BtFechar, BtAlterar,BotaoCadastrar1, BotaoExcluir1]);
  LocalizaSelect.Atualiza;
  PosicionaSelect;   //CHAMA PROCEDURE
end;

{ ************************ Altera Enable Após Cancelar *********************** }
procedure TFOrdemCampos.CadCamposExportacaoAfterCancel(DataSet: TDataSet);
begin
  AlterarEnabled([BtCancelar, BtFechar, BtAlterar, BotaoCadastrar1, BotaoExcluir1,BtExportar]);
  AlterarEnabledDet([SpeedLocaliza1,LocalizaSelect],TRUE);
  LocalizaSelect.Atualiza;
  PosicionaSelect;   //CHAMA PROCEDURE
end;

{ ************************* Altera Enable Após Editar ************************ }
procedure TFOrdemCampos.CadCamposExportacaoAfterEdit(DataSet: TDataSet);
begin
  AlterarEnabled([BtAlterar, BtGravar, BtCancelar]);
end;

{ ************************* Altera Enable Após Inserir *********************** }
procedure TFOrdemCampos.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  AlterarEnabled([BtAlterar,BtCancelar]);
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                    COMANDO PARA A MONTAGEM DA SELECT
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

procedure TFOrdemCampos.LocalizaSelectRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
    begin // 01
      Executa.SQL.Clear;
      Executa.SQL.Add(' Select CAD.I_COD_SQL, CAD.C_NOM_SEL ' +
                      ' From CadSql as CAD, CadCamposExportacao as CAM ' +
                      ' Where CAD.I_COD_SQL = ' + Retorno1 +
                      ' and  CAD.I_COD_SQL = CAM.I_COD_SQL ' +
                      ' and  CAD.I_EMP_FIL = CAM.I_EMP_FIL');
      Executa.Open;
      if Executa.Eof then
      begin //02
        PanelColor1.Visible := False;      //Desabilita PanelColor
        BtExportar.Enabled := True;        //Abilita Botão Executar
        Executa.Close;                     //Fecha Tabela Executar
      end  // 02
      else
      begin //03
        LocalizaSelect.Text := '';
        LocalizaSelect.Atualiza;
        aviso('Esta Select já foi usada. Escolha outra Select!');
        LocalizaSelect.SetFocus;
      end;  //03
    end;  //01
end;

{ **************** Varre a Tabela Pegando os Campos Selecionados ************* }
procedure TFOrdemCampos.BtExportarClick(Sender: TObject);
begin
  if (LocalizaSelect.Enabled = false) and (SpeedLocaliza1.Enabled = false) then
  begin
    LocalizaSelect.Enabled := true;
    SpeedLocaliza1.Enabled := true;
  end;
  if CadCamposExportacao.State in [dsInsert, dsEdit] then
  begin
    CadCamposExportacao.Post;  //SE ESTIVER INSERINDO OU EDITANDO ,GRAVAR
  end;
  AdicionaSQLAbreTabela(Procura,' Select * from CadSql where I_COD_SQL = '+ LocalizaSelect.Text);
  if not Procura.Eof then
  begin
    Executa.SQL.Clear; //Limpa Tabela
    Executa.SQL.Add(' Select ' + ProcuraC_TEX_SEL.AsString + //Executa a Select Básica
                    ' From ' +  ProcuraC_TEX_TAB.AsString );
  if ProcuraC_TEX_JOI.AsString <> '' then            //Se o Texto Join for Diferente de Vazio
  begin // 01
    Executa.SQL.Add(' Where ' + ProcuraC_TEX_JOI.AsString);
    if ProcuraC_TIP_DAT.AsString <> 'N' then         //Se a Data for Diferente de "Nenhum"
    begin // 02
      if ProcuraC_TIP_DAT.AsString = 'S' then        //Se a Data for Igual a "Simples"
          Executa.SQL.Add(' and ' + ProcuraC_CAM_DAT1.AsString +
                                    ProcuraC_TIP_SIP.AsString +  '' +
                                    SQLTextoDataAAAAMMMDD(Data1.Date) + '' )
      else                                           //Se a Data for Igual a "Composta"
          Executa.SQL.Add(' and ' + ProcuraC_CAM_DAT1.AsString +
                                      ProcuraC_TIP_SIP.AsString + '' +
                                      SQLTextoDataAAAAMMMDD(Data1.Date)+ '' +
                          ' and ' + ProcuraC_CAM_DAT2.AsString +
                                      ProcuraC_TIP_COP.AsString + '' +
                                      SQLTextoDataAAAAMMMDD(Data2.Date) + '' );
    end; // 02
  end // 01
  else
  if ProcuraC_TIP_DAT.AsString <> 'N' then            //Se a Data for Diferente de "Nenhum"
  begin // 03
    if ProcuraC_TIP_DAT.AsString = 'S' then         //Se a Data for Igual a "Simples"
      Executa.SQL.Add(' Where ' + ProcuraC_CAM_DAT1.AsString +
                                    ProcuraC_TIP_SIP.AsString + '' +
                                    SQLTextoDataAAAAMMMDD(Data1.Date) + '' )
    else                                            //Se a Data for Igual a "Composta"
      Executa.SQL.Add(' Where ' + ProcuraC_CAM_DAT1.AsString +
                                    ProcuraC_TIP_SIP.AsString + '' +
                                    SQLTextoDataAAAAMMMDD(Data1.Date)+ '' +
                        ' and '  + ProcuraC_CAM_DAT2.AsString +
                                   ProcuraC_TIP_COP.AsString + '' +
                                   SQLTextoDataAAAAMMMDD(Data2.Date) + '' );
  end; // 03
  Executa.Open;
  ExportaCampos;
  AlterarEnabledDet([BtGravar],TRUE);
  AlterarEnabledDet([BtExportar,BtAlterar,BotaoExcluir1,BotaoCadastrar1],FALSE);
  end;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                POSICIONA TABELA DE ACORDO COM O CÓDIGO DO REGISTRO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

procedure TFOrdemCampos.PosicionaSelect;
begin
  //Posiciona a Tabela no Registro Selecionado
  AdicionaSQLAbreTabela(Procura,' Select * From CadSql ' +
                                ' Where I_COD_SQL = ' + LocalizaSelect.Text);
  if ProcuraC_TIP_DAT.AsString <> 'N' then         //Se a Data for Diferente de "Nenhum"
  begin // 01
    if ProcuraC_TIP_DAT.AsString = 'S' then       //Se a Data for Igual a "Data Simples"
    begin // 02
      PanelColor1.Visible := True;                     //Abilita PanelColor
      Data1.DateTime := Date;                          //Recebe a Data do dia
      Label3.Caption := ProcuraC_CAM_DAT1.AsString + ProcuraC_TIP_SIP.AsString;//Passa o Campo Data1 p/ o Label
      Panel1.Visible := False;                          //Desabilita Panel
    end   // 02
    else
    begin //03                                 //Se a Data for Igual a "Data Composta"
      PanelColor1.Visible := True;                     //Abilita PanelColor
      Panel1.Visible := True;                          //Abilita Panel
      Data1.DateTime := Date;                          //Recebe a Data do dia
      Data2.DateTime := Date;                          //Recebe a Data do dia
      Label3.Caption := ProcuraC_CAM_DAT1.AsString +' '+ ProcuraC_TIP_SIP.AsString;//Passa o Campo Data1 p/ o Label
      Label4.Caption := ProcuraC_CAM_DAT2.AsString +' '+ ProcuraC_TIP_COP.AsString;//Passa o Campo Data2 p/ o Label
    end;  // 03
  end;  // 01
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 EXPORTA CAMPOS
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}
procedure TFOrdemCampos.ExportaCampos;
var
  Laco, Sequencial : Integer;
begin
  MovCamposExportacao.Open;
  Executa.Open;
  Sequencial := 0;     // SEQUENCIAL COMEÇA EM ZERO
  MovCamposExportacao.close;
   // DELETA CAMPOS CHAVE PARA NAUM DUPLICAR APOS EDITAR E GRAVAR
  ExecutaComandoSql(MovCamposExportacao,' Delete MovCamposExportacao ' +
                                        ' where I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                        ' AND I_COD_SQL = ' + CadCamposExportacaoI_COD_SQL.AsString +
                                        ' AND I_COD_CAM = ' + CadCamposExportacaoI_COD_CAM.AsString);
  AdicionaSQLAbreTabela(MovCamposExportacao,' Select * from MovCamposExportacao ' );// Abre Tabela MovCamposExportação
  for Laco := 0 to Executa.FieldCount - 1 do  // Repetir até que todos os campos forem Exportados
  begin
    if not Executa.Eof then                  // Verifica se nao é o FIM da tabela
    begin
      MovCamposExportacao.Insert;           // Insert na MovCamposExportação
      if grade.Focused then
        grade.SelectedIndex := 0;
        MovCamposExportacaoI_EMP_FIL.AsInteger := Varia.CodigoEmpFil; //Passa o Código da Filial
        MovCamposExportacaoI_COD_CAM.AsInteger := StrToInt(DBFilialColor1.Text);
        MovCamposExportacaoI_COD_SQL.AsInteger := ProcuraI_COD_SQL.AsInteger; // Pasa o Código da SQL
        Sequencial := Sequencial + 1;      // CODIGO SEQUENCIAL DA ORDEM
        MovCamposExportacaoI_COD_ORD.AsInteger := Sequencial;
        MovCamposExportacaoC_NOM_CAM.AsString := Executa.Fields[Laco].FieldName; // Pasa o Nome do Campo
        MovCamposExportacaoI_TAM_CAM.AsInteger := Executa.Fields[Laco].Size;     // Pasa o Tamanho do Campo
        MovCamposExportacaoI_CAR_INI.AsInteger := 1;     // Caracter Inicial
        MovCamposExportacaoI_CAR_FIM.AsInteger := 2;     // Caracter Final
        MovCamposExportacaoI_CAS_DEC.AsInteger := 10;     // Nº de Casas Decimais
        MovCamposExportacaoC_ALI_CAR.AsString := 'D';     // Alinhador de Caracter
        MovCamposExportacaoC_SEP_CAM.AsString := '#';     // Separador de Campos
        MovCamposExportacaoC_SEP_DEC.AsString := ',';     // Separador de Decimal

      if Executa.Fields[Laco].DataType = ftString then  // Se o Tipo do Campo for String
        MovCamposExportacaoC_TIP_CAM.AsString := 'S'   // Pasa o Tipo do Campo 'S'
      else
      if Executa.Fields[Laco].DataType = ftInteger then // Se o Tipo do Campo for Integer
        MovCamposExportacaoC_TIP_CAM.AsString := 'I'   // Pasa o Tipo do Campo 'I'
      else
      if Executa.Fields[Laco].DataType = ftFloat then   // Se o Tipo do Campo for Numeric
        MovCamposExportacaoC_TIP_CAM.AsString := 'N'   // Pasa o Tipo do Campo 'N'
      else
      if Executa.Fields[Laco].DataType = ftDate then    // Se o Tipo do Campo for Date
        MovCamposExportacaoC_TIP_CAM.AsString := 'D'   // Pasa o Tipo do Campo 'D'
      else
      if Executa.Fields[Laco].DataType = ftTime then  // Se o Tipo do Campo for Time
        MovCamposExportacaoC_TIP_CAM.AsString := 'T'  // Pasa o Tipo do Campo  'T'
      else
      if Executa.Fields[Laco].DataType = ftMemo then  // Se o Tipo do Campo for LongVarChar
        MovCamposExportacaoC_TIP_CAM.AsString := 'L'; // Pasa o Tipo do Campo  'L'

      MovCamposExportacaoD_ULT_ALT.AsDateTime := Date; // Dada da Ultima Alteracao
    end;
end;
  AdicionaSQLAbreTabela(MovCamposExportacao,' Select * From MovCamposExportacao ' +
                                            ' Where I_COD_SQL = '+ LocalizaSelect.Text);
  MovCamposExportacao.Edit; //       MOV ENTRA EM MODO DE ALTERAÇAO
end;

{******************** ABRE A TABELA CADCAMPOSEXPORTAÇÃO **********************}
procedure TFOrdemCampos.BotaoCadastrar1AntesAtividade(Sender: TObject);
begin
  CadCamposExportacao.Open;
end;

{****************** APÓS DESCER UM REGISTRO DA GRADE ALTERAR ******************}
procedure TFOrdemCampos.MovCamposExportacaoAfterScroll(DataSet: TDataSet);
begin
  MovCamposExportacao.Edit;
end;

{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
************************ EVITA PASSAR VAZIOS ANTES DE GRAVAR ****************
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

procedure TFOrdemCampos.MovCamposExportacaoBeforePost(DataSet: TDataSet);
begin                                 {VERIFICA SE HÁ CAMPOS VAZIOS NA MOV}
  if MovCamposExportacaoI_EMP_FIL.IsNull or // FILIAL FOR VAZIO
    MovCamposExportacaoI_COD_CAM.IsNull or  // CÓDIGO DO PERFIL
    MovCamposExportacaoI_COD_SQL.IsNull or  // CÓDIGO DA SQL
    MovCamposExportacaoI_COD_ORD.IsNull or  // CÓDIGO DA ORDEM
    MovCamposExportacaoC_NOM_CAM.IsNull or  // NOME DO CAMPO
    MovCamposExportacaoI_TAM_CAM.IsNull then  // TAMANHO DO CAMPO
  begin
    aviso('Dados do cadastro imcompletos!');
    Abort;
  end;
end;

{**************** DISPARA PROCESSO DE EXPORTAÇÃO VIA TECLA F9 ****************}
procedure TFOrdemCampos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if BtExportar.Enabled then
  begin
    if key = vk_F9 then
      BtExportar.Click;
  end;
end;

{******************* VAI PARA O REGISTRO ANTERIOR ****************************}
procedure TFOrdemCampos.BitBtn1Click(Sender: TObject);
begin
  CadCamposExportacao.Prior;  //ANTERIOR
  PosicionaSelect;   //CHAMA PROCEDURE
end;

{****************** VAI PARA O PRÓXIMO REGISTRO ******************************}
procedure TFOrdemCampos.BitBtn2Click(Sender: TObject);
begin
  CadCamposExportacao.Next;  //PRÓXIMO
  PosicionaSelect;   //CHAMA PROCEDURE
end;

Initialization
 RegisterClasses([TFOrdemCampos]);
end.
