unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Graphics, Inifiles, Menus,
  ExtCtrls, Dialogs;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    mniDraw: TMenuItem;
    mniOptions: TMenuItem;
    mniPNG: TMenuItem;
    mniExit: TMenuItem;
    Image1: TImage;
    procedure DrawMandelbrot(dX, dY, MinX, MinY: Single; SizeX, SizeY, MaxCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniDrawClick(Sender: TObject);
    procedure mniOptionsClick(Sender: TObject);
    procedure mniPNGClick(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CanvasWidth, CanvasHeight, MaxIterations: Integer;
    Xmin, Xmax, Ymin, Ymax: Single;
    Colour: string;
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2, pngimage;

{$R *.dfm}

procedure TForm1.DrawMandelbrot(dX, dY, MinX, MinY: Single; SizeX, SizeY, MaxCount: Integer);
var
  c1, c2, z1, z2, tmp: Single;
  i, j, Count: Integer;
  //Scanline stuff
  PicBuffer: TBitmap; //buffer
  BufferArray: array of array of Byte; // Multi-dimension array
  P: PRGBTriple; //Scanline pointer
  Palette: array[0..255] of TRGBTriple; //24bits RGB palettes
begin
  //Count will always be from 1<= count <= MaxIterations
  //Initialise. otherwise unpredictable colours from whatever already in memory
  for i := 0 to 255 do
  begin
    Palette[i].rgbtRed := 0;
    Palette[i].rgbtGreen := 0;
    Palette[i].rgbtBlue := 0;
  end;
  //Set colour palette
  if Colour = 'Fire' then
  begin
    for i := 1 to (MaxIterations div 3) do
    begin
      Palette[i].rgbtRed := (i * 255) div (MaxIterations div 3);
      Palette[i].rgbtGreen := 0;
      Palette[i].rgbtBlue := 0;
    end;
    for i := (MaxIterations div 3 + 1) to (2 * MaxIterations div 3) do
    begin
      Palette[i].rgbtRed := 255;
      Palette[i].rgbtGreen := ((i - MaxIterations div 3) * 255) div (MaxIterations div 3);
      Palette[i].rgbtBlue := 0;
    end;
    for i := (2 * MaxIterations div 3 + 1) to MaxIterations do
    begin
      Palette[i].rgbtRed := 255;
      Palette[i].rgbtGreen := 255;
      Palette[i].rgbtBlue := ((i - 2 * MaxIterations div 3) * 255) div (MaxIterations div 3);
    end;
  end
  else
    for i := 0 to MaxIterations do
    begin
      Palette[i].rgbtRed := 0;
      Palette[i].rgbtGreen := 0;
      Palette[i].rgbtBlue := 0;
      if Colour = 'Blue' then
        Palette[i].rgbtBlue := (i * 255) div MaxIterations
      else if Colour = 'Green' then
        Palette[i].rgbtGreen := (i * 255) div MaxIterations
      else
        Palette[i].rgbtRed := (i * 255) div MaxIterations;
    end;
  //Size the buffer array according to previous variables, i.e. form size
  SetLength(BufferArray, SizeX, SizeY);
  //Initialise buffer
  PicBuffer := TBitmap.Create;
  PicBuffer.Width := SizeX;
  PicBuffer.Height := SizeY;
  PicBuffer.PixelFormat := pf24bit; //Use 24bits RGB, not TColor as we won't use alpha blending
  //Calculate Mandelbrot set
  c2 := MinY;
  for i := 0 to SizeY - 1 do
  begin
    c1 := MinX;
    for j := 0 to SizeX - 1 do
    //Compute series iterations for this Z coordinate
    begin
      z1 := 0;
      z2 := 0;
      Count := 0;
      //Count is deep of iteration of the mandelbrot set
      //If |z| >=2 then z is not a member of a Mandelbrot set
      while ((z1 * z1 + z2 * z2 < 4.0) and (Count < MaxIterations)) do
      begin
        tmp := z1;
        z1 := z1 * z1 - z2 * z2 + c1;
        z2 := 2 * tmp * z2 + c2;
        Inc(Count);
      end;
      //Colour pixel at Z coordinates
      //Colour from palette with index = number of iterations
      BufferArray[j, i] := Count;
      c1 := c1 + dX;
    end;
    c2 := c2 + dY;
  end;
  //Populate buffer using scanline
  for j := 0 to SizeY - 1 do //Height-1 or pointer will fall out=crash!
  begin
    //Loop through Y, then X. This way we process the whole scanline in one go
    P := PicBuffer.ScanLine[j];
    for i := 0 to SizeX - 1 do //Width-1 or pointer will fall out=crash!
    begin
      //Set pixel colour according to index value in palettes
      P^ := Palette[MaxIterations - BufferArray[i, j]];
      //Increment pointer AFTER, otherwise we fail to process leftmost column
      Inc(P);
    end;
  end;
  //Copy buffer to form canvas
  Image1.Canvas.Draw(0, 0, PicBuffer);
  //Canvas.Draw(0, 0, PicBuffer);
  //Free PicBuffer to avoid memory leak
  PicBuffer.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  myINI: TINIFile;
begin
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
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  myINI: TINIFile;
begin
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
end;

procedure TForm1.mniDrawClick(Sender: TObject);
var
  dX, dY: Single;
  Start, Finish: Int64;
begin
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
end;

procedure TForm1.mniOptionsClick(Sender: TObject);
begin
  if Form2.Visible = False then
    Form2.Show
  else
    Form2.Hide;
end;

procedure TForm1.mniPNGClick(Sender: TObject);
var
  i: Integer;
  FileName: string;
  PNG: TPNGObject;
begin
  FileName := 'fractal.png';
  if fileexists(FileName) then
  begin
    i := 0;
    repeat
      Inc(i);
      FileName := 'fractal' + inttostr(i) + '.png';
    until not fileexists(FileName);
  end;
  PNG := TPNGObject.Create;
  try
    PNG.Assign(Image1.Picture.Bitmap);
    PNG.SaveToFile(FileName);
    ShowMessage('Saved file ' + FileName);
  finally
    PNG.Free;
  end
end;

procedure TForm1.mniExitClick(Sender: TObject);
begin
  Close;
end;

end.

