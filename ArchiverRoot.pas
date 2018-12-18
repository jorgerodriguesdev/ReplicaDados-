unit ArchiverRoot;
{
  TArchiver by Morgan Martinet (C) 1998 - mmm@imaginet.fr or mmm@mcom.fr

  COPYRIGHT
  ---------

  This component is email-ware. You may use it, distribute it and modify it, but
  you may not charge for it. Please send me a mail if you use it, I'll be happy
  to see in which country it is used, and I'll be able to mail you the updates.

  In case of modifications you must mail me a copy of the modifications.
  The reason are simple: Any changes that improve this free-ware component should
  be to benefit for everybody, not only you. That way you can be pretty sure,
  that this component has few errors and much functionality.
  In case of modifications, you will be on the credits list beneath.

  DESCRIPTION
  -----------

  This component lets you add/extract files to/from an archive.

}

interface

uses
  Windows,
  SysUtils,
  Classes,
  ArchiverMisc;

const
  kVersion = 1;
  kMaxCryptBuffer = 8;
  kMinKeySize = 10;
  kDefaultExt = '.mmm';

type
  TUserData = packed record
    UserName         : String[20];
    Company          : String[20];
    SerialNumber     : String[20];
    BackupName       : String[20];
    Date             : TDateTime;
    ProductId        : Integer;
    ProductVersion   : Integer;
    Free             : array [0..31] of Byte; // Free space for you
  end;
  PUserData = ^TUserData;

  TArchiveSize = Extended;
  TFileSize = Integer;

  TDataInfo = packed record
    FileCount      : Integer;
    Size           : TArchiveSize;
    CompressedSize : TArchiveSize;
  end;

  TArchiveFlag = set of (afCrypted, afCompressed, afSolid, afReadOnly, afFinalSegment);

  TArchiveHeader = packed record
    Signature             : Integer;
    Version               : Integer;
    RandomID              : Integer; // Used to check the segments
    BlockSize             : Integer;
    EndOffset             : Integer;
    Segment               : Word;
    ArchiveFlag           : TArchiveFlag;
    ArchiveInfo           : TDataInfo; // Infos about the whole archive
    SegmentInfo           : TDataInfo; // Infos about the current segment only
    UserData              : TUserData;
    Reserved              : array [0..63] of Byte;
    Comment               : String;
  end;

  TFileInfo = packed record
    Size            : Integer;
    CompressedSize  : Integer;
  end;

  TFileFlag = set of (ffFile, ffEmptyFolder, ffFinalSegment, ffCrypted, ffPatch);

  TFileEntry = packed record
    Name             : String;
    Date             : TDateTime;
    Attr             : Integer;
    Segment          : Word;       // First segment containing this file
    Offset           : Integer;    // Offset to the file in the current segment
    FileOffset       : Integer;    // Offset in the source file beeing archived
    FileFlag         : TFileFlag;
    ArchiveInfo      : TFileInfo;  // Informations for the whole file stored in the archive
    SegmentInfo      : TFileInfo;  // Informations on the part of this file stored in the current segment
  end;
  PFileEntry = ^TFileEntry;

  TFileObject = class
  public
    FileEntry : TFileEntry;
    DirectoryIndex : Integer;    // Used only by WinArchiver
    ImageIndex : Integer;        // Used only by WinArchiver
    StateIndex : Integer;        // Used only by WinArchiver
    Tag : Integer;               // Free for your own use
  end;

  TErrorAction = (eaContinue, eaAbort, eaAsk);
  TOperation = (opNone, opAdd, opExtract, opEnumerate, opDelete, opMakeSFX, opCheck);
  TInternalOperationEnum = (ioCompressingStream, ioUncompressingStream,
                            ioSkippingStream, ioSwappingSegment,
                            ioOpening, ioClosing, ioOpenSolid, ioCloseSolid,
                            ioEnumAfterOpen);
  TInternalOperation = set of TInternalOperationEnum;
  TOption = (oStoreEmptyFolders, oShowEmptyFolders, oCreateReadOnly,
             oCreateSolidArchives, oCompress, oCrypt, oEraseFirstDisk,
             oEraseNewDisk, oConfirmFileDeletion, oEnumerateAfterOpen,
             oIncludeStartingDirectory, oRecurseFolders, oOpenSingleSegment,
             oRestorePath, oSecureAccess, oWriteSFXCode, oEncryptFiles,
             oMaintainFileDirectory, oNoSpanning);

  TOptions = set of TOption;
  TLanguage = (lgAutomatic, lgEnglish, lgFrench, lgChinese, lgPortuguese,
               lgGerman, lgItalian, lgRussian, lgSpanish);

  TMySelectDirOpt = (sdAllowCreate, sdPerformCreate, sdPrompt);
  TMySelectDirOpts = set of TMySelectDirOpt;

  TOnFileProgressEvent      = procedure ( Sender : TObject; Percent : Integer ) of Object;
  TOnErrorEvent             = procedure ( Sender : TObject; E : Exception; const FileEntry : TFileEntry;
                                          var ErrorAction : TErrorAction ) of Object;
  TOnAcceptArchiveEvent     = procedure ( Sender : TObject; const Header : TArchiveHeader; var Accept : Boolean ) of Object;
  TOnWriteUserDataEvent     = procedure ( Sender : TObject; var UserData : TUserData ) of Object;
  TOnEnterCryptKeyEvent     = procedure ( Sender : TObject; var Key : String ) of Object;
  TOnRequestCryptKeyEvent   = procedure ( Sender : TObject; var Key : String ) of Object;
  TOnGetSignatureEvent      = procedure ( Sender : TObject; var Signature : Integer ) of Object;
  TOnShowCommentEvent       = procedure ( Sender : TObject; const Comment : String ) of Object;
  TOnShowTimingEvent        = procedure ( Sender : TObject; ElapsedTime, RemainingTime : TDateTime ) of Object;
  TOnDisplayMessageEvent    = procedure ( Sender : TObject; const msg : String ) of Object;
  TOnAddToLogEvent          = procedure ( Sender : TObject; const msg : String ) of Object;

  EArchiver = class( Exception );

  TMessages = class(TPersistent)
    protected
      FLanguage : TLanguage;
      FBadSignature : String;
      FFileNameNeeded : String;
      FSystemMessage : String;
      FAcceptArchiveFailed : String;
      FEnterCryptKey : String;
      FEnterDecryptKey : String;
      FKeyTooShort : String;
      FConfirmCryptKey : String;
      FKeyNotConfirmed : String;
      FArchiveIsReadOnly : String;
      FCanNotCreateArchive : String;
      FCannotCreateDir : String;
      FSelectADirectory : String;
      FOk : String;
      FCancel : String;
      FInformation : String;
      FWarning : String;
      FConfirmation : String;
      FError : String;
      FCanNotBuildTempFileName : String;
      FYes : String;
      FYesToAll : String;
      FNo : String;
      FFile : String;
      FCanContinue : String;
      FUnknownVersion : String;

      procedure AssignTo(Dest: TPersistent); override;
      procedure PropSetLanguage( language : TLanguage );
      procedure SetLanguage( language : TLanguage ); virtual;
      procedure SetGlobalStrings; virtual;

    public
      constructor Create;

      property Language : TLanguage read FLanguage write PropSetLanguage;

    published
      property BadSignature : String read FBadSignature write FBadSignature;
      property FileNameNeeded : String read FFileNameNeeded write FFileNameNeeded;
      property SystemMessage : String read FSystemMessage write FSystemMessage;
      property AcceptArchiveFailed : String read FAcceptArchiveFailed write FAcceptArchiveFailed;
      property EnterCryptKey : String read FEnterCryptKey write FEnterCryptKey;
      property EnterDecryptKey : String read FEnterDecryptKey write FEnterDecryptKey;
      property KeyTooShort : String read FKeyTooShort write FKeyTooShort;
      property ConfirmCryptKey : String read FConfirmCryptKey write FConfirmCryptKey;
      property KeyNotConfirmed : String read FKeyNotConfirmed write FKeyNotConfirmed;
      property ArchiveIsReadOnly : String read FArchiveIsReadOnly write FArchiveIsReadOnly;
      property CanNotCreateArchive : String read FCanNotCreateArchive write FCanNotCreateArchive;
      property CannotCreateDir : String read FCannotCreateDir write FCannotCreateDir;
      property SelectADirectory : String read FSelectADirectory write FSelectADirectory;
      property Ok : String read FOk write FOk;
      property Cancel : String read FCancel write FCancel;
      property Information : String read FInformation write FInformation;
      property Warning : String read FWarning write FWarning;
      property Confirmation : String read FConfirmation write FConfirmation;
      property Error : String read FError write FError;
      property CanNotBuildTempFileName : String read FCanNotBuildTempFileName write FCanNotBuildTempFileName;
      property Yes : String read FYes write FYes;
      property YesToAll : String read FYesToAll write FYesToAll;
      property No : String read FNo write FNo;
      property AFile : String read FFile write FFile;
      property CanContinue : String read FCanContinue write FCanContinue;
      property UnknownVersion : String read FUnknownVersion write FUnknownVersion;
    end;

  TArchiverRoot = class( TComponent )
  protected
    FHeader : TArchiveHeader;
    FFileName : String;
    FStream : TStream;
    FFilter : String;
    FBytesToProcess : TArchiveSize; // Used for calculating a progress ratio
    FBytesProcessed : TArchiveSize; // Used for calculating a progress ratio
    FPercent : Integer; // progress ratio
    FStartCount : Integer;     // Number of call of the Start/Finish methods
    FBlockSize : Integer;
    FSrcBlock : PChar;
    FDestBlock : PChar;
    FErrorAction : TErrorAction;
    FCurrentFileEntry : TFileEntry;
    FCurrentFileIdx : Integer;
    FOperation : TOperation;
    FMessages : TMessages;
    FMaxSegmentSize : Integer;
    FCheckAvailableSpace : Boolean;
    FInternalOperation : TInternalOperation;
    FArchiveDrive : String;
    FArchiveName : String;
    FArchiveDir : String;
    FArchiveExt : String;
    FCompressedArchiveSize : TArchiveSize; // Used for progress
    FIsOpen : Boolean;
    FCryptKey : String;
    FReadOnly : Boolean;
    FStartOffset : Integer;
    FOptions : TOptions;
    FOldFileName : String;
    FOldOptions : TOptions;
    FOldMaxSegmentSize : Integer;
    FSegmentNeeded : Integer;
    FSFXCodeSize : Integer;
    FIsSolidArchive : Boolean;
    FTmpFileDate : TDateTime;
    FAlwaysContinue : Boolean;
    FFiles : TList;
    FArchiveChanged : Boolean;
    FMustAbort : Boolean;
    // Timing informations
    FStartTime : TDateTime;
    FEndTime : TDateTime;
    FBytesPerMSec : Extended;
    FLastTicks : Integer;
    FTotTicks : Integer;

    // Events
    FOnFileProgress : TOnFileProgressEvent;
    FOnStartOperation : TNotifyEvent;
    FOnFinishOperation : TNotifyEvent;
    FOnError : TOnErrorEvent;
    FOnAcceptArchive : TOnAcceptArchiveEvent;
    FOnWriteUserData : TOnWriteUserDataEvent;
    FOnEnterCryptKey : TOnEnterCryptKeyEvent;
    FOnRequestCryptKey : TOnRequestCryptKeyEvent;
    FOnBeforeOpen : TNotifyEvent;
    FOnAfterOpen : TNotifyEvent;
    FOnBeforeClose : TNotifyEvent;
    FOnAfterClose : TNotifyEvent;
    FOnGetSignature : TOnGetSignatureEvent;
    FOnAfterHeaderUpdate : TNotifyEvent;
    FOnShowComment : TOnShowCommentEvent;
    FOnShowTiming : TOnShowTimingEvent;
    FOnDisplayMessage : TOnDisplayMessageEvent;
    FOnClearFileList : TNotifyEvent;
    FOnAddToLog : TOnAddToLogEvent;

    function  CreateMessages : TMessages; virtual;
    function  GetSignature : Integer; virtual;
    function  GetHeaderSize : Integer; virtual;
    procedure WriteHeader; virtual;
    procedure ReadHeader;
    function  ReadHeaderOfFile( const fileName : String; var AHeader : TArchiveHeader ) : Boolean;
    function  ReadHeaderOfStream( S : TStream; var AHeader : TArchiveHeader ) : Boolean; virtual;
    procedure CheckOpen;
    function  GetDirectorySize( const dir : String ) : Integer;
    procedure Start; virtual;
    procedure Finish; virtual;
    procedure UpdateProgress;
    procedure InitCompression; virtual;
    procedure InitCrypting; virtual;
    procedure EnterCryptKey; virtual;
    procedure RequestCryptKey; virtual;
    function  GetMinKeySize : Integer; virtual;
    procedure SetBlockSize( val : Integer );
    procedure AllocBlocks;
    procedure DeallocBlocks;
    function  CanContinue( E : Exception ) : Boolean;
    function  NeededBlockSize : Integer; virtual;
    function  GetLanguage : TLanguage;
    procedure SetLanguage( val : TLanguage );
    procedure SetMessages( val : TMessages );
    procedure SetFileName( const val : String );
    procedure ExplodeFileName;
    function  GetFileEntrySize( const fileEntry : TFileEntry ) : Integer;
    procedure WriteFileEntry( var fileEntry : TFileEntry );
    procedure ReadFileEntry( var fileEntry : TFileEntry );
    function  IsRemovableDisk( const drive : String ) : Boolean;
    function  GetSegmentName( segment : Word ) : String;
    procedure CreateStream;
    procedure OpenStream;
    procedure CloseStream;
    procedure CheckReadOnly;
    procedure CheckKey;
    procedure BeforeOpen; virtual;
    procedure AfterOpen; virtual;
    procedure BeforeClose; virtual;
    procedure AfterClose; virtual;
    procedure AfterUpdate; virtual;
    function  GetTempFileName : String;
    procedure GetProgressInformations; virtual;
    procedure CreateArchive; virtual;
    function  GetOpenMode : Integer; virtual;
    function  RequestSpace( val : Integer ) :  Boolean; virtual;
    function  CheckEOF : Boolean; virtual;
    function  SelectDirectory(var Directory: string; Options: TMySelectDirOpts; HelpCtx: Longint):Boolean; virtual;
    procedure ForceDirectories(Dir: string);
    function  SelectFile( const Title : String; var FileName : String ) : Boolean; virtual;
    function  MessageDlg( const Msg: string; DlgType: TMyMsgDlgType;
                          Buttons: TMyMsgDlgButtons; HelpCtx: Longint): Integer; virtual;
    function  InputQuery(const ACaption, APrompt: string; var AValue: string): Boolean; virtual;
    function  QueryPassword(const ACaption, APrompt: string; var AValue: string): Boolean; virtual;
    function  GetStartOffset : Integer;
    procedure CheckSFX( const aFileName : String ); virtual;
    procedure Loaded; override;
    procedure OpenSolidData; virtual;
    procedure CloseSolidData; virtual;
    procedure StartTimer;
    procedure StopTimer;
    procedure ShowTiming;
    function  GetElapsedTime : TDateTime;
    procedure DisplayMessage( const msg : String );
    procedure AddToLog( const msg : String );
    procedure CopyStream( Src, Dest : TStream; trapExceptions : Boolean );
    function  CopyFile( const srcName, destName : String; failIfExists, trapExceptions : Boolean ) : Boolean;
    procedure ClearFiles;
    procedure AddFileToList( const entry : TFileEntry );
    function  GetFiles( idx : Integer ) : TFileObject;
    function  GetFileCount : Integer;
    procedure AdjustArchiveSize;

  public
    // Creators & Destructor
    constructor Create( AOwner : TComponent ); override;
    destructor  Destroy; override;

    // Public methods

    // Open/close Archive
    procedure Open;
    procedure CreateTempFile;
    procedure Close;
    function  Reset : Boolean;
    function  Delete : Boolean;
    function  Rename( const NewName : String ) : Boolean;

    // Misc methods
    function  IsStreamOpen : Boolean;
    function  DeleteDirectory( const dir : String ) : Boolean;
    function  DeleteDriveContent( const drive : String ) : Boolean;
    function  IsSegmented : Boolean;
    function  IsEmpty : Boolean;
    function  IsBusy : Boolean;
    function  IndexOfFile( const FileName : String ) : Integer;
    function  CanAbort : Boolean;
    procedure RequestAbort;

    // Public properties
    property ArchiveDrive : String read FArchiveDrive;
    property ArchiveName : String read FArchiveName;
    property ArchiveDir : String read FArchiveDir;
    property ArchiveExt : String read FArchiveExt;
    property CheckAvailableSpace : Boolean read FCheckAvailableSpace write FCheckAvailableSpace;
    property CurrentFileEntry : TFileEntry read FCurrentFileEntry;
    property Operation : TOperation read FOperation;
    property Stream : TStream read FStream;
    property Header : TArchiveHeader read FHeader;
    property IsOpen : Boolean read FIsOpen write FIsOpen;
    property ReadOnly : Boolean read FReadOnly;
    property StartOffset : Integer read FStartOffset write FStartOffset;
    property SFXCodeSize : Integer read FSFXCodeSize write FSFXCodeSize;
    property IsSolidArchive : Boolean read FIsSolidArchive;
    property ElapsedTime : TDateTime read GetElapsedTime;
    property StartTime : TDateTime read FStartTime;
    property EndTime : TDateTime read FEndTime;
    property BytesPerMSec : Extended read FBytesPerMSec;
    property BytesToProcess : TArchiveSize read FBytesToProcess;
    property BytesProcessed : TArchiveSize read FBytesProcessed;
    property Percent : Integer read FPercent;
    property FileCount : Integer read GetFileCount;
    property Files[ idx : Integer ] : TFileObject read GetFiles;
    property ArchiveChanged : Boolean read FArchiveChanged;
    property MinKeySize : Integer read GetMinKeySize;

  published
    // Properties
    property BlockSize : Integer read FBlockSize write SetBlockSize;
    property ErrorAction : TErrorAction read FErrorAction write FErrorAction;
    property FileName : String read FFileName write SetFileName;
    property Filter : String read FFilter write FFilter;
    property Language : TLanguage read GetLanguage write SetLanguage;
    property Messages : TMessages read FMessages write SetMessages;
    property Options : TOptions read FOptions write FOptions;
     // Events
    property OnAcceptArchive : TOnAcceptArchiveEvent read FOnAcceptArchive write FOnAcceptArchive;
    property OnWriteUserData : TOnWriteUserDataEvent read FOnWriteUserData write FOnWriteUserData;
    property OnError : TOnErrorEvent read FOnError write FOnError;
    property OnFileProgress : TOnFileProgressEvent read FOnFileProgress write FOnFileProgress;
    property OnFinishOperation : TNotifyEvent read FOnFinishOperation write FOnFinishOperation;
    property OnStartOperation : TNotifyEvent read FOnStartOperation write FOnStartOperation;
    property OnEnterCryptKey : TOnEnterCryptKeyEvent read FOnEnterCryptKey write FOnEnterCryptKey;
    property OnRequestCryptKey : TOnRequestCryptKeyEvent read FOnRequestCryptKey write FOnRequestCryptKey;
    property OnBeforeOpen : TNotifyEvent read FOnBeforeOpen write FOnBeforeOpen;
    property OnAfterOpen : TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnBeforeClose : TNotifyEvent read FOnBeforeClose write FOnBeforeClose;
    property OnAfterClose : TNotifyEvent read FOnAfterClose write FOnAfterClose;
    property OnGetSignature : TOnGetSignatureEvent read FOnGetSignature write FOnGetSignature;
    property OnAfterHeaderUpdate : TNotifyEvent read FOnAfterHeaderUpdate write FOnAfterHeaderUpdate;
    property OnShowComment : TOnShowCommentEvent read FOnShowComment write FOnShowComment;
    property OnShowTiming : TOnShowTimingEvent read FOnShowTiming write FOnShowTiming;
    property OnDisplayMessage : TOnDisplayMessageEvent read FOnDisplayMessage write FOnDisplayMessage;
    property OnClearFileList : TNotifyEvent read FOnClearFileList write FOnClearFileList;
    property OnAddToLog : TOnAddToLogEvent read FOnAddToLog write FOnAddToLog;
  end;

  function  GetUserLanguage : TLanguage;

implementation


function  GetUserLanguage : TLanguage;
var
  xLanguage : Integer;
begin
  xLanguage := (LoWord(GetUserDefaultLangID) and $3ff);
  case xLanguage of
    LANG_GERMAN    : Result := lgGerman;
    LANG_ENGLISH   : Result := lgEnglish;
    LANG_SPANISH   : Result := lgSpanish;
    LANG_RUSSIAN   : Result := lgRussian;
    LANG_ITALIAN   : Result := lgItalian;
    LANG_FRENCH    : Result := lgFrench;
    LANG_PORTUGUESE: Result := lgPortuguese;
    LANG_CHINESE:    Result := lgChinese;
  else
                     Result := lgEnglish;
  end;
end;

////////////////////////////////////////////////////////////

procedure TMessages.AssignTo(Dest: TPersistent);
begin
  if Dest is TMessages then
    with TMessages( Dest ) do begin
      FBadSignature        := Self.FBadSignature;
      FFileNameNeeded      := Self.FFileNameNeeded;
      FSystemMessage       := Self.FSystemMessage;
      FAcceptArchiveFailed := Self.FAcceptArchiveFailed;
      FEnterCryptKey       := Self.FEnterCryptKey;
      FEnterDecryptKey     := Self.FEnterDecryptKey;
      FArchiveIsReadOnly   := Self.FArchiveIsReadOnly;
      FKeyTooShort         := Self.FKeyTooShort;
      FConfirmCryptKey     := Self.FConfirmCryptKey;
      FKeyNotConfirmed     := Self.FKeyNotConfirmed;
      FCanNotCreateArchive := Self.FCanNotCreateArchive;
      FCannotCreateDir     := Self.FCannotCreateDir;
      FSelectADirectory    := Self.FSelectADirectory;
      FOk                  := Self.FOK;
      FCancel              := Self.FCancel;
      FInformation         := Self.FInformation;
      FWarning             := Self.FWarning;
      FConfirmation        := Self.FConfirmation;
      FError               := Self.FError;
      FCanNotBuildTempFileName := Self.FCanNotBuildTempFileName;
      FYes                     := Self.FYes;
      FYesToAll                := Self.FYesToAll;
      FNo                      := Self.FNo;
      FFile                    := Self.FFile;
      FCanContinue             := Self.FCanContinue;
      FUnknownVersion          := Self.FUnknownVersion;
    end;
  SetGlobalStrings;
  inherited AssignTo( Dest );
end;

constructor TMessages.Create;
begin
  inherited;
  Language := lgAutomatic;
end;

procedure TMessages.PropSetLanguage( language : TLanguage );
begin
  SetLanguage( language );
  SetGlobalStrings;
end;

procedure TMessages.SetLanguage( language : TLanguage );
var
  lang : TLanguage;
begin
  FLanguage := language;
  if FLanguage = lgAutomatic then
    lang := GetUserLanguage
  else
    lang := FLanguage;
  case lang of
    lgEnglish:
      begin
        FBadSignature := 'Bad signature: file "%s" is not a valid archive';
        FFileNameNeeded := '"Archiver" needs property "FileName"';
        FSystemMessage := 'System Message';
        FAcceptArchiveFailed := 'This archive can not be used';
        FEnterCryptKey := 'Enter the encrypt key:';
        FEnterDecryptKey := 'Enter the decrypt key:';
        FArchiveIsReadOnly := 'Archive is ReadOnly';
        FKeyTooShort := 'The key is too short. It must contain %d chars at least.';
        FConfirmCryptKey := 'Confirm the encrypt key:';
        FKeyNotConfirmed := 'The key could not be confirmed. Enter it again.';
        FCanNotCreateArchive := 'This component can not create an archive';
        FCannotCreateDir := 'Can not create directory';
        FSelectADirectory := 'Select a directory:';
        FOk := 'OK';
        FCancel := 'Cancel';
        FInformation := 'Information';
        FWarning := 'Warning';
        FConfirmation := 'Confirmation';
        FError := 'Error';
        FCanNotBuildTempFileName := 'Can not build a temporary FileName';
        FYes := '&Yes';
        FYesToAll := 'Yes to &All';
        FNo := '&No';
        FFile := 'File';
        FCanContinue := 'Do you want to continue ?';
        FUnknownVersion := 'Unknown version';
      end;
    lgFrench:
      begin
        FBadSignature := 'Mauvaise signature: le fichier "%s" n''est pas une archive valide';
        FFileNameNeeded := '"Archiver" n�cessite la propri�t� "FileName"';
        FSystemMessage := 'Message syst�me';
        FAcceptArchiveFailed := 'Cette archive ne peut �tre utilis�e';
        FEnterCryptKey := 'Saisissez la cl� de cryptage:';
        FEnterDecryptKey := 'Saisissez la cl� de d�cryptage:';
        FArchiveIsReadOnly := 'L''Archive est en lecture seule';
        FKeyTooShort := 'La cl� est trop courte. Elle doit contenir au moins %d caract�res.';
        FConfirmCryptKey := 'Confirmez la cl� de cryptage:';
        FKeyNotConfirmed := 'La cl� n''a pas pu �tre confirm�e. Resaisissez-la.';
        FCanNotCreateArchive := 'Ce composant ne peut pas cr�er d''archives';
        FCannotCreateDir := 'Impossible de cr�er le r�pertoire';
        FSelectADirectory := 'S�lectionnez un r�pertoire:';
        FOk := 'OK';
        FCancel := 'Annuler';
        FInformation := 'Information';
        FWarning := 'Avertissement';
        FConfirmation := 'Confirmation';
        FError := 'Erreur';
        FCanNotBuildTempFileName := 'Impossible de construire un nom de fichier temporaire';
        FYes := '&Oui';
        FYesToAll := 'Oui � &Tout';
        FNo := '&Non';
        FFile := 'Fichier';
        FCanContinue := 'Voulez-vous continuer ?';
        FUnknownVersion := 'Version inconnue';
      end;
    lgChinese:
      begin
        // Traditional Chinese constants (in BIG-5 code).
        FBadSignature := '�L�k�ѧO: �ɮ� "%s" ���O�@�Ӧ��Ī����Y�ɡC';
        FSystemMessage := '�t�ΰT��';
        FFileNameNeeded := '"Archiver" �ݭn�]�w "FileName" �ݩʡC';
        FAcceptArchiveFailed := '�����Y�ɵL�k�ϥΡC';
        FEnterCryptKey := '��J�[�K���:';
        FEnterDecryptKey := '��J�ѱK���:';
        FArchiveIsReadOnly := '���Y�ɬ���Ū�C';
        FKeyTooShort := '��Ȫ����צܤ֭n�� %d �Ӧr���C';
        FConfirmCryptKey := '�T�{�[�K���:';
        FKeyNotConfirmed := '��J����ȩM�T�{����Ȥ��P, �Э��s��J�C';
        FCanNotCreateArchive := '�L�k�إ����Y��';
        FCannotCreateDir := '�L�k�إ߸�Ƨ�';
        FSelectADirectory := '��ܸ�Ƨ�:';
        FOk := '�T�w';
        FCancel := '����';
        FInformation := '�T��';
        FWarning := 'ĵ�i';
        FConfirmation := '�T�{';
        FError := '���~';
        FCanNotBuildTempFileName := '�L�k�إ߼Ȧs�ɦW';
        FYes := '�O(&Y)';
        FYesToAll := '�����ҬO(&A)';
        FNo := '�_(&N)';
        FFile := '�ɮ�';
        FCanContinue := '�z�O�_�n�~��?';
        FUnknownVersion := '�L�k�o���������X';
      end;
    lgPortuguese:
      begin
        // If it looks strange do not change. It's designed for page 850
        FBadSignature := 'Assinatura incorreta: arquivo "%s" n�o � v�lido.';
        FFileNameNeeded := '"Archiver" necessita a propriedade "FileName"';
        FSystemMessage := 'Mensagem do Sistema';
        FAcceptArchiveFailed := 'Este arquivo est� inutilizado!';
        FEnterCryptKey := 'Digite a chave de encripta��o:';
        FEnterDecryptKey := 'Digite a chave de desencripta��o:';
        FArchiveIsReadOnly := 'Arquivo com atributo Somente Leitura';
        FKeyTooShort := 'Senha muito curta. Utilizar, pelo menos, %d caracteres.';
        FConfirmCryptKey := 'Confirme a senha:';
        FKeyNotConfirmed := 'Senha n�o pode ser confirmada. Digite novamente.';
        FCanNotCreateArchive := 'Este componente n�o pode criar o arquivo';
        FCannotCreateDir := 'Imposs�vel criar diretorio';
        FSelectADirectory := 'Selecione um diretorio:';
        FOk := 'OK';
        FCancel := 'Cancelar';
        FInformation := 'Informa��o';
        FWarning := 'Alerta';
        FConfirmation := 'Confirma��o';
        FError := 'Erro';
        FCanNotBuildTempFileName := 'Impossivel criar "FileName" tempor�rio';
        FYes := '&Sim';
        FYesToAll := 'Sim para &Todos';
        FNo := '&N�o';
        FFile := 'Arquivo';
        FCanContinue := 'Deseja continuar ?';
        FUnknownVersion := 'Vers�o desconhecida';
      end;
    lgGerman:
      begin
        FBadSignature := 'Falsche Signatur: Die Datei "%s" ist kein Archiv';
        FFileNameNeeded := '"Archiver" ben�tigt die Eigenschaft "FileName"';
        FSystemMessage := 'System Nachricht';
        FAcceptArchiveFailed := 'Dieses Archiv kann nicht gelesen werden';
        FEnterCryptKey := 'Bitte geben sie das Passwort zum verschl�sseln ein:';
        FEnterDecryptKey := 'Bitte geben Sie das Passwort zum entschl�sseln ein:';
        FArchiveIsReadOnly := 'Das Archiv ist Schreibgesch�tzt';
        FKeyTooShort := 'Das Passwort ist zu kurz. Es mu� aus mindestens %d Zeichen bestehen.';
        FConfirmCryptKey := 'Wiederholung des Passwortes:';
        FKeyNotConfirmed := 'Das Passwort konnte nicht best�tigt werden. Bitte geben Sie das Passwort erneut ein.';
        FCanNotCreateArchive := 'Dieses Komponente kann kein Archiv erstellen';
        FCannotCreateDir := 'Fehler beim Erstellen des Verzeichnisses';
        FSelectADirectory := 'W�hlen Sie ein Verzeichnis:';
        FOk := 'OK';
        FCancel := 'Abbruch';
        FInformation := 'Information';
        FWarning := 'Warnung';
        FConfirmation := 'Best�tigung';
        FError := 'Fehler';
        FCanNotBuildTempFileName := 'Die tempor�re Datei kann nicht erstellt werden.';
        FYes := '&Ja';
        FYesToAll := '&Immer Ja';
        FNo := '&Nein';
        FFile := 'Datei';
        FCanContinue := 'M�chten Sie fortfahren?';
        FUnknownVersion := 'Unbekannte Version';
      end;
    lgItalian: // Thanks to Gabriele Bigliardi (gbigliardi@manord.com)
      begin
        FBadSignature := 'Bad signature: file "%s" non � un archivio valido';
        FFileNameNeeded := '"Archiver" deve avere la propriet� "FileName"';
        FSystemMessage := 'Messaggio di sistema';
        FAcceptArchiveFailed := 'Questo archivio non pu� essere usato';
        FEnterCryptKey := 'Digitare la encrypt key:';
        FEnterDecryptKey := 'Digitare la decrypt key:';
        FArchiveIsReadOnly := 'Archivio in sola lettura';
        FKeyTooShort := 'La chiave � troppo corta. Deve contenere almeno %d caratteri';
        FConfirmCryptKey := 'Confermare la encrypt key:';
        FKeyNotConfirmed := 'La chiave non pu� essere confermata. Ridigitarla.';
        FCanNotCreateArchive := 'Questo componente non pu� creare un archivio';
        FCannotCreateDir := 'Non si riesce a creare una directory';
        FSelectADirectory := 'Selezionare una directory:';
        FOk := 'OK';
        FCancel := 'Annulla';
        FInformation := 'Informazione';
        FWarning := 'Attenzione';
        FConfirmation := 'Conferma';
        FError := 'Errore';
        FCanNotBuildTempFileName := 'Non si riesce a creare un nome file temporaneo';
        FYes := '&Si';
        FYesToAll := 'Si a &Tutti';
        FNo := '&No';
        FFile := 'File';
        FCanContinue := 'Vuoi continuare ?';
        FUnknownVersion := 'Versione sconosciuta';
      end;
    lgRussian:  {Windows 1251}
      begin
        FBadSignature := '�������� ���������: ���� "%s" �� �������� �������';
        FFileNameNeeded := '"Archiver" ������� �������� "FileName"';
        FSystemMessage := '��������� �������';
        FAcceptArchiveFailed := '������ ����� �� ����� ���� �����������';
        FEnterCryptKey := '������� ���������� ����:';
        FEnterDecryptKey := '������� ������������ ����:';
        FArchiveIsReadOnly := '����� ������ ��� ������ (������ ������)';
        FKeyTooShort := '������� �������� ����. ���� ������ ��������� �� ����� %d ��������.';
        FConfirmCryptKey := '����������� ���������� ����:';
        FKeyNotConfirmed := '���� �� �����������. ��������� �����.';
        FCanNotCreateArchive := '���� ��������� �� ����� ������� ������';
        FCannotCreateDir := '�� ���� ������� �������';
        FSelectADirectory := '�������� �������:';
        FOk := 'OK';
        FCancel := '��������';
        FInformation := '����������';
        FWarning := '��������';
        FConfirmation := '�������������';
        FError := '������';
        FCanNotBuildTempFileName := '�� ���� ��������� ��� ���������� �����';
        FYes := '&��';
        FYesToAll := '�� ��� ��&��';
        FNo := '&���';
        FFile := '����';
        FCanContinue := '������ ���������� ?';
        FUnknownVersion := '����������� ������';
      end;
    lgSpanish:
      begin
        FBadSignature := 'Firma Erronea: el archivo "%s" no es valido';
        FFileNameNeeded := '"Archiver" necesita la propiedad "FileName"';
        FSystemMessage := 'Mensaje de Sistema';
        FAcceptArchiveFailed := 'El archivo no puede usarse';
        FEnterCryptKey := 'Clave de encriptamiento:';
        FEnterDecryptKey := 'Clave de desencripci�n:';
        FArchiveIsReadOnly := 'Archivo con atributo de solo lectura';
        FKeyTooShort := 'La clave es muy corta. Debe contener almenos %d caracteres.';
        FConfirmCryptKey := 'Confirma clave de encripci�n:';
        FKeyNotConfirmed := 'La clave no se confirmo. Introducela de nuevo.';
        FCanNotCreateArchive := 'Este componente no puede crear un archivo';
        FCannotCreateDir := 'No puedo crear el directorio';
        FSelectADirectory := 'Seleccione un directorio:';
        FOk := 'Aceptar';
        FCancel := 'Cancelar';
        FInformation := 'Informaci�n';
        FWarning := 'Advertencia';
        FConfirmation := 'Confirmaci�n';
        FError := 'Error';
        FCanNotBuildTempFileName := 'No puedo construir archivo temporal';
        FYes := '&Si';
        FYesToAll := 'Si a &Todo';
        FNo := '&No';
        FFile := 'Archivo';
        FCanContinue := '� Desea continuar ?';
        FUnknownVersion := 'Versi�n desconocida';
      end;
  end;
end;

procedure TMessages.SetGlobalStrings;
begin
  strOK           := Ok;
  strCancel       := Cancel;
  strInformation  := Information;
  strWarning      := Warning;
  strConfirmation := Confirmation;
  strError        := Error;
  strYes          := FYes;
  strYesToAll     := FYesToAll;
  strNo           := FNo;
  strFile         := FFile;
  strCanContinue  := FCanContinue;
end;


////////////////////////////////////////////////////////////
// Protected section

function  TArchiverRoot.CreateMessages : TMessages;
begin
  Result := TMessages.Create;
end;

function  TArchiverRoot.GetSignature : Integer;
begin
  Result := $1238;
  if Assigned(FOnGetSignature) then
    FOnGetSignature( Self, Result );
end;

function TArchiverRoot.GetHeaderSize : Integer;
begin
  Result := sizeof(Integer)   + // Signature
            sizeof(Integer)   + // Version
            sizeof(Integer)   + // RandomID
            sizeof(Integer)   + // BlockSize
            sizeof(Integer)   + // EndOffset
            sizeof(Integer)   + // Segment
            sizeof(Boolean)   + // Crypted
            sizeof(TDataInfo) + // ArchiveInfo
            sizeof(TDataInfo) + // SegmentInfo
            sizeof(TUserData) + // User DataBuffer
            sizeof(FHeader.Reserved) + // Reserved area for future use
            Length(FHeader.Comment)+sizeof(Integer); // Archive comment
end;

procedure TArchiverRoot.WriteHeader;
var
  extra : Integer;
  tmp : TDataInfo;
begin
  FStream.Seek( GetStartOffset, soFromBeginning );
  // Add 1 to the segment file count if a file is beeing written
  if ioCompressingStream in FInternalOperation then
    extra := 1
  else
    extra := 0;
  with FHeader do
    begin
      WriteInteger( FStream, GetSignature );
      WriteInteger( FStream, Version );
      WriteInteger( FStream, RandomID );
      WriteInteger( FStream, BlockSize );
      WriteInteger( FStream, EndOffset );
      WriteInteger( FStream, Segment );
      FStream.WriteBuffer( ArchiveFlag, sizeof(ArchiveFlag) );
      FStream.WriteBuffer( ArchiveInfo, sizeof(ArchiveInfo) );
      // We add 1 to the FileCount of a segment if a file is beeing written
      tmp := SegmentInfo;
      Inc( tmp.FileCount, extra );
      FStream.WriteBuffer( tmp, sizeof(tmp) );
      FillChar( UserData, sizeof(UserData), 0 );
      if Assigned(FOnWriteUserData) then
        FOnWriteUserData( Self, UserData );
      FStream.WriteBuffer( UserData, sizeof(UserData) );
      FStream.WriteBuffer( Reserved, sizeof(Reserved) );
      WriteString( FStream, Comment );
    end;
  AfterUpdate;
end;

procedure TArchiverRoot.ReadHeader;
begin
  FStream.Seek( GetStartOffset, soFromBeginning );
  if not ReadHeaderOfStream( FStream, FHeader ) then
    raise EArchiver.CreateFmt( Messages.BadSignature, [FFileName] );
  if FHeader.Version > kVersion then
    raise Exception.Create( Messages.UnknownVersion );
end;

function TArchiverRoot.ReadHeaderOfFile( const fileName : String; var AHeader : TArchiveHeader ) : Boolean;
var
  S : TStream;
begin
  if not FileExists( fileName ) then
    begin
      Result := False;
      Exit;
    end;
  try
    S := TFileStream.Create( fileName, fmOpenRead or fmShareDenyWrite );
    try
      CheckSFX( fileName );
      S.Position := GetStartOffset;
      Result := ReadHeaderOfStream( S, AHeader );
    finally
      S.Free;
    end;
  except
    Result := False;
  end;
end;

function TArchiverRoot.ReadHeaderOfStream( S : TStream; var AHeader : TArchiveHeader ) : Boolean;
begin
  Result := True;
  with AHeader do
    begin
      fillchar( AHeader, sizeof(AHeader), 0 );
      Signature := ReadInteger( S );
      if Signature <> GetSignature then
        begin
          Result := False;
          Exit;
        end;
      Version               := ReadInteger( S );
      RandomID              := ReadInteger( S );
      BlockSize             := ReadInteger( S );
      EndOffset             := ReadInteger( S );
      Segment               := ReadInteger( S );
      S.ReadBuffer( ArchiveFlag, sizeof(ArchiveFlag) );
      S.ReadBuffer( ArchiveInfo, sizeof(ArchiveInfo) );
      S.ReadBuffer( SegmentInfo, sizeof(SegmentInfo) );
      S.ReadBuffer( UserData, sizeof(UserData) );
      S.ReadBuffer( Reserved, sizeof(Reserved) );
      Comment := ReadString( S );
    end;
end;

procedure TArchiverRoot.CheckOpen;
begin
  if not IsOpen then
    Open
  else if not IsStreamOpen then
    OpenStream;
end;

function  TArchiverRoot.GetDirectorySize( const dir : String ) : Integer;
  function DoCalcSize( const dir, path : String ) : Integer;
  var
    SR : TSearchRec;
    Found : Integer;
    source : String;
  begin
    Result := 0;
    source := dir + path;
    if not DirectoryExists(source) then
      Exit;
    try
      Result := 0;
      // First look at files
      Found := FindFirst( source+'\'+Filter, faAnyFile, SR );
      try
        while Found = 0  do
          begin
            if (SR.Name <> '.') and (SR.Name <> '..') then
              begin
                if (SR.Attr and faDirectory) = 0 then
                   begin
                    // Add file
                    Inc( Result, SR.Size );
                  end;
              end;
            Found := FindNext( SR );
          end;
      finally
        FindClose(SR);
      end;
      // Then look at folders
      if oRecurseFolders in Options then
        begin
          Found := FindFirst( source+'\*.*', faDirectory, SR );
          try
            while Found = 0  do
              begin
                if (SR.Name <> '.') and (SR.Name <> '..') then
                  begin
                    if (SR.Attr and faDirectory) <> 0 then
                       Result := result + DoCalcSize( dir, path+'\'+SR.Name );
                  end;
                Found := FindNext( SR );
              end;
          finally
            FindClose(SR);
          end;
        end;
    except
    end;
  end;

begin
  Result := DoCalcSize( RemoveSlash(dir), '' );
end;

function TArchiverRoot.DeleteDirectory( const dir : String ) : Boolean;

  procedure DoDeleteDirectory( const dir, path : String; var Result : Boolean );
  var
    SR : TSearchRec;
    Found : Integer;
    source : String;
  begin
    if not Result or not DirectoryExists( dir ) then
      Exit;

    source := dir + path;
    // Remove the files in the directory
    Found := FindFirst( source+'\*.*', faAnyFile, SR );
    try
      while Result and (Found = 0)  do
        begin
          if (SR.Name<>'.') and (SR.Name <> '..') then
            begin
              if (SR.Attr and faDirectory) <> 0 then
                begin
                  DoDeleteDirectory( dir, path+'\'+SR.Name, Result );
                end
              else
                begin
                  // Remove attributes that could prevent us from deleting the file
                  FileSetAttr( source+'\'+SR.Name, FileGetAttr(source+'\'+SR.Name) and
                                                   not (faReadOnly or faHidden) );
                  // Delete file
                  if not DeleteFile( source+'\'+SR.Name ) then
                    Result := False;
                end;
            end;
          Found := FindNext( SR );
        end;
    finally
      FindClose(SR);
    end;
    if Result then
      // Delete the empty directory
      Result := Result and RemoveDir( source );
  end;
begin
  Result := True;
  DoDeleteDirectory( RemoveSlash(dir), '', Result );
end;

procedure TArchiverRoot.Start;
begin
  Inc(FStartCount);
  if FStartCount = 1 then
    begin
      FMustAbort := False;
      FBytesToProcess := 0;
      FBytesProcessed := 0;
      FCurrentFileIdx := 0;
      FAlwaysContinue := False;
      FStartTime := Now;
      FTotTicks := 0;
      StartTimer;
      try
        AllocBlocks;
        if Assigned(FOnStartOperation) then
          FOnStartOperation( Self );
        UpdateProgress;
      except
        Finish;
        raise;
      end;
    end;
end;

procedure TArchiverRoot.Finish;
begin
  if FStartCount = 0 then
    Exit;
  Dec(FStartCount);
  if FStartCount = 0 then
    begin
      DeallocBlocks;
      FEndTime := Now;
      StopTimer;
      if Assigned(FOnFinishOperation) then
        FOnFinishOperation( Self );
      FBytesToProcess := 0;
      FOperation := opNone;
      if not(afCrypted in FHeader.ArchiveFlag) then
        FCryptKey := '';
    end;
end;

procedure TArchiverRoot.UpdateProgress;
begin
  // Check if abortion was requested
  if FMustAbort then
    Abort;
  // Calc ratio
  if oOpenSingleSegment in Options then
    begin
      if FHeader.SegmentInfo.FileCount > 0 then
        FPercent := Round( FCurrentFileIdx / FHeader.SegmentInfo.FileCount * 100 )
      else
        FPercent := 0;
    end
  else
    begin
      if FBytesToProcess > 0 then
        FPercent := Round( FBytesProcessed / FBytesToProcess * 100 )
      else
        FPercent := 0;
    end;
  if (ioOpenSolid in FInternalOperation) then
    FPercent := FPercent div 2
  else if (ioEnumAfterOpen in FInternalOperation) then
    FPercent := 50 + (FPercent div 2);
  if Assigned( FOnFileProgress ) then
    FOnFileProgress( Self, FPercent );
  ShowTiming;
end;

procedure TArchiverRoot.InitCompression;
begin
end;

procedure TArchiverRoot.InitCrypting;
begin
  // Do nothing special. It will be overriden in the subclasses.
end;

procedure TArchiverRoot.EnterCryptKey;
var
  ConfirmCryptKey : String;
begin
  StopTimer;
  FCryptKey := '';
  if Assigned(FOnEnterCryptKey) then
    FOnEnterCryptKey( Self, FCryptKey )
  else
    repeat
      // Ask a key until it is confirmed
      repeat
        // Ask a key until there's enough chars
        if not QueryPassword( Messages.SystemMessage, Messages.EnterCryptKey, FCryptKey ) then
          Abort;
        if Length(FCryptKey) < GetMinKeySize then
          MessageDlg( Format(Messages.KeyTooShort, [GetMinKeySize]), mtWarning, [mbOk], 0 );
      until Length(FCryptKey) >= GetMinKeySize;
      // Ask a confirmation of the key
      ConfirmCryptKey := '';
      if not QueryPassword( Messages.SystemMessage, Messages.ConfirmCryptKey, ConfirmCryptKey ) then
        Abort;
      if ConfirmCryptKey <> FCryptKey then
        begin
          MessageDlg( Messages.KeyNotConfirmed, mtWarning, [mbOk], 0 );
          FCryptKey := '';
        end;
    until ConfirmCryptKey = FCryptKey;
  StartTimer;
end;

procedure TArchiverRoot.RequestCryptKey;
begin
  StopTimer;
  FCryptKey := '';
  if Assigned(FOnRequestCryptKey) then
    FOnRequestCryptKey( Self, FCryptKey )
  else
    begin
      if not QueryPassword( Messages.SystemMessage, Messages.EnterDecryptKey, FCryptKey ) then
        Abort;
    end;
  StartTimer;
end;

function  TArchiverRoot.GetMinKeySize : Integer;
begin
  Result := kMinKeySize;
end;

procedure TArchiverRoot.SetBlockSize( val : Integer );
begin
  if (val <> FBlockSize) and (val >= 1024) then
    begin
      FBlockSize := val;
    end;
end;

procedure TArchiverRoot.AllocBlocks;
begin
  DeallocBlocks;
  GetMem( FSrcBlock, NeededBlockSize );
  GetMem( FDestBlock, NeededBlockSize);
end;

procedure TArchiverRoot.DeallocBlocks;
begin
  if Assigned( FSrcBlock ) then
    begin
      FreeMem( FSrcBlock );
      FSrcBlock := nil;
    end;
  if Assigned( FDestBlock ) then
    begin
      FreeMem( FDestBlock );
      FDestBlock := nil;
    end;
end;

function TArchiverRoot.CanContinue( E : Exception ) : Boolean;

  function Ask : Boolean;
  var
    id : Integer;
  begin
    if FAlwaysContinue then
      begin
        Result := True;
        Exit;
      end;
    StopTimer;
    id := QueryContinue( E.Message, AdjustPath(FCurrentFileEntry.Name, 50),
                         FCurrentFileEntry.ArchiveInfo.Size,
                         FCurrentFileEntry.Date );
    StartTimer;
    FAlwaysContinue := (id = 102); // 102 = button "Yes to all"
    Result := (id = mrYes) or FAlwaysContinue;
  end;

var
  errorAction : TErrorAction;
begin
  Result := False;
  errorAction := FErrorAction;
  if Assigned( FOnError ) then
    FOnError( Self, E, FCurrentFileEntry, errorAction );
  case errorAction of
    eaContinue:  Result := True;
    eaAbort:     Result := False;
    eaAsk:       Result := Ask;
  end;
  if Result then
    FBytesProcessed := FBytesProcessed + FCurrentFileEntry.ArchiveInfo.Size;
end;

function  TArchiverRoot.NeededBlockSize : Integer;
begin
  Result := FHeader.BlockSize;
end;

function TArchiverRoot.GetLanguage : TLanguage;
begin
  Result := FMessages.Language;
end;

procedure TArchiverRoot.SetLanguage( val : TLanguage );
begin
  if val <> FMessages.Language then
    begin
      FMessages.Language := val;
    end;
end;

procedure TArchiverRoot.SetMessages( val : TMessages );
begin
  FMessages.Assign( val );
end;

procedure TArchiverRoot.SetFileName( const val : String );
begin
  if val <> FFileName then
    begin
      Close;
      FFileName := val;
      ExplodeFileName;
    end;
end;

procedure TArchiverRoot.ExplodeFileName;
var
  i : Integer;
begin
  // Prepare Archive drive, name, dir, ext
  FArchiveDrive := ExtractFileDrive( FFileName );
  FArchiveDir   := AppendSlash( ExtractFileDir( FFileName ) );
  if Length(FArchiveDrive) > 0 then
    System.Delete( FArchiveDir, 1, Length(FarchiveDrive) );
  FArchiveExt   := ExtractFileExt( FFileName );
  FArchiveName  := ExtractFileName( FFileName );
  // Remove extension
  if (Length(FArchiveExt) > 0) and (Length(FArchiveName) > 0) then
  System.Delete( FArchiveName, Length(FArchiveName)-Length(FArchiveExt)+1, Length(FArchiveExt) );
  // Remove Segment number attached to the name
  i := Length(FArchiveName);
  if i = 0 then
    Exit;
  while (i>0) and (FArchiveName[i] in ['0'..'9']) do
    Dec(i);
  if (i>0) and (FArchiveName[i] = '-') then
    begin
      System.Delete( FArchiveName, i, Length(FArchiveName) );
    end;
end;

function TArchiverRoot.GetFileEntrySize( const fileEntry : TFileEntry ) : Integer;
begin
  with fileEntry do
    Result := (Length(Name)+Sizeof(Integer)) + // Name
              sizeof(Extended)    +  // Date
              sizeof(Integer)     +  // Attr
              sizeof(Word)        +  // Segment
              sizeof(Integer)     +  // Offset
              sizeof(Integer)     +  // File Offset
              sizeof(Boolean)     +  // FinalSegment
              sizeof(ArchiveInfo) +  // ArchiveInfo
              sizeof(SegmentInfo) ;  // SegmentInfo
end;

procedure TArchiverRoot.WriteFileEntry( var fileEntry : TFileEntry );
begin
  RequestSpace( GetFileEntrySize( fileEntry ) );
  with fileEntry do
    begin
      Offset := FStream.Position - GetStartOffset;
      WriteString( FStream, Name );
      WriteFloat( FStream, Date );
      WriteInteger( FStream, Attr );
      WriteWord( FStream, Segment );
      WriteInteger( FStream, Offset );
      WriteInteger( FStream, FileOffset );
      FStream.WriteBuffer( FileFlag, sizeof(FileFlag) );
      FStream.WriteBuffer( ArchiveInfo, sizeof(ArchiveInfo) );
      FStream.WriteBuffer( SegmentInfo, sizeof(SegmentInfo) );
    end;
end;

procedure TArchiverRoot.ReadFileEntry( var fileEntry : TFileEntry );
begin
  CheckEOF;
  with fileEntry do
    begin
      Name := ReadString( FStream );
      Date := ReadFloat( FStream );
      Attr := ReadInteger( FStream );
      Segment := ReadWord( FStream );
      Offset := ReadInteger( FStream );
      FileOffset := ReadInteger( FStream );
      FStream.ReadBuffer( FileFlag, sizeof(FileFlag) );
      FStream.ReadBuffer( ArchiveInfo, sizeof(ArchiveInfo) );
      FStream.ReadBuffer( SegmentInfo, sizeof(SegmentInfo) );
    end;
end;

function TArchiverRoot.IsRemovableDisk( const drive : String ) : Boolean;
begin
  Result := GetDriveType(PChar(drive)) = DRIVE_REMOVABLE;
end;

function  TArchiverRoot.GetSegmentName( segment : Word ) : String;
var
  count : String;
begin
  if segment = 1 then
    Result := Format('%s%s%s%s', [FArchiveDrive, FArchiveDir, FArchiveName, FArchiveExt])
  else
    begin
      count := IntToStr(segment);
      while Length(count) < 3 do
        Insert( '0', count, 1 );
      Result := Format('%s%s%s-%s%s', [FArchiveDrive, FArchiveDir, FArchiveName, count, kDefaultExt]);
    end;
  FSegmentNeeded := segment;
end;

procedure TArchiverRoot.CreateStream;
begin
  CloseStream;
  ForceDirectories( ExtractFilePath( FileName ) );
  CheckSFX( FileName );
  FStream := TFileStream.Create( FileName, fmCreate );
  WriteHeader;
  FCurrentFileIdx := 0;
  FReadOnly := False;
end;

procedure TArchiverRoot.OpenStream;
var
  mode : Integer;
begin
  CloseStream;
  CheckSFX( FileName );
  FReadOnly := (FileGetAttr( FileName ) and faReadOnly) <> 0;
  if FReadOnly then
    mode := fmOpenRead or fmShareDenyWrite
  else
    mode := GetOpenMode;
  try
    // Try to open the file with the selected mode
    FStream := TFileStream.Create( FileName, mode );
  except
    // If we're already in ReadOnly, then just raise again the exception
    if FReadOnly then
      raise;
    // If we could not open, then try again in ReadOnly mode
    mode := fmOpenRead or fmShareDenyWrite;
    FReadOnly := True;
    FStream := TFileStream.Create( FileName, mode );
  end;
  try
    ReadHeader;
    FCurrentFileIdx := 0;
  except
    CloseStream;
    raise;
  end;
end;

procedure TArchiverRoot.CloseStream;
begin
  if Assigned( FStream ) then
    begin
      if (oCreateReadOnly in Options) and
         not(afReadOnly in FHeader.ArchiveFlag) then
        begin
          Include( FHeader.ArchiveFlag, afReadOnly );
          WriteHeader;
        end;

      FStream.Free;
      FStream := nil;
    end;
end;

procedure TArchiverRoot.CheckReadOnly;
begin
  if ReadOnly or (afReadOnly in FHeader.ArchiveFlag) then
    raise EArchiver.Create( Messages.ArchiveIsReadOnly );
end;

procedure TArchiverRoot.CheckKey;
begin
  if FCryptKey <> '' then
    Exit;
  if FOperation = opAdd then
    EnterCryptKey
  else if FOperation in [opExtract, opCheck] then
    RequestCryptKey;
end;

procedure TArchiverRoot.BeforeOpen;
begin
  ClearFiles;
  FOldFileName := FileName;
  FOldOptions := FOptions;
  FOldMaxSegmentSize := FMaxSegmentSize;
  if Assigned(FOnBeforeOpen) then
    FOnBeforeOpen( Self );
end;

procedure TArchiverRoot.AfterOpen;
begin
  if Assigned(FOnAfterOpen) then
    FOnAfterOpen( Self );
end;

procedure TArchiverRoot.BeforeClose;
begin
  if Assigned(FOnBeforeClose) then
    FOnBeforeClose( Self );
end;

procedure TArchiverRoot.AfterClose;
begin
  if oCreateSolidArchives in FOldOptions then
    begin
      FOptions := FOldOptions;
      FFileName := FOldFileName;
      FMaxSegmentSize := FOldMaxSegmentSize;
      ExplodeFileName;
    end;
  ClearFiles;
  if not(csDestroying in ComponentState) and Assigned(FOnAfterClose) then
    FOnAfterClose( Self );
end;

procedure TArchiverRoot.AfterUpdate;
begin
  if Assigned(FOnAfterHeaderUpdate) then
    FOnAfterHeaderUpdate( Self );
end;

function TArchiverRoot.GetTempFileName : String;
var
  TmpPath : String;
  number : Integer;
  count : Integer;
begin
  count := 0;
  TmpPath := GetTempDir;
  number := GetTickCount;
  repeat
    if count > 1000 then
      raise Exception.Create( Messages.CanNotBuildTempFileName );
    Inc(number);
    Inc(count);
    Result :=  Format('%s~Archiv-%x.tmp', [TmpPath, number]);
  until not FileExists(Result);
end;

procedure TArchiverRoot.GetProgressInformations;
begin
  // Will be overriden in TCustomExtractor
end;

procedure TArchiverRoot.CreateArchive;
begin
  raise EArchiver.Create( Messages.CanNotCreateArchive );
end;

function  TArchiverRoot.GetOpenMode : Integer;
begin
  Result := 0;
end;

function  TArchiverRoot.RequestSpace( val : Integer ) :  Boolean;
begin
  // This function will be overriden in TCustomArchiver
  Result := True;
end;

function  TArchiverRoot.CheckEOF : Boolean;
begin
  // This function will be overriden in TCustomExtractor
  Result := False;
end;

function  TArchiverRoot.SelectDirectory(var Directory: string; Options: TMySelectDirOpts; HelpCtx: Longint):Boolean;
begin
  Result := InputQuery( Messages.SystemMessage, Messages.SelectADirectory, Directory );
end;

// Copied from unit FileCtrl.pas
procedure TArchiverRoot.ForceDirectories(Dir: string);

  function LastChar( const s : String ) : Char;
  begin
    if Length(s) > 0 then
      Result := s[Length(s)]
    else
      Result := #0;
  end;

begin
  if Length(Dir) = 0 then
    raise Exception.Create(Messages.CannotCreateDir);
  if LastChar(Dir) = '\' then
    System.Delete(Dir, Length(Dir), 1);
  if (Length(Dir) < 3) or DirectoryExists(Dir)
    or (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
  ForceDirectories(ExtractFilePath(Dir));
  CreateDir(Dir);
end;

function  TArchiverRoot.SelectFile( const Title : String; var FileName : String ) : Boolean;
begin
  Result := InputQuery( Messages.SystemMessage, Title, FileName );
end;

function TArchiverRoot.MessageDlg( const Msg: string; DlgType: TMyMsgDlgType;
                                   Buttons: TMyMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  Result := ArchiverMisc.MessageDlg( Msg, DlgType, Buttons, HelpCtx );
end;

function TArchiverRoot.InputQuery(const ACaption, APrompt: string; var AValue: string): Boolean;
begin
  Result := ArchiverMisc.InputQuery( ACaption, APrompt, AValue );
end;

function TArchiverRoot.QueryPassword(const ACaption, APrompt: string; var AValue: string): Boolean;
begin
  Result := ArchiverMisc.QueryPassword( ACaption, APrompt, AValue );
end;

function  TArchiverRoot.GetStartOffset : Integer;
begin
  if (FSegmentNeeded = 1) or (SFXCodeSize > 0) then
    Result := StartOffset
  else
    Result := 0;
end;

procedure TArchiverRoot.CheckSFX( const aFileName : String );
begin
  if SFXCodeSize > 0 then
    begin
      if IsExeFile( aFileName ) then
        StartOffset := SFXCodeSize
      else
        StartOffset := 0;
    end;
end;

procedure TArchiverRoot.Loaded;
begin
  inherited;
  // if we choosed the automatic language, then set it again
  // in order to force the selection of the strings according
  // to the user language. Otherwise the message strings are stored
  // in the .dfm
  if Language = lgAutomatic then
    begin
      Language := lgEnglish;
      Language := lgAutomatic;
    end;

end;

procedure TArchiverRoot.OpenSolidData;
begin
end;

procedure TArchiverRoot.CloseSolidData;
begin
end;

procedure TArchiverRoot.StartTimer;
begin
  FLastTicks := GetTickCount;
end;

procedure TArchiverRoot.StopTimer;
var
  tmp : Integer;
begin
  tmp := GetTickCount;
  Inc( FTotTicks, tmp - FLastTicks );
  if FTotTicks > 0 then
    FBytesPerMSec := FBytesProcessed / FTotTicks
  else
    FBytesPerMSec := FBytesProcessed;
  FLastTicks := tmp;
end;

procedure TArchiverRoot.ShowTiming;
var
  remainingTime : TDateTime;
  remainingMSec : Extended;
begin
  StopTimer;
  if (FBytesPerMSec <> 0) and (FBytesToProcess > FBytesProcessed) then
    remainingMSec := (FBytesToProcess - FBytesProcessed) / FBytesPerMSec
  else
    remainingMSec := 0;
  remainingTime := MSecsAsTime( Round(remainingMSec) );
  if Assigned( FOnShowTiming ) then
    FOnShowTiming( Self, ElapsedTime, remainingTime );
  StartTimer;
end;

function TArchiverRoot.GetElapsedTime : TDateTime;
begin
  Result := MSecsAsTime( FTotTicks );
end;

procedure TArchiverRoot.DisplayMessage( const msg : String );
begin
  if Assigned( FOnDisplayMessage ) then
    FOnDisplayMessage( Self, msg );
end;

procedure TArchiverRoot.AddToLog( const msg : String );
begin
  if Assigned( FOnAddToLog ) then
    FOnAddToLog( Self, msg );
end;

procedure TArchiverRoot.CopyStream( Src, Dest : TStream; trapExceptions : Boolean );
const
  kBuffSize = 32 * 1024;
var
  buffer : PChar;
  bytes : Integer;
begin
  GetMem( buffer, kBuffSize );
  try
    Start;
    try
      Src.Position := 0;
      FBytesToProcess := Src.Size - Src.Position;
      FBytesProcessed := 0;
      FTotTicks := 0;
      StartTimer;
      while Src.Position < Src.Size do
        begin
          bytes := Min( kBuffSize, Src.Size - Src.Position );
          Src.ReadBuffer( buffer^, bytes );
          Dest.WriteBuffer( buffer^, bytes );
          FBytesProcessed := FBytesProcessed + bytes;
          try
            UpdateProgress;
          except
            if not trapExceptions then
              raise;
          end;
        end;
    finally
      Finish;
    end;
  finally
    FreeMem( buffer );
  end;
end;

function TArchiverRoot.CopyFile( const srcName, destName : String;
                                 failIfExists, trapExceptions : Boolean ) : Boolean;
var
  Src, Dest : TFileStream;
begin
  Result := False;
  if FileExists(destName) then
    begin
      if failIfExists then
        Exit
      else
        DeleteFile(destName);
    end;
  Src := TFileStream.Create( srcName, fmOpenRead or fmShareDenyWrite );
  try
    Dest := TFileStream.Create( destName, fmCreate );
    try
      CopyStream( Src, Dest, trapExceptions );
      Result := True;
    finally
      Dest.Free;
    end;
  finally
    Src.Free;
  end;
end;

procedure TArchiverRoot.ClearFiles;
var
  i : Integer;
begin
  for i := 0 to FFiles.Count - 1 do
    TObject(FFiles.Items[i]).Free;
  FFiles.Clear;
  if not(csDestroying in ComponentState) and Assigned( FOnClearFileList ) then
    FOnClearFileList( Self );
end;

procedure TArchiverRoot.AddFileToList( const entry : TFileEntry );
var
  fo : TFileObject;
begin
  if not(oMaintainFileDirectory in FOptions) then
    Exit;
  fo := TFileObject.Create;
  fo.FileEntry := entry;
  FFiles.Add( fo );
end;

function TArchiverRoot.GetFiles( idx : Integer ) : TFileObject;
begin
  Result := TFileObject(FFiles.Items[idx]);
end;

function TArchiverRoot.GetFileCount : Integer;
begin
  Result := FFiles.Count;
end;

function TArchiverRoot.IndexOfFile( const FileName : String ) : Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to FileCount - 1 do
    with Files[i] do
      if CompareStr( FileEntry.Name, FileName ) = 0 then
        begin
          Result := i;
          Break;
        end;
end;

procedure TArchiverRoot.AdjustArchiveSize;
begin
  if (Operation in [opExtract, opEnumerate, opCheck]) and
     (FHeader.ArchiveInfo.CompressedSize > FCompressedArchiveSize) then
    begin
      if FBytesToProcess = FCompressedArchiveSize then
        FBytesToProcess := FHeader.ArchiveInfo.CompressedSize;
      FCompressedArchiveSize := FHeader.ArchiveInfo.CompressedSize;
      UpdateProgress;
    end;
end;

///////////////////////////////////////////////////////
// Public methods

constructor TArchiverRoot.Create( AOwner : TComponent );
begin
  inherited;
  FFilter := '*.*';
  FBlockSize := 1024 * 64;
  FErrorAction := eaAsk;
  FOperation := opNone;
  FMessages := CreateMessages;
  FCheckAvailableSpace := True;
  FInternalOperation := [];
  FIsOpen := False;
  FCryptKey := '';
  FStartOffset := 0;
  FOptions := [oStoreEmptyFolders, oCompress, oRecurseFolders, oRestorePath,
               oSecureAccess, oEraseNewDisk, oConfirmFileDeletion];
  InitCompression;
  InitCrypting;
  FFiles := TList.Create;
end;

destructor  TArchiverRoot.Destroy;
begin
  Close;
  FMessages.Free;
  ClearFiles;
  FFiles.Free;
  inherited;
end;

function  TArchiverRoot.IsStreamOpen : Boolean;
begin
  Result := Assigned(FStream);
end;

function TArchiverRoot.IsSegmented : Boolean;
begin
  with FHeader do
    Result := not(afFinalSegment in FHeader.ArchiveFlag) or (Segment > 1);
end;

function TArchiverRoot.IsEmpty : Boolean;
begin
  Result := (FHeader.ArchiveInfo.FileCount + FHeader.SegmentInfo.FileCount) = 0;
end;

function TArchiverRoot.IsBusy : Boolean;
begin
  Result := FStartCount > 0;
end;

function TArchiverRoot.DeleteDriveContent( const drive : String ) : Boolean;
var
  SR : TSearchRec;
  Found : Integer;
  path : String;
begin
  Result := True;
  path := UpperCase( RemoveSlash( ExtractFileDrive(drive) ) );
  if not IsRemovableDisk( path ) then
    Exit;
  // Remove the files in the directory
  Found := FindFirst( path+'\*.*', faAnyFile, SR );
  try
    while Result and (Found = 0)  do
    begin
      if (SR.Name<>'.') and (SR.Name <> '..') then
      begin
        if (SR.Attr and faDirectory) <> 0 then
          // Delete subdirectory
          Result := Result and DeleteDirectory( path+'\'+SR.Name )
        else
        begin
          // Remove attributes that could prevent us from deleting the file
          FileSetAttr( path+'\'+SR.Name, FileGetAttr(path+'\'+SR.Name) and
                                           not (faReadOnly or faHidden) );
          // Delete file
          Result := DeleteFile( path+'\'+SR.Name );
        end;
      end;
      Found := FindNext( SR );
    end;
  finally
    FindClose(SR);
  end;
end;

procedure TArchiverRoot.Open;
var
  accept : Boolean;
begin
  if IsStreamOpen then
    Exit;
  if IsOpen then
    begin
      // If Archive is open, but the current segment is closed,
      // certainly because of an exception during swapping of the segment,
      // then we try to reopen the last opened segment.
      FFileName := GetSegmentName( FHeader.Segment );
      OpenStream;
      Exit;
    end;
  Include( FInternalOperation, ioOpening );
  try
    FArchiveChanged := False;
    FSegmentNeeded := 1;
    BeforeOpen;
    if FileName = '' then
      raise EArchiver.Create( Messages.FileNameNeeded );
    if not FileExists( FileName ) then
      CreateArchive
    else
      begin
        OpenStream;
      end;
    accept := True;
    try
      if Assigned(FOnAcceptArchive) then
        FOnAcceptArchive( Self, FHeader, accept );
      if not accept then
        raise EArchiver.Create( Messages.AcceptArchiveFailed );
      GetProgressInformations;
      FIsOpen := True;
      AllocBlocks;
      AfterOpen;
    except
      Close;
      raise;
    end;
  finally
    Exclude( FInternalOperation, ioOpening );
  end;
end;

procedure TArchiverRoot.CreateTempFile;
begin
  Close;
  FileName := GetTempFileName;
  FCheckAvailableSpace := False; // Don't check free space when creating a temporay file
  Open;
end;

procedure TArchiverRoot.Close;
begin
  Include( FInternalOperation, ioClosing );
  try
    if IsOpen then
      begin
        BeforeClose;
        CloseStream;
        FCryptKey := '';
        FIsOpen := False;
        AfterClose;
      end
    else
      CloseStream;
  finally
    Exclude( FInternalOperation, ioClosing );
  end;
end;

function TArchiverRoot.Reset : Boolean;
var
  tmp : String;
begin
  tmp := GetSegmentName( 1 );
  Result := Delete;
  FileName := tmp;
  if Result then
    Open;
end;

function TArchiverRoot.Delete : Boolean;
var
  tmp : String;
begin
  Result := False;
  tmp := FFileName;
  if IsSolidArchive then
    tmp := FOldFileName;
  Close;
  if FileExists( tmp ) then
     Result := DeleteFile( tmp )
end;

function TArchiverRoot.Rename( const NewName : String ) : Boolean;
begin
  Result := False;
  if FileExists( NewName ) then
    Exit;
  if not IsOpen then
    Exit;
  CloseStream;
  Result := RenameFile( FFileName, NewName );
  if Result then
    begin
      FFileName := NewName;
      ExplodeFileName;
    end;
  OpenStream;
end;

function TArchiverRoot.CanAbort : Boolean;
begin
  Result := not (ioCloseSolid in FInternalOperation);
end;

procedure TArchiverRoot.RequestAbort;
begin
  if CanAbort then
    FMustAbort := True;
end;

end.


