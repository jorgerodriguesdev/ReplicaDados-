unit AValidaNotaExportacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, LabelCorMove, Buttons, Componentes1, ExtCtrls, PainelGradiente,
  Db, DBTables, Grids, DBGrids, Tabela;

const
  CampoVazio = 'Campo Vazio';
  CampoErrado = 'Informações Incorretas';

type
  TFValidaNotaExportacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    BitBtn1: TBitBtn;
    Notas: TQuery;
    NotasC_EST_CLI: TStringField;
    NotasC_CPF_CLI: TStringField;
    NotasC_CGC_CLI: TStringField;
    NotasC_INS_CLI: TStringField;
    NotasC_TIP_PES: TStringField;
    NotasC_SER_NOT: TStringField;
    NotasI_NRO_NOT: TIntegerField;
    NotasD_DAT_EMI: TDateField;
    NotasN_TOT_NOT: TFloatField;
    BValidar: TBitBtn;
    DataNotas: TDataSource;
    DBGridColor1: TDBGridColor;
    NotasI_COD_CLI: TIntegerField;
    NotasC_NOM_CLI: TStringField;
    MemoColor1: TMemoColor;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BValidarClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    Texto : TStringList;
    function VerificaNotas : Boolean;
  public
    function Valida( Select : String ) : Boolean;
    procedure AdicionaTexto( Problema, campo : string);
  end;

var
  FValidaNotaExportacao: TFValidaNotaExportacao;

implementation

uses APrincipal, funsql, funvalida;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFValidaNotaExportacao.FormCreate(Sender: TObject);
begin
  Texto :=  TStringList.Create;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFValidaNotaExportacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  texto.free;
  FechaTabela(Notas);
  Action := CaFree;
end;

function TFValidaNotaExportacao.Valida( Select : String ) : Boolean;
begin
  AdicionaSQLAbreTabela(Notas, Select);
  self.ShowModal;
end;

procedure  TFValidaNotaExportacao.AdicionaTexto( Problema, campo : string );
begin
  Texto.Add('Nota nro : ' + NotasI_NRO_NOT.AsString + ' - Serie ' + NotasC_SER_NOT.AsString + ' - Data Emissão ' + NotasD_DAT_EMI.AsString +
            ' -  Cliente '+NotasI_COD_CLI.AsString+ NotasC_Nom_CLI.AsString + ' - '+ campo + ' : ' + Problema);
end;

{****************** verifica as notas de exportacao ***************************}
function TFValidaNotaExportacao.VerificaNotas : Boolean;
begin
 texto.clear;
// LValidando.Caption := 'Aguarde Validando Notas Fiscais para exportação . . .';

 Notas.First;
 while not Notas.Eof do
 begin

   if NotasC_TIP_PES.AsString = 'J' then
   begin
     if (NotasC_CGC_CLI.AsString = '') then
      AdicionaTexto( CampoVazio, 'CGC' );

     if (NotasC_INS_CLI.AsString = '') then
       AdicionaTexto( CampoVazio, 'Inscrição Estadual' )
     else
       if not(VerificarIncricaoEstadual(NotasC_INS_CLI.AsString, NotasC_EST_CLI.AsString, false, true )) or
         (NotasC_INS_CLI.AsString[1] = ' ') then
         AdicionaTexto( CampoErrado, 'Inscrição Estadual');
   end
   else
     if (NotasC_CPF_CLI.AsString = '') then
       AdicionaTexto( CampoVazio, 'CPF' );


   if NotasN_TOT_NOT.AsCurrency = 0 then
     AdicionaTexto( CampoVazio, 'Total Nota');

   Notas.next;
 end;

 MemoColor1.Lines := Texto;
 if MemoColor1.Lines.Count = 0 then
   MemoColor1.Lines.Add('O Sistema não encontrou nenhum erro em relação aos clientes');
end;


procedure TFValidaNotaExportacao.BValidarClick(Sender: TObject);
begin
  VerificaNotas;
end;

{****************** Fecha o formulario corrente *******************************}
procedure TFValidaNotaExportacao.BitBtn1Click(Sender: TObject);
begin
  close;
end;

Initialization
 RegisterClasses([TFValidaNotaExportacao]);
end.
