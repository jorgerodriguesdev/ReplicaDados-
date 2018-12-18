unit AExcluiPerfil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, StdCtrls, Mask, DBCtrls, DBTables, Tabela, BotaoCadastro, Buttons,
  Componentes1, ExtCtrls, PainelGradiente, Localizacao, Grids, DBGrids,
  DBKeyViolation;

type
  TFExcluiPerfil = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoExcluir1: TBitBtn;
    BFechar: TBitBtn;
    Perfil: TSQL;
    DataTabelaExportacao: TDataSource;
    GridIndice1: TGridIndice;
    Aux: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BotaoExcluir1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FExcluiPerfil: TFExcluiPerfil;

implementation

uses APrincipal, Constantes, FunSql;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFExcluiPerfil.FormCreate(Sender: TObject);
begin
  LimpaSQLTabela(Perfil);
  AdicionaSQLTabela(Perfil,' Select * from PERFIL_EXPORTACAO ' +
                           ' where cod_empresa = ' + Inttostr(varia.CodigoEmpresa) +
                           ' and cod_perfil <> 999999 ' +
                           ' and cod_perfil <> 888888 ' );
  AdicionaSQLTabela(Perfil,' order by cod_perfil ');
  AbreTabela(Perfil);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFExcluiPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Perfil.close;
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{****************** fecha o formulario corrente *******************************}
procedure TFExcluiPerfil.BFecharClick(Sender: TObject);
begin
  close;
end;




procedure TFExcluiPerfil.BotaoExcluir1Click(Sender: TObject);
begin
if not perfil.Eof then
   ExecutaComandoSql(aux, ' delete PERFIL_ITEM_EXPORTACAO ' +
                          ' where cod_empresa = ' +  Inttostr(varia.CodigoEmpresa) +
                          ' and cod_perfil = ' + Perfil.fieldByName('cod_perfil').AsString + ';' +
                          ' delete PERFIL_EXPORTACAO ' +
                          ' where cod_empresa = ' +  Inttostr(varia.CodigoEmpresa) +
                          ' and cod_perfil = ' + Perfil.fieldByName('cod_perfil').AsString );
  AtualizaSQLTabela(perfil);
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFExcluiPerfil]);
end.
