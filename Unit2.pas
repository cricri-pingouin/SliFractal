Unit Unit2;

Interface

Uses
  SysUtils, Classes, Controls, Forms, StdCtrls, Unit1, Dialogs;

Type
  TForm2 = Class(TForm)
    lblCanvasWidth: TLabel;
    edtWidth: TEdit;
    edtHeight: TEdit;
    lblHeight: TLabel;
    lblXmin: TLabel;
    edtXmin: TEdit;
    edtXmax: TEdit;
    lblXmax: TLabel;
    lblYmin: TLabel;
    edtYmin: TEdit;
    edtYmax: TEdit;
    lblYmax: TLabel;
    edtMaxIterations: TEdit;
    lblMaxIterations: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    cbbColour: TComboBox;
    lblColour: TLabel;
    Procedure FormActivate(Sender: TObject);
    Procedure btnOKClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form2: TForm2;

Implementation

{$R *.dfm}

Procedure TForm2.btnCancelClick(Sender: TObject);
Begin
  Form2.Close;
End;

Procedure TForm2.btnOKClick(Sender: TObject);
Begin
  Form1.CanvasWidth := StrToInt(edtWidth.Text);
  Form1.CanvasHeight := StrToInt(edtHeight.Text);
  Form1.Xmin := StrToFloat(edtXmin.Text);
  Form1.Xmax := StrToFloat(edtXmax.Text);
  Form1.Ymin := StrToFloat(edtYmin.Text);
  Form1.Ymax := StrToFloat(edtYmax.Text);
  Form1.MaxIterations := StrToInt(edtMaxIterations.Text);
  If Form1.MaxIterations < 3 Then
  Begin
    Form1.MaxIterations := 3;
    ShowMessage('Max iterations cannot be less than 3!' + #13#10 + 'Setting it to 3.');
  End;
  If Form1.MaxIterations > 255 Then
  Begin
    Form1.MaxIterations := 255;
    ShowMessage('Max iterations cannot be more than 255!' + #13#10 + 'Setting it to 255.');
  End;
  Form1.Colour := cbbColour.Text;
  Form2.Close;
End;

Procedure TForm2.FormActivate(Sender: TObject);
Begin
  edtWidth.Text := IntToStr(Form1.CanvasWidth);
  edtHeight.Text := IntToStr(Form1.CanvasHeight);
  edtXmin.Text := FloatToStr(Form1.Xmin);
  edtXmax.Text := FloatToStr(Form1.Xmax);
  edtYmin.Text := FloatToStr(Form1.Ymin);
  edtYmax.Text := FloatToStr(Form1.Ymax);
  edtMaxIterations.Text := IntToStr(Form1.MaxIterations);
  cbbColour.Text := Form1.Colour;
End;

End.

