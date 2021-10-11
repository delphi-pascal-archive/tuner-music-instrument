{
 Эта программа распространяется в надежде, что она будет полезной,
  но БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ; даже без подразумеваемых гарантий
  КОММЕРЧЕСКОЙ ЦЕННОСТИ или ПРИГОДНОСТИ ДЛЯ КОНКРЕТНОЙ ЦЕЛИ. Для
  получения подробных сведений смотрите Универсальную Общественную
  Лицензию (GNU GPL)
}

unit TNLib;

interface

uses SysUtils, Classes, MMSystem, Windows, Forms;

type
  EDirectXError = class(Exception);

  {  TCustomWaveStream  }

  TCustomWaveStream = class(TStream)
  private
    FPosition: Integer;
  protected
    function GetFilledSize: Integer; virtual;
    function GetFormat: PWaveFormatEx; virtual; abstract;
    function GetFormatSize: Integer; virtual;
    function GetSize: Integer; virtual;
    function ReadWave(var Buffer; Count: DWORD): DWORD; virtual;
    procedure SetFormatSize(Value: Integer); virtual; abstract;
    procedure SetSize(Value: Integer); override;
    function WriteWave(const Buffer; Count: Integer): Integer; virtual;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SetPCMFormat(SamplesPerSec, BitsPerSample, Channels: Integer);
    function Write(const Buffer; Count: Longint): Longint; override;
    property FilledSize: Integer read GetFilledSize;
    property Format: PWaveFormatEx read GetFormat;
    property FormatSize: Integer read GetFormatSize write SetFormatSize;
    property Size: Integer read GetSize write SetSize;
  end;

  {  TCustomWaveStream2  }

  TCustomWaveStream2 = class(TCustomWaveStream)
  private
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
  protected
    function GetFormat: PWaveFormatEx; override;
    function GetFormatSize: Integer; override;
    procedure SetFormatSize(Value: Integer); override;
  end;

 { DSCBCAPS }

  DSCBCAPS = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
  end;

  { DSCBUFFERDESC }

  DSCBUFFERDESC = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
    lpwfxFormat: PWaveFormatEx;
  end;

  IDirectSoundCapture = interface;

  { IDirectSoundCaptureBuffer }

  IDirectSoundCaptureBuffer = interface(IUnknown)
    ['{B0210782-89CD-11D0-AF08-00A0C925CD16}']
    (*** IDirectSoundCaptureBuffer methods ***)
    function GetCaps(var lpDSCBCaps: DSCBCAPS): HRESULT; stdcall;
    function GetCurrentPosition(var lpdwCapturePosition,
        lpdwReadPosition: DWORD): HRESULT; stdcall;
    function GetFormat(var lpwfxFormat: TWaveFormatEx; dwSizeAllocated: DWORD;
        var lpdwSizeWritten: DWORD): HRESULT; stdcall;
    function GetStatus(var lpdwStatus: DWORD): HRESULT; stdcall;
    function Initialize(lpDirectSoundCapture: IDirectSoundCapture;
        const lpcDSBufferDesc: DSCBUFFERDESC): HRESULT; stdcall;
    function Lock(dwReadCursor: DWORD; dwReadBytes: DWORD;
        var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: DWORD;
        var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: DWORD;
        dwFlags: DWORD): HRESULT; stdcall;
    function Start(dwFlags: DWORD): HRESULT; stdcall;
    function Stop: HRESULT; stdcall;
    function Unlock(lpvAudioPtr1: Pointer; dwAudioBytes1: DWORD;
        lpvAudioPtr2: Pointer; dwAudioBytes2: DWORD): HRESULT; stdcall;
  end;

  { DSCCAPS }

  DSCCAPS = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwFormats: DWORD;
    dwChannels: DWORD;
  end;

  { IDirectSoundCapture }

  IDirectSoundCapture = interface(IUnknown)
    (*** IDirectSoundCapture methods ***)
    function CreateCaptureBuffer(const lpDSCBufferDesc: DSCBUFFERDESC;
        out lplpDirectSoundCaptureBuffer: IDirectSoundCaptureBuffer;
        pUnkOuter: IUnknown): HRESULT; stdcall;
    function GetCaps(var lpDSCCaps: DSCCAPS): HRESULT; stdcall;
    function Initialize(lpGuid: PGUID): HRESULT; stdcall;
  end;

  {  TSoundCaptureFormat  }

  TSoundCaptureFormat = class(TCollectionItem)
  private
    FBitsPerSample: Integer;
    FChannels: Integer;
    FSamplesPerSec: Integer;
  public
    property BitsPerSample: Integer read FBitsPerSample;
    property Channels: Integer read FChannels;
    property SamplesPerSec: Integer read FSamplesPerSec;
  end;

  {  TSoundCaptureFormats  }

  TSoundCaptureFormats = class(TCollection)
  private
    function GetItem(Index: Integer): TSoundCaptureFormat;
  public
    constructor Create;
    function IndexOf(ASamplesPerSec, ABitsPerSample, AChannels: Integer): Integer;
    property Items[Index: Integer]: TSoundCaptureFormat read GetItem; default;
  end;

  {  TDirectXDriver  }

  TDirectXDriver = class(TCollectionItem)
  private
    FGuid: PGUID;
    FGuid2: TGUID;
    FDescription: string;
    FDriverName: string;
    procedure SetGuid(Value: PGUID);
  public
    property Guid: PGUID read FGuid write SetGuid;
    property Description: string read FDescription write FDescription;
    property DriverName: string read FDriverName write FDriverName;
  end;

  {  TDirectXDrivers  }

  TDirectXDrivers = class(TCollection)
  private
    function GetDriver(Index: Integer): TDirectXDriver;
  public
    constructor Create;
    property Drivers[Index: Integer]: TDirectXDriver read GetDriver; default;
  end;

  {  TSoundCaptureStream  }

  ESoundCaptureStreamError = class(Exception);

  TSoundCaptureStream = class(TCustomWaveStream2)
  private
    FBuffer: IDirectSoundCaptureBuffer;
    FBufferLength: Integer;
    FBufferPos: DWORD;
    FBufferSize: DWORD;
    FCapture: IDirectSoundCapture;
    FCaptureFormat: Integer;
    FCapturing: Boolean;
    FNotifyEvent: THandle;
    FNotifyThread: TThread;
    FOnFilledBuffer: TNotifyEvent;
    FSupportedFormats: TSoundCaptureFormats;
    function GetReadSize: Integer;
    procedure SetBufferLength(Value: Integer);
    procedure SetOnFilledBuffer(Value: TNotifyEvent);
  protected
    procedure DoFilledBuffer; virtual;
    function GetFilledSize: Integer; override;
    function ReadWave(var Buffer; Count: DWORD): DWORD; override;
  public
    constructor Create(GUID: PGUID);
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Start;
    procedure Stop;
    property BufferLength: Integer read FBufferLength write SetBufferLength;
    property CaptureFormat: Integer read FCaptureFormat write FCaptureFormat;
    property Capturing: Boolean read FCapturing;
    property OnFilledBuffer: TNotifyEvent read FOnFilledBuffer write SetOnFilledBuffer;
    property SupportedFormats: TSoundCaptureFormats read FSupportedFormats;
  end;
const
  DDCREATE_HARDWAREONLY       = $00000001;
  DDCREATE_EMULATIONONLY      = $00000002;

  DS_OK = 0;

  DSCBSTART_LOOPING     = $00000001;


implementation

type
  LPDSENUMCALLBACKA = function(lpGuid: PGUID; lpstrDescription: LPCSTR;
    lpstrModule: LPCSTR; lpContext: Pointer): BOOL;

var
  LibList: TStringList;
  DirectSoundCaptureDrivers: TDirectXDrivers;

resourcestring
  SDLLNotLoaded = '%s not loaded';
  SSinceDirectX5 = 'Necessary since DirectX5';
  SCannotInitialized = '%s cannot be initialized';
  SDirectSoundCapture = 'DirectSoundCapture';
  SCannotMade = '%s cannot be made';
  SDirectSoundCaptureBuffer = 'Sound Capture Buffer';

procedure MakePCMWaveFormatEx(var Format: TWaveFormatEx;
  SamplesPerSec, BitsPerSample, Channels: Integer);
begin
  with Format do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Channels;
    nSamplesPerSec := SamplesPerSec;
    wBitsPerSample := BitsPerSample;
    nBlockAlign := nChannels*(wBitsPerSample div 8);
    nAvgBytesPerSec := nBlockAlign*nSamplesPerSec;
    cbSize := 0;
  end;
end;

{  TDirectXDriver  }

procedure TDirectXDriver.SetGuid(Value: PGUID);
begin
  case Integer(Value) of
    0, DDCREATE_HARDWAREONLY, DDCREATE_EMULATIONONLY:
      FGuid := Value
  else
    FGuid2 := Value^;
    FGuid := @FGuid2;
  end;
end;

{  TDirectXDrivers  }

constructor TDirectXDrivers.Create;
begin
  inherited Create(TDirectXDriver);
end;

function TDirectXDrivers.GetDriver(Index: Integer): TDirectXDriver;
begin
  Result := (inherited Items[Index]) as TDirectXDriver;
end;

{  TSoundCaptureFormats  }

constructor TSoundCaptureFormats.Create;
begin
  inherited Create(TSoundCaptureFormat);
end;

function TSoundCaptureFormats.GetItem(Index: Integer): TSoundCaptureFormat;
begin
  Result := TSoundCaptureFormat(inherited Items[Index]);
end;

function TSoundCaptureFormats.IndexOf(ASamplesPerSec, ABitsPerSample, AChannels: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to Count-1 do
    with Items[i] do
      if (FSamplesPerSec=ASamplesPerSec) and (FBitsPerSample=ABitsPerSample) and (FChannels=AChannels) then
      begin
        Result := i;
        Break;
      end;
end;

{  TCustomWaveStream  }

function TCustomWaveStream.GetFilledSize: Longint;
begin
  Result := -1;
end;

function TCustomWaveStream.GetFormatSize: Integer;
begin
  Result := 0;
end;

function TCustomWaveStream.GetSize: Integer;
begin
  Result := -1;
end;

function TCustomWaveStream.Read(var Buffer; Count: Longint): Longint;
begin
  if GetSize<0 then
    Result := ReadWave(Buffer, Count)
  else
  begin
    if FPosition>Size then
      FPosition := Size;
    if FPosition+Count>Size then
      Result := Size-FPosition
    else
      Result := Count;

    Result := ReadWave(Buffer, Result);
  end;

  Inc(FPosition, Result);
end;

function TCustomWaveStream.ReadWave(var Buffer; Count: DWORD): DWORD;
begin
  Result := 0;
end;

function TCustomWaveStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent  : FPosition := FPosition + Offset;
    soFromEnd      : FPosition := GetSize + Offset;
  end;
  if FPosition<0 then FPosition := 0;
  if FPosition>GetSize then FPosition := GetSize;

  Result := FPosition;
end;

procedure TCustomWaveStream.SetPCMFormat(SamplesPerSec, BitsPerSample, Channels: Integer);
begin
  FormatSize := SizeOf(TWaveFormatEx);
  MakePCMWaveFormatEx(Format^, SamplesPerSec, BitsPerSample, Channels);
end;

procedure TCustomWaveStream.SetSize(Value: Integer);
begin
end;

function TCustomWaveStream.Write(const Buffer; Count: Longint): Longint;
begin
  if FPosition>Size then
    FPosition := Size;
  Result := WriteWave(Buffer, Count);
  Inc(FPosition, Result);
end;

function TCustomWaveStream.WriteWave(const Buffer; Count: Integer): Integer;
begin
  Result := 0;
end;

{  TCustomWaveStream2  }

function TCustomWaveStream2.GetFormat: PWaveFormatEx;
begin
  Result := FFormat;
end;

function TCustomWaveStream2.GetFormatSize: Integer;
begin
  Result := FFormatSize;
end;

procedure TCustomWaveStream2.SetFormatSize(Value: Integer);
begin
  ReAllocMem(FFormat, Value);
  FFormatSize := Value;
end;

function Min(B1, B2: Integer): Integer;
begin
  if B1<=B2 then Result := B1 else Result := B2;
end;

function Max(B1, B2: Integer): Integer;
begin
  if B1>=B2 then Result := B1 else Result := B2;
end;

{  TSoundCaptureStream  }

type
  TSoundCaptureStreamNotify = class(TThread)
  private
    FCapture: TSoundCaptureStream;
    FSleepTime: Integer;
    constructor Create(Capture: TSoundCaptureStream);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Update;
  end;

constructor TSoundCaptureStreamNotify.Create(Capture: TSoundCaptureStream);
begin
  FCapture := Capture;

  FCapture.FNotifyEvent := CreateEvent(nil, False, False, nil);
  FSleepTime := Min(FCapture.FBufferLength div 4, 1000 div 20);

  FreeOnTerminate := True;
  inherited Create(True);
end;

destructor TSoundCaptureStreamNotify.Destroy;
begin
  FreeOnTerminate := False;
  SetEvent(FCapture.FNotifyEvent);

  inherited Destroy;

  CloseHandle(FCapture.FNotifyEvent);
  FCapture.FNotifyThread := nil;

  if Assigned(FCapture.FOnFilledBuffer) then FCapture.Stop;
end;

procedure TSoundCaptureStreamNotify.Execute;
begin
  while WaitForSingleObject(FCapture.FNotifyEvent, FSleepTime)=WAIT_TIMEOUT do
  begin
    Synchronize(Update);
  end;
end;

procedure TSoundCaptureStreamNotify.Update;
begin
  if FCapture.FilledSize>0 then
  begin
    try
      FCapture.DoFilledBuffer;
    except
      on E: Exception do
      begin
        Application.HandleException(E);
        SetEvent(FCapture.FNotifyEvent);
      end;
    end;
  end;
end;

function DXLoadLibrary(const FileName, FuncName: string): Pointer;
var
  i: Integer;
  h: THandle;
begin
  if LibList=nil then
    LibList := TStringList.Create;

  i := LibList.IndexOf(AnsiLowerCase(FileName));
  if i=-1 then
  begin
    {  DLL is loaded.  }
    h := LoadLibrary(PChar(FileName));
    if h=0 then
      raise Exception.CreateFmt(SDLLNotLoaded, [FileName]);
    LibList.AddObject(AnsiLowerCase(FileName), Pointer(h));
  end else
  begin
    {  DLL has already been loaded.  }
    h := THandle(LibList.Objects[i]);
  end;

  Result := GetProcAddress(h, PChar(FuncName));
  if Result=nil then
    raise Exception.CreateFmt(SDLLNotLoaded, [FileName]);
end;

function DXDirectSoundCaptureCreate(lpGUID: PGUID; out lplpDSC: IDirectSoundCapture;
  pUnkOuter: IUnknown): HRESULT;
type
  TDirectSoundCaptureCreate = function(lpGUID: PGUID; out lplpDD: IDirectSoundCapture;
    pUnkOuter: IUnknown): HRESULT; stdcall;
begin
  try
    Result := TDirectSoundCaptureCreate(DXLoadLibrary('DSound.dll', 'DirectSoundCaptureCreate'))
      (lpGUID, lplpDSC, pUnkOuter);
  except
    raise EDirectXError.Create(SSinceDirectX5);
  end;
end;

constructor TSoundCaptureStream.Create(GUID: PGUID);
const
  SamplesPerSecList: array[0..6] of Integer = (8000, 11025, 22050, 33075, 44100, 48000, 96000);
  BitsPerSampleList: array[0..3] of Integer = (8, 16, 24, 32);
  ChannelsList: array[0..1] of Integer = (1, 2);
var
  ASamplesPerSec, ABitsPerSample, AChannels: Integer;
  dscbd: DSCBUFFERDESC;
  TempBuffer: IDirectSoundCaptureBuffer;
  Format: TWaveFormatEx;
begin
  inherited Create;
  FBufferLength := 1000;
  FSupportedFormats := TSoundCaptureFormats.Create;

  if DXDirectSoundCaptureCreate(GUID, FCapture, nil)<>DS_OK then
    raise ESoundCaptureStreamError.CreateFmt(SCannotInitialized, [SDirectSoundCapture]);

  {  The supported format list is acquired.  }
  for ASamplesPerSec:=Low(SamplesPerSecList) to High(SamplesPerSecList) do
    for ABitsPerSample:=Low(BitsPerSampleList) to High(BitsPerSampleList) do
      for AChannels:=Low(ChannelsList) to High(ChannelsList) do
      begin
        {  Test  }
        MakePCMWaveFormatEx(Format, SamplesPerSecList[ASamplesPerSec], BitsPerSampleList[ABitsPerSample], ChannelsList[AChannels]);

        FillChar(dscbd, SizeOf(dscbd), 0);
        dscbd.dwSize := SizeOf(dscbd);
        dscbd.dwBufferBytes := Format.nAvgBytesPerSec;
        dscbd.lpwfxFormat := @Format;

        {  If the buffer can be made,  the format of present can be used.  }
        if FCapture.CreateCaptureBuffer(dscbd, TempBuffer, nil)=DS_OK then
        begin
          TempBuffer := nil;
          with TSoundCaptureFormat.Create(FSupportedFormats) do
          begin
            FSamplesPerSec := Format.nSamplesPerSec;
            FBitsPerSample := Format.wBitsPerSample;
            FChannels := Format.nChannels;
          end;
        end;
      end;
end;

destructor TSoundCaptureStream.Destroy;
begin
  Stop;
  FSupportedFormats.Free;
  inherited Destroy;
end;

procedure TSoundCaptureStream.DoFilledBuffer;
begin
  if Assigned(FOnFilledBuffer) then FOnFilledBuffer(Self);
end;

function DXDirectSoundCaptureEnumerate(lpCallback: LPDSENUMCALLBACKA;
    lpContext: Pointer): HRESULT;
type
  TDirectSoundCaptureEnumerate = function(lpCallback: LPDSENUMCALLBACKA;
    lpContext: Pointer): HRESULT; stdcall;
begin
  try
    Result := TDirectSoundCaptureEnumerate(DXLoadLibrary('DSound.dll', 'DirectSoundCaptureEnumerateA'))
      (lpCallback, lpContext);
  except
    raise EDirectXError.Create(SSinceDirectX5);
  end;
end;

function EnumDirectSoundDrivers_DSENUMCALLBACK(lpGuid: PGUID; lpstrDescription: LPCSTR;
  lpstrModule: LPCSTR; lpContext: Pointer): BOOL; stdcall;
begin
  Result := True;
  with TDirectXDriver.Create(TDirectXDrivers(lpContext)) do
  begin
    Guid := lpGuid;
    Description := lpstrDescription;
    DriverName := lpstrModule;
  end;
end;

function EnumDirectSoundCaptureDrivers: TDirectXDrivers;
begin
  if DirectSoundCaptureDrivers=nil then
  begin
    DirectSoundCaptureDrivers := TDirectXDrivers.Create;
    try
      DXDirectSoundCaptureEnumerate(@EnumDirectSoundDrivers_DSENUMCALLBACK, DirectSoundCaptureDrivers);
    except
      DirectSoundCaptureDrivers.Free;
      raise;
    end;
  end;

  Result := DirectSoundCaptureDrivers;
end;

class function TSoundCaptureStream.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectSoundCaptureDrivers;
end;

function TSoundCaptureStream.GetFilledSize: Integer;
begin
  Result := GetReadSize;
end;

function TSoundCaptureStream.GetReadSize: Integer;
var
  CapturePosition, ReadPosition: DWORD;
begin
  if FBuffer.GetCurrentPosition(CapturePosition, ReadPosition)=DS_OK then
  begin
    if FBufferPos<=ReadPosition then
      Result := ReadPosition - FBufferPos
    else
      Result := FBufferSize - FBufferPos + ReadPosition;
  end else
    Result := 0;
end;

function TSoundCaptureStream.ReadWave(var Buffer; Count: DWORD): DWORD;
var
  Size: Integer;
  Data1, Data2: Pointer;
  Data1Size, Data2Size: DWORD;
  C: Byte;
begin
  if not FCapturing then
    Start;

  Result := 0;
  while Result<Count do
  begin
    Size := Min(Count-Result, GetReadSize);
    if Size>0 then
    begin
      if FBuffer.Lock(FBufferPos, Size, Data1, Data1Size, Data2, Data2Size, 0)=DS_OK then
      begin
        Move(Data1^, Pointer(DWORD(@Buffer)+Result)^, Data1Size);
        Result := Result + Data1Size;

        if Data2<>nil then
        begin
          Move(Data2^, Pointer(DWORD(@Buffer)+Result)^, Data2Size);
          Result := Result + Data1Size;
        end;

        FBuffer.UnLock(Data1, Data1Size, Data2, Data2Size);
        FBufferPos := (FBufferPos + Data1Size + Data2Size) mod FBufferSize;
      end else
        Break;
    end;
    if Result<Count then Sleep(50);
  end;

  case Format^.wBitsPerSample of
     8: C := $80;
    16: C := $00;
  else
    C := $00;
  end;

  FillChar(Pointer(DWORD(@Buffer)+Result)^, Count-Result, C);
  Result := Count;
end;

procedure TSoundCaptureStream.SetBufferLength(Value: Integer);
begin
  FBufferLength := Max(Value, 0);
end;

procedure TSoundCaptureStream.SetOnFilledBuffer(Value: TNotifyEvent);
begin
  if CompareMem(@TMethod(FOnFilledBuffer), @TMethod(Value), SizeOf(TMethod)) then Exit;

  if FCapturing then
  begin
    if Assigned(FOnFilledBuffer) then
      FNotifyThread.Free;

    FOnFilledBuffer := Value;

    if Assigned(FOnFilledBuffer) then
    begin
      FNotifyThread := TSoundCaptureStreamNotify.Create(Self);
      FNotifyThread.Resume;
    end;
  end else
    FOnFilledBuffer := Value;
end;

procedure TSoundCaptureStream.Start;
var
  dscbd: DSCBUFFERDESC;
begin
  Stop;
  try
    FCapturing := True;

    FormatSize := SizeOf(TWaveFormatEx);
    with FSupportedFormats[CaptureFormat] do
      MakePCMWaveFormatEx(Format^, SamplesPerSec, BitsPerSample, Channels);

    FBufferSize := Max(MulDiv(Format^.nAvgBytesPerSec, FBufferLength, 1000), 8000);

    FillChar(dscbd, SizeOf(dscbd), 0);
    dscbd.dwSize := SizeOf(dscbd);
    dscbd.dwBufferBytes := FBufferSize;
    dscbd.lpwfxFormat := Format;

    if FCapture.CreateCaptureBuffer(dscbd, FBuffer, nil)<>DS_OK then
      raise ESoundCaptureStreamError.CreateFmt(SCannotMade, [SDirectSoundCaptureBuffer]);

    FBufferPos := 0;

    FBuffer.Start(DSCBSTART_LOOPING);

    if Assigned(FOnFilledBuffer) then
    begin
      FNotifyThread := TSoundCaptureStreamNotify.Create(Self);
      FNotifyThread.Resume;
    end;
  except
    Stop;
    raise;
  end;
end;

procedure TSoundCaptureStream.Stop;
begin
  if FCapturing then
  begin
    FNotifyThread.Free;
    FCapturing := False;
    if FBuffer<>nil then
      FBuffer.Stop;
    FBuffer := nil;
  end;
end;

end.
