{
 Эта программа распространяется в надежде, что она будет полезной,
  но БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ; даже без подразумеваемых гарантий
  КОММЕРЧЕСКОЙ ЦЕННОСТИ или ПРИГОДНОСТИ ДЛЯ КОНКРЕТНОЙ ЦЕЛИ. Для
  получения подробных сведений смотрите Универсальную Общественную
  Лицензию (GNU GPL)
}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Gauges, AppEvnts, TeEngine, Series,
  TeeProcs, Chart, Math, ActnList, SyncObjs, ShellApi, TNLib, Menus;

resourcestring
  Ver = '0.10';

const
  BaseFreq = 440;
  NotesName: array [0..11] of string =
  (
   'C',
   'C#',
   'D',
   'D#',
   'E',
   'F',
   'F#',
   'G',
   'G#',
   'A',
   'A#',
   'B'
  );
type
  TSpec = array [0..2048 - 1] of Double;

  TMyThread = class(TThread)
  private
    FCapture: TSoundCaptureStream;
  public
    FS: TCriticalSection;
    Ampls: TSpec;
    Buff: array [0..$FFFF] of Byte;
    UpFreq: Double;
    BytesPerSamp, BytesPerChannel: Integer;
    SampleFreq: Integer;
    constructor Create(CreateSuspended: Boolean);
    procedure Execute; override;
  end;

  TFormMain = class(TForm)
    ChartSpec: TChart;
    PanelTop: TPanel;
    LabelNoteValue: TLabel;
    LabelRangeValue: TLabel;
    LabelRangef: TLabel;
    LabelNotev: TLabel;
    ActionListMain: TActionList;
    ActionLeft: TAction;
    ActionRight: TAction;
    ActionUp: TAction;
    ActionDown: TAction;
    Timer1: TTimer;
    PanelDown: TPanel;
    PanelPiano: TPanel;
    ImagePiano: TImage;
    PanelPianoPoint: TPanel;
    SeriesPointer: TLineSeries;
    LabelSoundMode: TLabel;
    Timer2: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    NSettings: TMenuItem;
    ActionDown1: TMenuItem;
    ActionUp1: TMenuItem;
    ActionLeft1: TMenuItem;
    ActionRight1: TMenuItem;
    ActionHelp: TAction;
    SeriesSpec: TFastLineSeries;
    ActionString1: TAction;
    ActionString2: TAction;
    ActionString3: TAction;
    ActionString4: TAction;
    ActionString5: TAction;
    ActionString6: TAction;
    NGuitar: TMenuItem;
    NString1: TMenuItem;
    NString2: TMenuItem;
    NString3: TMenuItem;
    NSting4: TMenuItem;
    NString5: TMenuItem;
    NString6: TMenuItem;
    N12: TMenuItem;
    ActionRC: TAction;
    NRC: TMenuItem;
    Series1: TBarSeries;
    N2: TMenuItem;
    N5: TMenuItem;
    ActionSpace: TAction;
    procedure FormShow(Sender: TObject);
    procedure ActionLeftExecute(Sender: TObject);
    procedure ActionRightExecute(Sender: TObject);
    procedure ActionUpExecute(Sender: TObject);
    procedure ActionDownExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure ImagePianoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure N4Click(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionStringExecute(Sender: TObject);
    procedure ActionRCExecute(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure ActionSpaceExecute(Sender: TObject);
  private
    FThread: TMyThread;
    FSpec: TSpec;
    FNote: Integer;
    FRange: Integer;
    TuneS: Double;
    T: Cardinal;
    WeelInc: Integer;
    procedure RecalcFreq;
  public

  end;

var
  FormMain: TFormMain;

implementation

uses AboutBox;

{$R *.dfm}
type
TComplex = record
  RE: Double;
  IM: Double;
end;

procedure Mult(X, Y: TComplex; var Z: TComplex);
begin
  Z.Re := X.Re * Y.Re - X.Im * Y.Im;
  Z.Im := X.Im * Y.Re + X.Re * Y.Im;
end;

procedure MultC(C: Double; var X: TComplex);
begin
  X.Re := C * X.Re;
  X.Re := C * X.Im;
end;

procedure Plus(X, Y: TComplex; var Z: TComplex);
begin
  Z.Re := X.Re + Y.Re;
  Z.Im := X.Im + Y.Im;
end;

procedure Minus(X, Y: TComplex; var Z: TComplex);
begin
  Z.Re := X.Re - Y.Re;
  Z.Im := X.Im - Y.Im;
end;


procedure FFT(var Amp: array of Double);
var
  mm, ll, k, nn, kk, j, jj, i, nv2, nm1: Integer;
  C1, C2, C3: TComplex;
  RootExp: Integer;
  WSinTo: array of TComplex;
  S: Double;
  LenAmp: Integer;
  Spec: array of TComplex;
begin
  LenAmp := Length(Amp);
  S := 2 * PI / LenAmp;
  C1.Re := Cos(s);
  C1.Im := -Sin(S);
  C2.Re := 1;
  C2.Im := 0;
  SetLength(WSinTo, LenAmp);
  SetLength(Spec, LenAmp);
  for I := 0 to LenAmp - 1 do begin
    WSinTo[I] := C2;
    Mult(C2, C1, C2);
  end;
  RootExp := Round(Ln(LenAmp) / Ln(2));
  mm := 1;
  ll := LenAmp;
  for K := 0 to LenAmp - 1 do begin
    Spec[K].Re := Amp[K];
    Spec[K].Im := 0;
  end;
  for K := 1 to RootExp do begin
    nn := ll div 2;
    jj := mm + 1;
    i := 1;
    while (i <= LenAmp) do begin
      kk := i + nn;
      plus(Spec[i - 1], Spec[kk - 1], c1);
      minus(Spec[i - 1], Spec[kk - 1], Spec[kk - 1]);
      Spec[i - 1] := c1;
      i := i + ll;
    end;
    if (nn <> 1) then begin
      for j := 2 to nn do begin
        c2 := WSinTO[jj];
        i := j;
        while (i <= LenAmp) do begin
          kk := i + nn;
          plus(spec[i - 1], Spec[kk - 1], c1);
          minus(Spec[i - 1], Spec[kk - 1], c3);
          mult(c3, c2, Spec[kk - 1]);
          Spec[i - 1] := c1;
          i := i + ll;
        end;
        jj := jj + mm;
      end;
      ll := nn;
      mm := mm * 2;
    end;
  end;
  nv2 := LenAmp div 2;
  nm1 := LenAmp - 1;
  j := 1;
  for i := 1 to nm1 do begin
    if (i < j) then begin
      c1 := Spec[j - 1];
      Spec[j - 1] := Spec[i - 1];
      Spec[i - 1] := c1;
    end;
    k := nv2;
    while (k < j) do begin
      j := j - k;
      k := k div 2;
    end;
    j := j + k;
  end;
  for K := 0 to LenAmp - 1 do
    Amp[K] := Sqrt(Sqr(Spec[K].Re / (LenAmp div 2)) + Sqr(Spec[K].Im / (LenAmp div 2)))
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FThread := TMyThread.Create(False);
  FRange := 4;
  FNote := 0;
  RecalcFreq;
end;


{ TMyThread }

constructor TMyThread.Create(CreateSuspended: Boolean);
var
  I: Integer;
begin
  FS := TCriticalSection.Create;
  FCapture := TSoundCaptureStream.Create(nil);
  FCapture.CaptureFormat := 2;
  for I := FCapture.SupportedFormats.Count - 1 downto 0 do
  with FCapture.SupportedFormats[I] do
    if (BitsPerSample = 16) and (Channels = 1) and
      ((SamplesPerSec = 48000) or
       (SamplesPerSec = 44100) or
       (SamplesPerSec = 22050) or
       (SamplesPerSec = 11025) or
       (SamplesPerSec = 8000)
      ) then
    begin
      FCapture.CaptureFormat := I;
      Break;
    end;
  with FCapture.SupportedFormats[FCapture.CaptureFormat] do begin
    BytesPerChannel := BitsPerSample div 8;
    BytesPerSamp :=  BytesPerChannel * Channels ;
    SampleFreq := SamplesPerSec;
  end;
  inherited;
end;

procedure TMyThread.Execute;
var
  BuffSize: Integer;
  I: Integer;
  Ampl: Double;
  P, PP: Integer;
  D: Double;
  Sum: Double;
  Cnt: Integer;
  FAmpls: TSpec;
begin
  for I := 0 to High(FAmpls) do
    FAmpls[I] := 0;
  D := 0;
  P := 0;
  Sum := 0;
  Cnt := 1;
  FCapture.Start;
  repeat
    Sleep(1);
    BuffSize := FCapture.FilledSize;
    if BuffSize > (SizeOf(Buff) - 10) then
      BuffSize := (SizeOf(Buff) - 10);
    FCapture.Read(Buff[0], BuffSize);
    for I := 0 to BuffSize div BytesPerSamp - 1 do
    begin
      case BytesPerChannel of
        1: Ampl := ShortInt(Buff[I * BytesPerSamp]) / High(ShortInt);
      else
        {2:} Ampl := Smallint((@Buff[I * BytesPerSamp])^) / High(Smallint);
      end;
      if D > 0 then
      begin
        FAmpls[P] := Sum / Cnt;
        Inc(P);
        if P > High(Ampls) then
          P := 0;
        Sum := Ampl;
        Cnt := 1;
        D := D - SampleFreq;
      end
      else
      begin
        Sum := Sum + Ampl;
        Inc(Cnt);
      end;
      D := D + UpFreq;
    end;
    PP := P;
    FS.Enter;
    try
      for I := 0 to High(Ampls) do
      begin
        Ampls[I] := Exp((I - High(Ampls)) / (0.2 * High(Ampls))) * FAmpls[PP];
        Inc(PP);
        if PP > High(Ampls) then
          PP := 0;
      end;
    finally
      FS.Leave;
    end;
  until Terminated;
  FCapture.Stop;
  FCapture.Free;
  FS.Free;
end;

procedure TFormMain.ActionLeftExecute(Sender: TObject);
begin
  if FNote > -50 then
    Dec(FNote);
  RecalcFreq;
end;

procedure TFormMain.RecalcFreq;
var
  I: Integer;
  FF: Real;
  N: string;
begin
  LabelNoteValue.Caption := Format('%s %d', [NotesName[(FNote - 3 + 100 * 12) mod 12], (FNote + 9 + 10 * 12) div 12 - 10]);
  LabelRangeValue.Caption := IntToStr(FRange);
  FThread.UpFreq := BaseFreq * Power(2, FNote / 12) * 2;
  TuneS := High(FSpec) / 4;
  ChartSpec.BottomAxis.SetMinMax(TuneS / Power(2, FRange / 12), TuneS * Power(2, FRange / 12));
  PanelPianoPoint.Left := (FNote + 12 * 4)  * 6 + 1;

  SeriesPointer.Clear;
  Series1.Clear;
  for I := -FRange to FRange do
  begin
    FF := TuneS / Power(2, I / 12 );
    if I = 0 then
    begin
      SeriesPointer.AddXY(FF, 0, '', $DFDFFF);
      SeriesPointer.AddXY(FF, 100, '', clRed);
      SeriesPointer.AddXY(FF, 0, '', clRed);
    end
    else
    begin
      SeriesPointer.AddXY(FF, 0, '', $DFDFFF);
      SeriesPointer.AddXY(FF, 100, '', $DFDFFF);
      SeriesPointer.AddXY(FF, 0, '', $DFDFFF);
    end;
    N := NotesName[(FNote - 3 + 100 * 12 - I) mod 12];
    {if N[2] = '#' then}
    if (Length(N)>1) and (N[2] = '#') then
      Series1.AddXY(FF, 95, ' ', $000000)
    else
      Series1.AddXY(FF, 90, N, $FFFFFF);
  end;
end;

procedure TFormMain.ActionRightExecute(Sender: TObject);
begin
  if FNote < 50 then
    Inc(FNote);
  RecalcFreq;
end;

procedure TFormMain.ActionUpExecute(Sender: TObject);
begin
  Inc(FRange);
  RecalcFreq;
end;

procedure TFormMain.ActionDownExecute(Sender: TObject);
begin
  if FRange > 1 then
    Dec(FRange);
  RecalcFreq;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  with FThread do
    if BytesPerChannel <> 0 then
      LabelSoundMode.Caption := Format('Частота дискретизации, Гц: %d'#13'Битовая'+
        ' глубина: %d моно',
        [SampleFreq, BytesPerChannel * 8, BytesPerSamp div BytesPerChannel]);
end;

procedure TFormMain.Edit1Enter(Sender: TObject);
begin
  ActionLeft.Enabled := False;
  ActionRight.Enabled := False;
end;

procedure TFormMain.Edit1Exit(Sender: TObject);
begin
  ActionLeft.Enabled := True;
  ActionRight.Enabled := True;
end;

procedure TFormMain.ImagePianoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FNote := X div 6 - 12 * 4;
  RecalcFreq;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  try
    ImagePiano.Picture.LoadFromFile('piano.bmp'); // 24.07.2006 Serga
  except
    Caption:= 'Файл "piano.bmp" не найден.';
  end;
  Application.Title := Format('%s вер. %s', [Application.Title, Ver]);
  T := GetTickCount;
end;

procedure TFormMain.Timer2Timer(Sender: TObject);
var
  I: Integer;
  Max: Double;
begin
  if FThread = nil then
    Exit;
  FThread.FS.Enter;
  try
    FSpec := FThread.Ampls;
  finally
    FThread.FS.Leave;
  end;
  FFT(FSpec);
  SeriesSpec.Clear;
  Max := 0;
  for I := 1 to Length(FSpec) div 2 - 1 do
  begin
    try
      SeriesSpec.AddXY(I, FSpec[I]);
      if Max < FSpec[I] then
        Max := FSpec[I];
    except
    end;
  end;
end;

procedure TFormMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  P = 1;
begin
  if WheelDelta > 0 then
    Inc(WeelInc);
  if WheelDelta < 0 then
    Dec(WeelInc);
  if WeelInc >= P then
  begin
    Dec(WeelInc, P);
    ActionUp.Execute;
  end;
  if WeelInc <= -P then
  begin
    Inc(WeelInc, P);
    ActionDown.Execute;
  end;
end;

procedure TFormMain.N4Click(Sender: TObject);
begin
  if not Assigned(FormAbout) then // 24.07.2006 Serga
    FormAbout:= TFormAbout.Create(Application); // 24.07.2006 Serga
  FormAbout.MemoName.Clear;
  FormAbout.MemoName.Lines.Add(Caption);
  FormAbout.ShowModal;
end;

procedure TFormMain.ActionHelpExecute(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('file:///' +
    ExtractFileDir(Application.ExeName) + '/Help/help.htm'), '', '', SW_SHOW)
end;

procedure TFormMain.ActionStringExecute(Sender: TObject);
begin
  case (Sender as TAction).Tag of
    1: FNote := 7;
    2: FNote := 2;
    3: FNote := -2;
    4: FNote := -7;
    5: FNote := -12;
    6: FNote := -17;
  end;
  RecalcFreq;
end;

procedure TFormMain.ActionRCExecute(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'sndvol32.exe', '-rec', '', SW_SHOW)
end;

procedure TFormMain.mmExitClick(Sender: TObject);
begin
  Close; // 10.07.2006 Serga
end;

procedure TFormMain.ActionSpaceExecute(Sender: TObject);
begin
  case FNote of
     7:  FNote :=  2;
     2:  FNote := -2;
    -2:  FNote := -7;
    -7:  FNote := -12;
    -12: FNote := -17;
  else {  -17:} FNote := 7;
  end;
  RecalcFreq;
end;

END.
