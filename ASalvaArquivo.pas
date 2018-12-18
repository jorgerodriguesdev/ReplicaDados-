unit ASalvaArquivo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, FileCtrl, PainelGradiente, Buttons, ExtCtrls, Componentes1;

type
  TFSalvaArquivo = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BitBtn1: TBitBtn;
    BValidar: TBitBtn;
    PainelGradiente1: TPainelGradiente;
    Arquivos: TFileListBox;
    PanelColor1: TPanelColor;
    Drive: TDriveComboBox;
    Label1: TLabel;
    Tempo: TPainelTempo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BValidarClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CarregaCopia(Diretorio : string);
  end;

var
  FSalvaArquivo: TFSalvaArquivo;

implementation

uses APrincipal, funarquivos, constantes, constmsg, funHardware;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFSalvaArquivo.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFSalvaArquivo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := CaFree;
end;

procedure TFSalvaArquivo.CarregaCopia(Diretorio : string);
begin
  Arquivos.Directory := Diretorio;
  Drive.Drive := 'A';
  self.ShowModal;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFSalvaArquivo.BitBtn1Click(Sender: TObject);
begin
  self.close;
end;

procedure TFSalvaArquivo.BValidarClick(Sender: TObject);
begin
  if (Arquivos.ItemIndex <> -1) and (Arquivos.items.Count > 0)   then
  begin
    if DiscoNoDrive(Drive.Drive) then
    begin
      if Confirmacao('Todas as informações contidas no disquete será excluida, deseja continuar ?') then
      begin
        tempo.execute('Limpando disco, aguarde....');
        DeletaArquivo('a:\*.*');
        tempo.execute('Copiando Arquivo, aguarde....');
        CopiaArquivo(Arquivos.FileName, Drive.Drive + ':\'  +  Arquivos.Items.Strings[Arquivos.itemindex]);
        tempo.fecha;
        aviso('O arquivo ' + Arquivos.Items.Strings[Arquivos.itemindex] + ' foi copiado com sucesso !');
      end;
    end
    else
      erro('Insira antes o disquete no drive ' + Drive.Drive);
  end
  else
    erro('Não existe arquivo selecionado para copiar !');

end;

Initialization
 RegisterClasses([TFSalvaArquivo]);
end.
