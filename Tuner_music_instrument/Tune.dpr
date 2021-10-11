{
 Эта программа распространяется в надежде, что она будет полезной,
  но БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ; даже без подразумеваемых гарантий
  КОММЕРЧЕСКОЙ ЦЕННОСТИ или ПРИГОДНОСТИ ДЛЯ КОНКРЕТНОЙ ЦЕЛИ. Для
  получения подробных сведений смотрите Универсальную Общественную
  Лицензию (GNU GPL)
}

program Tune;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  TNLib in 'TNLib.pas',
  AboutBox in 'AboutBox.pas' {FormAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Настройщик музыкальных инструментов';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
