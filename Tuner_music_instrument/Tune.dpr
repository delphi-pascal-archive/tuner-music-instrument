{
 ��� ��������� ���������������� � �������, ��� ��� ����� ��������,
  �� ��� �����-���� ��������; ���� ��� ��������������� ��������
  ������������ �������� ��� ����������� ��� ���������� ����. ���
  ��������� ��������� �������� �������� ������������� ������������
  �������� (GNU GPL)
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
  Application.Title := '���������� ����������� ������������';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
