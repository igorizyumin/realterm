unit Realterm_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 6/06/2010 3:34:25 p.m. from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\l\D7\a\realterm\realterm.tlb (1)
// LIBID: {2130F380-39E1-11D7-BA0F-00E018852F5E}
// LCID: 0
// Helpfile: 
// HelpString: Realterm Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  RealtermMajorVersion = 1;
  RealtermMinorVersion = 0;

  LIBID_Realterm: TGUID = '{2130F380-39E1-11D7-BA0F-00E018852F5E}';

  IID_IRealtermIntf: TGUID = '{2130F381-39E1-11D7-BA0F-00E018852F5E}';
  DIID_IRealtermIntfEvents: TGUID = '{2130F382-39E1-11D7-BA0F-00E018852F5E}';
  CLASS_RealtermIntf: TGUID = '{2130F383-39E1-11D7-BA0F-00E018852F5E}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum EnumCaptureMode
type
  EnumCaptureMode = TOleEnum;
const
  cmOff = $00000000;
  cmOn = $00000001;
  cmAppend = $00000002;

// Constants for enum EnumWindowState
type
  EnumWindowState = TOleEnum;
const
  wsNormal = $00000000;
  wsMinimized = $00000001;
  wsMaximized = $00000002;

// Constants for enum EnumUnits
type
  EnumUnits = TOleEnum;
const
  Bytes = $00000000;
  Secs = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRealtermIntf = interface;
  IRealtermIntfDisp = dispinterface;
  IRealtermIntfEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RealtermIntf = IRealtermIntf;


// *********************************************************************//
// Interface: IRealtermIntf
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2130F381-39E1-11D7-BA0F-00E018852F5E}
// *********************************************************************//
  IRealtermIntf = interface(IDispatch)
    ['{2130F381-39E1-11D7-BA0F-00E018852F5E}']
    function Get_TimerPeriod: Integer; safecall;
    procedure Set_TimerPeriod(TimerPeriod: Integer); safecall;
    function Get_EnableTimerCallbacks: WordBool; safecall;
    procedure Set_EnableTimerCallbacks(EnableTimerCallbacks: WordBool); safecall;
    function Get_CaptureFile: WideString; safecall;
    procedure Set_CaptureFile(const CaptureFile: WideString); safecall;
    function Get_Capture: EnumCaptureMode; safecall;
    procedure Set_Capture(Capture: EnumCaptureMode); safecall;
    function Get_baud: Integer; safecall;
    procedure Set_baud(baud: Integer); safecall;
    function Get_Port: WideString; safecall;
    procedure Set_Port(const Port: WideString); safecall;
    function Get_PortOpen: WordBool; safecall;
    procedure Set_PortOpen(PortOpen: WordBool); safecall;
    function Get_CaptureCountForCallback: Integer; safecall;
    procedure Set_CaptureCountForCallback(CaptureCountForCallback: Integer); safecall;
    function Get_EnableCaptureCallbacks: WordBool; safecall;
    procedure Set_EnableCaptureCallbacks(EnableCaptureCallbacks: WordBool); safecall;
    procedure Close; safecall;
    procedure StartCapture; safecall;
    procedure StartCaptureAppend; safecall;
    procedure StopCapture; safecall;
    function Get_FrameSize: Integer; safecall;
    procedure Set_FrameSize(FrameSize: Integer); safecall;
    function Get_DisplayAs: Integer; safecall;
    procedure Set_DisplayAs(DisplayAs: Integer); safecall;
    function Get_CharCount: Integer; safecall;
    procedure Set_CharCount(CharCount: Integer); safecall;
    function Get_CPS: Integer; safecall;
    procedure Set_CPS(CPS: Integer); safecall;
    function Get_WindowState: EnumWindowState; safecall;
    procedure Set_WindowState(WindowState: EnumWindowState); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Caption: WideString); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Visible: WordBool); safecall;
    function Get_CaptureEnd: Integer; safecall;
    procedure Set_CaptureEnd(CaptureEnd: Integer); safecall;
    function Get_CaptureEndUnits: EnumUnits; safecall;
    procedure Set_CaptureEndUnits(CaptureEndUnits: EnumUnits); safecall;
    procedure PutString(const S: WideString); safecall;
    function SelectTabSheet(const TabCaption: WideString): WordBool; safecall;
    function DiskFree(Drive: Integer): Double; safecall;
    function Get_CaptureTimeLeft: Integer; safecall;
    procedure PutChar(C: Byte); safecall;
    function Get_TrayIconActive: WordBool; safecall;
    procedure Set_TrayIconActive(TrayIconActive: WordBool); safecall;
    function DiskSize(Drive: Integer): Double; safecall;
    function Get_BigEndian: WordBool; safecall;
    procedure Set_BigEndian(BigEndian: WordBool); safecall;
    function Get_EchoPort: WideString; safecall;
    procedure Set_EchoPort(const EchoPort: WideString); safecall;
    function Get_EchoPortOpen: WordBool; safecall;
    procedure Set_EchoPortOpen(EchoPortOpen: WordBool); safecall;
    function Get_HalfDuplex: WordBool; safecall;
    procedure Set_HalfDuplex(HalfDuplex: WordBool); safecall;
    function Get_HideControls: WordBool; safecall;
    procedure Set_HideControls(HideControls: WordBool); safecall;
    function Get_Parity: WideString; safecall;
    procedure Set_Parity(const Parity: WideString); safecall;
    function Get_DataBits: Integer; safecall;
    procedure Set_DataBits(DataBits: Integer); safecall;
    function Get_StopBits: Integer; safecall;
    procedure Set_StopBits(StopBits: Integer); safecall;
    function Get_EchoBaud: Integer; safecall;
    procedure Set_EchoBaud(EchoBaud: Integer); safecall;
    function Get_EchoParity: WideString; safecall;
    procedure Set_EchoParity(const EchoParity: WideString); safecall;
    function Get_EchoDataBits: Integer; safecall;
    procedure Set_EchoDataBits(EchoDataBits: Integer); safecall;
    function Get_EchoStopBits: Integer; safecall;
    procedure Set_EchoStopBits(EchoStopBits: Integer); safecall;
    function Get_FlowControl: Integer; safecall;
    procedure Set_FlowControl(FlowControl: Integer); safecall;
    function Get_EchoFlowControl: Integer; safecall;
    procedure Set_EchoFlowControl(EchoFlowControl: Integer); safecall;
    function Get_CharDelay: Integer; safecall;
    procedure Set_CharDelay(CharDelay: Integer); safecall;
    function Get_LineDelay: Integer; safecall;
    procedure Set_LineDelay(LineDelay: Integer); safecall;
    function Get_Rows: Integer; safecall;
    procedure Set_Rows(Rows: Integer); safecall;
    function Get_SendFileDelay: Integer; safecall;
    procedure Set_SendFileDelay(SendFileDelay: Integer); safecall;
    function Get_SendFileRepeats: Integer; safecall;
    procedure Set_SendFileRepeats(SendFileRepeats: Integer); safecall;
    function Get_SendFile: WideString; safecall;
    procedure Set_SendFile(const SendFile: WideString); safecall;
    function Get_Send: WordBool; safecall;
    procedure Set_Send(Send: WordBool); safecall;
    procedure ClearTerminal; safecall;
    function Get_MonitorOn: WordBool; safecall;
    procedure Set_MonitorOn(MonitorOn: WordBool); safecall;
    function Get_LinefeedIsNewline: WordBool; safecall;
    procedure Set_LinefeedIsNewline(LinefeedIsNewline: WordBool); safecall;
    procedure NewlineTerminal; safecall;
    function Get_RTS: WordBool; safecall;
    procedure Set_RTS(Value: WordBool); safecall;
    function Get_DTR: WordBool; safecall;
    procedure Set_DTR(Value: WordBool); safecall;
    function Get_CaptureDirect: WordBool; safecall;
    procedure Set_CaptureDirect(Value: WordBool); safecall;
    function AddCannedSendString(const SendString: WideString; ControlNum: Integer): WordBool; safecall;
    function Get_Version: WideString; safecall;
    procedure TimeStamp(Style: Integer; Delimiter: Byte); safecall;
    procedure EnableDataTrigger(Index: Integer); safecall;
    procedure DisableDataTrigger(Index: Integer); safecall;
    function WaitforDataTrigger(Timeout: Integer): WideString; safecall;
    function Get_CaptureAsHex: WordBool; safecall;
    procedure Set_CaptureAsHex(Value: WordBool); safecall;
    procedure DataTriggerSet(Index: Integer; const StartString: WideString; 
                             const EndString: WideString; PacketSIze: Integer; Timeout: Integer; 
                             AutoEnable: WordBool; IgnoreCase: WordBool; IncludeStrings: WordBool); safecall;
    property TimerPeriod: Integer read Get_TimerPeriod write Set_TimerPeriod;
    property EnableTimerCallbacks: WordBool read Get_EnableTimerCallbacks write Set_EnableTimerCallbacks;
    property CaptureFile: WideString read Get_CaptureFile write Set_CaptureFile;
    property Capture: EnumCaptureMode read Get_Capture write Set_Capture;
    property baud: Integer read Get_baud write Set_baud;
    property Port: WideString read Get_Port write Set_Port;
    property PortOpen: WordBool read Get_PortOpen write Set_PortOpen;
    property CaptureCountForCallback: Integer read Get_CaptureCountForCallback write Set_CaptureCountForCallback;
    property EnableCaptureCallbacks: WordBool read Get_EnableCaptureCallbacks write Set_EnableCaptureCallbacks;
    property FrameSize: Integer read Get_FrameSize write Set_FrameSize;
    property DisplayAs: Integer read Get_DisplayAs write Set_DisplayAs;
    property CharCount: Integer read Get_CharCount write Set_CharCount;
    property CPS: Integer read Get_CPS write Set_CPS;
    property WindowState: EnumWindowState read Get_WindowState write Set_WindowState;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property CaptureEnd: Integer read Get_CaptureEnd write Set_CaptureEnd;
    property CaptureEndUnits: EnumUnits read Get_CaptureEndUnits write Set_CaptureEndUnits;
    property CaptureTimeLeft: Integer read Get_CaptureTimeLeft;
    property TrayIconActive: WordBool read Get_TrayIconActive write Set_TrayIconActive;
    property BigEndian: WordBool read Get_BigEndian write Set_BigEndian;
    property EchoPort: WideString read Get_EchoPort write Set_EchoPort;
    property EchoPortOpen: WordBool read Get_EchoPortOpen write Set_EchoPortOpen;
    property HalfDuplex: WordBool read Get_HalfDuplex write Set_HalfDuplex;
    property HideControls: WordBool read Get_HideControls write Set_HideControls;
    property Parity: WideString read Get_Parity write Set_Parity;
    property DataBits: Integer read Get_DataBits write Set_DataBits;
    property StopBits: Integer read Get_StopBits write Set_StopBits;
    property EchoBaud: Integer read Get_EchoBaud write Set_EchoBaud;
    property EchoParity: WideString read Get_EchoParity write Set_EchoParity;
    property EchoDataBits: Integer read Get_EchoDataBits write Set_EchoDataBits;
    property EchoStopBits: Integer read Get_EchoStopBits write Set_EchoStopBits;
    property FlowControl: Integer read Get_FlowControl write Set_FlowControl;
    property EchoFlowControl: Integer read Get_EchoFlowControl write Set_EchoFlowControl;
    property CharDelay: Integer read Get_CharDelay write Set_CharDelay;
    property LineDelay: Integer read Get_LineDelay write Set_LineDelay;
    property Rows: Integer read Get_Rows write Set_Rows;
    property SendFileDelay: Integer read Get_SendFileDelay write Set_SendFileDelay;
    property SendFileRepeats: Integer read Get_SendFileRepeats write Set_SendFileRepeats;
    property SendFile: WideString read Get_SendFile write Set_SendFile;
    property Send: WordBool read Get_Send write Set_Send;
    property MonitorOn: WordBool read Get_MonitorOn write Set_MonitorOn;
    property LinefeedIsNewline: WordBool read Get_LinefeedIsNewline write Set_LinefeedIsNewline;
    property RTS: WordBool read Get_RTS write Set_RTS;
    property DTR: WordBool read Get_DTR write Set_DTR;
    property CaptureDirect: WordBool read Get_CaptureDirect write Set_CaptureDirect;
    property Version: WideString read Get_Version;
    property CaptureAsHex: WordBool read Get_CaptureAsHex write Set_CaptureAsHex;
  end;

// *********************************************************************//
// DispIntf:  IRealtermIntfDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2130F381-39E1-11D7-BA0F-00E018852F5E}
// *********************************************************************//
  IRealtermIntfDisp = dispinterface
    ['{2130F381-39E1-11D7-BA0F-00E018852F5E}']
    property TimerPeriod: Integer dispid 1;
    property EnableTimerCallbacks: WordBool dispid 2;
    property CaptureFile: WideString dispid 3;
    property Capture: EnumCaptureMode dispid 4;
    property baud: Integer dispid 5;
    property Port: WideString dispid 6;
    property PortOpen: WordBool dispid 7;
    property CaptureCountForCallback: Integer dispid 8;
    property EnableCaptureCallbacks: WordBool dispid 9;
    procedure Close; dispid 10;
    procedure StartCapture; dispid 11;
    procedure StartCaptureAppend; dispid 12;
    procedure StopCapture; dispid 13;
    property FrameSize: Integer dispid 14;
    property DisplayAs: Integer dispid 15;
    property CharCount: Integer dispid 16;
    property CPS: Integer dispid 17;
    property WindowState: EnumWindowState dispid 18;
    property Caption: WideString dispid 19;
    property Visible: WordBool dispid 20;
    property CaptureEnd: Integer dispid 21;
    property CaptureEndUnits: EnumUnits dispid 23;
    procedure PutString(const S: WideString); dispid 22;
    function SelectTabSheet(const TabCaption: WideString): WordBool; dispid 25;
    function DiskFree(Drive: Integer): Double; dispid 24;
    property CaptureTimeLeft: Integer readonly dispid 26;
    procedure PutChar(C: Byte); dispid 27;
    property TrayIconActive: WordBool dispid 28;
    function DiskSize(Drive: Integer): Double; dispid 29;
    property BigEndian: WordBool dispid 30;
    property EchoPort: WideString dispid 31;
    property EchoPortOpen: WordBool dispid 32;
    property HalfDuplex: WordBool dispid 33;
    property HideControls: WordBool dispid 34;
    property Parity: WideString dispid 35;
    property DataBits: Integer dispid 36;
    property StopBits: Integer dispid 37;
    property EchoBaud: Integer dispid 38;
    property EchoParity: WideString dispid 39;
    property EchoDataBits: Integer dispid 40;
    property EchoStopBits: Integer dispid 41;
    property FlowControl: Integer dispid 42;
    property EchoFlowControl: Integer dispid 43;
    property CharDelay: Integer dispid 44;
    property LineDelay: Integer dispid 45;
    property Rows: Integer dispid 46;
    property SendFileDelay: Integer dispid 47;
    property SendFileRepeats: Integer dispid 48;
    property SendFile: WideString dispid 49;
    property Send: WordBool dispid 50;
    procedure ClearTerminal; dispid 51;
    property MonitorOn: WordBool dispid 52;
    property LinefeedIsNewline: WordBool dispid 53;
    procedure NewlineTerminal; dispid 54;
    property RTS: WordBool dispid 55;
    property DTR: WordBool dispid 56;
    property CaptureDirect: WordBool dispid 57;
    function AddCannedSendString(const SendString: WideString; ControlNum: Integer): WordBool; dispid 58;
    property Version: WideString readonly dispid 59;
    procedure TimeStamp(Style: Integer; Delimiter: Byte); dispid 201;
    procedure EnableDataTrigger(Index: Integer); dispid 202;
    procedure DisableDataTrigger(Index: Integer); dispid 203;
    function WaitforDataTrigger(Timeout: Integer): WideString; dispid 204;
    property CaptureAsHex: WordBool dispid 205;
    procedure DataTriggerSet(Index: Integer; const StartString: WideString; 
                             const EndString: WideString; PacketSIze: Integer; Timeout: Integer; 
                             AutoEnable: WordBool; IgnoreCase: WordBool; IncludeStrings: WordBool); dispid 206;
  end;

// *********************************************************************//
// DispIntf:  IRealtermIntfEvents
// Flags:     (4096) Dispatchable
// GUID:      {2130F382-39E1-11D7-BA0F-00E018852F5E}
// *********************************************************************//
  IRealtermIntfEvents = dispinterface
    ['{2130F382-39E1-11D7-BA0F-00E018852F5E}']
    procedure OnTimer; dispid 1;
    procedure OnCaptureCount; dispid 2;
    procedure OnCaptureStop; dispid 3;
    procedure OnDataTrigger(Index: Integer; Timeout: WordBool; Data: OleVariant; Size: Integer; 
                            Reenable: WordBool); dispid 201;
  end;

// *********************************************************************//
// The Class CoRealtermIntf provides a Create and CreateRemote method to          
// create instances of the default interface IRealtermIntf exposed by              
// the CoClass RealtermIntf. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRealtermIntf = class
    class function Create: IRealtermIntf;
    class function CreateRemote(const MachineName: string): IRealtermIntf;
  end;

implementation

uses ComObj;

class function CoRealtermIntf.Create: IRealtermIntf;
begin
  Result := CreateComObject(CLASS_RealtermIntf) as IRealtermIntf;
end;

class function CoRealtermIntf.CreateRemote(const MachineName: string): IRealtermIntf;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RealtermIntf) as IRealtermIntf;
end;

end.
