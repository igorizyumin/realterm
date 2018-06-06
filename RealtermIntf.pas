unit RealtermIntf;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, realterm_TLB, StdVcl, ExtCtrls, AdPacket;

type
  TRealtermIntf = class(TAutoObject, IConnectionPointContainer, IRealtermIntf)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IRealtermIntfEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
    FEnableTimerCallbacks : boolean;
    FEnableCaptureCallbacks : boolean;
  public
    procedure Initialize; override;

    procedure SendEvent(EventNum:Integer); safecall;
    procedure SendEventOnTimer; safecall;
    procedure SendEventOnCaptureCount; safecall;
    procedure SendEventOnCaptureStop; safecall;
    procedure SendEventOnDataTrigger(TriggerNum:integer;Packet:TApdDataPacket); safecall;
    procedure SendEventOnDataTimeout; safecall;

  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function Get_baud: Integer; safecall;
    function Get_CaptureCountForCallback: Integer; safecall;
    function Get_CaptureFile: WideString; safecall;
    function Get_Capture: EnumCaptureMode; safecall;
    function Get_EnableCaptureCallbacks: WordBool; safecall;
    function Get_EnableTimerCallbacks: WordBool; safecall;
    function Get_Port: WideString; safecall;
    function Get_PortOpen: WordBool; safecall;
    function Get_TimerPeriod: Integer; safecall;
    procedure Set_baud(Value: Integer); safecall;
    procedure Set_CaptureCountForCallback(Value: Integer); safecall;
    procedure Set_CaptureFile(const Value: WideString); safecall;
    procedure Set_Capture(Value: EnumCaptureMode); safecall;
    procedure Set_EnableCaptureCallbacks(Value: WordBool); safecall;
    procedure Set_EnableTimerCallbacks(Value: WordBool); safecall;
    procedure Set_Port(const Value: WideString); safecall;
    procedure Set_PortOpen(Value: WordBool); safecall;
    procedure Set_TimerPeriod(Value: Integer); safecall;
    procedure Close; safecall;
    procedure StartCapture; safecall;
    procedure StartCaptureAppend; safecall;
    procedure StopCapture; safecall;
    function Get_CharCount: Integer; safecall;
    function Get_CPS: Integer; safecall;
    function Get_DisplayAs: Integer; safecall;
    function Get_FrameSize: Integer; safecall;
    function Get_WindowState: EnumWindowState; safecall;
    procedure Set_CharCount(Value: Integer); safecall;
    procedure Set_CPS(Value: Integer); safecall;
    procedure Set_DisplayAs(Value: Integer); safecall;
    procedure Set_FrameSize(Value: Integer); safecall;
    procedure Set_WindowState(Value: EnumWindowState); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_CaptureEnd: Integer; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_CaptureEnd(Value: Integer); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_CaptureEndUnits: EnumUnits; safecall;
    procedure Set_CaptureEndUnits(Value: EnumUnits); safecall;
    procedure PutString(const S: WideString); safecall;
    function  SelectTabSheet(const TabCaption: WideString): WordBool; safecall;
    function DiskFree(Drive: Integer): Double; safecall;
    function Get_CaptureTimeLeft: Integer; safecall;
    procedure PutChar(C: Byte); safecall;
    function Get_TrayIconActive: WordBool; safecall;
    procedure Set_TrayIconActive(Value: WordBool); safecall;
    function DiskSize(Drive: Integer): Double; safecall;
    function Get_BigEndian: WordBool; safecall;
    procedure Set_BigEndian(Value: WordBool); safecall;
    function Get_EchoPort: WideString; safecall;
    procedure Set_EchoPort(const Value: WideString); safecall;
    function Get_EchoPortOpen: WordBool; safecall;
    procedure Set_EchoPortOpen(Value: WordBool); safecall;
    function Get_HalfDuplex: WordBool; safecall;
    procedure Set_HalfDuplex(Value: WordBool); safecall;
    function Get_HideControls: WordBool; safecall;
    procedure Set_HideControls(Value: WordBool); safecall;
    function Get_Parity: WideString; safecall;
    procedure Set_Parity(const Value: WideString); safecall;
    function Get_DataBits: Integer; safecall;
    procedure Set_DataBits(Value: Integer); safecall;
    function Get_StopBits: Integer; safecall;
    procedure Set_StopBits(Value: Integer); safecall;
    function Get_EchoBaud: Integer; safecall;
    procedure Set_EchoBaud(Value: Integer); safecall;
    function Get_EchoParity: WideString; safecall;
    procedure Set_EchoParity(const Value: WideString); safecall;
    function Get_EchoDataBits: Integer; safecall;
    procedure Set_EchoDataBits(Value: Integer); safecall;
    function Get_EchoStopBits: Integer; safecall;
    procedure Set_EchoStopBits(Value: Integer); safecall;
    function Get_FlowControl: Integer; safecall;
    procedure Set_FlowControl(Value: Integer); safecall;
    function Get_EchoFlowControl: Integer; safecall;
    procedure Set_EchoFlowControl(Value: Integer); safecall;
    function Get_CharDelay: Integer; safecall;
    procedure Set_CharDelay(Value: Integer); safecall;
    function Get_LineDelay: Integer; safecall;
    procedure Set_LineDelay(Value: Integer); safecall;
    function Get_Rows: Integer; safecall;
    procedure Set_Rows(Value: Integer); safecall;
    function Get_SendFileDelay: Integer; safecall;
    procedure Set_SendFileDelay(Value: Integer); safecall;
    function Get_SendFileRepeats: Integer; safecall;
    procedure Set_SendFileRepeats(Value: Integer); safecall;
    function Get_SendFile: WideString; safecall;
    procedure Set_SendFile(const Value: WideString); safecall;
    function Get_Send: WordBool; safecall;
    procedure Set_Send(Value: WordBool); safecall;
    procedure ClearTerminal; safecall;
    function Get_MonitorOn: WordBool; safecall;
    procedure Set_MonitorOn(Value: WordBool); safecall;
    function Get_LinefeedIsNewline: WordBool; safecall;
    procedure Set_LinefeedIsNewline(Value: WordBool); safecall;
    procedure NewlineTerminal; safecall;
    function Get_DTR: WordBool; safecall;
    function Get_RTS: WordBool; safecall;
    procedure Set_DTR(Value: WordBool); safecall;
    procedure Set_RTS(Value: WordBool); safecall;
    function Get_CaptureDirect: WordBool; safecall;
    procedure Set_CaptureDirect(Value: WordBool); safecall;
    function AddCannedSendString(const SendString: WideString;
      ControlNum: Integer): WordBool; safecall;
    function Get_Version: WideString; safecall;
    procedure TimeStamp(Style: Integer; Delimiter: Byte); safecall;
    procedure DisableDataTrigger(Index: Integer); safecall;
    procedure EnableDataTrigger(Index: Integer); safecall;
    function WaitforDataTrigger(Timeout: Integer): WideString; safecall;
    function Get_CaptureAsHex: WordBool; safecall;
    procedure Set_CaptureAsHex(Value: WordBool); safecall;
    procedure DataTriggerSet(Index: Integer; const StartString,
      EndString: WideString; PacketSIze, TimeOut: Integer; AutoEnable,
      IgnoreCase, IncludeStrings: WordBool); safecall;
  end;

var
  RTI: TRealtermIntf;
implementation

uses ComServ{,Windows},Forms,Realterm1,AdTrmEmu,SysUtils{,OleCtrls},OoMisc,Messages;

//const FEnableTimerCallbacks : boolean=false;
//const FEnableCaptureCallbacks : boolean=false;
  //FEnableCaptureStopCallbacks : boolean=true;


procedure TRealtermIntf.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IRealtermIntfEvents;
end;

procedure TRealtermIntf.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
  RTI:=self;  //expose to the world
end;
//----------------------------------------
procedure TRealtermIntf.SendEvent(EventNum:Integer); //Used to force event, bypassing switches etc in the proper subroutine

begin
  if FEvents <> nil then begin
    case EventNum of
      1: FEvents.OnTimer;//OnTimer;
      2: FEvents.OnCaptureCount;
      3: FEvents.OnCaptureStop;
      4: begin
           FEvents.OnDataTrigger(1,false,'1234',4,true);
          end
      else exit;
    end;

  Form1.LabelLastEvent.Caption:='SentEvent '+inttostr(EventNum);
  end
  else begin
    Form1.LabelLastEvent.Caption:='No Callbacks for Event'
    end;
end;
procedure TRealtermIntf.SendEventOnTimer;
begin
  if FEnableTimerCallbacks and (FEvents <> nil) then FEvents.OnTimer;
end;

procedure TRealtermIntf.SendEventOnCaptureCount;
begin
  if FEnableCaptureCallbacks and (FEvents <> nil) then FEvents.OnCaptureCount;
end;
procedure TRealtermIntf.SendEventOnCaptureStop;
begin
  if FEnableCaptureCallbacks and (FEvents <> nil) then FEvents.OnCaptureStop;
end;

var LastDataString:string;  DataEventCount:integer;  TimedOut:boolean; DataMatch:boolean;

procedure TRealtermIntf.SendEventOnDataTrigger(TriggerNum:integer; Packet:TApdDataPacket);
var S:string;
begin
  inc(DataEventCount);
  Packet.GetCollectedString(S);
  LastDataString:=S;
  DataMatch:=true;
  if true and (FEvents <> nil) then begin
    //Packet.GetCollectedString(S);
    FEvents.OnDataTrigger(TriggerNum,false,S,length(S),true);
  end;
end;
procedure TRealtermIntf.SendEventOnDataTimeout;
begin
  TimedOut:=true;
end;
//----------------------------------------

function TRealtermIntf.Get_baud: Integer;
begin
  result:=strtoint(Form1.ComboBoxBaud.text);
end;

function TRealtermIntf.Get_CaptureCountForCallback: Integer;
begin
  result:=Form1.CaptureCountForCallback;
end;

function TRealtermIntf.Get_CaptureFile: WideString;
begin
  result:=Form1.ComboBoxSaveFName.text;
end;

function TRealtermIntf.Get_Capture: EnumCaptureMode;
begin
  result:=TOleEnum(Form1.CaptureMode);
end;

function TRealtermIntf.Get_EnableCaptureCallbacks: WordBool;
begin
  result:=FEnableCaptureCallbacks;
end;

function TRealtermIntf.Get_EnableTimerCallbacks: WordBool;
begin
  result:=FEnableTimerCallbacks;
end;

function TRealtermIntf.Get_Port: WideString;
begin
  result:=Form1.ComboBoxComPort.text;
end;

function TRealtermIntf.Get_PortOpen: WordBool;
begin
  result:=Form1.Port1.Open; //perhaps it should include connected
end;

function TRealtermIntf.Get_TimerPeriod: Integer;
begin
  //result:=Form1.Timer1.interval;
  result:=Form1.TimerCallback.Interval;
end;

procedure TRealtermIntf.Set_baud(Value: Integer);
begin
  Form1.ComboBoxBaud.text:=IntToStr(Value);
  Form1.SetPortClick(self)
  //Port1.baud:=strtoint(ComboBoxBaud.text);
//  Form1.Set_Comport(Form1.Port1,Form1.ComboBoxComPort.text);
end;

procedure TRealtermIntf.Set_CaptureCountForCallback(Value: Integer);
begin
  Form1.CaptureCountForCallback:=Value;
end;

procedure TRealtermIntf.Set_CaptureFile(const Value: WideString);
begin
  Form1.ComboBoxSaveFName.text:=Value;
end;

procedure TRealtermIntf.Set_Capture(Value: EnumCaptureMode);
begin
  Form1.StartCapture(TAdCaptureMode(Value));
end;

procedure TRealtermIntf.Set_EnableCaptureCallbacks(Value: WordBool);
begin
  FEnableCaptureCallbacks:=Value;
end;

procedure TRealtermIntf.Set_EnableTimerCallbacks(Value: WordBool);
begin
  FEnableTimerCallbacks:=Value;
  Form1.TimerCallback.Enabled:= (Value and (Form1.TimerCallback.Interval>0));
end;

procedure TRealtermIntf.Set_Port(const Value: WideString);
begin
  Form1.ComboBoxComport.text:=value;
  Form1.SetPortClick(self);
  //Set_Comport(Port1,ComboBoxComPort.text);
end;

procedure TRealtermIntf.Set_PortOpen(Value: WordBool);
begin
  Form1.Port1.Open:=Value;
  Form1.SpeedButtonPort1Open.down:=Form1.Port1.Open;
end;
function TRealtermIntf.Get_EchoPort: WideString; 
begin
  result:=Form1.ComboBoxEchoPort.text;
end;

procedure TRealtermIntf.Set_EchoPort(const Value: WideString); 
begin
  Form1.ComboBoxEchoPort.text:=value;
//  Form1.SetPortClick(self);
  Form1.BitBtnSetEchoPortClick(nil);
//  CheckBoxEchoOn.checked:=true;
//  CheckBoxEchoOnClick(nil); //and open the port

  //Set_Comport(Port1,ComboBoxComPort.text);
end;

function TRealtermIntf.Get_EchoPortOpen: WordBool; 
begin
  result:=Form1.EchoPort.open;
end;

procedure TRealtermIntf.Set_EchoPortOpen(Value: WordBool); 
begin
  Form1.CheckBoxEchoOn.checked:=Value;
  Form1.CheckBoxEchoOnClick(nil);
end;

procedure TRealtermIntf.Set_TimerPeriod(Value: Integer);
begin
  //Form1.Timer2.Interval:=Value;
  Form1.TimerCallback.Interval:=Value;
end;

procedure TRealtermIntf.Close;
begin
  //D3 ComServer.TerminateWarning:=false; //disable warning
  Comserver.UIInteractive:=false;  //disable warning
  //since D7 version there seems to be an exception when closing, unless a delay is inserted
  // On my laptop (P4, 1.5G) the critical delay is ~50ms
  // so setting it to 250ms to have s safety margin
  // note that delay can be before or after setting QuitNow

  //  sleep(200);
  Form1.QuitNow:=true;
  sleep(250);
end;

procedure TRealtermIntf.StartCapture;
begin
  Form1.StartCapture(cmOn);
end;

procedure TRealtermIntf.StartCaptureAppend;
begin
  Form1.StartCapture(cmAppend);
end;

procedure TRealtermIntf.StopCapture;
begin
  Form1.StartCapture(cmOff);
end;

function TRealtermIntf.Get_CharCount: Integer;
begin
  result:=Form1.CharCount;
end;

function TRealtermIntf.Get_CPS: Integer;
begin
  result:=Form1.CPS;
end;

function TRealtermIntf.Get_DisplayAs: Integer;
begin
  result:=Form1.RadioGroupDisplayType.ItemIndex;
end;

function TRealtermIntf.Get_FrameSize: Integer;
begin
  result:=Form1.SpinEditFrameSize.value;
  if Form1.CheckBoxSingleFrame.checked
    then begin
      result:=-result;
    end;
end;

function TRealtermIntf.Get_WindowState: EnumWindowState;
begin
  result:=TOleEnum(Form1.WindowState);
end;

procedure TRealtermIntf.Set_CharCount(Value: Integer);
begin
  Form1.CharCount:=Value;
end;

procedure TRealtermIntf.Set_CPS(Value: Integer);
begin
  //do nothing
end;

procedure TRealtermIntf.Set_DisplayAs(Value: Integer);
begin
  if Value>=Form1.RadioGroupDisplayType.Items.Count
    then Value:=0;
  Form1.RadioGroupDisplayType.ItemIndex:=Value;
  //do we need to call click?
end;

procedure TRealtermIntf.Set_FrameSize(Value: Integer);
begin
  Form1.SpinEditFrameSize.value:=abs(Value);
  Form1.CheckBoxSingleFrame.checked:= (value<=-1);

end;

procedure TRealtermIntf.Set_WindowState(Value: EnumWindowState);
begin
  Form1.WindowState:=TWindowState(Value);
end;

function TRealtermIntf.Get_Caption: WideString;
begin
  result:=Form1.Caption;
end;

procedure TRealtermIntf.Set_Caption(const Value: WideString);
begin
  Form1.Caption:=Value;
  Form1.MenuItemTitle.Caption:=Value;
  Application.Title:=Value;
end;

function TRealtermIntf.Get_CaptureEnd: Integer;
begin
  result:=strtoint(Form1.ComboBoxCaptureSize.text);
end;

function TRealtermIntf.Get_Visible: WordBool;
begin
  result:=Form1.visible;
end;

procedure TRealtermIntf.Set_CaptureEnd(Value: Integer);
begin
  Form1.ComboBoxCaptureSize.text:=inttostr(Value);
  form1.ComboBoxCaptureSizeChange(nil); // is this needed?
end;

procedure TRealtermIntf.Set_Visible(Value: WordBool);
begin
  //Form1.visible:=Value;
  Form1.MenuItemShow.checked:=not Value; //will leave restore button in correct state
  Form1.MenuItemShowClick(nil);
end;

function TRealtermIntf.Get_CaptureEndUnits: EnumUnits;
begin
  result:=form1.RadiogroupCaptureSizeUnits.ItemIndex;

end;

procedure TRealtermIntf.Set_CaptureEndUnits(Value: EnumUnits);
begin
  form1.RadiogroupCaptureSizeUnits.ItemIndex:=integer(Value);
  form1.ComboBoxCaptureSizeChange(nil);
end;

procedure TRealtermIntf.PutString(const S: WideString);
begin
  //form1.StatusBar1.Panels[5].Text:= inttostr(length(S))+' '+inttostr(ord(S[1]));
  //Form1.Port1.PutString(S);
      while (Form1.Port1.OutBuffFree<length(S)) do //room to fit this string in the buffer
        begin
          sleep(0); //yield remainder of thread...
          Form1.Port1.ProcessCommunications;
        end;
      Form1.Port1.PutString(S);
      if Form1.CheckBoxHalfDuplex.checked then Form1.AdTerminal1.WriteString(S);
end;

function TRealtermIntf.SelectTabSheet(const TabCaption: WideString): WordBool;
begin
  result:=Form1.SelectTabSheet(TabCaption);
end;
function TRealtermIntf.DiskFree(Drive: Integer): Double;
begin
  result:=SysUtils.DiskFree(byte(Drive));
  //D3 result:= DiskSpaceKludge.DiskFree(Drive);

  //result:=Drive;
end;

function TRealtermIntf.Get_CaptureTimeLeft: Integer;
begin
  result:=Form1.CaptureTimeLeft;
end;

procedure TRealtermIntf.PutChar(C: Byte);
begin
  //Form1.Port1.PutChar(char(C));
        while (Form1.Port1.OutBuffFree<1) do //room to fit this string in the buffer
        begin
          sleep(0); //yield remainder of thread...
          Form1.Port1.ProcessCommunications;
        end;
      Form1.Port1.PutChar(char(C));
      if Form1.CheckBoxHalfDuplex.checked then Form1.AdTerminal1.WriteChar(char(C));

end;

function TRealtermIntf.Get_TrayIconActive: WordBool;
begin
  result:=Form1.TrayIcon1.Active;
end;

procedure TRealtermIntf.Set_TrayIconActive(Value: WordBool);
begin
  Form1.TrayIcon1.Active:=Value;
end;

function TRealtermIntf.DiskSize(Drive: Integer): Double;
begin
//D3  result:= DiskSpaceKludge.DiskSize(Drive);
  result:= SysUtils.DiskSize(Drive);
end;
function TRealtermIntf.Get_BigEndian: WordBool;
begin
  result:=Form1.CheckBoxBigEndian.checked;
end;

procedure TRealtermIntf.Set_BigEndian(Value: WordBool);
begin
  Form1.CheckBoxBigEndian.checked:=Value;
end;

function TRealtermIntf.Get_HalfDuplex: WordBool;
begin
  result:=Form1.CheckBoxHalfDuplex.checked;
end;

procedure TRealtermIntf.Set_HalfDuplex(Value: WordBool);
begin
  Form1.CheckBoxHalfDuplex.checked:=value;
  Form1.CheckBoxHalfDuplexClick(nil);
end;

function TRealtermIntf.Get_HideControls: WordBool;
begin
  result:=Form1.HideControls1.checked;
end;

procedure TRealtermIntf.Set_HideControls(Value: WordBool);
begin
  Form1.HideControls1.checked:=not value;
  Form1.HideControls1Click(nil);
end;

function TRealtermIntf.Get_Parity: WideString;
begin
  result:=widestring(uppercase(Form1.ParityGroup.Items[Form1.ParityGroup.ItemIndex]));
end; 

procedure TRealtermIntf.Set_Parity(const Value: WideString);
begin
  SetGroupItemByString(Value, Form1.ParityGroup);
  Form1.BitBtnSetPortClick(nil);
end;

 
function TRealtermIntf.Get_DataBits: Integer; 
begin
  result:=Form1.Port1.DataBits;
end;
procedure TRealtermIntf.Set_DataBits(Value: Integer); 
begin
  SetGroupItemByString(inttostr(Value), Form1.DataBitsGroup);
  Form1.BitBtnSetPortClick(nil);
end;
function TRealtermIntf.Get_StopBits: Integer; 
begin
  //result:=strtoint(Form1.StopBitsGroup.Items[Form1.StopBitsGroup.ItemIndex]);
  result:=Form1.Port1.StopBits;
end;
procedure TRealtermIntf.Set_StopBits(Value: Integer);
begin
  SetGroupItemByString(inttostr(Value), Form1.StopBitsGroup);
  Form1.BitBtnSetPortClick(nil);
end;

function TRealtermIntf.Get_EchoBaud: Integer;
begin
  result:=strtoint(Form1.ComboBoxEchoBaud.text);
end;

procedure TRealtermIntf.Set_EchoBaud(Value: Integer);
begin
  Form1.ComboBoxEchoBaud.text:=IntToStr(Value);
  Form1.BitBtnSetEchoPortClick(nil);
end;


 
function TRealtermIntf.Get_EchoParity: WideString; 
begin
  result:=uppercase(Form1.EchoParityGroup.Items[Form1.EchoParityGroup.ItemIndex]);
end;

procedure TRealtermIntf.Set_EchoParity(const Value: WideString); 
begin
  SetGroupItemByString(Value, Form1.EchoParityGroup);
  Form1.BitBtnSetEchoPortClick(nil);
end;

function TRealtermIntf.Get_EchoDataBits: Integer; 
begin
  result:=Form1.EchoPort.DataBits;
end;
procedure TRealtermIntf.Set_EchoDataBits(Value: Integer);
begin
  SetGroupItemByString(inttostr(Value), Form1.EchoDataBitsGroup);
  Form1.BitBtnSetEchoPortClick(nil);
end;
function TRealtermIntf.Get_EchoStopBits: Integer;
begin
  //result:=strtoint(Form1.EchoStopBitsGroup.Items[Form1.EchoStopBitsGroup.ItemIndex]);
  result:=Form1.EchoPort.StopBits;
end;
procedure TRealtermIntf.Set_EchoStopBits(Value: Integer);
begin
  SetGroupItemByString(inttostr(Value), Form1.EchoStopBitsGroup);
  Form1.BitBtnSetEchoPortClick(nil);
end;


function TRealtermIntf.Get_FlowControl: Integer; safecall;
begin
  result:=Form1.HardwareFlowGroup.ItemIndex;
end;
procedure TRealtermIntf.Set_FlowControl(Value: Integer); safecall;
begin
  if (Value>=0) and (Value<=Form1.HardwareFlowGroup.ControlCount)
    then begin
      Form1.HardwareFlowGroup.ItemIndex:=Value;
      Form1.BitBtnSetPortClick(nil);
    end;
end;

function TRealtermIntf.Get_EchoFlowControl: Integer; safecall;
begin
  result:=Form1.EchoHardwareFlowGroup.ItemIndex;
end;
procedure TRealtermIntf.Set_EchoFlowControl(Value: Integer); safecall;
begin
  if (Value>=0) and (Value<=Form1.EchoHardwareFlowGroup.ControlCount)
    then begin
      Form1.EchoHardwareFlowGroup.ItemIndex:=Value;
      Form1.BitBtnSetEchoPortClick(nil);
    end;
end;

function TRealtermIntf.Get_CharDelay: Integer;
begin 
  result:=Form1.SpinEditAsciiCharDelay.value;
end;
procedure TRealtermIntf.Set_CharDelay(Value: Integer); 
begin 
  Form1.SpinEditAsciiCharDelay.value:=Value;
end;
function TRealtermIntf.Get_LineDelay: Integer; 
begin 
  result:=Form1.SpinEditAsciiLineDelay.value;
end;
procedure TRealtermIntf.Set_LineDelay(Value: Integer); 
begin 
  Form1.SpinEditAsciiLineDelay.value:=Value;
end;
function TRealtermIntf.Get_Rows: Integer; 
begin
  result:=Form1.SpinEditTerminalRows.value; 
end;
procedure TRealtermIntf.Set_Rows(Value: Integer); 
begin
  Form1.SpinEditTerminalRows.value:=value; 
end;

function TRealtermIntf.Get_SendFileDelay: Integer; 
begin
  result:=Form1.SpinEditFileSendDelay.value;
end;
procedure TRealtermIntf.Set_SendFileDelay(Value: Integer); 
begin
  Form1.SpinEditFileSendDelay.Value:=value;
end;
function TRealtermIntf.Get_SendFileRepeats: Integer; 
begin
  result:=Form1.SpinEditFileSendRepeats.value;
end;
procedure TRealtermIntf.Set_SendFileRepeats(Value: Integer); 
begin
  Form1.SpinEditFileSendRepeats.Value:=Value;
end;
function TRealtermIntf.Get_SendFile: WideString; 
begin
  result:=Form1.ComboBoxSendFName.text;
end;
procedure TRealtermIntf.Set_SendFile(const Value: WideString); 
begin
  Form1.ComboBoxSendFName.text:=Value;
end;
function TRealtermIntf.Get_Send: WordBool; 
begin
  result:=Form1.IsSendingFile;
end;
procedure TRealtermIntf.Set_Send(Value: WordBool); 
begin
  if Value <> Form1.IsSendingFile
    then begin  //we need to start or stop
      if value
        then begin
          Form1.ButtonSendFileClick(nil);
        end
        else begin
          Form1.BitBtnAbortSendFileClick(nil);
        end;
    end;
end;
procedure TRealtermIntf.ClearTerminal;
begin
  Form1.ButtonClearClick(nil);
end;
function TRealtermIntf.Get_MonitorOn: WordBool;
begin
  result:=Form1.CheckBoxEchoPortMonitoring.checked;
end;
procedure TRealtermIntf.Set_MonitorOn(Value: WordBool);
begin
  Form1.CheckBoxEchoPortMonitoring.checked:=Value;
  Form1.CheckBoxEchoPortMonitoringClick(nil);
end;
function TRealtermIntf.Get_LinefeedIsNewline: WordBool;
begin
  result:=Form1.CheckBoxNewLine.checked;
end;
procedure TRealtermIntf.Set_LinefeedIsNewline(Value: WordBool);
begin
  Form1.CheckBoxNewLine.checked:=Value;
end;


procedure TRealtermIntf.NewlineTerminal;
begin
  Form1.ButtonNewLineClick(nil);
end;

function TRealtermIntf.Get_DTR: WordBool;
begin
  result:=Form1.Port1.DTR;
end;

function TRealtermIntf.Get_RTS: WordBool;
begin
  result:=Form1.Port1.RTS;
end;

procedure TRealtermIntf.Set_DTR(Value: WordBool);
begin
  Form1.Port1.DTR:=Value;
end;

procedure TRealtermIntf.Set_RTS(Value: WordBool);
begin
  Form1.Port1.RTS:=Value;
end;

function TRealtermIntf.Get_CaptureDirect: WordBool;
begin
  result:=Form1.CheckBoxDirectCapture.Checked;
end;

procedure TRealtermIntf.Set_CaptureDirect(Value: WordBool);
begin
  Form1.CheckBoxDirectCapture.Checked:=value;
end;

function TRealtermIntf.AddCannedSendString(const SendString: WideString;
  ControlNum: Integer): WordBool; //true if control exists
begin
   result:=true;
  case ControlNum of
    0: ComboboxPushString(Form1.ComboBoxIAddress,SendString,10);
    1: ComboboxPushString(Form1.ComboBoxSend1,SendString,10);
    2: ComboboxPushString(Form1.ComboBoxSend2,SendString,10);
  else
    result:=false;
  end; //case
end;

function TRealtermIntf.Get_Version: WideString;
begin
  Form1.AFVersionCaption1.InfoPrefix:='';
  result:=Form1.AFVersionCaption1.Caption;
end;



procedure TRealtermIntf.TimeStamp(Style: Integer; Delimiter: Byte);
begin
  Form1.RadioGroupTimeStamp.ItemIndex:=Style;
  case Delimiter of
    byte(','): Form1.RadioGroupTimeStampDelimiter.ItemIndex:=0;
    byte(' '): Form1.RadioGroupTimeStampDelimiter.ItemIndex:=1;
  else Form1.RadioGroupTimeStampDelimiter.ItemIndex:=0;
  end; //case
end;

procedure TRealtermIntf.DisableDataTrigger(Index: Integer);
begin
  Form1.ApdDataPacket1.Enabled:=true;
end;

procedure TRealtermIntf.EnableDataTrigger(Index: Integer);
begin
  Form1.ApdDataPacket1.Enabled:=false;
end;

function TRealtermIntf.WaitforDataTrigger(Timeout: Integer): WideString;
var S:string;  SZ:integer;  P:pointer;  Res :LongInt;
begin
  //Form1.ApdDataPacket1.SyncEvents:=false;
  //Form1.ApdDataPacket1.Enabled:=true;
  //if Form1.ApdDataPacket1.WaitForString(S)
  //if Form1.ApdDataPacket1.WaitForPacket(P,SZ)
  //  then result:=S
  //  else result:='';
  //Form1.ApdDataPacket1.GetCollectedString(S);
  //result:=LastDataString;
  //result:=inttostr(DataEventCount);

  TimedOut:=false;
  Form1.ApdDataPacket1.AutoEnable := False;

  Form1.ApdDataPacket1.Enabled:=true;
  //Form1.ApdDataPacket1.Timeout
  repeat
    sleep(0);
    Res := SafeYield;
  until DataMatch or (Res = WM_QUIT) or TimedOut ;
  if DataMatch
    then  result:=LastDataString
    else result:='';
  DataMatch:=false;
end;

function TRealtermIntf.Get_CaptureAsHex: WordBool;
begin
  result:=Form1.CheckBoxCaptureAsHex.Checked;
end;

procedure TRealtermIntf.Set_CaptureAsHex(Value: WordBool);
begin
  Form1.CheckBoxCaptureAsHex.Checked:=Value;
end;



procedure TRealtermIntf.DataTriggerSet(Index: Integer; const StartString,
  EndString: WideString; PacketSIze, TimeOut: Integer; AutoEnable,
  IgnoreCase, IncludeStrings: WordBool);
  var Packet:TApdDataPacket;
  function CalcEndCond: TPacketEndSet;
  begin
    if length(StartString)=0
      then result:=[]
      else result:=[ecString];
    if PacketSize>0
      then result:=result + [ecPacketSize];
  end;
begin
  Packet:=Form1.ApdDataPacket1;
  Packet.StartString:=StartString;
  Packet.EndString:=EndString;
  Packet.PacketSize:=PacketSize;
  Packet.Timeout:=Timeout;
  Packet.AutoEnable:=AutoEnable;
  Packet.IgnoreCase:=IgnoreCase;
  Packet.IncludeStrings:=IncludeStrings;

  if length(StartString)=0
    then Packet.StartCond:=scAnyData
    else Packet.StartCond:=scString;
  Packet.EndCond:=CalcEndCond;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRealtermIntf, Class_RealtermIntf,
    {ciMultiInstance}ciSingleInstance, tmApartment);
end.
