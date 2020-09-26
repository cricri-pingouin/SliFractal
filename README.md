# SliFractal
Draw a Mandelbrot set fractal, written in Turbo Delphi (using scanline).

Addendum 26/09/2020:

Note that changing the calculation (checking if a point belongs to the set) from pure Pascal to FPU assembly is not faster!

Pascal:

      While ((z1 * z1 + z2 * z2 < 4.0) And (Count < MaxIterations)) Do
      Begin
        tmp := z1;
        z1 := z1 * z1 - z2 * z2 + c1;
        z2 := 2 * tmp * z2 + c2;
        Inc(Count);
      End;
      
FPU assembly:

      while ((z1 * z1 + z2 * z2 < 4.0) and (Count < MaxIterations)) do
      begin
        tmp := z1;
        asm
        //z1 = z1 * z1 - z2 * z2 + c1
        fld     z1
        fld     z1  //fld st = slower!
        fmul
        fld     z2
        fld     z2  //same comment as z1
        fmul
        fsub
        fld     c1
        fadd
        fstp    z1 //z1 = st(0)
        //z2 = 2 * tmp * z2 + c2 (where tmp = previous value of z1)
        fld     tmp
        fld     z2
        fmul
        //fld1 twice + fadd slightly faster than loading 2?!
        fld1
        fld1
        fadd
        fmul
        fld     c2
        fadd
        fstp    z2 //z2 = st(0)
        //Inc Count
        inc     Count
        end;
      end;
