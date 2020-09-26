program Fractal;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  pngimage in 'png\pngimage.pas',
  pnglang in 'png\pnglang.pas',
  zlibpas in 'png\zlibpas.pas';

{$R *.res}
{$SetPEFlags 1}

begin
  Application.Initialize;
  Application.Title := 'Fractal';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
