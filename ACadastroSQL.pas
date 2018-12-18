unit ACadastroSQL;

{  Autor: Leonardo Emanuel Pretti
   Data da Criação: 07/08/2001
   Função: Cadastra Select(SQL)
   Alterado Por:  JORGE EDUARDO
   Data da Alteração:
   Motivo da Alteração:}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, StdCtrls, Mask, DBCtrls, DBTables, Tabela, BotaoCadastro, Buttons,
  Componentes1, ExtCtrls, PainelGradiente, Localizacao, Grids, DBGrids,
  DBKeyViolation;

type
  TFCadastroSQL = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    BFechar: TBitBtn;
    DataCadSql: TDataSource;
    Label3: TLabel;
    Label5: TLabel;
    Localiza: TConsultaPadrao;
    Bevel1: TBevel;
    Label7: TLabel;
    Consulta: TLocalizaEdit;
    GridIndice1: TGridIndice;
    ValidaGravacao1: TValidaGravacao;
    PainelGradiente1: TPainelGradiente;
    Label1: TLabel;
    TextoSelect: TDBMemoColor;
    TextoTabela: TDBMemoColor;
    DBFilialColor1: TDBFilialColor;
    CadSql: TSQL;
    Nome: TDBEditColor;
    Label2: TLabel;
    Label4: TLabel;
    TextoJoin: TDBMemoColor;
    Label6: TLabel;
    Datas: TDBRadioGroup;
    Bevel2: TBevel;
    Panel1: TPanel;
    Label12: TLabel;
    CampoData1: TDBEditColor;
    Data1: TDBComboBoxColor;
    Label8: TLabel;
    Panel2: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    CampoData2: TDBEditColor;
    Data2: TDBComboBoxColor;
    CadSqlI_EMP_FIL: TIntegerField;
    CadSqlI_COD_SQL: TIntegerField;
    CadSqlC_TEX_TAB: TMemoField;
    CadSqlC_TEX_SEL: TMemoField;
    CadSqlC_NOM_SEL: TStringField;
    CadSqlC_TIP_DAT: TStringField;
    CadSqlD_ULT_ALT: TDateField;
    CadSqlC_CAM_DAT1: TStringField;
    CadSqlC_CAM_DAT2: TStringField;
    CadSqlC_TIP_SIP: TStringField;
    CadSqlC_TIP_COP: TStringField;
    CadSqlC_TEX_JOI: TMemoField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure CadSqlAfterInsert(DataSet: TDataSet);
    procedure CadSqlBeforePost(DataSet: TDataSet);
    procedure CadSqlAfterPost(DataSet: TDataSet);
    procedure BotaoAlterar1DepoisAtividade(Sender: TObject);
    procedure DatasChange(Sender: TObject);
    procedure CadSqlAfterScroll(DataSet: TDataSet);
    procedure CadSqlAfterCancel(DataSet: TDataSet);
  private
    procedure AtualizaPanel;
  public
    { Public declarations }
  end;

var
  FCadastroSQL: TFCadastroSQL;

implementation

 uses APrincipal, Constmsg, Constantes, FunSql, FunData, FunObjeto, FunNumeros;

{$R *.DFM}

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                    BASICO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFCadastroSQL.FormCreate(Sender: TObject);
begin
  CadSql.Open;
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadastroSQL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 Ações da SQL
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ********************* Atualiza Tabela Após Gravar ************************** }
procedure TFCadastroSQL.CadSqlAfterPost(DataSet: TDataSet);
begin
  AtualizaSQLTabela(CadSql);  //Atualiza o Grid "TABELA"
  AtualizaPanel;              //Atualiza Panel Conforme Registro da Tabela
end;

{ *********************** Ação Após Mudar Item no Grid *********************** }
procedure TFCadastroSQL.CadSqlAfterScroll(DataSet: TDataSet);
begin
  AtualizaPanel; //Atualiza Panel Conforme Registro da Tabela
end;

{ **************************** Ação Após Cancelar **************************** }
procedure TFCadastroSQL.CadSqlAfterCancel(DataSet: TDataSet);
begin
  AtualizaPanel; //Atualiza Panel Conforme Registro da Tabela
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 Eventos Diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ***************** fecha o formulario corrente ****************************** }
procedure TFCadastroSQL.BFecharClick(Sender: TObject);
begin
  Self.Close; //Fecha Formulário
end;

{ ****************** executa o valida gravação ******************************* }
procedure TFCadastroSQL.CadSqlAfterInsert(DataSet: TDataSet);
begin
   ValidaGravacao1.execute;
   CadSqlI_COD_SQL.AsInteger := Varia.CodigoFilCadastro;
   CadSqlI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
   DBFilialColor1.ProximoCodigo;                 //Passa Próximo Código
   Nome.SetFocus;                                //Foca o Edit Nome
   CadSqlC_TIP_DAT .Value := 'N';                //Datas Recebe "Nenhum"
end;

{ *********************** verifica código na rede **************************** }
procedure TFCadastroSQL.CadSqlBeforePost(DataSet: TDataSet);
begin
  CadSqlD_ULT_ALT.AsDateTime := Date;   //Ultima Alteração Recebe "Data"
  if CadSql.State = dsinsert then      //Se a Tabela Estiver em Estado de Inserção
    DBFilialColor1.VerificaCodigoRede; //Verifica Código na Rede
end;

{ ********************** Seta o Memo do Nome Após Alterar ******************** }
procedure TFCadastroSQL.BotaoAlterar1DepoisAtividade(Sender: TObject);
begin
   Nome.SetFocus;                            //Foca o Edit Nome
end;

{ ******************* Abilita Panel´s Conforme Filtro Data ******************* }
procedure TFCadastroSQL.DatasChange(Sender: TObject);
begin
  if CadSql.State in [dsInsert, dsEdit] then
   begin // 01
    if Datas.Value = 'N' then           //Se a Data for Igual a "Nenhum"
       begin // 02
         CadSqlC_CAM_DAT1.AsString := '';
         CadSqlC_TIP_SIP.AsString := '';        //Joga Valor String Vazio

         CadSqlC_CAM_DAT2.AsString := '';
         CadSqlC_TIP_COP.AsString := '';
       end // 02
    else
       if Datas.Value = 'S' then        //Se a Data for Igual a "Simples"
         begin // 03
          CadSqlC_CAM_DAT2.AsString := '';
          CadSqlC_TIP_COP.AsString := '';        //Joga Valor String Vazio
         end; // 03
   AtualizaPanel;   //Atualiza Panel Conforme Registro da Tabela
   end; // 01
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  PROCEDURE PARA ATUALIZAÇÃO DOS PANEL´S
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ **************** Atualiza Panel Conforme Registro da Tabela **************** }
procedure TFCadastroSQL.AtualizaPanel;
begin
  if Datas.Value = 'N' then   //Se Data For Igual a "NENHUM"
    begin
      Panel1.Visible := False;     //Desabilita Panel
      Panel2.Visible := False;
    end
  else
     if Datas.Value = 'S' then //Se Data For Igual a "DATA SIMPLES"
        begin
         Panel1.Visible := True;    //Desabilita Panel
         Panel2.Visible := False;   //Abilita Panel
        end
     else                      //Se Data For Igual a "DATA COMPOSTA"
        begin
         Panel1.Visible := True;    //Abilita Panel
         Panel2.Visible := True;
        end;
end;

Initialization
 RegisterClasses([TFCadastroSQL]);
end.
