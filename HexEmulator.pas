unit HexEmulator;

interface
 uses ADTrmEmu;
type
  THexEmulatorShowAs = (NoStr,HexStr, Int8Str, Uint8Str, Int16Str, Uint16Str, BinaryStr,NibbleStr,Float4Str);
  THexEmulator = object
    private
    ShowChar : boolean; {shows ascii chars}
    UnprintablesBlank: boolean;
    HasTrailingSpace : boolean; {uses a space between chars}
    ShowAs : THexEmulatorShowAs;

//    History: array [1..10] of byte;
//    HistoryLength:integer;
//    HistoryWrPos:integer;
    HistoryString: shortstring;
    SyncString: shortstring;
    SyncLength:integer;

    SyncAND, SyncXOR: shortstring;
    SyncLeading:boolean;
    IsFrameEnd:boolean;
    fSyncCount:integer;
    fSyncCountChanged:boolean;
    procedure NewChar(C:char);
    procedure SetSyncCount(Value:integer);
    public
    NumChars: byte; {the number of chars put on terminal for each incoming char}
    InvertData : boolean;
    MaskMSB:boolean;
    GulpCount:integer;
    BigEndian : boolean;

    procedure Init(iShowChar,iUnPrintablesBlank,iHasTrailingSpace, iInvertData: boolean; iMaskMSB:boolean ;
                      iShowAs:THexEmulatorShowAs;iNumChars:byte);
    procedure SetSync(inSync,inXOR, inAND:shortstring; inLeading:boolean);  //sets the Sync values
    procedure ProcessChar(Sender: TObject;
  C: Char; var ReplaceWith: String; Commands: TAdEmuCommandList;
  CharSource: TAdCharSource);
    function IsSyncCountChanged:boolean;
    property SyncCount:integer read fSyncCount write SetSyncCount;
  end; //HexEmulator

implementation
uses SysUtils, StStrL, StStrS, StUtils, Realterm1;
{$J+} //D7
procedure THexEmulator.Init(iShowChar,iUnPrintablesBlank,iHasTrailingSpace, iInvertData: boolean; iMaskMSB:boolean;
                      iShowAs:THexEmulatorShowAs;iNumChars:byte);
begin
  ShowChar:=iShowChar;
  UnPrintablesBlank  :=iUnPrintablesBlank;
  HasTrailingSpace:=iHasTrailingSpace;
  ShowAs:=iShowAs;
  NumChars:=iNumChars;
  InvertData:=iInvertData;
  MaskMSB:=iMaskMSB;
  //HistoryLength:=0;
  //HistoryWrPos:=0;
  HistoryString:='';
  GulpCount:=0;
  SetSync('','','',false);
  fSyncCountChanged:=true;
  fSyncCount:=0;
end;
procedure THexEmulator.SetSyncCount(Value:integer);
begin
  fSyncCount:=value;
  fSyncCountChanged:=true;
end;

function THexEmulator.IsSyncCountChanged:boolean;
begin
  result:=fSyncCountChanged;
  fSyncCountChanged:=false;
end;
procedure THexEmulator.NewChar(C:char);
  var i:integer;
begin
  SyncLength:=length(SyncString);
  if SyncLength=0 then exit;

  if length(HistoryString) < SyncLength //length(HexEmulator.SyncString)
    then HistoryString:=HistoryString+C
    else HistoryString:= copy(HistoryString,2,SyncLength)+C;
  //FrameEnd:=(HexEmulator.HistoryString=HexEmulator.SyncString);
  IsFrameEnd:=true;
  for i:=1 to SyncLength do begin  //do bytewise
    IsFrameEnd:= IsFrameEnd and
      (byte(SyncString[i]) = (byte(HistoryString[i]) xor byte(SyncXOR[i])) and byte(SyncAND[i]));
  end;
  if IsFrameEnd then begin
    inc(fSyncCount);
    fSyncCountChanged:=true;
  end
end;
procedure THexEmulator.ProcessChar(Sender: TObject;
  C: Char; var ReplaceWith: String; Commands: TAdEmuCommandList;
  CharSource: TAdCharSource);
{procedure TForm1.AdEmulator_HexProcessCharOld(CP: TObject; C: Char;
    var Command: TEmuCommand);}
  var CShow:string; //char to actually display
      BinStr: string;
      //LeadingSpaces:byte;
      FrameEnd:boolean;
  const PendingChars:integer=0; //used where displayed numbers are multi-byte
  const WordInFrameCount:integer=0; //used to allow formatted frames to be displayed
  const LastC:Char=char(0);

  procedure MakeFloat4String;
  const V: array[1..4] of char='1234';
  begin
    assert(PendingChars>0);
    if (PendingChars>4) then PendingChars:=4;
    if BigEndian
      then V[5-PendingChars]:=C
      else V[PendingChars]:=C;

    if (PendingChars>=4) then begin
        BinStr:=FloatToStrF(single(V),ffGeneral,4,3){+' '};
        PendingChars:=0;
       end
       else BinStr:='';
  end;
begin
  PendingChars:=PendingChars+1; //as at least C is pending
  //we do a raw invert before any other processing at all
  if ( InvertData ) then begin
    C:= char(not byte(C));
  end;
  if MaskMSB then begin
        C:=char(127 and byte(C));
    end;

  NewChar(C);
  FrameEnd:=IsFrameEnd;
  if ShowChar
    then begin
        if UnprintablesBlank
             and ((byte(C)<32) or (byte(C)>127))
          then CShow:=' ' //don't try to print control codes
          else CShow:=C;
      end
    else CShow:='';
  case ShowAs of
    NoStr   : BinStr:='';
    HexStr  : BinStr:=IntToHex(Byte(C),2);
    BinaryStr  : BinStr:=BinaryBL(Byte(C));
    NibbleStr : begin  // nibbles divided by "."
                BinStr:=BinaryBL(Byte(C));
                insert('.',BinStr,5);
              end;
    Int8Str : begin
                BinStr:=IntToStr(shortint(C));
                LeftPadS(BinStr,4); //was3
               end;
    Uint8Str: begin
                BinStr:=IntToStr(byte(C));  //must have space enabled to work properly...
                LeftPadS(BinStr,3); //was4
              end;
    Int16Str,UInt16Str: begin
              if PendingChars>=2 //no chars ready
                then begin   //put a word together
                  if ShowAs=Int16Str
                    then begin
                      if BigEndian
                        then BinStr:=IntToStr(MakeInteger16(byte(LastC),byte(C)))
                        else BinStr:=IntToStr(MakeInteger16(byte(C),byte(LastC)));
                      BinStr:=LeftPadS(BinStr,6);
                    end
                    else begin //uint16
                      if BigEndian
                        then BinStr:=IntToStr(MakeWord(byte(LastC),byte(C)))
                        else BinStr:=IntToStr(MakeWord(byte(C),byte(LastC)));
                      BinStr:=LeftPadS(BinStr,5);
                    end;
                  PendingChars:=0; //used them
                  end; //pending
              end;
     Float4Str: begin
                  MakeFloat4String;
              {if PendingChars>=4 //no chars ready
                then begin   //put a word together
                  MakeFloat4Str;
                  PendingChars:=0; //used them
                  end; //pending }
              end;//
  end; //case
  //Command.OtherStr := CShow+BinStr;
  ReplaceWith := CShow+BinStr;
  if (HasTrailingSpace) {and not (ShowAs = Uint8str)}
    then ReplaceWith := ReplaceWith + ' ' //Command.OtherStr:=Command.OtherStr+' '
    else begin
//      if (CharCount and 1)<>0  //trys to give alternating colors...
//        then begin
//          Command.FColor:=Command.Fcolor xor 255;
//          Command.bColor:=Command.bcolor xor 255;
//        end;
    end;
  //IncCharCount(1);
  if FrameEnd
    then begin
      if SyncLeading
      then ReplaceWith := char(13)+char(10) + ReplaceWith
      else ReplaceWith := ReplaceWith + char(13)+char(10);//Command.OtherStr:=Command.OtherStr+char(13)+char(10);
    end;
  if GulpCount>=1
    then begin
      dec(GulpCount);
      //Command.Cmd:=eNone; // swallow this char
      ReplaceWith := '';
    end;
  //Command.Ch:=char(0); //try to prevent spurious screen resizing
  //assert(length(Command.OtherStr)<=10); // is this valid or too late?
  assert(length(ReplaceWith)<=12); // is this valid or too late?
  LastC:=C;
  if FrameEnd then begin
    PendingChars:=0; // forces some sort of sync...
    WordInFrameCount:=0;
  end;
  Form1.SetTerminalCharColor(Sender,CharSource);
end;
//-------------------
procedure THexEmulator.SetSync(inSync,inXOR, inAND:shortstring; inLeading:boolean);  //sets the Sync values
begin
 SyncString:=inSync;
 SyncAnd:=inAND;
 SyncXOR:=inXOR;
 SyncLeading:=inLeading;

 if length(SyncAND)<>length(SyncString) //sync must be same size or default to FF
    then begin
      SyncAND:=CharStrS(#255,length(SyncString));
    end;
  if length(SyncXOR)<>length(SyncAnd) //default to 00
    then begin
      SyncXOR:=CharStrS(#0,length(SyncAND));
    end;
end;



end.
