unit AEntradaSaida;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, PainelGradiente, ExtCtrls, Componentes1, ImgList,
  ComCtrls, FileCtrl, Menus;

type
  TFEntradaSaida = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    PainelGradiente1: TPainelGradiente;
    Lista: TTreeView;
    ImageList1: TImageList;
    Arquivos: TFileListBox;
    PanelColor3: TPanelColor;
    BEnviarReceber: TBitBtn;
    BGravar: TBitBtn;
    BExcluir: TBitBtn;
    PopupMenu1: TPopupMenu;
    MoverparaItem1: TMenuItem;
    MoverparaEntrada1: TMenuItem;
    MoverparaEnviados1: TMenuItem;
    MoverparaRecebidos1: TMenuItem;
    MoverparaExcluidos1: TMenuItem;
    BMover: TBitBtn;
    BConectar: TBitBtn;
    Abrir: TOpenDialog;
    BitBtn3: TBitBtn;
    BGerarDados: TBitBtn;
    BreceberDados: TBitBtn;
    Fechar: TBitBtn;
    BreceberBaixa: TBitBtn;
    BDesconectar: TBitBtn;
    Tempo: TPainelTempo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FecharClick(Sender: TObject);
    procedure ListaChange(Sender: TObject; Node: TTreeNode);
    procedure BEnviarClick(Sender: TObject);
    procedure BReceberClick(Sender: TObject);
    procedure BGravarClick(Sender: TObject);
    procedure BExcluirClick(Sender: TObject);
    procedure BMoverClick(Sender: TObject);
    procedure MoverparaEntrada1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BConectarClick(Sender: TObject);
    procedure BDesconectarClick(Sender: TObject);
    procedure BreceberBaixaClick(Sender: TObject);
    procedure AtualizaPerfil;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEntradaSaida: TFEntradaSaida;

implementation

uses APrincipal, constantes, constmsg, funarquivos, AImportacao,
     AExportacao, funsistema, funstring, funHardware, AEnviarBaixas, AConectar, ARecebeBaixa, UnPerfil;

{$R *.DFM}


procedure TFEntradaSaida.FormCreate(Sender: TObject);
begin
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFEntradaSaida.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if VerificaFormCriado('TFConectar') then
  begin
    FConectar.free;
    FConectar := nil;
  end;
  Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFEntradaSaida.FecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFEntradaSaida.ListaChange(Sender: TObject; Node: TTreeNode);
begin
  if Node.SelectedIndex <> 5 then
  begin
    if not FileExists(varia.PathImportacao + Node.Text) then
      CriaDiretorio(varia.PathImportacao + Node.Text);
    Arquivos.Directory := varia.PathImportacao + Node.Text;
  end
  else
    if DiscoNoDrive('A') then
    begin
      Arquivos.Directory := 'A:\';
      end
    else
      erro('Insira o disco no drive A, ou disco danificado.');

  BreceberDados.Enabled := ((Node.SelectedIndex = 0) or (Node.SelectedIndex = 5)) and (Arquivos.Items.Count > 0);
  BGravar.Enabled := (Node.SelectedIndex = 1) and (Arquivos.Items.Count > 0);
  BExcluir.Enabled := (Node.SelectedIndex <> 5) and (Arquivos.Items.Count > 0);
end;

procedure TFEntradaSaida.BEnviarClick(Sender: TObject);
begin
  AtualizaPerfil;
  fExportacao := TfExportacao.CriarSDI(application, '', true);
  fExportacao.ShowModal;
  Arquivos.Update;
  ListaChange(lista,lista.Selected);
end;

procedure TFEntradaSaida.BReceberClick(Sender: TObject);
begin
  AtualizaPerfil;
  if (Arquivos.ItemIndex <> -1) and (Arquivos.Items.Count <> 0) and (Arquivos.FileName <> '') then
  begin
    if not VerificaFormCriado('TFImportacao') then
      fImportacao := TfImportacao.CriarSDI(application, '', true);
    fImportacao.show;
    fImportacao.Refresh;
    if fImportacao.Importar(Arquivos.FileName,Arquivos.Items.Strings[Arquivos.itemindex], lista.Selected.SelectedIndex = 5) then
      if lista.Selected.SelectedIndex <> 5 then
        MoveArquivo(Arquivos.FileName,varia.PathImportacao +  'Recebidos\' +Arquivos.Items.Strings[Arquivos.itemindex]);
    Arquivos.Update;
    ListaChange(lista,lista.Selected);
  end;
end;



procedure TFEntradaSaida.BGravarClick(Sender: TObject);
begin
  if DiscoNoDrive('A') then
  begin
    if confirmacao('Todas as informações contidas no disco será excluida, deseja continuar ?') then
    begin
      tempo.execute('Limpando disco, aguarde....');
      DeletaArquivo('a:\*.*');
      tempo.execute('Copiando Arquivo para o Disco, aguarde....');
       if CopiaArquivo(Arquivos.FileName,'a:\' + Arquivos.Items.Strings[Arquivos.itemindex]) then
      begin
        MoveArquivo(Arquivos.FileName,varia.PathImportacao +  'Enviados\' +Arquivos.Items.Strings[Arquivos.itemindex]);
        Arquivos.Update;
        ListaChange(lista,lista.Selected);
      end;
      tempo.fecha;
      aviso('Operação Concluida!');
    end;  
  end
  else
    erro('Insira o disco no drive A, ou disco danificado.');
end;

procedure TFEntradaSaida.BExcluirClick(Sender: TObject);
begin
  if Lista.Selected.SelectedIndex = 4 then
  begin
    if Confirmacao('Deseja realmente excluir o arquivo ' + Arquivos.Items.Strings[Arquivos.itemindex]) then
      DeletaArquivo(Arquivos.FileName);
  end
  else
    MoveArquivo(Arquivos.FileName,varia.PathImportacao +  'Excluidos\' + Arquivos.Items.Strings[Arquivos.itemindex]);
  Arquivos.Update;
  ListaChange(lista,lista.Selected);
end;


procedure TFEntradaSaida.BMoverClick(Sender: TObject);
begin
  PopupMenu1.Popup( self.Left + 4 + BMover.Left,Self.Top + BMover.top + PainelGradiente1.Height + 5);
end;

procedure TFEntradaSaida.MoverparaEntrada1Click(Sender: TObject);
begin
  if (Arquivos.ItemIndex <> -1) and (Arquivos.Items.Count <> 0) then
  begin
    MoveArquivo(Arquivos.FileName,varia.PathImportacao +  (sender as TMenuItem).Hint + '\' + Arquivos.Items.Strings[Arquivos.itemindex]);
    Arquivos.Update;
    ListaChange(lista,lista.Selected);
  end;
end;





procedure TFEntradaSaida.BitBtn3Click(Sender: TObject);
begin
  AtualizaPerfil;
  FEnviarBaixa := TFEnviarBaixa.CriarSDI(application, '', true);
  FEnviarBaixa. ShowModal;
  Arquivos.Update
end;

procedure TFEntradaSaida.BConectarClick(Sender: TObject);
begin
  if not VerificaFormCriado('TFConectar') then
    FConectar := TFConectar.CriarSDI(application, '', true);
  if FConectar.Conecta then
  begin
    BConectar.Enabled := false;
    BDesconectar.Enabled := true;
  end;
end;

procedure TFEntradaSaida.BDesconectarClick(Sender: TObject);
begin
  FConectar.Desconectar;
  BConectar.Enabled := true;
  BDesconectar.Enabled := false;
  FConectar.free;
  FConectar := nil;
end;

procedure TFEntradaSaida.BreceberBaixaClick(Sender: TObject);
begin
  AtualizaPerfil;
  if (Arquivos.ItemIndex <> -1) and (Arquivos.Items.Count <> 0) and (Arquivos.FileName <> '') then
  begin
    if not VerificaFormCriado('TFRecebeBaixa') then
      FRecebeBaixa := TFRecebeBaixa.CriarSDI(application, '', true);
    FRecebeBaixa.show;
    FRecebeBaixa.Refresh;
    if FRecebeBaixa.Importar(Arquivos.FileName,Arquivos.Items.Strings[Arquivos.itemindex], lista.Selected.SelectedIndex = 5) then
      if lista.Selected.SelectedIndex <> 5 then
        MoveArquivo(Arquivos.FileName,varia.PathImportacao +  'Recebidos\' +Arquivos.Items.Strings[Arquivos.itemindex]);
    Arquivos.Update;
    ListaChange(lista,lista.Selected);
  end;
end;

procedure TFEntradaSaida.AtualizaPerfil;
var
  UnPerfilAtu : TFuncoesPerfil;
begin
  if varia.VersaoPerfil < ct_VersaoPerfil then
  begin
    Tempo.execute('Atualizando o sistema, aguarde...');
    UnPerfilAtu := TFuncoesPerfil.criar(self, FPrincipal.BaseDados);
    UnPerfilAtu.AtualizaGruposPerfil;
    UnPerfilAtu.free;
    varia.VersaoPerfil := ct_VersaoPerfil;
    tempo.fecha;
  end;
end;

Initialization
 RegisterClasses([TFEntradaSaida]);
end.
