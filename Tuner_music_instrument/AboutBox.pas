{
 Эта программа распространяется в надежде, что она будет полезной,
  но БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ; даже без подразумеваемых гарантий
  КОММЕРЧЕСКОЙ ЦЕННОСТИ или ПРИГОДНОСТИ ДЛЯ КОНКРЕТНОЙ ЦЕЛИ. Для
  получения подробных сведений смотрите Универсальную Общественную
  Лицензию (GNU GPL)
}

unit AboutBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi;

type
  TFormAbout = class(TForm)
    ImageMain: TImage;
    Button1: TButton;
    MemoName: TMemo;
    Memo2: TMemo;
    Label2: TLabel;
    Label1: TLabel;
    LabelGNUGPL: TLabel;
    Label3: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure LabelGNUGPLClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

procedure TFormAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://ecsoft.mephi.ru/anton/tune.htm', '', '', SW_SHOW)
end;

procedure TFormAbout.Label2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'mailto:te.anton@gmail.com', '', '', SW_SHOW)
end;

procedure TFormAbout.LabelGNUGPLClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open',
    PChar(ExtractFileDir(Application.ExeName) + '/Help/gpl.txt'), '', '', SW_SHOW)
end;

procedure TFormAbout.Label3Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'mailto:zoth@bk.ru', '', '', SW_SHOW)
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  try
    ImageMain.Picture.LoadFromFile('TuningFork.bmp')
  except
    Caption:= 'Файл "TuningFork.bmp" не найден.';
  end;
end;

END.
