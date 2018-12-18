unit AEntraData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, Componentes1;

type
  TFEntraData = class(TForm)
    CaixaData: TCalendario;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TextoData: TLabel;
    Bevel1: TBevel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    acao : Boolean;
  public
    function Executa(var Data : TDateTime ) : Boolean;
  end;

var
  FEntraData : TFEntraData;

implementation

{$R *.DFM}

function TFEntraData.Executa(var Data : TDateTime ) : Boolean;
begin
self.ShowModal;
if Acao then
  Data := CaixaData.date;
result := acao;
end;

procedure TFEntraData.BitBtn1Click(Sender: TObject);
begin
acao := true;
self.close
end;

procedure TFEntraData.BitBtn2Click(Sender: TObject);
begin
acao := false;
self.close
end;

procedure TFEntraData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := Cafree;
end;

end.
