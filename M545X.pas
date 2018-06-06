unit M545X;
{ Support Routines for M5451 Display Modules
}
interface
{returns the hex chars to send to an M5451D4 display via BL233}
function Str2M5451D4(S:string):string; //Scrambled I2CCHIP segment arrangement

function Str2NSM4000(S:string):string; //Unscrambled Natsemi obsolete display


function ClearM5451D4Str:string; //Command string to clear M5451 . Must be sent after power on, before first data str

implementation
uses StBits,Ststrs,Ststrl,StUtils,math, sysutils;
{Define segments of 4 digit part of 7 seg display}
const SegA=1; SegB=2; SegC=4; SegD=8; SegE=16; SegF=32; SegG=64; SegDp=128;
{Define special segments}
const SegDp5=1; SegA5=2; SegB5=4; SegG5=4;

{Char LookUpTable}
const AlphaLUT7Seg: array[0..35] of byte = (
  1*SegA+1*SegB+1*SegC+1*SegD+1*SegE+1*SegF+0*SegG ,//0
  0*SegA+1*SegB+1*SegC+0*SegD+0*SegE+0*SegF+0*SegG ,//1
  1*SegA+1*SegB+0*SegC+1*SegD+1*SegE+0*SegF+1*SegG ,//2
  1*SegA+1*SegB+1*SegC+1*SegD+0*SegE+0*SegF+1*SegG ,//3
  0*SegA+1*SegB+1*SegC+0*SegD+0*SegE+1*SegF+1*SegG ,//4
  1*SegA+0*SegB+1*SegC+1*SegD+0*SegE+1*SegF+1*SegG ,//5
  1*SegA+0*SegB+1*SegC+1*SegD+1*SegE+1*SegF+1*SegG ,//6
  1*SegA+1*SegB+1*SegC+0*SegD+0*SegE+0*SegF+0*SegG ,//7
  1*SegA+1*SegB+1*SegC+1*SegD+1*SegE+1*SegF+1*SegG ,//8
  1*SegA+1*SegB+1*SegC+0*SegD+0*SegE+1*SegF+1*SegG ,//9
  1*SegA+1*SegB+1*SegC+0*SegD+1*SegE+1*SegF+1*SegG ,//A
  0*SegA+0*SegB+1*SegC+1*SegD+1*SegE+1*SegF+1*SegG ,//b
  0*SegA+0*SegB+0*SegC+1*SegD+1*SegE+0*SegF+1*SegG ,//c
  0*SegA+1*SegB+1*SegC+1*SegD+1*SegE+0*SegF+1*SegG ,//d
  1*SegA+0*SegB+0*SegC+1*SegD+1*SegE+1*SegF+1*SegG ,//E
  1*SegA+0*SegB+0*SegC+0*SegD+1*SegE+1*SegF+1*SegG ,//F
  
  1*SegA+1*SegB+1*SegC+1*SegD+0*SegE+1*SegF+1*SegG ,//g
  0*SegA+0*SegB+1*SegC+0*SegD+1*SegE+1*SegF+1*SegG ,//h
  0*SegA+0*SegB+1*SegC+0*SegD+0*SegE+0*SegF+0*SegG ,//i
  0*SegA+1*SegB+1*SegC+1*SegD+0*SegE+0*SegF+0*SegG ,//J
  0 ,//k
  0*SegA+0*SegB+0*SegC+1*SegD+1*SegE+1*SegF+0*SegG ,//L
  0 ,//m
  0*SegA+0*SegB+1*SegC+0*SegD+1*SegE+0*SegF+1*SegG ,//n
  0*SegA+0*SegB+1*SegC+1*SegD+1*SegE+0*SegF+1*SegG ,//o
  1*SegA+1*SegB+0*SegC+0*SegD+1*SegE+1*SegF+1*SegG ,//P
  0, //q
  0*SegA+0*SegB+0*SegC+0*SegD+1*SegE+0*SegF+1*SegG,//r
  1*SegA+0*SegB+1*SegC+1*SegD+0*SegE+1*SegF+1*SegG ,//s
  0*SegA+0*SegB+0*SegC+1*SegD+1*SegE+1*SegF+1*SegG ,//t
  0*SegA+0*SegB+1*SegC+1*SegD+1*SegE+0*SegF+0*SegG ,//u
  0, //v
  0, //w
  0, //x
  0*SegA+1*SegB+1*SegC+1*SegD+0*SegE+1*SegF+1*SegG ,//y
  0 //z
  
);
const SpecialLUT7Seg: array[0..10] of byte = (
  0*SegA+0*SegB+0*SegC+0*SegD+0*SegE+0*SegF+1*SegG ,//-
  0*SegA+0*SegB+0*SegC+1*SegD+0*SegE+0*SegF+0*SegG ,//_
  1*SegA+0*SegB+0*SegC+0*SegD+0*SegE+0*SegF+0*SegG ,//~
  1*SegA+1*SegB+0*SegC+0*SegD+0*SegE+1*SegF+0*SegG ,//^
  0*SegA+0*SegB+0*SegC+1*SegD+0*SegE+0*SegF+1*SegG ,//=
  1*SegA+0*SegB+0*SegC+1*SegD+1*SegE+1*SegF+0*SegG ,//[
  1*SegA+1*SegB+1*SegC+1*SegD+0*SegE+0*SegF+0*SegG ,//]
  0*SegA+1*SegB+1*SegC+0*SegD+0*SegE+0*SegF+1*SegG ,//{
  0*SegA+0*SegB+0*SegC+0*SegD+1*SegE+1*SegF+1*SegG ,//}
  1*SegA+0*SegB+0*SegC+1*SegD+0*SegE+0*SegF+1*SegG ,//%
  1*SegA+1*SegB+0*SegC+0*SegD+0*SegE+1*SegF+1*SegG //@ degree
);
//Map used to map segments of NSM4000 to BEL M5451D4 family displays
//NSM4000 has the obvious mapping ie bit1 is seg A4...
//M5451D4 has a single sided pcb optimised arrangement
const M5451D4Map : array[0..34] of Longint =
 (31-1, //map is 0 indexed hence -1
  30-1,
  4 -1,
  3 -1,
  2 -1,
  32-1,
  33-1,
  5 -1,
  27-1,
  26-1,
  8 -1,
  7 -1,
  6 -1,
  28-1,
  29-1,
  9 -1,
  23-1,
  22-1,
  12-1,
  11-1,
  10-1,
  24-1,
  25-1,
  13-1,
  19-1,
  18-1,
  16-1,
  15-1,
  14-1,
  20-1,
  21-1,
  17-1,
  1 -1,
  34-1,
  35-1);

function ReverseBitOrder(B:byte) :byte ;
{swaps bit order of byte ie Bit7 goes to 0  and vice versa}
  var i:byte;
begin
  result:=0;
  for i:=1 to 8 do begin
    result:=result shl 1;
    if ((B and 1)=1)
      then result:=result or 1;
    B:= B shr 1;
  end;
end; //ReverseBitOrder
function Str27Seg(S: string) : string ;
 {take an ascii string and turn into 7 seg data}
  var i,digitnum:integer;
      Ch:char;
      R,R5:byte;
      HoldDigitNum:boolean;
begin
  result:='';
  //S:=LeftPadl(S,4);
  digitnum:=1; //Digit1 is the LSB ie rightmost digit !!!!!
  result:=chr(0)+chr(0)+chr(0)+chr(0)+chr(0);
  R5:=0;
  for i:=length(S) downto 1 do begin
    if digitnum<=4 
      then begin
          HoldDigitNum:=false;
          Ch:=S[i]; //get the char
          case Ch of
            '0'..'9': R:=AlphaLUT7Seg[ord(Ch) - byte('0')];
            'A'..'Z': R:=AlphaLUT7Seg[ord(Ch) - byte('A')+10];
            'a'..'z': R:=AlphaLUT7Seg[ord(Ch) - byte('a')+10];
            '-': R:=SpecialLUT7Seg[0];
            '_': R:=SpecialLUT7Seg[1];
            '~': R:=SpecialLUT7Seg[2];
            '^': R:=SpecialLUT7Seg[3];
            '=': R:=SpecialLUT7Seg[4];
            '[','<': R:=SpecialLUT7Seg[5];
            ']','>': R:=SpecialLUT7Seg[6];
            '{': R:=SpecialLUT7Seg[7];
            '}': R:=SpecialLUT7Seg[8];
            '%': R:=SpecialLUT7Seg[9];
            '@': R:=SpecialLUT7Seg[10];
            '.',':' : begin
                        R:=SegDp;
                        HoldDigitNum:=true;
                      end;
            else R:=0; //unknown chars are blank
          end; //case
          result[5-digitnum]:= chr(byte(result[5-digitnum]) or R); //or dp in
          if not HoldDigitNum
              then digitnum:=digitnum+1;
         end //digits 1-4

       else
          begin //into digit5 or more
            HoldDigitNum:=true; //stall at digit 5
            Ch:=S[i]; //get the char
            case Ch of
              '1': R5:=R5 or SegA5 or SegB5;
              '-': begin
                     R5:=R5 or SegG5;
                     //HoldDigitNum:=true;
                   end;
              '.',':' : begin
                          R5:= R5 or SegDp5;
                          //HoldDigitNum:=true;
                        end;
              else R:=0; //unknown chars are blank
            end; //case
          end; //digitnum=6

    //R:=reverseBitOrder(R);
  end; //for
   result[5]:=chr(R5);
end; //Str27Seg

function Map2M5451D4(S:ansistring) :ansistring ;
  {maps the (obvious) NSM4000 segment arrangement to the M5451D4 modules optimised pcb layout}
  var B4,After:TStBits;
begin
  //I use the bitset class for mapping bit positions
  B4:=TStBits.create(35-1);
  After:=TStBits.create(35-1);
  B4.AsString:=S;
  After.MapBits(B4,M5451D4Map);
  result:=After.AsString;
end; //Map2M5451D4

function String2Hex(S:string) :string;
  {returns a string (of bytes) as a string of 2 hex chars}
  var i:integer; B:byte;
begin
  result:='';
  for i:=1 to length(S) do begin
    B:= byte(S[i]);
    B:=ReverseBitOrder(B); //bits will be sent from BL233 MSB first
    result:=result + inttohex(B,2);
  end;
end;

function Str2M5451D4(S:string):string;
{returns the hex chars to send to an M5451D4 display via BL233}
begin
  result:=Str27Seg(S);
  result:=Map2M5451D4(result);
  result:=String2Hex(result);
end;

function Str2NSM4000(S:string):string;
{returns the hex chars to send to an M5451D4 display via BL233}
begin
  result:=Str27Seg(S);
  //don't map
  result:=String2Hex(result);
end;
function ClearM5451D4Str:string; //Command string to clear M5451 . Must be sent after power on, before first data str
begin
  result:='Y W0000000000 Y101 0000000000 '; //send 6 bytes of zeros to ensure sync, then send zeros
end;


function Str2M5451D4viaBL233(S:string) :string ;
begin
  result:='Y101 '; //start bit is a 1
  result:=result+Str2M5451D4(S);
end; //Str2M5451D4viaBL233

function HexStr2Ascii(S:string) :string;
  {converts a string of hex into ascii. Resulting string will be half the length
  ignores all whitespace and non-hex chars}
  var i,j,L:integer; HexChar,ByteVal:byte;
      IsHiNibble:boolean;
  procedure DoChar(BaseChar:byte);

   begin
    HexChar:=HexChar-BaseChar;
    if IsHiNibble then begin
        ByteVal:=HexChar*16;
        IsHiNibble:=false;
      end
      else begin
        ByteVal:=ByteVal+HexChar;
        result[j]:=char(ByteVal);
        inc(j);
        IsHiNibble:=true;
      end;
  end;

begin
  L:=length(S);
  i:=1;
  j:=1;
  IsHiNibble:=true;
  while i<L do begin
    HexChar:=byte(S[i]);
    case HexChar of  //this will ignore all non-hex chars
      byte('0')..byte('9') : DoChar(byte('0'));
      byte('A')..byte('F') : DoChar(byte('A')-10);
    end; //case
    inc(i);
  end;//while
end; //hexstr2ascii

{const AddressBase=-7;
function EES(S:string):string;
  procedure ShowByte(NameStr:string; Address:integer);

  begin
    R:=Namestr+'@0x'+hexb(Address=hexb(S[Address])
  end

begin

  //check length to make sure we have whole eeprom perhaps
  ShowByte('fSerial',1);
  ShowByte('BaudDiv',2);
  ShowWord('TimerDiv',S[3]);
  ShowByte('fControl',S[4]);
  ShowByte('IRQVector'
  ShowByte('WatchDogVector',
  ShowAscii('');

end;   }

end.


















