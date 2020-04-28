Unit Unit1;

Interface

Uses
  Windows, SysUtils, Classes, Controls, Forms, Graphics, Inifiles, Menus,
  ExtCtrls, Dialogs;

Type
  TForm1 = Class(TForm)
    MainMenu1: TMainMenu;
    mniDraw: TMenuItem;
    mniOptions: TMenuItem;
    mniPNG: TMenuItem;
    Image1: TImage;
    Procedure DrawMandelbrot(X, Y, MinX, MinY: Single; SizeX, SizeY, MaxCount: Integer);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormCreate(Sender: TObject);
    Procedure mniDrawClick(Sender: TObject);
    Procedure mniOptionsClick(Sender: TObject);
    Procedure mniPNGClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
    CanvasWidth, CanvasHeight, MaxIterations: Integer;
    Xmin, Xmax, Ymin, Ymax: Single;
    Colour: String;
  End;

Var
  Form1: TForm1;

Implementation

Uses
  Unit2, pngimage;

{$R *.dfm}

Procedure TForm1.DrawMandelbrot(X, Y, MinX, MinY: Single; SizeX, SizeY, MaxCount: Integer);
Var
  c1, c2, z1, z2, tmp: Single;
  i, j, Count: Integer;
  //Scanline stuff
  PicBuffer: TBitmap; //buffer
  BufferArray: Array Of Array Of Byte; // Multi-dimension array
  P: PRGBTriple; //Scanline pointer
  Palette: Array[0..255] Of TRGBTriple; //24bits RGB palettes
Begin
//Count will always be from 1<= count <= MaxIterations
  //Initialise. otherwise unpredictable colours from whatever already in memory
  For i := 0 To 255 Do
  Begin
    Palette[i].rgbtRed := 0;
    Palette[i].rgbtGreen := 0;
    Palette[i].rgbtBlue := 0;
  End;
  //Set colour palette
  If Colour = 'Fire' Then
  Begin
    For i := 1 To (MaxIterations Div 3) Do
    Begin
      Palette[i].rgbtRed := (i * 255) Div (MaxIterations Div 3);
      Palette[i].rgbtGreen := 0;
      Palette[i].rgbtBlue := 0;
    End;
    For i := (MaxIterations Div 3 + 1) To (2 * MaxIterations Div 3) Do
    Begin
      Palette[i].rgbtRed := 255;
      Palette[i].rgbtGreen := ((i - MaxIterations Div 3) * 255) Div (MaxIterations Div 3);
      Palette[i].rgbtBlue := 0;
    End;
    For i := (2 * MaxIterations Div 3 + 1) To MaxIterations Do
    Begin
      Palette[i].rgbtRed := 255;
      Palette[i].rgbtGreen := 255;
      Palette[i].rgbtBlue := ((i - 2 * MaxIterations Div 3) * 255) Div (MaxIterations Div 3);
    End;
  End
  Else
    For i := 0 To MaxIterations Do
    Begin
      Palette[i].rgbtRed := 0;
      Palette[i].rgbtGreen := 0;
      Palette[i].rgbtBlue := 0;
      If Colour = 'Blue' Then
        Palette[i].rgbtBlue := (i * 255) Div MaxIterations
      Else If Colour = 'Green' Then
        Palette[i].rgbtGreen := (i * 255) Div MaxIterations
      Else
        Palette[i].rgbtRed := (i * 255) Div MaxIterations;
    End;
  //Size the buffer array according to previous variables, i.e. form size
  SetLength(BufferArray, SizeX, SizeY);
  //Initialise buffer
  PicBuffer := TBitmap.Create;
  PicBuffer.Width := SizeX;
  PicBuffer.Height := SizeY;
  PicBuffer.PixelFormat := pf24bit; //Use 24bits RGB, not TColor as we won't use alpha blending
  //Calculate Mandelbrot set
  c2 := MinY;
  For i := 0 To SizeX - 1 Do
  Begin
    c1 := MinX;
    For j := 0 To SizeY - 1 Do
    //Compute series iterations for this Z coordinate
    Begin
      z1 := 0;
      z2 := 0;
      Count := 0;
      //Count is deep of iteration of the mandelbrot set
      //If |z| >=2 then z is not a member of a Mandelbrot set
      //Use * as faster than ^2 I was told
      While ((z1 * z1 + z2 * z2 < 4.0) And (Count < MaxIterations)) Do
      Begin
        tmp := z1;
        z1 := z1 * z1 - z2 * z2 + c1;
        z2 := 2 * tmp * z2 + c2;
        Inc(Count);
      End;
      //Colour pixel at Z coordinates
      //Colour from palette with index = number of iterations
      BufferArray[i, j] := Count;
      c1 := c1 + X;
    End;
    c2 := c2 + Y;
  End;
  //Populate buffer using scanline
  For j := 0 To SizeY - 1 Do //Height-1 or pointer will fall out=crash!
  Begin
    //Loop through Y, then X. This way we process the whole scanline in one go
    P := PicBuffer.ScanLine[j];
    For i := 0 To SizeX - 1 Do //Width-1 or pointer will fall out=crash!
    Begin
      //Set pixel colour according to index value in palettes
      P^ := Palette[MaxIterations - BufferArray[j, i]];
      //Increment pointer AFTER, otherwise we fail to process leftmost column
      Inc(P);
    End;
  End;
    //Copy buffer to form canvas
//Size image in Draw menu event, it seems to fail if doing it here if size > ca. 800 pixels
//  Image1.Width := SizeX;
//  Image1.Height := SizeY;
  Image1.Canvas.Draw(0, 0, PicBuffer);
  //Canvas.Draw(0, 0, PicBuffer);
  //Free PicBuffer to avoid memory leak
  PicBuffer.Free;
End;

Procedure TForm1.FormClose(Sender: TObject; Var Action: TCloseAction);
Var
  myINI: TINIFile;
Begin
  //Save settings to INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'fractal.ini');
  myINI.WriteInteger('Settings', 'CanvasWidth', CanvasWidth);
  myINI.WriteInteger('Settings', 'CanvasHeight', CanvasHeight);
  myINI.WriteFloat('Settings', 'Xmin', Xmin);
  myINI.WriteFloat('Settings', 'Xmax', Xmax);
  myINI.WriteFloat('Settings', 'Ymin', Ymin);
  myINI.WriteFloat('Settings', 'Ymax', Ymax);
  myINI.WriteInteger('Settings', 'MaxIterations', MaxIterations);
  myINI.WriteString('Settings', 'Colour', Colour);
  myINI.Free;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Var
  myINI: TINIFile;
Begin
  //Initialise options from INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'fractal.ini');
  //Read settings from INI file
  CanvasWidth := myINI.ReadInteger('Settings', 'CanvasWidth', 800);
  CanvasHeight := myINI.ReadInteger('Settings', 'CanvasHeight', 800);
  Xmin := myINI.ReadFloat('Settings', 'Xmin', -2);
  Xmax := myINI.ReadFloat('Settings', 'Xmax', 1);
  Ymin := myINI.ReadFloat('Settings', 'Ymin', -1.5);
  Ymax := myINI.ReadFloat('Settings', 'Ymax', 1.5);
  MaxIterations := myINI.ReadInteger('Settings', 'MaxIterations', 255);
  Colour := myINI.ReadString('Settings', 'Colour', 'Red');
  myINI.Free;
End;

Procedure TForm1.mniDrawClick(Sender: TObject);
Var
  dX, dY: Single;
  Start, Finish: Int64;
Begin
  //Size window
  ClientWidth := CanvasWidth;
  ClientHeight := CanvasHeight;
  //Size image, it seems to fail if doing it in Fractal drawing routine if size > ca. 800 pixels
  Image1.Width := CanvasWidth;
  Image1.Height := CanvasHeight;
  //Calculate steps size to make one pixel
  dX := (Xmax - Xmin) / CanvasWidth;
  dY := (Ymax - Ymin) / CanvasHeight;
  //Draw fractal
  Caption := 'Wait...';
  Start := GetTickCount;
  DrawMandelbrot(dX, dY, Xmin, Ymin, CanvasWidth, CanvasHeight, MaxIterations);
  Finish := GetTickCount;
  Caption := 'Time: ' + IntToStr(Finish - Start) + 'ms';
  mniPNG.Enabled := True;
End;

Procedure TForm1.mniOptionsClick(Sender: TObject);
Begin
  If Form2.Visible = False Then
    Form2.Show
  Else
    Form2.Hide;
End;

Procedure TForm1.mniPNGClick(Sender: TObject);
Var
  i: Integer;
  FileName: String;
  PNG: TPNGObject;
Begin
  FileName := 'fractal.png';
  If fileexists(FileName) Then
  Begin
    i := 0;
    Repeat
      Inc(i);
      FileName := 'fractal' + inttostr(i) + '.png';
    Until Not fileexists(FileName);
  End;
  PNG := TPNGObject.Create;
  Try
    PNG.Assign(Image1.Picture.Bitmap);
    PNG.SaveToFile(FileName);
    ShowMessage('Saved file ' + FileName);
  Finally
    PNG.Free;
  End
End;

End.

