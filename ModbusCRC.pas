{MODBUS CRC-16 ObjectPascal (Delphi) Routine by Panu-Kristian Poiksalo 2003
This function calculates a checksum STRING for a message STRING for maximum
usability for me... example call for this function would be something like...
Examples
$47 03 00 01 00 08 CRC= 1B6A
1 3 0 1 0 1  CRC=D5CA

var message:string;
begin
message:=#1#5#0#0#255#0;
ModbusSerialPort.Output:= message + crc16string (message);
end;

happy coding! send me a greeting at bancho@microdim.net when you get it to
work and share this code freely with everyone at any web site!}

unit ModbusCRC;

interface
function ModbusCrc16String(msg:string):string;

implementation

function Modbuscrc16string(msg:string):string;
var crc: word; 
n,i: integer; 
b:byte; 
begin 
crc := $FFFF; 
for i:=1 to length (msg) do begin 
b:=ord(msg[i]); 
crc := crc xor b; 
for n:=1 to 8 do begin 
if (crc and 1)<>0 
then crc:=(crc shr 1) xor $A001 
else crc:=crc shr 1; 
end; 
end; 
result:=chr(crc and $ff)+chr(crc shr 8); 
end;
end.
 