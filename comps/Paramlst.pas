unit Paramlst;
// _                                                                     _
//   Author name   = Thomas Moore                                        _
//   Author E-mail = Dagger@provalue.net                                 _
//   Author URL    = www.provalue.net/users/tmoore                       _
//   Version       = 1.0          12.10.1997                             _
// _                                                                     _
//   New OPTIONS   = Kurt Kosnar                                         _
//          E-Mail = kurt.kosnar@usa.net                                 _
//   Version       = 1.1          18.10.1998                             _
// _                                                                     _
//   ReWritten                                                           _
//   most of it    = Kurt Kosnar                                         _
//          E-Mail = kurt.kosnar@usa.net                                 _
//   Version       = 1.2          28.12.1998                             _
// _                                                                     _
// ********************************************************************* _

{    from Kurt Kosnar : the NEW OPTIONS are less then I can think of     _
     Version 1.1                                  but all I needet !     _
                      ----------------------------------------------     _
     differenzes :                                                       _
     1.) Name NEW : Parameter                                            _
              OLD : Paramater                                            _
     2.) onParamMatch and onSwitchMatch                                  _
         have 1 more parameter for the User                              _
         called " Reference "                                            _
         Anything else works like before BUT the following will bring    _
         results                                                         _
                                                                         _
         the defined Switch or Param may have a REFERECE to the          _
         connected SUB-Parameter                                         _
                                                                         _
         SAY : defined Switch is "/Log"                                  _
                       Input is  " /Log " as before                      _
               or NEW            " /Log=True "                           _
               RESULT       CaseMatch : TRUE                             _
                            Param     : Log                              _
                            Reference : True                             _
                                                                         _
         Or    defined Param is "LogFile"                                _
                       Input is  " LogFile " as before                   _
               or NEW            " LogFile=tmp_log.txt "                 _
               RESULT       CaseMatch   : TRUE                           _
                            ParamSwitch : LogFile                        _
                            Reference   : tmp_log.txt                    _
                                                                         _
         Legal CONNECTOR from Parameter to the SUB-Parameter             _
         may be the ":" or the "=" sign                                  _
                                                                         _
         *** thats it - KK ***                                           _
                                                                         }

{    from Kurt Kosnar : ADDED ability to use Commandline NOT JUST        _
     Version 1.2                                  the REAL PROGRAMCALL   _
                      ----------------------------------------------     }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TParamMatch  = procedure( Sender: Tobject;
                            CaseMatch: Boolean;
                            Param,
                            Reference : String) of object;
  TSwitchMatch = procedure( Sender: TObject;
                            CaseMatch: Boolean;
                            ParamSwitch,
                            Reference : String) of object;
  TParameter = class(TComponent)
  private
    { Private declarations }
    //                 .
    FParamlist         : TStringlist;
    FSwitchList        : TStringlist;
    FSwitchWatch       : TStringlist;
    FParamWatch        : TStringlist;
    FParamMatch        : TParamMatch;
    FSwitchMatch       : TSwitchMatch;
    FUseProgramParams  : boolean;                                                //Variable used in property
    FParamString       : TStringList;                                                 //Variable used in property
    Procedure PutParamString(value : TStringList);
    Procedure Break_Line( S : String ; L : TStringList ) ;
  protected
    { Protected declarations }
    Procedure Loaded; Override;
    Procedure NoWrite(value: TStringlist);
    Procedure WriteParamWatch(Value: TStringlist);
    Procedure WriteSwitchWatch(Value: TStringlist);

  public
    { Public declarations }
    Constructor Create(AOwner : TComponent); override;
    property ParamList: TStringlist  read FParamlist  write nowrite;
    property SwitchList: TStringlist read FSwitchlist write nowrite;
    Procedure Execute;
  published
    { Published declarations }
    property ParamWatch: TStringlist     read  FParamWatch
                                         write WriteParamWatch;
    property SwitchWatch: TStringlist    read  FSwitchwatch
                                         write WriteSwitchWatch;
    property OnParamMatch: TParamMatch   read  FParamMatch
                                         write FParamMatch;
    property OnSwitchMatch: TSwitchMatch read  FSwitchMatch
                                         write FSwitchmatch;
    property useProgramParams : boolean  read  FUseProgramParams
                                         write FUseProgramParams
                                         default True ;
    property ParamString : TStringList   read  FParamString
                                         write PutParamString;
    Procedure Execute_LINE ( Line : String ) ;

  end;

procedure Register;

implementation
// _                                                        _
// _                                                        _
// Decode and EXECUTE the CommandLine                       _
// _                                                        _
// _                                                        _
Procedure TParameter.Execute_LINE ( Line : String ) ;
Begin
   FUseProgramParams := False ;
   Break_Line( Line , FParamString ) ;
   Execute ;
End ;
// _                                                        _
// _                                                        _
// Break a Line apart ( Delimeters are Blank and Tab        _
// _                                                        _
// _                                                        _
Procedure TParameter.Break_Line( S : String ; L : TStringList ) ;
VAR    I        : Integer ;
       X        : String ;
       T        : Boolean ;
BEGIN   // Commandline decoding where a Blank or a TAB is used as          _
   L.Clear ;  // delimeter . Parameters enclosed with " will be used as    _
   X := '' ;  // ONE Parameter                                             _
   T := False ;
   S := S + ' ' ;
   FOR I := 1 TO Length(S) DO
   BEGIN
      IF ( ( S[I] = ' ' ) OR ( S[I] = CHR(9) ) ) AND NOT T THEN
      BEGIN
         IF X <> '' THEN
         BEGIN
            IF ( CHR(34) = X[1] ) THEN X := COPY(X,2,Length(X)-2) ;
            L.Add(X) ;
            X := '' ;
         END ;
      END ELSE
      BEGIN
         IF ( S[I] = CHR(34) )
            THEN T := NOT T ;
         X := X + S[I] ;
      END ;
   END ;
END ;
// _                                                        _
// _                                                        _
// EXECUTE the Decoded CommandLine                          _
// _                                                        _
// _                                                        _
Procedure TParameter.Execute;
var i, c: integer;
    tempstr: string;
    startparm: boolean;
   // internal COMPARE AND SEND                             .
   Function DO_Cmp( C , S , T , R : String  ;
                     of_Case   ,
                     Sub1      : Boolean ) : Boolean ;
   //   C = Comparestring                        .
   //   S = UserParameter                        .
   //   T = Comparestring with without : or =    .
   //   R = ReferenceString                      .
   VAR   Do_Exit : Boolean ;
   BEGIN
      Result := False ;
      Do_Exit := True ;
      IF     of_Case AND ( C = S )
         THEN Do_Exit := False ;
      IF NOT of_Case
         AND ( AnsiUpperCase(C) = AnsiUpperCase(S) )
             THEN Do_Exit := False ;
      IF Do_Exit THEN Exit ;
      IF Sub1
         THEN FParamMatch (Self, of_Case, T , R )
         ELSE FSwitchMatch(Self, of_Case, T , R ) ;
      Result := True ;                    // all is well - SAY END       .
   END ;
   // internal Sub to Check and Send Params                 .
   Procedure Check_Pars( Sub1     : Boolean ;
                         Chk_Str  ,
                         Send_Str : String ) ;
   VAR    Status    : Boolean ;
          tmp_Chk   ,
          tmp_Send  ,
          Refer     : String ;
      // Prepare PARAM with : or = or := or whatever           .
      Procedure Prepare_STR( S : String ) ;
      BEGIN
         Status := False ;
         tmp_Chk  := Chk_Str + S ;
         IF Length(Send_Str) < Length(tmp_Chk)+1 THEN Status := TRUE ;
         IF Status THEN EXIT ;
         tmp_Send := Copy(Send_Str,1,Length(Chk_Str)) + S ;
         Refer    := Copy(Send_Str,Length(Chk_Str)+Length(S)+1,255) ;
      END ;
   BEGIN
      Status := DO_Cmp( Chk_Str, Send_Str, Chk_Str, ''   , True , Sub1 ) ;
      IF Status THEN Exit ;
      Status := DO_Cmp( Chk_Str, Send_Str, Chk_Str, ''   , False, Sub1 ) ;
      IF Status THEN Exit ;
      // Prepare Compare = and check                        .
      Prepare_STR('=') ;    // will set the STATUS          .
      IF Status THEN Exit ;
      Status := DO_Cmp( tmp_Chk, tmp_Send, Chk_Str, Refer, True , Sub1 ) ;
      IF Status THEN Exit ;
      Status := DO_Cmp( tmp_Chk, tmp_Send, Chk_Str, Refer, False, Sub1 ) ;
      IF Status THEN Exit ;
      // Prepare Compare : and check                        .
      Prepare_STR(':') ;    // will set the STATUS          .
      IF Status THEN Exit ;
      Status := DO_Cmp( tmp_Chk, tmp_Send, Chk_Str, Refer, True , Sub1 ) ;
      IF Status THEN Exit ;
      Status := DO_Cmp( tmp_Chk, tmp_Send, Chk_Str, Refer, False, Sub1 ) ;
   // IF Status THEN Exit ;
   END ;
   //                                                       _
begin
   FSwitchList.Clear ;
   FParamList.Clear ;
   IF FuseProgramParams THEN // if real program call        _
   BEGIN
      FParamString.Clear;
      for i := 0 to paramcount do
      Begin
         TempStr := ParamStr(I) ;
         //sjb This doesn't seem to be needed, and the following processing doesn't seem to work properly, but I can't be bothered trying to see why
 (*        IF ( POS(CHR(9),TempStr ) <> 0 )    //string contains TAB
            OR ( POS( ' ',TempStr ) <> 0 )   //or space
               THEN tempstr := CHR(34) + TempStr + CHR(34) ;  //enclose in "
  *)       FParamString.Add( TempStr ) ;
      END ;
   END ;
   //                                                       _
   startparm := False;
   for i := 0 to FParamString.Count - 1 do
   begin
      IF POS(CHR(34),FParamString.Strings[I] ) <> 0
            THEN Sleep (1) ;
      IF I > 0 THEN
      BEGIN
         if (copy( FParamString.Strings[I] , 1, 1) = '"') //1st char in string is quote "
            and (not startparm) then
         begin
            startparm := True;
            tempstr := '';
            tempstr := copy(FParamString.Strings[I], 2, length(FParamString.Strings[I]));
         end
         else if (copy(FParamString.Strings[I], length(FParamString.Strings[I]), 1) = '"') //last char is quote "
                 and (startparm) then
         begin
            if length(FParamString.Strings[I]) > 1
               then tempstr := tempstr + ' ' +
                    copy(FParamString.Strings[I], 1, length(FParamString.Strings[I]) - 1)
            else tempstr := tempstr + ' ';
            if (copy(tempstr, 1, 1) = '-') or
               (copy(tempstr, 1, 1) = '/') then
                 FSwitchlist.Add(copy(tempstr, 2, length(tempstr)))
            else FParamlist.Add(tempstr);
            startparm := False;
         end
         else if startparm
                 then tempstr := tempstr + FParamString.Strings[I]
         else if (copy(FParamString.Strings[I], 1, 1) = '-') or     //1st char is dash -
                 (copy(FParamString.Strings[I], 1, 1) = '/') then   //1st char is forward slash /
                   FSwitchlist.Add(copy(FParamString.Strings[I], 2, length(FParamString.Strings[I]))) //then add to SWITCHES not params
         else    FParamlist.Add(FParamString.Strings[I]);   //save as is
      END ;
   END ;

   IF FParamString.Count - 1 > 0 THEN
   BEGIN
      if assigned(FParamMatch) then
         for i := 0 to FParamlist.count - 1 do
            For C := 0 to FParamWatch.count - 1 do
               Check_Pars(True,FParamWatch.Strings[c],FParamlist.Strings[i]);
      if assigned(FSwitchMatch) then
         for i := 0 to FSwitchlist.count - 1 do
            for C := 0 to FSwitchWatch.count - 1 do
               Check_Pars(False,FSwitchWatch.Strings[c],FSwitchList.Strings[i]);
   END ;

end;

Procedure TParameter.Loaded;
begin
   inherited Loaded;
   Execute;
end;

Constructor TParameter.Create(AOwner : TComponent);
Begin
   inherited Create(AOwner);
   FSwitchWatch        := TStringlist.create;
   FSwitchWatch.Sorted := False;
   FSwitchList         := TStringlist.create;
   FSwitchlist.sorted  := False;
   fParamList          := TStringlist.Create;
   FParamlist.sorted   := False;
   FSwitchlist         := TStringlist.Create;
   FSwitchlist.Sorted  := False;
   FParamWatch         := TStringlist.Create;
   FParamWatch.sorted  := False;
   FParamString        := TStringList.Create ;     // NOT Sorted              _
   FParamString.Sorted := False ;
   FUseProgramParams   := True ;
End;

Procedure TParameter.WriteParamWatch(Value: TStringlist);
begin
   FParamWatch.Clear;
   FParamWatch.AddStrings(Value);
end;

Procedure TParameter.WriteSwitchWatch(Value: TStringlist);
begin
   FSwitchWatch.Clear;
   FSwitchWatch.AddStrings(Value);
end;

procedure TParameter.NoWrite(value: TStringlist);
begin
   raise Exception.Create('Can''t modify a read-only property');
end;

Procedure TParameter.PutParamString(value : TStringList);
begin
  FParamString := value;
end;

procedure Register;
begin
   RegisterComponents('System', [TParameter]);
end;

end.


