unit I2Cx;
{Support routines for BL233B I2C interface chip
http://www.i2cchip.com
}
interface

  function IAscii2Hex(S:string; CompactAscii:boolean):string;
  function ConvertDelimitedHexStr2Dec(const S:string; BigEndian:boolean=true; Signed:boolean=false;FormatStr:string=''):string;
  procedure ConvertDelimitedHexFile(InputFname,OutputFname:string; BigEndian:boolean=true; Signed:boolean=false;FormatStr:string='');
(*  type tHexData = class
    private
      CurrentString:string;  //string that is being processed
      CurrentStringPos:integer; //pointer to current char pos

    protected

    public
    property FormatString:string;
    property BigEndian:boolean;
    property Signed:boolean;
    property HexString:string;
    function IncrementalConvertString(const HexString:String):string; //r
    function ConvertString(const HexString:string)
    function ConvertFile(InputFname,OutputFname:string)
    function PullQuotedString:string;
    function PullInteger:integer;
    function PullFloat:double;
    function PullChar:char;
  end;//class
 *)
implementation
uses sysutils,strutils,math;

function IAscii2Hex(S:string; CompactAscii:boolean):string;
  var i,n:integer;
      C:byte;
begin
  i:=1;
  n:=length(S);
  result:='';
  while (i<=N ) do begin
     C:=byte(S[i]);
    if ( CompactAscii and (C<=127) )
    then begin
      result:=result+chr(C+128);  //BL233 compact ascii mode
    end
    else begin
      result:=result+inttohex(C,2);
    end;
    inc(i);
  end;
end;

   Function ReverseEndian (V:longword; NibbleCount:integer) : longword ;
   //reverse endianness of an integer
   var i, ByteCount:integer;
       B:byte;
     //Var B0, B1, B2, B3 : Byte ;
    Begin
      ByteCount:=ceil(NibbleCount / 2);
      result:=0;
      for i:=1 to ByteCount do begin
        B:=(V and $000000FF);
        V:=V shr 8;
        result:=result shl 8;
        result:=result or B;
      end; //for
    End ;
// Reading routines

function HexN2Int(S:string;N:integer;BigEndian:boolean):longword;
begin

end;

// Convert a delimited string to delimited decimal
// Quoted strings are passed through with quotes
// numbers preceded by "d" (lower case) can be treated as bcd/decimal, and passed through without the "d"
// numbers containing "." can be treated as decimal floats

//4AsFloat
//8AsFloat
//SignedInts
//BigEndian
const QuoteChar:char = '"';
const Delims:string = ', ';
function IsDelimiter(C:char):boolean;
var i:integer;
begin
  result:=false;
  for i:=1 to length(Delims) do begin
    if C=Delims[i] then begin
       result:=true;
       break;
     end;
  end; //for
end; //fn

function SignAdjust(V:cardinal;NibbleCount:integer):longword;
//takes a number N nibbles long. Tests sign bit, and if set, fills the other bits
//uses lookups for test and or
const SignBitArray: array[1..8] of cardinal =
($00000008,
 $00000080,
 $00000800,
 $00008000,
 $00080000,
 $00800000,
 $08000000,
 $80000000);
const SignExtendArray: array[1..8] of cardinal =
($FFFFFFF0,
 $FFFFFF00,
 $FFFFF000,
 $FFFF0000,
 $FFF00000,
 $FF000000,
 $F0000000,
 $00000000);

begin
  if (V and SignBitArray[NibbleCount])<>0    //sign bit for this length is set
    then result:=V or SignExtendArray[NibbleCount]
    else result:=V;
end;

    function HexChar2Nibble(C:char):byte;
    //must be uppercase hex chars only
    var V:byte;
    begin
      if byte(C)<= byte('9')
        then V:=byte(C)-byte('0')
        else V:=byte(C)-byte('A')+10;
      result:=V;
      //result:=7;
    end;//fn

function Hex2Dec(HexS:string; BigEndian, Signed:boolean):longword;
//
var Ptr,PtrStep,ExitPtr:integer;
    NibbleCount:integer;
  procedure InitPtr;
    //setup pointer for either forward or reverse loading
    //this idea didn't work, as endianness is bytewise not nibblewise
    begin
      {if not BigEndian
        then begin
          Ptr:=length(HexS);
          PtrStep:=-1;
          ExitPtr:=0;
          end
        else begin }
          Ptr:=1;
          PtrStep:=1;
          ExitPtr:=length(HexS)+1;
       // end; //if
    end; //fn

var V:longword;
begin //hex2dec
  InitPtr;
  V:=0;
  NibbleCount:=0;
  while Ptr<>ExitPtr do begin
    V:=V shl 4; //make space for the nibble
    V:=V or HexChar2Nibble(HexS[Ptr]);

    Ptr:=Ptr+PtrStep; //move the pointer
    inc(NibbleCount);
  end; // while
  //so now we have an unsigned integer
  if not BigEndian then V:=ReverseEndian(V,NibbleCount);
  if Signed then V:=SignAdjust(V,NibbleCount);
  result:=V;
end; //fn hex2dec

function Hex2BinStr(S:string):string;
var i:integer; B:string; V:byte;
begin
  result:='';
  for i:=1 to length(S) do begin
    B:='0000';
    V:=HexChar2Nibble(S[i]);
    if (V and 8)>0 then B[1]:='1';
    if (V and 4)>0 then B[2]:='1';
    if (V and 2)>0 then B[3]:='1';
    if (V and 1)>0 then B[4]:='1';
    result:=result+B;
  end; //for
end; //fn
function Hex2DecStr(S:string;BigEndian,Signed:boolean):string;
  var V:longword;
begin
   V:=Hex2Dec(S,BigEndian,Signed);
      if Signed
        then result:=inttostr(longint(V))
        else result:=inttostr(V);

end; //fn
type PSingle=^Single;
function HexFloat2Str(S:string;BigEndian:boolean):string;
  var V:longword;
   X:Single; PV,PX:pointer;
begin
  V:= Hex2Dec(S,BigEndian,false);
  X:=PSingle(@V)^;

  case length(S) of
    8:  result:=Floattostr(X);
    else //invalid floating points
      result:=S;
    end;
end;
function Hex2AsciiStr(S:string):string;
  var V:byte;
      i:integer;
begin
  i:=1;
  result:='';
  while i<=length(S) do begin
    V:=HexChar2Nibble(S[i]);
    inc(i);
    if i<=length(S) then begin //there is another hex char to be had
      V:=V shl 4;
      V:=V or HexChar2Nibble(S[i]);
      inc(i);
    end;//if
    result:=result+char(V);
  end;//for
end;
//type TGetCharFunction = function(var C:char):boolean;
function ConvertDelimitedHexStr2Dec(const S:string; BigEndian:boolean; Signed:boolean;FormatStr:string):string;
//BigEndian and Signed set the default. Use of the explicit chars overides them
    //CommaDelim, TabDelim,

    //AllHex
    function ProcessSubString(S:string; IsAllHex,BigEndian,Signed:boolean;Float:boolean=false):string;
      procedure TrimLeadingCharX(var S:string; IsBigEndian, IsSigned:boolean; IsFloat:boolean=false);
      var STrimmed:string; i:integer;
      begin
        BigEndian:=IsBigEndian;
        Signed:=IsSigned;
        Float:=IsFloat;
        STrimmed:=RightStr(S,Length(S)-1);
        IsAllHex:=true;
        IsFloat:=false;
        for i:=1 to length(STrimmed) do begin
             case Strimmed[i] of
                '0'..'9','A'..'F' : ;
                else begin
                  IsAllHex:=false;
                end; //else
              end;//case
        end; //for
        if IsAllHex then S:=STrimmed;
      end; //fn
    var LengthS:integer;
        C1:char;
        V:longword;
        //Signed: boolean;
    begin
      LengthS:=length(S);
      if LengthS=0 then begin
        result:='';
        exit;
      end;

      C1:=S[1];
      {if (C1='d') and (LengthS>=2) then begin //explicit decimals
        result:=RightStr(S,LengthS-1); //prune off the leading D
        exit;
      end; }
      if LengthS>=2 then begin
      case C1 of
        'd': begin
               result:=RightStr(S,LengthS-1); //prune off the leading D
               exit;
              end;
        'b':  begin TrimLeadingCharX(S,true,false,true);
              result:=Hex2BinStr(S);
              exit;
              end;
        'a':  begin ;
              result:=Hex2AsciiStr(RightStr(S,LengthS-1));
              exit;
              end;
        'f':  TrimLeadingCharX(S,true,false,true); //big endian floating point
        'g':  TrimLeadingCharX(S,false,false,true); //little endian floating point
        's': TrimLeadingCharX(S,true,true);    //s signed bigendian
        't': TrimLeadingCharX(S,false,true);   //t  signed littleendian
        'u': TrimLeadingCharX(S,true,false);   //u unsigned bigendian
        'v': TrimLeadingCharX(S,false,false);   //v unsigned littleendian
        end; //case
      end; //if
      if not IsAllHex then begin //quoted strings, floats, random errors
          result:=S;
          exit;
      end;
      //must be a hex string to process....
      //Signed:=true;
      if Float
      then result:=HexFloat2Str(S,BigEndian)
      else result:=Hex2DecStr(S,BigEndian,Signed);
    end; //fn
var i, iSubString:integer;
    InQuotes:boolean;

var IsAllHex:boolean;
    c:char;
    SS:string; //substring
    iFormat:integer; //
begin
  InQuotes:=false;
  iSubString:=1;
  iFormat:=1;
  IsAllHex:=true;
  SS:='';
  result:='';
  for i:=1 to length(S) do begin
    c:=S[i];
  //while GetNextChar(c) do begin

    if c=QuoteChar then begin
        InQuotes:=not InQuotes;
    end;
    if InQuotes
        then begin
          SS:=SS+c; //add to substring, but
          end
          else begin
            if IsDelimiter(c) then begin
              //use the format string for Allhex strings, if within format string
              if IsAllHex and (length(FormatStr)>=1) and (iFormat<=length(FormatStr)) then begin
                SS:=FormatStr[iFormat]+SS;
                inc(iFormat);
              end; //if
              result:=result+ProcessSubString(SS,IsAllHex,BigEndian,Signed)+c;
              IsAllHex:=true;
              SS:='';
              inc(iSubstring);
            end
            else begin
              SS:=SS+c;
              case C of
                '0'..'9','A'..'F' : ;
                else begin
                  IsAllHex:=false;
                end; //else
              end;//case
            end;//if
      end;
  end; //for each char
  result:=result+ProcessSubString(SS,IsAllHex,BigEndian,Signed);
end; //fn


procedure ConvertDelimitedHexFile(InputFname,OutputFname:string;BigEndian:boolean; Signed:boolean;FormatStr:string);
var Input,Output:text;
    S,Sout:string;
    LineCount:integer;
begin
  LineCount:=0;
  try
    AssignFile(Input, InputFname);
    Reset(Input);
    AssignFile(Output, OutputFname);
    Rewrite(Output);
    while not EOF(Input) do begin
      ReadLn(Input,S);
      Sout:=ConvertDelimitedHexStr2Dec(S,BigEndian,Signed,FormatStr);
      WriteLn(Output,Sout);
      inc(LineCount);
    end; //while
  finally
    CloseFile(Input);
    CloseFile(Output);
  end; //try
end;

end.
