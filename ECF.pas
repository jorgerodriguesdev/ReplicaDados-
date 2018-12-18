unit ECF;

interface

uses
 SysUtils, Classes, StdCtrls;

const // mensagens
CT_ErroPorta        = 'Erro ao inicializar porta %s !!';
CT_ErroLiberaPorta  = 'Erro ao tentar liberar porta %s !!';
CT_ErroComuFisica   = 'Erro de comunucação física.';
CT_ErroQdadeCaracter= 'A Quantidade maxima de caracteres para este procedimento é de %s.';
CT_ValorForaFaixa   = 'O valor %s esta acima da faixa permitida!!';

CT_NomeArqConfig = 'mp20fi.ret';
CT_NomeArqStatus = 'Status.ret';

const // comandos
  CT_ReducaoZ              = #27 + '|5|' + #27;
  CT_LeituraX              = #27 + '|6|' + #27;
  CT_CancelaItemAnt        = #27 + '|13|' + #27;
  CT_CancelaCupomAnt       = #27 + '|14|' + #27;
  CT_Autenticacao          = #27 + '|16|' + #27;
  CT_HorarioVerao          = #27 + '|18|' + #27;
  CT_StatusImpressora      = #27 + '|19|' + #27;
  CT_FechaCupomSemICMS     = #27 + '|21|' + #27;

  CT_RetornaAlicota        = #27 + '|26|' + #27;

  CT_TotalizadorsParciais  = #27 + '|27|' + #27;
  CT_RetornoSubTotal       = #27 + '|29|' + #27;
  CT_NumeroCupom           = #27 + '|30|' + #27;

const
CT_00	= '00';	// Número de Série
CT_01	= '01';	// Versão do Firmware
CT_02	= '02';	// C.G.C./I.E.
CT_04	= '04';	// Cancelamentos
CT_05	= '05';	// Descontos
CT_06	= '06';	// Contador Seqüencial
CT_07	= '07';	// Núm. de operações não fiscais
CT_08	= '08';	// Núm. de Cupons cancelados
CT_09	= '09';	// Núm. de Reduções
CT_10	= '10';	// Núm. de intervenções técnicas
CT_11	= '11';	// Núm. de substituições de proprietário
CT_12	= '12';	// Núm. do Item
CT_13	= '13';	// Clichê do proprietário
CT_14	= '14';	// Núm. do Caixa
CT_15	= '15';	// Núm. da loja
CT_16	= '16';	// Moeda
CT_17	= '17';	// "Flag" fiscal
                // 0 - Cupom fiscal aberto.
                // 1 - Fechamento de formas de pagamento iniciado.
                // 2 - Horário de verão(selecionado=1).
                // 3 - Já houve redução "Z" no dia.
                // 4 - Não existe.
                // 5 - Permite cancelar cupom fiscal.
                // 6 - Não existe.
                // 7 - Memória fiscal sem espaço
CT_18	= '18';	// Minutos Ligada
CT_19	= '19';	// Minutos Imprimindo
CT_22	= '22';	// Valor pago no Cupom
CT_23	= '23';	// Data e hora da impressora.   (disponível a partir do firmware versão 2.10)
CT_24	= '24';	// Contadores dos totalizadores não sujeitos ao ICMS
CT_25	= '25';	// Descrição dos totalizadores não sujeitos ao ICMS
CT_26	= '26';	// Data da ultima redução
CT_27	= '27';	// Data do movimento
CT_28	= '28';	// Flag de Truncamento
CT_29	= '29';	// Flags de Vinculação ao ISS (Cada “bit” corresponde a um totalizador. Um “bit” setado indica vinculação ao ISS)
CT_30	= '30';	// Totalizador de acréscimos
CT_31	= '31';	// Contador de Bilhetes de passagem
CT_253	= '253';	// Tipo da impressora

type
 TVendaItens = class
   CodigoPro  : string;
   NomePro    : string;
   Tributo    : string;
   Quantidade : double;
   Valor      : double;
   DescReal   : double;
   DescPercet : double;
end;

type
  TFechaCupom = class
end;

type
    TECFBematechMP_20FI_II = class
  private
    function ValidaParametro( texto : string; QdadeCaracter : integer ) : Boolean;
    function MontaNumero( Valor : double; QdadeInteiro, QdadeFracao : integer; UsarFracaoZera : boolean  ) : string;
    function alteraDiretorio( path : string) : boolean;
    function BuscaConfig( path : string ) : string;
    function DecBinario( variavel : char ): string;


  public
    function AbrePorta( porta : string ) : Boolean;  //DLL
    function FecharPorta( porta : string ) : Boolean;                  //DLL
    procedure Imprime( Texto : string );             //DLL

    procedure AbreCupom(Texto : string);
    procedure PrgMoeda( moeda : string); //1
    procedure ReducaoZ;   //5
    procedure LeituraX;  //6
    procedure InseriAlicota( alicota : double; ICMS : Boolean); //7
    procedure LeituraMemoriaFiscalData(dataInicial, dataFinal : TDateTime); //8
    procedure LeituraMemoriaFiscalIntervalo(IntervaloInicial,IntervaloFinal : integer); //8
    procedure VendaItem( itens : TVendaItens; Decimal_2 : boolean ); //9 e 56 veificar parametros
    procedure FechaCupomFrmPag;//( dados : TFechaCupom ); //10
    procedure CancelaItemAnterior;  //13
    procedure CancelaCupomAnterior;  //14
    procedure Autenticacao;  //16
    procedure MudaHorarioVerao; //18
    procedure StatusImpressora; //19
    procedure ImpressaoNaoIcms( frase : string ); //20
    procedure FechaCupomSemICMS; //21

    function RetornaAlicotas( path : string ) : TStringList; //26
    function RetornaAlicotasICMS( path : string; ICMS : boolean ) : TStringList; //26

    procedure TotalizadoresParciais; //27
    procedure RetornoSubTotal; // 29
    function NumeroCupom( path : string ) : string;  //30
    procedure CancelamentoItemGenerico( numeroItem : integer ); //31

    procedure IniciaFechamentoCupom(Valor : double; Percentual : Boolean; Desconto : Boolean); //32
    procedure EfetuaFormaPagCupom( formaPag : string; valor : double); //33
    procedure FechaCupom( texto : TStringList); // 34
    function RetornaVariaveis( variavel : string; path : string ) : string; //35

    procedure Arredondar( arredondar : boolean ); //39

    procedure AbreComprovanteNaoFiscal( FormaPag : string); //66
    procedure MensagemComprovanteNaoFiscal( texto : string ); //67

    function VerificaFrmPag( FrmPagamento : string;  Path : string ) : string; //71
    procedure FormaPagamento( IndiceFrmPagto : string; Valor : double ); //72

end;


// Abre a porta conforme paramatro passado IniPortaStr Lib "mp20fi.dll"
// retorna 0 abertura com problemas, 1 abertura OK
function IniPortaStr(Porta:string):integer; stdcall; external 'C:\SYSTEC\Mp20fi32.dll';

//Declare Function FormataTX Lib "mp20fi.dll" (byVal BUFFER as string) as integer
// Escreve na impressora uma string passada com parametro
//  0 = Sucesso
//  1 = Erro de comunicação física.
// -2 = Parâmetro inválido.
// -3 = Versão antiga do firmware (não suporta o novo comando)
function FormataTX(BUFFER:string):integer; stdcall; external 'C:\SYSTEC\Mp20fi32.dll';

// NÃO TEM PARÂMETRO -> função nome_função:tipo_retorno_da_função
// Fecha a porta de comunicacao aberta anteriormente.
function FechaPorta: integer; stdcall; external 'C:\SYSTEC\Mp20fi32.dll';


implementation

uses constmsg, funstring, funnumeros, fundata, funBases;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 procedimentos da classe
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }


function TECFBematechMP_20FI_II.alteraDiretorio( path : string) : boolean;
begin
result := true;
try
  ChDir(path);
except
     result := false;
     AvisoFormato(CT_DiretorioInvalidoECF, [ path]);
end;
end;


function TECFBematechMP_20FI_II.BuscaConfig( path : string ) : string;
var
   Arq : TextFile;
   texto : string;
begin
   AssignFile(Arq, path + '\' + CT_NomeArqConfig);
   Reset(Arq);
   Readln(Arq, texto);
   closeFile(arq);
   result := texto;
end;

{************** decimal binario ******************************************** }
function TECFBematechMP_20FI_II.DecBinario( variavel : char ): string;
begin
  result := AdicionaCharE('0', Dec2Bin(ord(variavel)), 8);
end;


function TECFBematechMP_20FI_II.ValidaParametro( texto : string; QdadeCaracter : integer ) : Boolean;
begin
result := true;
 if length(texto) > QdadeCaracter then
 begin
   erroFormato(CT_ErroQdadeCaracter, [ IntToStr(QdadeCaracter) ]);
   result := false;
 end;
end;

function TECFBematechMP_20FI_II.MontaNumero( Valor : double; QdadeInteiro, QdadeFracao : integer; UsarFracaoZera : boolean ) : string;
var
  liberado : Boolean;
begin
liberado := true;
result := AdicionaCharE('0',intToStr(RetornaInteiro(valor)),QdadeInteiro);

if length(result) > QdadeInteiro then
begin
  ErroFormato(CT_ValorForaFaixa, [ result ] );
  abort;
end;

if RetornaFracao(valor,QdadeFracao) = 0  then
    if not UsarFracaoZera then
       liberado := false;

if liberado then
    result :=  result + AdicionaCharE('0',IntToStr(RetornaFracao(valor,QdadeFracao)), QdadeFracao);
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 Chamadas direta a DLL  - MP20FI32.DLL -
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ *********************** Verifica e  Abre a porta de comunicacao ************ }
function TECFBematechMP_20FI_II.AbrePorta( porta : string ) : Boolean;
var
   Retorno : integer;
begin
   Retorno := IniPortaStr(porta);
   result := false;
   if Retorno = 0 then
     erroFormato(CT_ErroPorta, [ porta ])
   else
     result := true;
end;

{ *********** verifica e fecha a porta de comunicacao ************************ }
function TECFBematechMP_20FI_II.FecharPorta( porta : string ) : Boolean;
var
   Retorno : integer;
begin
 Retorno := FechaPorta();
 result := false;
 if Retorno = 0 then
    ErroFormato(CT_ErroLiberaPorta, [ Porta ] )
 else
    result := true;
end;

{ ********************* Imprime string na impressora ************************ }
procedure TECFBematechMP_20FI_II.Imprime( Texto : string );
var
   Retorno : integer;
begin
   Retorno := FormataTX(texto);
   if Retorno = 1 then
      erro(CT_ErroComuFisica);
end;


{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Atividades na impressora
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }


procedure TECFBematechMP_20FI_II.AbreCupom(Texto : string);  //0
var
  frase : string;
begin
frase :=  AdicionaBrancoD(CortaString(texto, 29),29);
imprime(#27 + '|0|' + frase + '|' + #27);
end;

procedure TECFBematechMP_20FI_II.PrgMoeda( moeda : string); //1
begin
if ValidaParametro(moeda,2) then
  imprime( #27 + '|1|' + moeda + '|' + #27);
end;

procedure TECFBematechMP_20FI_II.ReducaoZ;   //5
begin
imprime(CT_ReducaoZ);
end;

procedure TECFBematechMP_20FI_II.LeituraX;  //6
begin
imprime(CT_LeituraX);
end;

procedure TECFBematechMP_20FI_II.InseriAlicota( alicota : double; ICMS : Boolean ); //7
var
  AliInt, AliFra : integer;
  ali : string;
begin
 if (alicota < 99) and ( alicota > 0 ) then
 begin
   AliInt := RetornaInteiro(alicota);
   AliFra := RetornaFracao(alicota, 2);
   Ali := AdicionaCharE('0',IntToStr(AliInt),2);
   if (alicota - aliInt) >= 0.1 then
     Ali := Ali +  AdicionaCharD('0',IntToStr(AliFra),2)
   else
     Ali := Ali +  AdicionaCharE('0',IntToStr(AliFra),2);

   if ICMS then   // vincular icms = 0, iss = 1
     imprime( #27 + '|7|' + ali + '|0|' + #27)
   else
     imprime( #27 + '|7|' + ali + '|1|' + #27)
end;
end;

procedure TECFBematechMP_20FI_II.LeituraMemoriaFiscalData(dataInicial, dataFinal : TDateTime); //8
begin
imprime(#27 + '|8|' + DataToStrFormato(DDMMAA,DataInicial,#0) + '|' +
                      DataToStrFormato(DDMMAA,DataFinal,#0) + '|I|' + #27);
end;

procedure TECFBematechMP_20FI_II.LeituraMemoriaFiscalIntervalo(IntervaloInicial,IntervaloFinal : integer); //8
begin
imprime(#27 + '|8|' + montaNumero(IntervaloInicial,4,0,false) + '|' +
                      montaNumero(IntervaloFinal,4,0,false) + '|I|' + #27);
end;


procedure TECFBematechMP_20FI_II.VendaItem( itens : TVendaItens; Decimal_2 : boolean ); //9 e 56 veificar parametros
var
  frase : string;
  valor : double;
begin
if Decimal_2 then
  frase := #27 + '|09|'
else
  frase := #27 + '|56|';
frase := frase + AdicionaBrancoE(CortaString(itens.CodigoPro, 13),13)  + '|' ;
frase := frase + AdicionaBrancoD(CortaString(Itens.NomePro, 29),29)  + '|';
frase := frase + AdicionaCharE('0',CortaString(itens.Tributo, 2),2) + '|';
frase := frase + MontaNumero(itens.Quantidade,4,3,false) + '|';
if Decimal_2 then
  frase := frase + MontaNumero(itens.Valor,6,2,true) + '|'
else
  frase := frase + MontaNumero(itens.Valor,5,3,true) + '|';

if Itens.DescReal <> 0 then
  frase := frase + MontaNumero(itens.DescReal,6,2,true) + '|'
else
  frase := frase + MontaNumero(itens.DescPercet,2,2,true) + '|';

frase := frase + #27;

imprime(frase);
end;

procedure TECFBematechMP_20FI_II.FechaCupomFrmPag;//( dados : TFechaCupom ); //10
begin
imprime(#27 + '|10|0000|00000000010000|A|Bematech - Sempre presente nas melhores soluções'+ #13#10+'|'+ #27);
end;

procedure TECFBematechMP_20FI_II.CancelaItemAnterior;  //13
begin
imprime(CT_CancelaItemAnt);
end;

procedure TECFBematechMP_20FI_II.CancelaCupomAnterior;  //14
begin
imprime(CT_CancelaCupomAnt);
end;

procedure TECFBematechMP_20FI_II.Autenticacao;  //16
begin
imprime(CT_Autenticacao);
end;

procedure TECFBematechMP_20FI_II.MudaHorarioVerao; //18
begin
imprime(CT_HorarioVerao);
end;

procedure TECFBematechMP_20FI_II.StatusImpressora; //19
begin
imprime(CT_StatusImpressora);
end;

procedure TECFBematechMP_20FI_II.ImpressaoNaoIcms( frase : string ); //20
begin
imprime(#27 + '|20|'+ frase + '|' + #13 + #27);
end;

procedure TECFBematechMP_20FI_II.FechaCupomSemICMS; //21
begin
imprime(CT_FechaCupomSemICMS);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Alicotas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

function TECFBematechMP_20FI_II.RetornaAlicotas( path : string ) : TStringList;
var
  aux : string;
  conta, laco : integer;
begin
result := TstringList.Create;
imprime(CT_RetornaAlicota);
aux := BuscaConfig(path);
conta := strToInt(copy(aux,1,2));
for laco := 0 to conta - 1 do
  result.Add(copy(aux,3+(laco*4),2) + ',' + copy(aux,5+(laco*4),2));
end;

function TECFBematechMP_20FI_II.RetornaAlicotasICMS( path : string; ICMS : boolean ) : TStringList; //26
var
  aux : TStringList;
  laco : integer;
  ISSVinc, flagICMS : string;
begin
result := TStringList.Create;
aux := RetornaAlicotas( path );
ISSVinc := RetornaVariaveis(CT_29, path);
FlagICMS := '0';
if not ICMS then
  flagICMS := '1';
for laco := 0 to aux.Count - 1 do
  if ISSVinc[laco+1] = FlagICMS then
    result.Add('T' + AdicionaCharE('0',IntTostr(laco + 1),2) + ' - ' + aux.Strings[laco] + '%');
end;



{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((}


procedure TECFBematechMP_20FI_II.TotalizadoresParciais; //27
begin
imprime(CT_TotalizadorsParciais);
end;

procedure TECFBematechMP_20FI_II.RetornoSubTotal;
begin
imprime(CT_RetornoSubTotal);
end;

function TECFBematechMP_20FI_II.NumeroCupom( path : string ) : string; //30
begin
imprime(CT_NumeroCupom);
result := BuscaConfig(path);
end;

procedure TECFBematechMP_20FI_II.CancelamentoItemGenerico( numeroItem : integer ); //31
begin
imprime(#27 + '|31|' + AdicionaCharE('0',IntToStr(numeroItem),4) + '|' + #27);
end;

procedure TECFBematechMP_20FI_II.IniciaFechamentoCupom(Valor : double; Percentual : Boolean; Desconto : Boolean); //32
var
  frase : string;
begin
frase := #27 + '|32|';

if percentual then
begin
 if desconto then
    frase := frase + 'D|'
 else
    frase := frase + 'A|';
 frase := frase + MontaNumero(Valor,2,2,false) + '|';
end
else
begin
 if desconto then
    frase := frase + 'd|'
 else
    frase := frase + 'a|';
 frase := frase + MontaNumero(Valor,12,2,false) + '|'
end;
frase := frase +  #27;
imprime(frase);
end;

procedure TECFBematechMP_20FI_II.EfetuaFormaPagCupom( formaPag : string; valor : double); //33
var
  frase : string;
begin
frase := #27 + '|33|' + CortaString(formaPag, 22) + '|';
frase := frase + montaNumero(valor,12,2,true) + '|' + #27;
imprime(frase);
end;

procedure TECFBematechMP_20FI_II.FechaCupom( texto : TStringList); // 34
var
  aux : string;
  laco : integer;
begin
for laco := 0 to texto.Count - 1 do
  aux := aux + texto.Strings[laco] + #13 + #10;

imprime(#27 + '|34|' + aux + '|' + #27);
end;

function TECFBematechMP_20FI_II.RetornaVariaveis( variavel : string; Path  : string ) : string; //35
begin
result := '';
if alteraDiretorio(path) then
begin
  imprime(#27 + '|35|' + variavel + '|' + #27);
  result := BuscaConfig(path);

   if variavel = '17' then
    if result <> '' then
      result := DecBinario(result[1])
    else
      result := '00000000';

   if variavel = '29' then
     if result <> '' then
     begin
        if length(result) = 1 then
        begin
           result := DecBinario(result[1]);
           result := result + '00000000';
        end
        else
        begin
           result := DecBinario(result[1]);
           result := result + DecBinario(result[2])
        end
      end
     else
        result := '0000000000000000';
end;
end;

procedure TECFBematechMP_20FI_II.Arredondar( arredondar : boolean ); //39
begin
if arredondar then
  imprime(#27 + '|39|1|' + #27)
else
  imprime(#27 + '|39|0|' + #27);
end;

procedure TECFBematechMP_20FI_II.AbreComprovanteNaoFiscal( FormaPag : string); //66
begin
imprime(#27 + '|66|' + AdicionaBrancoD(CortaString(FormaPag, 16),16) + '|' + #27);
end;

procedure TECFBematechMP_20FI_II.MensagemComprovanteNaoFiscal( texto : string ); //67
begin
imprime( #27 + '|67|' + CortaString(texto, 48) + '|'+ #27);
end;

function TECFBematechMP_20FI_II.VerificaFrmPag( FrmPagamento : string; Path : string ) : string; //71
begin
imprime( #27 + '|71|' + AdicionaBrancoD(CortaString(FrmPagamento,16),16) + '|' + #27);
result := BuscaConfig(path);
end;



procedure TECFBematechMP_20FI_II.FormaPagamento( IndiceFrmPagto : string; Valor : double ); //72
begin
imprime( #27 + '|72|' + indiceFrmPagto + '|' +
        MontaNumero(valor,12,2,true) + '|' + #27 );
end;

end.
