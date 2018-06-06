unit ADSpcEmu;  //Special Emulators

{$I AWDEFINE.INC}

{$Z-}

interface

uses
  {$IFDEF Win32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls,
  Forms, Dialogs, ClipBrd, Menus,
  OOMisc,
  ADPort, ADExcept,
  ADTrmPsr, ADTrmMap, ADTrmBuf,
  ADTrmEmu;

type TControlCharShowStyle=(ssShowControlChars,ssShowCRLF,ssAlwaysLFatCR,ssNoCRLFActions,ssShowBackspace, ssNoTabAction);
     TControlCharShowStyles=set of TControlCharShowStyle;

{ Optionally shows all chars.
 Requires special behaviour for CRLF.
 If CR or LF, then flag and store posn. If next char is CR/LF then write at pos+1
 (except @EOL)
 If showing CR/LF, then perhaps always do a LF when CR to prevent overwriting
 Backspace: If "show bckspace" doesn't backspace, writes backspace char

 }

type
  TAdShowAllEmulator = class(TAdTTYEmulator)
    private
//      FCellWidths    : PAdIntegerArray;
//      FDisplayStr    : PAnsiChar;
//      FDisplayStrSize: integer;
//      FPaintFreeList : pointer;
//      FRefresh       : Boolean;
        FControlCharShowStyles : TControlCharShowStyles;
        CRSinceLastRealChar:boolean;
        LFSinceLastRealChar:boolean;
        LastCharWasCR:boolean;
        LastCharWasLF:boolean;
        EndOfLastLineCol: integer;
        EndOfLastLineRow: integer;

        FColor4Keyboard :TColor;
        FColor4Port     :TColor;
        FColor4WriteChar:TColor;
        FColor4Unknown:TColor;
    protected
      {property accessor methods}
//      function teGetNeedsUpdate : boolean; override;

      {overridden ancestor methods}
//      procedure teClear; override;
//      procedure teClearAll; override;
//      procedure teSetTerminal(aValue : TAdCustomTerminal); override;

      {miscellaneous}
//      function  ttyCharToCommand (aCh : AnsiChar) : TAdEmuCommand;     {!!.04}
//      procedure ttyDrawChars(aRow, aStartCol, aEndCol : integer;
//                             aVisible : boolean);

      {paint node methods}
//      procedure ttyExecutePaintScript(aRow    : integer;
//                                      aScript : pointer);
//      procedure ttyFreeAllPaintNodes;
//      procedure ttyFreePaintNode(aNode : pointer);
//      function ttyNewPaintNode : pointer;

    public
      constructor Create(aOwner : TComponent); override;
      destructor Destroy; override;

      {overridden ancestor methods}
//      procedure KeyPress(var Key : AnsiChar); override;
//      procedure LazyPaint; override;
//      procedure Paint; override;
      procedure ProcessBlock (aData : pointer; aDataLen : longint;     {!!.04}
                              CharSource : TAdCharSource); override;   {!!.04}
    published
      property OnProcessChar;                                          {!!.04}
      property ControlCharShowStyles: TControlCharShowStyles read FControlCharShowStyles write FControlCharShowStyles;
      property Color4Keyboard : TColor read fColor4Keyboard write fColor4Keyboard;
//        FColor4Port     :TColor;
//        FColor4WriteChar:TColor;
//        FColor4Unknown:TColor;

  end;

implementation


procedure TAdShowAllEmulator.ProcessBlock (aData  : pointer;             {!!.04}
                                       aDataLen   : Longint;             {!!.04}
                                       CharSource : TAdCharSource);      {!!.04}
var
  DataAsChar : PAnsiChar absolute aData;
  i          : integer;
  j          : Integer;                                                  {!!.03}
  Ch         : AnsiChar;
  Str        : string;                                                   {!!.03}
  StrLen     : Integer;                                                  {!!.03}
  ThisCharIsCR, ThisCharIsLF : boolean;
  procedure WriteRealChar(Ch:AnsiChar);
  begin
    if CRSinceLastRealChar and not LFSinceLastRealChar
      then teProcessCommand(ecLF,nil);
    Buffer.WriteChar(Ch);
    CRSinceLastRealChar:=false;
    LFSinceLastRealChar:=false;
  end;
  procedure PutAtEndOfLastLine(Ch:ansichar);
  var EntryRow, EntryCol: integer;
  begin
    with Buffer do begin
      EntryRow:=Row; EntryCol:=Col;
      Buffer.Row:=EndOfLastLineRow;
      Buffer.Col:=EndOfLastLineCol;
      Buffer.WriteChar(Ch);
      EndOfLastLineCol:=Col;
      EndOfLastLineRow:=Row;
      Col:=EntryCol;
      Row:=EntryRow;
    end; //with
  end;
  procedure SavePosWriteChar(Ch:ansichar);
  begin
    Buffer.WriteChar(Ch);
    with Buffer do begin
      EndOfLastLineCol:=Col;
      EndOfLastLineRow:=Row;
    end; //with
  end;

begin
  case CharSource of
    csUnknown: Buffer.ForeColor:= FColor4Unknown;
    csKeyboard: Buffer.ForeColor:= FColor4Keyboard;
    csPort: Buffer.ForeColor    := FColor4Port;
    csWriteChar: Buffer.ForeColor:=FColor4WriteChar;
    else
      Buffer.ForeColor:= FColor4Unknown;
  end; //case

  for i := 0 to pred (aDataLen) do begin
    ThisCharIsCR:=false;
    ThisCharIsLF:=false;
    Ch := DataAsChar[i];
    SetLength (Str, 1);                                                  {!!.03}
    Str[1] := Ch;                                                        {!!.03}
    teClearCommandList;                                                  {!!.04}
    if Assigned (OnProcessChar) then                                    {!!.04}
      OnProcessChar (Self, Ch, Str, CommandList, CharSource);          {!!.04}
    teProcessCommandList (CommandList);                                 {!!.04}
    StrLen := Length (Str);                                              {!!.03}
    for j := 1 to StrLen do begin                                        {!!.03}
      Ch := Str[j];                                                      {!!.03}
//      if (Ch < ' ')
//        then begin
          case Ch of                                                          {!!.04}
            ^H : if ssShowBackspace in FControlCharShowStyles 
                   then WriteRealChar(Ch)
                   else teProcessCommand(ecBackspace,nil);                        {!!.04}
            ^I : {tab}
                begin
                   WriteRealChar(Ch);
                   if not (ssNoTabAction in FControlCharShowStyles)
                     then teProcessCommand(ecTabHorz,nil);
                end;
            ^J : begin//LF
                 if ssShowCRLF in FControlCharShowStyles
                   then begin
                     if LastCharWasCR
                      then PutAtEndOfLastLine(Ch) 
                      else SavePosWriteChar(Ch);                                                {!!.04}
                     //storep
                   end;
                if not (ssNoCRLFActions in FControlCharShowStyles) 
                  then begin
                    teProcessCommand(ecLF,nil);
                  end;
                ThisCharIsLF:=true;
                LFSinceLastRealChar:=true;
                end;
            ^M : begin//CR
                 if ssShowCRLF in FControlCharShowStyles
                   then begin
                     if LastCharWasLF
                      then PutAtEndOfLastLine(Ch) 
                      else SavePosWriteChar(Ch);                                               {!!.04}
                     //storep
                   end;
                if not (ssNoCRLFActions in FControlCharShowStyles)
                  then begin
                    teProcessCommand(ecCR,nil);
                  end;
                ThisCharIsCR:=true;
                CRSinceLastRealChar:=true;
                end;
            else                                                               {!!.04}
              WriteRealChar(Ch);
          end;{case}                                                           {!!.04}
//    end; //if                                                                 {!!.03}
    LastCharWasCR:=ThisCharIsCR;
    LastCharWasLF:=ThisCharIsLF;
  end; //for
  end; //for
end;

constructor TAdShowAllEmulator.Create(aOwner : TComponent);
begin
  {Note: the buffer *must* be created before the ancestor can perform
         initialization. The reason is that at design time dropping an
         emulator on the form will cause a series of Notification
         calls to take place. This in turn could cause a terminal's
         tmSetEmulator method to be called, which would then set up
         some default text in the emulator's buffer.}

  {create the buffer}
 // FTerminalBuffer := TAdTerminalBuffer.Create(false);

  {now let the ancestor do his stuff}
  inherited Create(aOwner);
  LastCharWasCR:=false;
  CRSinceLastRealChar:=false;

  ControlCharShowStyles :=[ssShowControlChars,ssShowCRLF,ssAlwaysLFatCR,{ssNoCRLFActions,}ssShowBackspace{, ssNoTabAction}];
  fColor4Keyboard:=clRed;
  fColor4Port    :=clYellow;
  fColor4WriteChar:=clLime;
  FColor4Unknown:=clWhite;

  {set up the terminal buffer and ourselves}
 // FDisplayStrSize := 256; {enough for standard terminals}
 // GetMem(FDisplayStr, FDisplayStrSize);
 // GetMem(FCellWidths, 255 * sizeof(integer));
 // FillChar(FCellWidths^, 255 * sizeof(integer), 0);

 //FTerminalBuffer.OnCursorMoved := teHandleCursorMovement;
end;
{--------}
destructor TAdShowAllEmulator.Destroy;
begin
  {free the paint node free list}
//  ttyFreeAllPaintNodes;
  {free the cell widths array}
//  if (FCellWidths <> nil) then
//    FreeMem(FCellWidths, 255 * sizeof(integer));
  {free the display string}
//  if (FDisplayStr <> nil) then
//    FreeMem(FDisplayStr, FDisplayStrSize);
  {free the internal objects}
//  FTerminalBuffer.Free;
  inherited Destroy;
end;
{--------}

end.





