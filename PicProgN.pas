
{+--------------------------------------------------------------------------+
 | Created:     2001-06-24 15:45:41
 | Author:      
 | Company:     
 | Copyright    
 | Description: 
 | Version:  $Revisions$ $Date: 2002-12-30 17:22:53+13 $
 | Open Issues:
 +--------------------------------------------------------------------------+}
 
unit PicProgN;

interface
uses Windows,Messages,SysUtils,Classes,PortIO;

type
TPicPN = class(TDLPrinterPortIO)
  private
  FPower: Boolean;
  FAutoOpen:boolean;
  fIsOpen : boolean;
  fRB7 : boolean;

    function GetPower: Boolean;
    procedure SetPower(AValue: Boolean);
    function GetOpen: Boolean;
    procedure SetOpen(AValue: Boolean);
    function getRB7: boolean;
    procedure setRB7(AValue: boolean);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Reset(Channel:integer);
    procedure Idle;
    procedure MakeOpen;
  published
    property AutoOpen : boolean read FAutoOpen write FAutoOpen;
    property Power: Boolean read GetPower write SetPower;
    property Open : boolean read getOpen write setOpen;
    property RB7 : boolean read getRB7 write setRB7;
end; {TPicPN}

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DiskDude', [TPicPN]);
end;

//////////////////////// TPicPN ///////////////////////
{Private methods for TPicPN}
procedure TPicPN.MakeOpen; {opens the driver if it is closed}
begin
  if (not fIsOpen) and fAutoOpen
    then SetOpen(true);
end; //MakeOpen

function TPicPN.GetPower: Boolean;
begin
  result:=FPower;
end; {GetPower}

procedure TPicPN.SetPower(AValue: Boolean);
begin
  // this is called during init when the Power property is loaded.
  FPower:= AValue;
  if not (csLoading in ComponentState) and not (csDesigning in ComponentState)
    then begin
      MakeOpen;
  //LPTAutofd(FPower);
      if AValue
        then Port[LPTBasePort+2]:=2 //Power ON
        else Port[LPTBasePort+2]:=0; //Power Off
    end; //if
end; {SetPower}


function TPicPN.GetOpen: Boolean;
begin
  if not(csDesigning in ComponentState) and not (csLoading in ComponentState)
        then begin 
          fIsOpen:=ActiveHW;
        end;
  result:=fIsOpen;
end; {GetOpen}

procedure TPicPN.SetOpen(AValue: Boolean);
begin
  if not(csDesigning in ComponentState) and not (csLoading in ComponentState)
     then begin 
       if AValue
          then OpenDriver
          else CloseDriver;
       fIsOpen:=ActiveHW;
       //fIsOpen:=true;
     end else begin  //designing or loading
       fIsOpen:=AValue;
     end
//  if fIsOpen then Idle;
end; {SetOpen}


function TPicPN.getRB7 : boolean;
begin
  result:=fRB7; //default...
  if not (csDesigning in ComponentState) and not (csLoading in ComponentState)
    then begin
      MakeOpen;
      fRB7:= not LPTAckwl;
      result:=fRB7;
    end; //if
end; //getRB7
procedure TPicPN.setRB7(AValue: boolean);
begin
  fRB7:=AValue;
{  if  not(csDesigning in ComponentState) and not (csLoading in ComponentState)
    then begin
      MakeOpen;
      if AValue
          Port[LPTBasePort]:= 
        else
          Port[LPTBasePort]:=  

      result:=fRB7;
    end; //if
               }
end; //setRB7

{Public methods for TPicPN}
constructor TPicPN.Create(AOwner: TComponent);
begin
inherited Create(Aowner);
fAutoOpen:=true;
fIsOpen:=false;
fPower:=false;

end; {Create}

destructor TPicPN.Destroy;
begin
//  if fIsOpen then Idle; //this seems to crash it on w2k
//sleep(1000);
//CloseDriver;
inherited Destroy; //also closes driver
end; {Destroy}

procedure TPicPN.Reset(Channel:integer);
begin
  //MakeOpen;
  case ( Channel ) of
    0: Port[LPTBasePort]:=4+16+64;//Pin[8]:=false;
    1: Port[LPTBasePort]:=4+16;
    2: Port[LPTBasePort]:=4+64;
  end;
  sleep(500);
  Idle;
end; {Reset}

procedure TPicPN.Idle; //power on, vmid,
begin
  MakeOpen;
  Port[LPTBasePort]:=4; // Vmid
  Port[LPTBasePort+2]:=2; //Power ON
end; {Idle}

{Published methods for TPicPN}
end.





















