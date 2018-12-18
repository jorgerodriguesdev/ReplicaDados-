unit AExecutaSQL;

//               Autor: Leonardo Emanuel Pretti
//     Data da Criação: 09/08/2001
//              Função: Executar  Select(SQL)
//        Alterado Por:
//   Data da Alteração:
// Motivo da Alteração:

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  Grids, DBGrids, Tabela, DBKeyViolation, Localizacao, ComCtrls;

type
  TFExecutaSQL = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    PanelColor3: TPanelColor;
    BtExecutar: TBitBtn;
    Grade: TGridIndice;
    Procura: TQuery;
    Label2: TLabel;
    SpeedLocaliza1: TSpeedButton;
    Label1: TLabel;
    LocalizaSelect: TEditLocaliza;
    Localiza: TConsultaPadrao;
    PainelGradiente1: TPainelGradiente;
    DataExecuta: TDataSource;
    PanelColor1: TPanelColor;
    Data1: TCalendario;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    Data2: TCalendario;
    Executa: TQuery;
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BtExecutarClick(Sender: TObject);
    procedure LocalizaSelectRetorno(Retorno1, Retorno2: String);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedLocaliza1Click(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  FExecutaSQL: TFExecutaSQL;

implementation
 uses APrincipal, ConstMsg, Constantes, FunSql, FunData, FunObjeto, FunNumeros;
{$R *.DFM}

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                      BASICO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFExecutaSQL.FormCreate(Sender: TObject);
begin
 { abre tabelas }
 { chamar a rotina de atualização de menus }
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFExecutaSQL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{ ***************** fecha o formulario corrente ****************************** }
procedure TFExecutaSQL.BFecharClick(Sender: TObject);
begin
  Self.Close; //Fecha Formulário
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                    AÇÕES DIVERSAS
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ******************** Altera Enable No Retorno do Localiza ****************** }
procedure TFExecutaSQL.LocalizaSelectRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
     PanelColor1.Visible := False;                           //Desabilita PanelColor
     BtExecutar.Enabled := True;                             //Abilita Botão Executar
     Executa.Close;                                          //Fecha Tabela Executar

     //Posiciona a Tabela no Registro Selecionado
     AdicionaSQLAbreTabela(Procura,'Select * From CadSql '+
                                   ' Where I_COD_SQL = '+ LocalizaSelect.Text);

     if ProcuraC_TIP_DAT.AsString <> 'N' then           //Se a Data for Diferente de "Nenhum"
      begin // 01
        if ProcuraC_TIP_DAT.AsString = 'S' then         //Se a Data for Igual a "Data Simples"
           begin // 02
            PanelColor1.Visible := True;                     //Abilita PanelColor
            Data1.DateTime := Date;                          //Recebe a Data do dia
            Label3.Caption := ProcuraC_CAM_DAT1.AsString;    //Passa o Campo Data1 p/ o Label
            Panel1.Visible := False;                         //Desabilita Panel
           end   // 02
        else
           begin //03                                   //Se a Data for Igual a "Data Composta"
            PanelColor1.Visible := True;                   //Abilita PanelColor
            Panel1.Visible := True;                        //Abilita Panel
            Data1.DateTime := Date;                        //Recebe a Data do dia
            Data2.DateTime := Date;                        //Recebe a Data do dia
            Label3.Caption := ProcuraC_CAM_DAT1.AsString;  //Passa o Campo Data1 p/ o Label
            Label4.Caption := ProcuraC_CAM_DAT2.AsString;  //Passa o Campo Data2 p/ o Label
           end;  // 03
      end;  // 01
end;

{ ********************* Executa Operação Pressionando F9 ********************* }
procedure TFExecutaSQL.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 120 then              //Ação Pressionando o Botão F9
    if BtExecutar.Enabled then   //Funciona Somente so o" Botão Executar" Estver Abilitado
      BtExecutar.Click;
end;

procedure TFExecutaSQL.SpeedLocaliza1Click(Sender: TObject);
begin
  BtExecutar.Enabled := False;  //Desabilita Botão Executar
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                    COMANDO PARA A MONTAGEM DA SELECT
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ************************* Executa Comando SQL ****************************** }
procedure TFExecutaSQL.BtExecutarClick(Sender: TObject);
begin
  Executa.SQL.Clear; //Limpa SQL da Tabela

  Executa.SQL.Add('Select ' + ProcuraC_TEX_SEL.AsString + //Executa a Select Básica
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
end;

Initialization
 RegisterClasses([TFExecutaSQL]);
end.


