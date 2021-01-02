program binaryfiles;
uses
crt, windows;
var
floats: file of float;
a,b: integer;

const
 fuelc : ARRAY [0..3, 0..2] of float = ((0.3, 0.2, 0.0), (0.6, 0.0, 0.0), (0.2, 0.2, 0.4), (0.0, 0.6, 0.0));

begin
assign(floats, 'fuelc.dat');
rewrite(floats);
for a:= 0 to 3 do
for b:= 0 to 2 do
begin
write(floats, fuelc[a,b]);
end;
close(floats);
end.
