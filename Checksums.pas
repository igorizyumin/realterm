unit Checksums;

interface

function Checksum8( msg :string ) :char;
function Checksum16( msg :string ) :string;

implementation
function Checksum8( msg :string ) :char;
var crc: byte; i:integer;  ch:byte;
begin
  crc := 0;
  for i := 1 to length(msg) do begin
    ch:=byte(msg[i]);
    crc := crc+ch;
  end;
  result:= char(crc);
end;

function Checksum16( msg :string ) :string;
var crc: word; i:integer;  ch:byte;
begin
  crc := 0;
  for i := 1 to length(msg) do begin
    ch:=byte(msg[i]);
    crc := crc+ch;
  end;
  result:= char(hi(crc))+char(lo(crc));
end;

end.
 