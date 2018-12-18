unit Entrada;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Componentes1, Mask, numericos;

type
  TFEntrada = class(TForm)
    Caixa: TEditColor;
    Texto: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Numero: Tnumerico;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    function Executa( var texto : string ) : boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    acao : Boolean;
    procedure SomenteNumeros( Moeda : Boolean );
  end;

var
  FEntrada: TFEntrada;

implementation

{$R *.DFM}

function TFEntrada.Executa( var texto : string ) : boolean;
begin
  ShowModal;
  result := acao;
  if Caixa.Visible then
    texto := Caixa.Text
  else
  begin
    try
      texto := FloatToStr(numero.AValor);
    except
      texto := '0';
    end;
  end;  
end;

procedure TFEntrada.FormCreate(Sender: TObject);
begin
acao := false;
end;

procedure TFEntrada.BitBtn1Click(Sender: TObject);
begin
acao := true;
close;
end;

procedure TFEntrada.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := cafree;
end;

procedure TFEntrada.BitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFEntrada.SomenteNumeros( Moeda : Boolean );
var
  decimal : string;
begin
if CurrencyDecimals = 2 then
  decimal := '00'
else
  decimal := '000';

Caixa.Visible := false;
Numero.ADecimal := CurrencyDecimals;
if Moeda then
  Numero.AMascara := CurrencyString + ' ,0.' + decimal + ';-' + CurrencyString + ' ,0.' + decimal
else
  Numero.AMascara := ',0.' + decimal + ';,0.' + decimal;
end;

procedure TFEntrada.FormShow(Sender: TObject);
begin
if caixa.Visible then
  caixa.SetFocus
else
  Numero.SetFocus;
end;

end.
