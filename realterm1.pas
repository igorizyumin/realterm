{ Program to capture data from serial port to a file....}
{ To Do:
  Freeze overflows. Change to dump when buffer near critical
  Stop capture resets display mode
  command line for com port and baud rate
  Add data auto-synchronise mode
}
{SJB $Date: 2004-02-22 16:20:00+13 $ $Revision: 1.45 $}
unit Realterm1;
{$J+} //D7
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdPort, AdWnPort, AdProtcl, {AdTerm,} AdSocket, ExtCtrls, Spin,
  AdStatLt,AdWUtil, {AdIniDB,} adExcept, Paramlst, ComCtrls, ToolWin, Buttons,
  checklst, Menus, TrayIcon, PicProgN, PortIO, {verslab,} AFVersionCaption,
  ADTrmEmu, OoMisc, Mask, AdSpcEmu, AdPStat, StBase, StWmDCpy, StFirst,
  {TVicCommUnit,} StExpr, StVInfo, sc, AppEvnts, AdPacket;

type
  TForm1 = class(TForm)
    Port1: TApdWinsockPort;
    AdEmulator_Plain: TAdVT100Emulator;
    Timer1: TTimer;
    AdEmulator_Hex: TAdTTYEmulator;
    ApdSLController1: TApdSLController;
    EchoPort: TApdWinsockPort;
    Parameter1: TParameter;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheetDisplay: TTabSheet;
    RadioGroupDisplayType: TRadioGroup;
    TabSheetPort: TTabSheet;
    GroupBoxFrames: TGroupBox;
    Label4: TLabel;
    SpinEditFrameSize: TSpinEdit;
    CheckBoxSingleFrame: TCheckBox;
    ButtonGulp1: TButton;
    AdTerminal1: TAdTerminal;
    GroupBox2: TGroupBox;
    StopBitsGroup: TRadioGroup;
    ParityGroup: TRadioGroup;
    DataBitsGroup: TRadioGroup;
    SoftwareFlowGroup: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    ReceiveFlowBox: TCheckBox;
    TransmitFlowBox: TCheckBox;
    XonCharEdit: TEdit;
    XoffCharEdit: TEdit;
    HardwareFlowGroup: TRadioGroup;
    BitBtnSetPort: TBitBtn;
    CheckBoxInvertData: TCheckBox;
    Pins: TTabSheet;
    TabSheetSend: TTabSheet;
    Label13: TLabel;
    CheckBoxHalfDuplex: TCheckBox;
    GroupBoxStatus: TGroupBox;
    ApdStatusLightConnected: TApdStatusLight;
    LabelConnected: TLabel;
    ApdStatusLightRxd: TApdStatusLight;
    Label6: TLabel;
    ApdStatusLightTXD: TApdStatusLight;
    LabelApdStatusTXD: TLabel;
    ApdStatusLightCTS: TApdStatusLight;
    Label8: TLabel;
    ApdStatusLightDCD: TApdStatusLight;
    Label10: TLabel;
    ApdStatusLightDSR: TApdStatusLight;
    Label11: TLabel;
    ApdStatusLightBREAK: TApdStatusLight;
    Label12: TLabel;
    ApdStatusERROR: TApdStatusLight;
    LabelApdStatusError: TLabel;
    MemoPinNumbers: TMemo;
    ApdProtocol1: TApdProtocol;
    GroupBoxBinarySync: TGroupBox;
    ComboBoxSyncString: TComboBox;
    RadioGroupSyncIs: TRadioGroup;
    BitBtnChangeBinarySync: TBitBtn;
    TabSheetCapture: TTabSheet;
    GroupBoxCapture: TGroupBox;
    Label1: TLabel;
    ButtonCaptureOverwrite: TButton;
    ButtonCaptureAppend: TButton;
    ButtonCaptureStop: TButton;
    CheckBoxDirectCapture: TCheckBox;
    ComboBoxSaveFName: TComboBox;
    ButtonSaveFName: TButton;
    RadioGroupCaptureSizeUnits: TRadioGroup;
    OpenDialog1: TOpenDialog;
    PanelBaud1: TPanel;
    ComboBoxBaud: TComboBox;
    Panel2: TPanel;
    ComboBoxComPort: TComboBox;
    ComboBoxSyncXOR: TComboBox;
    ComboBoxSyncAND: TComboBox;
    Label16: TLabel;
    Label18: TLabel;
    TabSheetEcho: TTabSheet;
    GroupBoxEchoPort: TGroupBox;
    EchoStopBitsGroup: TRadioGroup;
    EchoParityGroup: TRadioGroup;
    EchoDataBitsGroup: TRadioGroup;
    EchoSoftwareFlowGroup: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    EchoReceiveFlowBox: TCheckBox;
    EchoTransmitFlowBox: TCheckBox;
    EchoXonCharEdit: TEdit;
    EchoXoffCharEdit: TEdit;
    EchoHardwareFlowGroup: TRadioGroup;
    BitBtnSetEchoPort: TBitBtn;
    Panel3: TPanel;
    ComboBoxEchoBaud: TComboBox;
    CheckBoxEchoOn: TCheckBox;
    ApdStatusLightRI: TApdStatusLight;
    Label22: TLabel;
    FontDialog1: TFontDialog;
    ButtonFont: TButton;
    GroupBox7: TGroupBox;
    ButtonSetRTS: TButton;
    ApdStatusLightRTS: TApdStatusLight;
    ButtonClrRTS: TButton;
    GroupBox4: TGroupBox;
    ButtonSetDTR: TButton;
    ApdStatusLightDTR: TApdStatusLight;
    ButtonClearDTR: TButton;
    GroupBox8: TGroupBox;
    ButtonSetBreak: TButton;
    ButtonClearBreak: TButton;
    Button500msBreak: TButton;
    CheckBoxBigEndian: TCheckBox;
    GroupBox10: TGroupBox;
    Label24: TLabel;
    ComboBoxTraceFName: TComboBox;
    ButtonTraceFName: TButton;
    CheckBoxTrace: TCheckBox;
    CheckBoxLog: TCheckBox;
    ProgressBarCapture: TProgressBar;
    ComboBoxCaptureSize: TComboBox;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    MenuItemTitle: TMenuItem;
    MenuItemPort: TMenuItem;
    MenuItemShow: TMenuItem;
    MenuItemClose: TMenuItem;
    MenuItemCapture: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    SpeedButtonPort1Open: TSpeedButton;
    MenuItemBaud: TMenuItem;
    PicProg: TPicPN;
    Panel4: TPanel;
    ComboBoxEchoPort: TComboBox;
    Label19: TLabel;
    ApdSLControllerEcho: TApdSLController;
    LabelEchoConnected: TLabel;
    ApdStatusLightEchoConnected: TApdStatusLight;
    ApdStatusLightEchoTXD: TApdStatusLight;
    Label25: TLabel;
    ApdStatusLightEchoRXD: TApdStatusLight;
    Label26: TLabel;
    N3: TMenuItem;
    MenuItemEcho: TMenuItem;
    GroupBoxWSRetry: TGroupBox;
    SpinEditTelnetRetryPeriod: TSpinEdit;
    TabSheetI2C: TTabSheet;
    LabelI2CChip: TLabel;
    AFVersionCaption1: TAFVersionCaption;
    HideControls1: TMenuItem;
    CheckBoxEchoPortMonitoring: TCheckBox;
    PanelFloatingButtons: TPanel;
    ButtonFreeze: TButton;
    ButtonClear: TButton;
    SpinEditTerminalRows: TSpinEdit;
    Label2: TLabel;
    RadioGroupBusNum: TRadioGroup;
    ButtonIStart: TButton;
    ButtonIStop: TButton;
    ButtonIRead: TButton;
    SpinEditIBytes2Read: TSpinEdit;
    Label3: TLabel;
    ButtonIGetStatus: TButton;
    ButtonIQueryPins: TButton;
    ButtonNewLine: TButton;
    CheckBoxNewLine: TCheckBox;
    GroupBox1: TGroupBox;
    ComboBoxSend1: TComboBox;
    ButtonSendNumbers1: TButton;
    ButtonSendAscii1: TButton;
    ButtonSendAscii2: TButton;
    GroupBoxEOL: TGroupBox;
    CheckBoxCR1: TCheckBox;
    CheckBoxLF1: TCheckBox;
    CheckBoxCR2: TCheckBox;
    CheckBoxLF2: TCheckBox;
    ComboBoxSend2: TComboBox;
    SpinEditNumTimesToSend: TSpinEdit;
    BitBtnCancelSend: TBitBtn;
    CheckBoxStripSpaces: TCheckBox;
    ButtonSendNumbers2: TButton;
    Label17: TLabel;
    StWMDataCopy1: TStWMDataCopy;
    ParameterRemote: TParameter;
    ButtonSMBusAlert: TButton;
    ButtonI2CGCAReset: TButton;
    TabsheetMISC: TTabSheet;
    MenuItemSend: TMenuItem;
    MenuItemSendString1: TMenuItem;
    EditSendNumeric: TEdit;
    ButtonSend0: TButton;
    ButtonSend3: TButton;
    GroupBoxGPIB: TGroupBox;
    ButtonGPIBCtrlC: TButton;
    ButtonGPIBSetup: TButton;
    ButtonGPIBRST: TButton;
    ButtonGPIBIDN: TButton;
    ButtonGPIBERR: TButton;
    ButtonGPIBTST: TButton;
    GroupBoxPP: TGroupBox;
    SpeedButtonPower: TSpeedButton;
    ApdStatusLightRB7: TApdStatusLight;
    Label23: TLabel;
    ButtonReset1: TButton;
    ButtonReset2: TButton;
    ButtonResetBoth: TButton;
    SpinEditLPT: TSpinEdit;
    ButtonOpenLPT: TButton;
    SpeedButtonSpy1: TSpeedButton;
    CheckBoxLiteralStrings: TCheckBox;
    GroupBoxIAddress: TGroupBox;
    SpinEditISubAddress: TSpinEdit;
    Label31: TLabel;
    CheckBoxCRC: TCheckBox;
    GroupBoxSignalWsConnect: TGroupBox;
    CheckBoxSignalWsWithDTR: TCheckBox;
    CheckBoxSignalWsWithRTS: TCheckBox;
    GroupBoxNL: TGroupBox;
    CheckBoxNLBefore: TCheckBox;
    CheckBoxNLAfter: TCheckBox;
    N4: TMenuItem;
    MenuItemCopyTerminal: TMenuItem;
    MenuItemPasteTerminal: TMenuItem;
    GroupBoxIWrite: TGroupBox;
    ButtonIWrite: TButton;
    EditIData2Write: TEdit;
    StExpressionEditIW: TStExpressionEdit;
    ButtonIWByte: TButton;
    ButtonIWWordBE: TButton;
    ButtonIWWordLE: TButton;
    ButtonIWAscii: TButton;
    CheckBoxIWCompactAscii: TCheckBox;
    ButtonIWClear: TButton;
    ButtonIWrite00: TButton;
    ButtonIWriteFF: TButton;
    ButtonIWBit: TButton;
    ButtonIWNotBit: TButton;
    ButtonIWBitClear: TButton;
    SpeedButtonIWBit7: TSpeedButton;
    SpeedButtonIWBit6: TSpeedButton;
    SpeedButtonIWBit5: TSpeedButton;
    SpeedButtonIWBit4: TSpeedButton;
    SpeedButtonIWBit3: TSpeedButton;
    SpeedButtonIWBit2: TSpeedButton;
    SpeedButtonIWBit1: TSpeedButton;
    SpeedButtonIWBit0: TSpeedButton;
    RadioGroupWsTelnet: TRadioGroup;
    TimerSendFile: TTimer;
    CommSpy1: TetaSerialCop;
    CheckBoxClearTerminalOnDisplayChange: TCheckBox;
    CheckBoxClearTerminalOnPortChange: TCheckBox;
    CheckboxScrollback: TCheckBox;
    Help1: TMenuItem;
    TabSheetI2CMisc: TTabSheet;
    GroupBox3: TGroupBox;
    ButtonI2CSend2M5451D4: TButton;
    EditI2CDigits: TEdit;
    ButtonM5451Clear: TButton;
    GroupBox6: TGroupBox;
    ButtonIRead1WireID: TButton;
    GroupBoxSensirion: TGroupBox;
    ButtonSHTReadTemp: TButton;
    ButtonSHTReadHumidity: TButton;
    ButtonSHTClear: TButton;
    CheckBoxSHTCRC: TCheckBox;
    ButtonSHTReadStatus: TButton;
    ButtonSHTSoftReset: TButton;
    CheckboxSHTWrHideAck: TCheckBox;
    ButtonSHTWriteStatus: TButton;
    EditSHTStatus: TEdit;
    CheckBoxTraceHex: TCheckBox;
    CheckBoxLogHex: TCheckBox;
    ButtonIWriteThenRead: TButton;
    SpinEditIBytes2Read2: TSpinEdit;
    Label5: TLabel;
    LabeledEditIWriteB4Data: TLabeledEdit;
    TabSheetI2C2: TTabSheet;
    GroupBoxBL301: TGroupBox;
    ButtonBL301WriteAscii2LCD: TButton;
    ButtonBL301InitLCD: TButton;
    ButtonBL301SetContrast: TButton;
    ButtonBL301SetLeds: TButton;
    ButtonBL301ReadSwitches: TButton;
    SpinEditBL301Contrast: TSpinEdit;
    SpeedButtonBL301Leds7: TSpeedButton;
    SpeedButtonBL301Leds6: TSpeedButton;
    SpeedButtonBL301Leds5: TSpeedButton;
    SpeedButtonBL301Leds4: TSpeedButton;
    SpeedButtonBL301Leds3: TSpeedButton;
    SpeedButtonBL301Leds2: TSpeedButton;
    SpeedButtonBL301Leds1: TSpeedButton;
    SpeedButtonBL301Leds0: TSpeedButton;
    ComboBoxIWAscii: TComboBox;
    CheckBoxIWAsciiLiteral: TCheckBox;
    ComboBoxBL301Ascii: TComboBox;
    SpeedButtonBL301ClearLedButtons: TSpeedButton;
    CheckBoxBL301AsciiLiteral: TCheckBox;
    GroupBoxaSC7511: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label9: TLabel;
    Label27: TLabel;
    GroupBoxSPI: TGroupBox;
    ButtonSpiCSInit: TButton;
    ButtonSpiCS00: TButton;
    ButtonSpiCS01: TButton;
    ButtonSpiCS11: TButton;
    ButtonSpiCS10: TButton;
    ApdStatusLightEchoCTS: TApdStatusLight;
    ApdStatusLightEchoDSR: TApdStatusLight;
    Label28: TLabel;
    Label32: TLabel;
    ApdStatusLightEchoDCD: TApdStatusLight;
    Label33: TLabel;
    ApdStatusLightEchoBreak: TApdStatusLight;
    Label34: TLabel;
    ButtonIRead1WireDS1820: TButton;
    SpinEditScrollbackRows: TSpinEdit;
    GroupBoxSendFile: TGroupBox;
    LabelRepeats: TLabel;
    LabelProtocolError: TLabel;
    ProgressBarSendFile: TProgressBar;
    ComboBoxSendFName: TComboBox;
    ButtonSendFName: TButton;
    ButtonSendFile: TButton;
    BitBtnAbortSendFile: TBitBtn;
    SpinEditAsciiCharDelay: TSpinEdit;
    SpinEditAsciiLineDelay: TSpinEdit;
    SpinEditFileSendDelay: TSpinEdit;
    SpinEditFileSendRepeats: TSpinEdit;
    PanelSpecialCapture: TPanel;
    CheckBoxCaptureAsHex: TCheckBox;
    RadioGroupTimeStamp: TRadioGroup;
    GroupBoxPCA9544: TGroupBox;
    RadioGroupPCA9544BusNum: TRadioGroup;
    ButtonPCA9544Status: TButton;
    Label35: TLabel;
    ButtonWriteTranslatorLogFile: TButton;
    ComboBoxIAddress: TComboBox;
    ButtonChangeTraceFName: TButton;
    ButtonClearTraceLog: TButton;
    ButtonDumpTraceLog: TButton;
    GroupBoxBlueSMiRF: TGroupBox;
    ButtonBSEnterAT: TButton;
    ButtonBSExitAT: TButton;
    ButtonBSFastMode: TButton;
    ComboBoxBSBaud: TComboBox;
    ButtonBSBaud: TButton;
    ButtonBSRSSI: TButton;
    ButtonBSPark: TButton;
    ButtonSendLF: TButton;
    GroupBoxMAX127: TGroupBox;
    RadioGroupMax127Range: TRadioGroup;
    ButtonMax127Read: TButton;
    SpinEditTerminalCols: TSpinEdit;
    Label36: TLabel;
    TimerCallback: TTimer;
    RadioGroupTimeStampDelimiter: TRadioGroup;
    ApdDataPacket1: TApdDataPacket;
    TabSheetEvents: TTabSheet;
    RadioGroupSendEvent: TRadioGroup;
    LabelLastEvent: TLabel;
    GroupBoxDataTrigger: TGroupBox;
    ApdStatusLightDataTrigger: TApdStatusLight;
    ButtonEditDataTrigger1: TButton;
    CheckBoxDataTrigger1: TCheckBox;
    ButtonBSQueryBaud: TButton;
    ComboBoxBaudMult: TComboBox;
    ButtonBL301MAscii: TButton;
    SpinEditBL301MNumDisplay: TSpinEdit;
    ComboBoxBL301MString: TComboBox;
    ButtonBL301MInit: TButton;
    RadioGroupEchoWsTelnet: TRadioGroup;
    ComboBoxCRC: TComboBox;
    GroupBox5: TGroupBox;
    ButtonPCA9545Status: TButton;
    GroupBox9: TGroupBox;
    CheckBox9545_Bus0: TCheckBox;
    CheckBox9545_Bus1: TCheckBox;
    CheckBox9545_Bus2: TCheckBox;
    CheckBox9545_Bus3: TCheckBox;
    C1: TMenuItem;
    SendBreak1: TMenuItem;
    ButtonI2CTestM5451: TButton;
    CheckBoxI2CM5451_Color: TCheckBox;
    CheckBoxLeadingSync: TCheckBox;
    Label7: TLabel;
    ButtonPopupMenu: TButton;
    SpeedButton1: TSpeedButton;
    Label37: TLabel;
    Label38: TLabel;
    CheckBoxDisplayTimeStamp: TCheckBox;
    GroupBoxAddCannedString: TGroupBox;
    EditCannedStringTitle: TEdit;
    EditCannedStringContents: TEdit;
    ButtonAddCannedString: TButton;
    GroupBoxBitBash: TGroupBox;
    ButtonBL233_BitBashIdle: TButton;
    SpeedButtonP7: TSpeedButton;
    SpeedButtonP6: TSpeedButton;
    SpeedButtonP5: TSpeedButton;
    SpeedButtonP4: TSpeedButton;
    SpeedButtonP3: TSpeedButton;
    SpeedButtonP2: TSpeedButton;
    SpeedButtonP1: TSpeedButton;
    SpeedButtonP0: TSpeedButton;
    Label39: TLabel;
    ButtonBL233ReadPins: TButton;
    EditCannedStringShortcut: TEdit;
    LabelSyncCount: TLabel;
    Label40: TLabel;
    GroupBoxColors: TGroupBox;
    EditColors: TEdit;
    ButtonScanBus: TButton;
    PopupMenuI2CControlRegister: TPopupMenu;
    MenuItemCR7: TMenuItem;
    MenuItemCR6: TMenuItem;
    MenuItemCR5: TMenuItem;
    MenuItemCR4: TMenuItem;
    MenuItemCR3: TMenuItem;
    MenuItemCR2: TMenuItem;
    MenuItemCR1: TMenuItem;
    MenuItemCR0: TMenuItem;
    GroupBoxI2CControlRegister2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    GroupBoxI2CControlRegister: TGroupBox;
    CheckBoxMenuItemCR7: TCheckBox;
    CheckBoxMenuItemCR1: TCheckBox;
    ButtonI2CCRMore: TButton;
    abc1: TMenuItem;
    MenuItemCRDefault: TMenuItem;
    Function1: TMenuItem;
    N5: TMenuItem;
    TabSheetI2CMem: TTabSheet;
    GroupBox11: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    SpinEditIMWriteTime: TSpinEdit;
    Label41: TLabel;
    SpinEdit1: TSpinEdit;
    Label42: TLabel;
    Label43: TLabel;
    Button6: TButton;
    SpinEditMax127Channel: TSpinEdit;
    Label44: TLabel;
    ButtonShowEventsTab: TButton;
    StatusBarFormattedData: TStatusBar;
    SpeedButtonShowFormattedData: TSpeedButton;
    GroupBoxHexCSV: TGroupBox;
    Label29: TLabel;
    ComboBoxHexCSVFormat: TComboBox;
    RadioGroupHexCSVTerminalShows: TRadioGroup;
    PopupMenuHexCSVFormat: TPopupMenu;
    Clear1: TMenuItem;
    uUnsignedBigendian1: TMenuItem;
    sSignedBigendian1: TMenuItem;
    fFloatBigendian1: TMenuItem;
    gFloatlittleendian1: TMenuItem;
    dBCDLiteralDecimal1: TMenuItem;
    bBinary1: TMenuItem;
    aASCII1: TMenuItem;
    vUnsignedLittleendian1: TMenuItem;
    tSignedLittleEndian1: TMenuItem;
    ButtonHexCSVFormat: TButton;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    HexCSVFormatCharacters1: TMenuItem;
    RadioGroupHexCSVStatusShows: TRadioGroup;
    LabeledEditDataTriggerLastString1: TLabeledEdit;
    CheckBoxMaskMSB: TCheckBox;
    Panel1: TPanel;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;

    procedure ButtonCaptureOverwriteClick(Sender: TObject);
    procedure ButtonCaptureAppendClick(Sender: TObject);

    procedure ButtonCaptureStopClick(Sender: TObject);
    {procedure AdEmulator_PlainProcessCharOld(CP: TObject; C: Char;
      var Command: TEmuCommand);}
    procedure Timer1Timer(Sender: TObject);
    procedure RadioGroupDisplayTypeClick(Sender: TObject);
    {procedure AdEmulator_HexProcessCharOld(CP: TObject; C: Char;
      var Command: TEmuCommand);}
    procedure SpinEditFrameSizeChange(Sender: TObject);
    procedure ButtonFreezeClick(Sender: TObject);
    procedure SetPortClick(Sender: TObject);
    procedure Port1WsConnect(Sender: TObject);
    procedure Port1WsDisconnect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Port1WsAccept(Sender: TObject; Addr: TInAddr;
      var Accept: Boolean);
    procedure CheckBoxSingleFrameClick(Sender: TObject);
    procedure ButtonGulp1Click(Sender: TObject);
    procedure ComboBoxCaptureSizeChange(Sender: TObject);
    procedure ParameterParamMatch(Sender: TObject; CaseMatch: Boolean;
      Param, Reference: String);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnSetPortClick(Sender: TObject);
    procedure CheckBoxInvertDataClick(Sender: TObject);
    procedure ButtonSetRTSClick(Sender: TObject);
    procedure ButtonClrRTSClick(Sender: TObject);
    procedure ButtonSetDTRClick(Sender: TObject);
    procedure ButtonClearDTRClick(Sender: TObject);
    procedure Button500msBreakClick(Sender: TObject);
    procedure ButtonSendAscii1Click(Sender: TObject);
    procedure ButtonSendAscii2Click(Sender: TObject);
    procedure CheckBoxHalfDuplexClick(Sender: TObject);
    procedure ButtonSetBreakClick(Sender: TObject);
    procedure ButtonClearBreakClick(Sender: TObject);
    procedure ButtonSendFileClick(Sender: TObject);
    procedure BitBtnAbortSendFileClick(Sender: TObject);
    procedure SpinEditLPTChange(Sender: TObject);
    procedure BitBtnChangeBinarySyncClick(Sender: TObject);
    procedure ButtonSendNumbers1Click(Sender: TObject);
    procedure ButtonSendNumbers2Click(Sender: TObject);
    procedure ButtonSaveFNameClick(Sender: TObject);
    procedure ButtonSendFNameClick(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure SpeedButtonPowerClick(Sender: TObject);
    procedure ButtonResetBothClick(Sender: TObject);
    procedure ButtonReset1Click(Sender: TObject);
    procedure ButtonReset2Click(Sender: TObject);
    procedure PortTriggerAvail(CP: TObject; Count: Word);
    procedure EchoPortWsAccept(Sender: TObject; Addr: TInAddr;
      var Accept: Boolean);
    procedure BitBtnSetEchoPortClick(Sender: TObject);
    procedure CheckBoxEchoOnClick(Sender: TObject);
    procedure ButtonFontClick(Sender: TObject);
    procedure CheckBoxBigEndianClick(Sender: TObject);
    procedure CheckBoxTraceClick(Sender: TObject);
    procedure CheckBoxLogClick(Sender: TObject);
    procedure ComboBoxTraceFNameChange(Sender: TObject);
    procedure ButtonTraceFNameClick(Sender: TObject);
    procedure ButtonOpenLPTClick(Sender: TObject);
    procedure MenuItemShowClick(Sender: TObject);
    procedure MenuItemCloseClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure MenuItemCaptureClick(Sender: TObject);
    procedure MenuItemPortClick(Sender: TObject);
    procedure SpeedButtonPort1OpenClick(Sender: TObject);
    procedure Hide1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EchoPortWsDisconnect(Sender: TObject);
    procedure EchoPortWsConnect(Sender: TObject);
    procedure EchoPortTrigger(CP: TObject; Msg, TriggerHandle, Data: Word);
    procedure Port1TriggerCaptureWrite(CP: TObject; Msg, TriggerHandle, Data: Word);
    procedure Port1TriggerEchoOut(CP: TObject; Msg, TriggerHandle, Data: Word);
    procedure MenuItemEchoClick(Sender: TObject);
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure ApdProtocol1ProtocolStatus(CP: TObject; Options: Word);
    procedure HideControls1Click(Sender: TObject);
    procedure SpinEditAsciiCharDelayChange(Sender: TObject);
    procedure SpinEditAsciiLineDelayChange(Sender: TObject);
    procedure AdEmulator_PlainProcessChar(Sender: TObject; Character: Char;
      var ReplaceWith: String; Commands: TAdEmuCommandList;
      CharSource: TAdCharSource);
    //procedure AdEmulator_HexProcessChar(Sender: TObject; C: Char;
    //  var ReplaceWith: String; Commands: TAdEmuCommandList;
    //  CharSource: TAdCharSource);
    procedure AdEmulator_ShowAllProcessChar(Sender: TObject;
      Character: Char; var ReplaceWith: String; Commands: TAdEmuCommandList;
      CharSource: TAdCharSource);
    procedure CheckBoxEchoPortMonitoringClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure SpinEditTerminalRowsChange(Sender: TObject);
    procedure AdTerminal1Click(Sender: TObject);
    procedure RadioGroupBusNumClick(Sender: TObject);
    procedure ButtonIStartClick(Sender: TObject);
    procedure ButtonIStopClick(Sender: TObject);
    procedure ButtonIReadClick(Sender: TObject);
    procedure ButtonIRead1WireIDClick(Sender: TObject);
    procedure ButtonIGetStatusClick(Sender: TObject);
    procedure ButtonIWriteClick(Sender: TObject);
    procedure ButtonIQueryPinsClick(Sender: TObject);
    procedure ButtonNewLineClick(Sender: TObject);
    procedure CheckBoxNewLineClick(Sender: TObject);
    procedure SpinEditFileSendRepeatsChange(Sender: TObject);
    procedure StWMDataCopy1DataReceived(Sender: TObject;
//D3     CopyData: TCopyDataStruct);
      CopyData: tagCopyDataStruct);
    procedure TrayIcon1RightClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
//    procedure ButtonKReadAllClick(Sender: TObject);
    procedure FontDialog1Apply(Sender: TObject; Wnd: HWND);
//D3   procedure FontDialog1Apply(Sender: TObject; Wnd: Integer);
    procedure ApdProtocol1ProtocolError(CP: TObject; ErrorCode: Integer);
    procedure ButtonSMBusAlertClick(Sender: TObject);
    procedure ButtonI2CGCAResetClick(Sender: TObject);
    procedure ButtonI2CSend2M5451D4Click(Sender: TObject);
    procedure ButtonGPIBCtrlCClick(Sender: TObject);
    procedure ButtonGPIBSetupClick(Sender: TObject);
    procedure ButtonGPIBRSTClick(Sender: TObject);
    procedure ButtonGPIBIDNClick(Sender: TObject);
    procedure ButtonGPIBERRClick(Sender: TObject);
    procedure ButtonSend0Click(Sender: TObject);
    procedure ButtonSend3Click(Sender: TObject);
    procedure EditSendNumericChange(Sender: TObject);
    procedure MenuItemSendStringClick(Sender: TObject);
    procedure ButtonGPIBTSTClick(Sender: TObject);
    procedure SpeedButtonSpy1Click(Sender: TObject);
{    procedure VicCommSpy1Received(ComNumber: Byte; sValue: String);
    procedure VicCommSpy1Sent(ComNumber: Byte; sValue: String);
}    procedure TerminalNewLine;
    procedure MenuItemCopyTerminalClick(Sender: TObject);
    procedure MenuItemPasteTerminalClick(Sender: TObject);
    procedure IWrite(S:string);
    procedure IRead(BytesToRead:byte);
    procedure ButtonIWrite00Click(Sender: TObject);
    procedure ButtonIWriteFFClick(Sender: TObject);
    procedure ButtonM5451ClearClick(Sender: TObject);
    procedure ButtonIWAsciiClick(Sender: TObject);
    procedure ButtonIWClearClick(Sender: TObject);
    procedure ButtonIWByteClick(Sender: TObject);
    procedure ButtonIWWordBEClick(Sender: TObject);
    procedure ButtonIWWordLEClick(Sender: TObject);
    procedure ButtonIWBitClearClick(Sender: TObject);
    procedure ButtonIWBitClick(Sender: TObject);
    procedure ButtonIWNotBitClick(Sender: TObject);
    procedure RadioGroupWsTelnetClick(Sender: TObject);
    procedure ComboBoxComPortDblClick(Sender: TObject);
    procedure TimerCallbackTimer(Sender: TObject);
    procedure TimerSendFileTimer(Sender: TObject);
    procedure CommSpy1Received(CommIndex: Byte; Data: String;
      Info: Cardinal);
    procedure CommSpy1Sent(CommIndex: Byte; Data: String;
      Info: Cardinal);
    procedure CheckboxScrollbackClick(Sender: TObject);
    procedure LabelHTMLClick(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ButtonSHTReadTempClick(Sender: TObject);
    procedure ButtonSHTClearClick(Sender: TObject);
    procedure ButtonSHTReadHumidityClick(Sender: TObject);
    procedure ButtonSHTReadStatusClick(Sender: TObject);
    procedure ButtonSHTSoftResetClick(Sender: TObject);
    procedure ButtonSHTWriteStatusClick(Sender: TObject);
    procedure CheckBoxTraceHexClick(Sender: TObject);
    procedure CheckBoxLogHexClick(Sender: TObject);
    procedure ButtonIWriteThenReadClick(Sender: TObject);
    procedure ButtonBL301WriteAscii2LCDClick(Sender: TObject);
    procedure ButtonBL301InitLCDClick(Sender: TObject);
    procedure SpeedButtonBL301ClearLedButtonsClick(Sender: TObject);
    procedure ButtonBL301SetContrastClick(Sender: TObject);
    procedure ButtonBL301SetLedsClick(Sender: TObject);
    procedure ButtonBL301ReadSwitchesClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Port1TriggerAvail(CP: TObject; Count: Word);
    procedure ButtonSpiCSInitClick(Sender: TObject);
    procedure ButtonSpiCS00Click(Sender: TObject);
    procedure ButtonSpiCS01Click(Sender: TObject);
    procedure ButtonSpiCS10Click(Sender: TObject);
    procedure ButtonSpiCS11Click(Sender: TObject);
    procedure ButtonIRead1WireDS1820Click(Sender: TObject);
    procedure SpinEditScrollbackRowsChange(Sender: TObject);
    procedure RadioGroupPCA9544BusNumClick(Sender: TObject);
    procedure ButtonPCA9544StatusClick(Sender: TObject);
    procedure ButtonWriteTranslatorLogFileClick(Sender: TObject);
    procedure TabSheetI2CShow(Sender: TObject);
    procedure ButtonChangeTraceFNameClick(Sender: TObject);
    procedure ButtonClearTraceLogClick(Sender: TObject);
    procedure ButtonDumpTraceLogClick(Sender: TObject);
    procedure ButtonUser1Click(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure ButtonBSEnterATClick(Sender: TObject);
    procedure ButtonBSExitATClick(Sender: TObject);
    procedure ButtonBSFastModeClick(Sender: TObject);
    procedure ButtonBSBaudClick(Sender: TObject);
    procedure ButtonBSRSSIClick(Sender: TObject);
    procedure ButtonBSParkClick(Sender: TObject);
    procedure ButtonSendLFClick(Sender: TObject);
    procedure ButtonMax127ReadClick(Sender: TObject);
    procedure RadioGroupSendEventClick(Sender: TObject);
    procedure SpinEditTerminalColsChange(Sender: TObject);
    procedure CheckBoxDirectCaptureClick(Sender: TObject);
    procedure ButtonEditDataTrigger1Click(Sender: TObject);
    procedure CheckBoxDataTrigger1Click(Sender: TObject);
    procedure ApdDataPacket1Packet(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure ButtonBL233_BitBashIdleClick(Sender: TObject);
    procedure ApdDataPacket1Timeout(Sender: TObject);
    procedure ButtonBSQueryBaudClick(Sender: TObject);
    procedure LabelApdStatusErrorDblClick(Sender: TObject);
    procedure LabelApdStatusTXDDblClick(Sender: TObject);
    procedure PanelBaud1DblClick(Sender: TObject);
    procedure ButtonBL301MAsciiClick(Sender: TObject);
    procedure ButtonBL301MInitClick(Sender: TObject);
    procedure RadioGroupEchoWsTelnetClick(Sender: TObject);
    procedure CheckBoxCRCClick(Sender: TObject);
    procedure ButtonPCA9545StatusClick(Sender: TObject);
    procedure CheckBox9545_BusXClick(Sender: TObject);
    procedure SendBreak1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure ButtonI2CTestM5451Click(Sender: TObject);
    procedure CheckBoxI2CM5451_ColorClick(Sender: TObject);
    procedure ButtonTerminalEnableClick(Sender: TObject);
    procedure ButtonTerminalActiveClick(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);
    procedure ButtonAddCannedStringClick(Sender: TObject);
    procedure SpeedButtonP0Click(Sender: TObject);
    procedure ButtonBL233ReadPinsClick(Sender: TObject);
    procedure LabelSyncCountClick(Sender: TObject);
    procedure EditColorsChange(Sender: TObject);
    procedure ButtonScanBusClick(Sender: TObject);
    procedure ButtonI2CCRMoreClick(Sender: TObject);
    procedure CheckBoxMenuItemCR7Click(Sender: TObject);
    procedure CheckBoxMenuItemCR1Click(Sender: TObject);
    procedure PopupMenuI2CControlRegisterChange(Sender: TObject;
      Source: TMenuItem; Rebuild: Boolean);
    procedure MenuItemCRClick(Sender: TObject);
    procedure MenuItemCRDefaultClick(Sender: TObject);
    procedure ButtonShowEventsTabClick(Sender: TObject);
    procedure SpeedButtonShowFormattedDataClick(Sender: TObject);
    procedure ButtonHexCSVFormatClick(Sender: TObject);
    procedure ComboBoxHexCSVFormatDblClick(Sender: TObject);
    procedure HexCSVFormatChars1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure RadioGroupHexCSVTerminalShowsClick(Sender: TObject);
    procedure RadioGroupHexCSVStatusShowsClick(Sender: TObject);
    procedure CheckBoxMaskMSBClick(Sender: TObject);
    //procedure CheckBox9545_AllOffClick(Sender: TObject);



  private
    { Private declarations }
    CaptureStopTime:TDateTime;
    CaptureAutoQuit:boolean; //quit program when capture is done
    SpyModeAutoStart:Boolean; //automatically starts SPY mode.

    LastCharCount:Cardinal;
    fCharCount:cardinal;
    fEchoPortConnected:boolean; //as telnet ports can be open, but not connected to anything
    CaptureAutostart         :TAdCaptureMode; //triggers immediate capture after startup
    Color4Keyboard: TColor;
    Color4Port: TColor;
    Color4WriteChar: TColor;
    Color4SpyTx : TColor;
    Color4SpyRx : TColor;
//    SendStringAutostartString:string; //sends the string immediately after start
    SendFileAutostart:boolean;
    SendFileAutoQuit:boolean; //quit program when sendfile is done
//    QuitNow:boolean; //makes timer routine close the program

    SendFileCounter:cardinal;

    PendingInvisible:boolean;
    PendingHelp:boolean;
    Port1Changed:boolean;
    EchoPortChanged:boolean;
    AdShowAllEmulator : TAdTTYEmulator;
    CannedStrings: TStringlist;
//    DataTriggerCount:integer;
    IsCurrentDataTrigger:boolean;
    DataTriggerLightTimer:integer;
    FirstAvailablePort:word; //0 for none/not searched
//    LastDataTriggerCount:integer;
//    SuppressPortScan:boolean;
//    PortScanLastPort:integer;
//    PortScanLastPortOnStartup:integer;
    procedure CaptureButtonsEnable(Enabled:boolean);
    procedure ShowSerialStatus(ForceShow:boolean);
    procedure UpdateTrayIcon(Name:string);
    procedure OptimiseTerminalWidth(N:integer);
    procedure SetDisplayWidth;
//    procedure Port1Trigger(CP: TObject; Msg, TriggerHandle, Data: Word);
    procedure SetCharCount(CC: cardinal); //keeps last<=current
    procedure IncCharCount(Increment:cardinal); //always safely wraps to 0
    procedure SendString(S:string); //sends a string
    procedure SendTabSendString(S:string); //sends string, controlled by SendTab global controls: CRC, Repeats etc
    procedure SendASCIIString(S:string;AppendCR,AppendLF,StripSpaces:boolean); //sends a string, appending CRLF as chosen, a number of times
    procedure SendTabSendASCIIString(S:string;AppendCR,AppendLF,StripSpaces:boolean);
    procedure PositionFloatingButtons;
//    procedure Send2KCDXO(Add,Command,Data:string);
    procedure SetHalfDuplex(State:boolean); //wrapper for setting terminal HD
    procedure PopulateComNumbers(LastComport:integer; ShowForm:boolean); //shell chooses between two methods depending on Window version
    procedure PopulateComNumbersFromRegistry(LastComport:integer; ShowForm:boolean);
    procedure PopulateComNumbersBySearch(LastComport:integer; ShowForm:boolean);
    procedure Port1PutChar(C:char);
    procedure Port1PutString(S:string);
    procedure SendCannedString(Index:integer); //index is 0 based
    procedure AddCannedString(AsText, AsChars :string); //adds a canned string to the list if new
    procedure SetPortAndBaudCaptions; //writes menu and statusbar strings.
    procedure SetComPortClick(Sender: TObject); //changes the comport
    procedure SpyModeOpen(Open:boolean); //programatically enter start mode.
    procedure SignalWsConnectedThroughRTSDTR(Connected:boolean; OtherPort:TApdWinsockPort);
    function  IWBitValue:byte;
    procedure IWriteThenRead(WriteData:string;BytesToRead:byte);
    procedure ItemIndexToHWFlowOptions(ItemIndex:integer;Port:TApdWinsockPort);
    procedure SHT(S:string);
    function BL301LEDBitValue: byte;
    procedure SpiCSButtonClick(Sender:TObject; CommandStr:string);
    procedure SetDataTriggerLight;
    function ICRBitValue:byte;
    procedure SpyOpen(State:boolean);
    function SpyDriversInstalled:boolean; //detect an install of the driver, using the Realterm driver installer.
    procedure ShowHideStatusBarFormattedData;
    procedure InvertAndMaskChars(Character: char; var ReplaceWith:String);
  public
    CaptureMode:TAdCaptureMode;
    IsCapturing:boolean;
    IsSendingFile:boolean;
    CaptureSize:integer;
    CaptureTime:integer; //seconds
    CaptureTimeLeft:integer; //seconds
    CaptureCountForCallback:integer;
    CPS:cardinal;
    QuitNow:boolean; //makes timer routine close the program
    property CharCount : cardinal read fCharCount write SetCharCount;
    procedure StartCapture(CaptureMode: TAdCaptureMode);
    procedure StopCapture;
    function SelectTabSheet(TabCaption:string):boolean;
    //procedure Set_ComPort(Com:TApdWinsockPort; const Value: WideString);
    procedure DisplayHint(Sender: TObject);
    procedure SetTerminalCharColor(Sender:TObject;CharSource:TADCharSource);
    procedure SetColors(ColorString:string);
    { Public declarations }
  end;

var
  Form1: TForm1;
const
  StatusBarPanelHints=0;
  StatusBarPanelCharCount=1;
  StatusBarPanelCPS=2;
  StatusBarPanelEnd=3;
  PortScanLastPort:integer=MaxComHandles;
  PortScanLastPortOnStartup:integer=MaxComHandles;

procedure SetGroupItemByString(Value:String; RadioGroup:TRadioGroup);
//procedure ComboBoxPutStringAtTop(CB:TComboBox; MaxLength:integer);
procedure ComboBoxPushString(CB:TComboBox; S:string; Maxlength:Integer);

implementation

uses gnugettext, RealtermIntf,Ststrs,Ststrl,StUtils,math,ComServ, adSelCom, Registry,
     M545X, EscapeString, ModbusCRC{, gnugettextD5},SpyNagDialog, ShellApi,
  RTAboutBox, D6OnHelpFix, DateUtils, ScanPorts, AdPackEd, StrUtils, CRC8, HexEmulator,
  Checksums, I2Cx, ComportFinder;

{$R *.DFM}
const CRLF=chr(13)+chr(10);
var F: file;
    Block : array[0..1023] of Char;
    TimerHandle : word;
    CurrentEmulator : TAdTerminalEmulator;
//    KAdjustingF0:boolean; //set while F0 is being adjusted

    SaveOnTrigger:TTriggerEvent; //save port trigger handler during direct capture
    NoNagAboutSpy:boolean;
    PlainCapture:boolean;
    TimeStampDelimiter:char;

var HexEmulator : THexEmulator;

const Capturing:boolean=false;
//interlocks the capture buttons

procedure SetGroupItemByString(Value:String; RadioGroup:TRadioGroup);
  var i:integer;
      ThisItem:string;
begin
  Value:=uppercase(Value);
  for i:=0 to RadioGroup.ControlCount-1 do begin
    ThisItem:= uppercase(RadioGroup.Items[i]);
    if Value[1]= ThisItem[1]
      then begin
        RadioGroup.ItemIndex:=i; // set when match found
        exit;
      end;
  end;
  //no match
  //no error handler, just ignore
end;
procedure TForm1.SetTerminalCharColor(Sender:TObject;CharSource:TADCharSource);
begin
  with sender as TAdTerminalEmulator do begin
  case CharSource of
    csUnknown: ;
    csKeyboard: Buffer.ForeColor:= Color4Keyboard;
    csPort: begin
              IncCharCount(1);
              Buffer.ForeColor    := Color4Port;
            end;
    csWriteChar: Buffer.ForeColor:=Color4WriteChar;
    //else
  end; //case
  end; //with
end;

procedure TForm1.DisplayHint(Sender: TObject);
begin
  if StatusBar1.SimplePanel
    then StatusBar1.SimpleText := GetLongHint(Application.Hint)
    else StatusBar1.panels[0].Text:= GetLongHint(Application.Hint);
end;
procedure TForm1.Port1PutString(S:string);
begin
  Port1.PutString(S);
  if CheckBoxHalfDuplex.checked then AdTerminal1.WriteString(S);
end;

procedure TForm1.Port1PutChar(C:char);
begin
  Port1.PutChar(C); 
  if CheckBoxHalfDuplex.checked then AdTerminal1.WriteString(C);
end;

//try to find a page with the matching caption (case independent)
function TForm1.SelectTabSheet(TabCaption:string):boolean; //true if Caption is found
 var I:integer;
begin
  result:=false;
  for I:=0 to PageControl1.PageCount-1 do begin
    if ( uppercase(PageControl1.Pages[I].Caption) = uppercase(TabCaption) ) then begin
      PageControl1.ActivePage:=PageControl1.Pages[I];
      PageControl1.Pages[I].visible:=true; //in case page was hidden
      PageControl1.Pages[I].TabVisible:=true; //in case page was hidden
      result:=true;
    end;
  end;
end; //select tab
function NumericStringToChars(var S :string):boolean ;
   var i,WC, Value:word; R:string;
begin
  WC:=WordCountS(S,' ,');
  R:='';
  i:=1;
  result:=true;
  while ( i<=WC ) do begin
    if Str2WordS(ExtractWordS(i,S,' ,'),Value) and (Value<256)
      then
        R:=R+char(Value)
      else begin
        R:='';
        result:=false;
        break;
      end;
    i:=i+1;
  end;
  S:=R;
end; //NumericStringToChars

const MAXLENGTHOFMENUCAPTION=20;

procedure TForm1.AddCannedString(AsText, AsChars :string); //adds a canned string to the list if new
  var index:integer;

  procedure RenumberMenuItems;
  begin
    //for i:=
  end;
  procedure InsertMenuItem(index:integer); //index is 0 based
    var base :integer;
        mi:TMenuItem;
  begin
    base:=MenuItemSend.Indexof(MenuItemSendString1); //get base index of string menu items
    //if base+index >= MenuItemSend.Count then exit; //check exists

    mi:=TMenuItem.Create(Self);
    if length(AsText)>MAXLENGTHOFMENUCAPTION
      then  mi.Caption:=copy(AsText,1,MAXLENGTHOFMENUCAPTION-3)+'...'
      else mi.Caption:=AsText;
    mi.OnClick:=MenuItemSendStringClick;
//    inttostr(index+1)
    mi.Shortcut:=Shortcut(Word(1), [ssCtrl]);
    mi.Tag:=index;

//    MenuItemSend.Insert([base+index],mi);
    mi.destroy;
  end;

begin
    if length(AsChars)=0 then exit; //don't want to try and add...
    index:=CannedStrings.IndexOf(AsChars);
    if index>=0 //if exists then move to top of list, otherwise add
      then begin
        CannedStrings.Delete(index);
        CannedStrings.Insert(0,AsChars);
//        SetMenuItem(0);
        end
      else begin //doesn't exist
        if CannedStrings.Count >= 9 //max length of list
          then CannedStrings.Delete(CannedStrings.Count - 1); //delete last item in list
        CannedStrings.Insert(0,AsChars);
//        SetMenuItem(0);
      end;
end;
procedure ComboBoxPutStringAtTop(CB:TComboBox; MaxLength:integer);
  var Original:string;
      index:integer;
begin
    Original:=CB.text;

    index:=CB.Items.IndexOf(Original);
    if index>=0 //if exists then move to top of list, otherwise add
      then CB.Items.Delete(Index)
      else begin //doesn't exist
        if CB.Items.Count >= MaxLength //max length of list
          then CB.Items.Delete(CB.Items.Count - 1); //delete last item in list
      end;
    CB.Items.Insert(0,Original);
    CB.text:=Original;

end; //ComboBoxPutStringAtTop

procedure ComboBoxPushString(CB:TComboBox; S:string; Maxlength:Integer);
begin
  CB.Text:=S;
  ComboBoxPutStringAtTop(CB,MaxLength);
end;

function ComboBoxConvertString(CB:TComboBox; AsNumber, LiteralAscii: boolean):string;
var //index:integer;
    S,Original:string;
    OK:boolean;
begin
  Original:=CB.text;
  S:=Original;
  OK:=true;
  if AsNumber then begin //convert
    if not NumericStringToChars(S) //unsuccessful
      then begin
        //MessageBox('Expecting numbers (0-255 or hex) separated by spaces');
        OK:=false;
      end;
  end; //if
  if OK then begin
    // insert (text form) into history list
    ComboBoxPutStringAtTop(CB,100);
//    index:=CB.Items.IndexOf(Original);
//    if index>=0 //if exists then move to top of list, otherwise add
//      then CB.Items.Delete(Index)
//      else begin //doesn't exist
//        if CB.Items.Count >= 100 //max length of list
//          then CB.Items.Delete(CB.Items.Count - 1); //delete last item in list
//      end;
//    CB.Items.Insert(0,Original);
//    CB.text:=Original;
    Form1.AddCannedString(Original,S);
  end;
  if not LiteralAscii then begin
    S:=ExpandEscapeString(S);
  end;
  result:=S;
end; //CheckBoxString
function comboboxstring(CB:TComboBox):string;
begin
  //result:=ComboBoxConvertString(CB,false,true); //this adds to canned strings...
  ComboBoxPutStringAtTop(CB,100);
  result:=CB.Text;
end;
procedure TForm1.CaptureButtonsEnable( Enabled : boolean);
begin
    ButtonCaptureOverwrite.enabled:=enabled;
    ButtonCaptureAppend.enabled:=enabled;
    ButtonCaptureStop.enabled:=not enabled;
    Capturing:= not Enabled;
    RadioGroupCaptureSizeUnits.enabled:=Enabled;
    ComboBoxCaptureSize.enabled:=Enabled;

end; //TForm1.CaptureButtonsState(Enabled:boolean)

procedure TForm1.StartCapture(CaptureMode: TAdCaptureMode);
  const SavedTrayIcon1ToolTip:string='';
begin
  if self.CaptureMode<>CaptureMode then begin //don't call it if you are already there

  if (CaptureMode=cmOff)  //close
    then begin
      StopCapture;
    end
    else  begin
      //open the capture file
      SelectTabSheet('Capture'); //select tab when called from interface
      if not Port1.Open then begin
          showmessage('Port must be open to capture!');
          exit;
      end;
      PlainCapture:= not (CheckboxCaptureAsHex.checked or (RadioGroupTimeStamp.ItemIndex>0) );
      case RadioGroupTimeStampDelimiter.ItemIndex of
        0: TimeStampDelimiter:=',';
        1: TimeStampDelimiter:=' ';
      end; //case


      CharCount:=0;
      CurrentEmulator:=AdTerminal1.Emulator; //save emulator for later...
      if ( CaptureTime>0)
        then CaptureStopTime:=now+(CaptureTime/(3600*24))
        else CaptureStopTime:=0;
      if ( CaptureTime>0) or (CaptureSize>0 ) then begin
        ProgressBarCapture.Position:=0;
        ProgressBarCapture.visible:=true;
      end;
      ComboBoxPutStringAtTop(Form1.ComboBoxSaveFname,10);
      if not CheckBoxDirectCapture.checked
        then begin    //use terminal capture function...
          try
            AdTerminal1.Emulator:=AdEmulator_Plain;
            Port1.FlushInBuffer;
            //AdTerminal1.CaptureFile:=comboboxstring(Form1.ComboBoxSaveFname);
            AdTerminal1.CaptureFile:=Form1.ComboBoxSaveFname.text;
            AdTerminal1.Capture:=CaptureMode;
            //AdTerminal1.visible:=not CheckBoxHideTerminal.checked; //hide it...
            CaptureButtonsEnable(false);
            IsCapturing:=true;
            Form1.CaptureMode:=CaptureMode;
          except
            CaptureButtonsEnable(true);
            AdTerminal1.Emulator:=CurrentEmulator;
            showmessage('Unable to open capture file');
          end;
        end
        else begin  //if direct capture
          AdTerminal1.Active:=false;
          try
            //AssignFile(F,comboboxstring(Form1.ComboBoxSaveFname));
            AssignFile(F,Form1.ComboBoxSaveFname.text);
            if (CaptureMode=cmAppend)
              then begin
                  //showmessage('Append in direct Not available yet')//append(F,1)
                  //append is a text file only function, and has probs w/ ^Z's
                  reset(F,1);
                  Seek(F, FileSize(F));
                  end
              else rewrite(F,1);
            Port1.FlushInBuffer;
            SaveOnTrigger:=Port1.OnTrigger;
            Port1.OnTrigger:=Port1TriggerCaptureWrite;
            TimerHandle:=Port1.AddTimerTrigger;
            Port1.SetTimerTrigger(TimerHandle, 2, True);  //110ms interrupt
            CaptureButtonsEnable(false);
            IsCapturing:=true;
            Form1.CaptureMode:=CaptureMode;
          except
            CloseFile(F);
            CaptureButtonsEnable(true);
            showmessage('Unable to open capture file');
            Port1.RemoveAllTriggers;
            AdTerminal1.Active:=true;
          end; //try
        end;
        Form1.GroupBoxCapture.color:=clRed;
        PanelSpecialCapture.Enabled:=false; //prevent mode changes during capture
        PanelSpecialCapture.color:=clRed;
      end;
    end; //if needs to be done
    if IsCapturing//MenuItemCapture.Checked
      then begin
        SavedTrayIcon1ToolTip:=TrayIcon1.ToolTip;
        MenuItemCapture.Caption:='Stop &Capture';
        TrayIcon1.ToolTip:= TrayIcon1.ToolTip+ ':Capturing';
        if CaptureAutoQuit
          then begin
            MenuItemClose.Caption:='&Close (AutoQuit when capture ends)';
            TrayIcon1.ToolTip:= TrayIcon1.ToolTip+ ':AutoQuit';
          end;
      end
      else begin
        MenuItemCapture.Caption:='Start &Capture';
        TrayIcon1.ToolTip:=SavedTrayIcon1ToolTip;
      end;
  end; //StartCapture

procedure TForm1.StopCapture;
begin
  if CheckBoxDirectCapture.checked
    then begin
      Port1.RemoveTrigger(TimerHandle);
      CloseFile(F);
      Port1.OnTrigger:=SaveOnTrigger; //restore to the way it was
      end;
  if AdTerminal1.Emulator<>CurrentEmulator
    then AdTerminal1.Emulator:=CurrentEmulator;
  AdTerminal1.Capture:=cmOff;
  AdTerminal1.ClearAll; //was ClearBuffer;
  AdTerminal1.Visible:=true;
  AdTerminal1.Active:=true;
  Form1.CaptureMode:=cmOff;
  CaptureButtonsEnable(true);
  Form1.GroupBoxCapture.color:=clBtnFace;
  MenuItemCapture.Caption:='Start &Capture';
  IsCapturing:=false;
  PanelSpecialCapture.Enabled:=true;
  PanelSpecialCapture.color:=clBtnFace;
  //TRealtermIntf(ComServer).SendEventOnCaptureStop;
  if (ComServer.StartMode=smAutomation) then begin
      RTI.SendEventOnCaptureStop;
      end;

  //Formclose is moved into timer to remove an error thrown with "capquit"
  //if CaptureAutoQuit then Form1.close; //end application
end; //StopCapture
procedure TForm1.ButtonCaptureOverwriteClick(Sender: TObject);
begin
  StartCapture(cmOn);
end;

procedure TForm1.ButtonCaptureAppendClick(Sender: TObject);
begin
  StartCapture(cmAppend);
end;

procedure TForm1.Port1TriggerCaptureWrite(CP: TObject; Msg, TriggerHandle, Data: Word);
//original routine to do direct capture
var NumCharsToRead : cardinal;
const TimeStampNextChar:boolean=false;

procedure FormatAndWriteBlock;
var i:integer; C:char; TD,TS:tdatetime;
    S:shortstring;

  procedure UnixDateStr(AsHex:boolean);
  begin
    TD:=TS-UnixDateDelta;
    if AsHex
      then S:= inttohex( round(TD*24*3600),8)
      else S:= inttostr( round(TD*24*3600));
  end;
  procedure MatlabDateStr;
  const MatlabDateDelta=-693960;
  begin
    TD:=TS-MatlabDateDelta;
    S:= floattostrf(TD,ffgeneral,12,2);
  end;

begin
  if CharCount=0 then TimeStampNextChar:=true; //always put timestamp at the start of the file
  for i:=0 to NumCharsToRead-1 do begin
    C:=Block[i];
   if  RadioGroupTimeStamp.ItemIndex>0 then begin //if desire timestamp
     if ((C=char(10)) or (C=char(13)))
       then begin
         TimeStampNextChar:=true;
       end
       else begin
         if TimeStampNextChar then begin  //emit timestamp
           TS:=Now;
           case RadioGroupTimeStamp.ItemIndex of
             1: UnixDateStr(false);//unix
             2: UnixDateStr(true); //unixHex
             3: MatlabDateStr;//matlab
             4: S:='"'+DateTimeToStr(TS)+'"';//ymds
            end; //case
              S:=S+TimeStampDelimiter;
              Blockwrite(F,S[1],length(S));
            TimeStampNextChar:=false; //clear for next time....
         end;
       end;
   end;//has timestamp
       if CheckBoxCaptureAsHex.Checked
      then begin
        S:=inttohex(integer(C),2);
        Blockwrite(F,S[1],2);
      end
      else begin
        Blockwrite(F,C,1);
      end;

  end; //for each char in block....
end; //formatandwriteblock
var BeforeCharCount:integer;
begin
  //check for data and write to a file...
  while ( Port1.InBuffUsed > 0 ) do begin
      NumCharsToRead:=Port1.InBuffUsed;
        if (NumCharsToRead > sizeof(Block))
            then NumCharsToRead:= sizeof(Block);
        try
          Port1.GetBlock(Block, NumCharsToRead);
          if PlainCapture
            then BlockWrite(F,Block,NumCharsToRead)
            else FormatAndWriteBlock;//BlockWrite(F,Block,NumCharsToRead);//FormatAndWriteBlock
          BeforeCharCount:=CharCount;
          IncCharCount(NumCharsToRead);
          if ((CaptureSize>0) and ( CharCount>=CaptureSize ))
            then begin
              StopCapture;
            end;
          if (CaptureCountForCallback>0) and     //?want to callback at all?
             ( CharCount>=CaptureCountForCallback) and  //have reached the count?
             ( CaptureCountForCallback > BeforeCharCount ) //but only do 1st time
             then begin
            //StopCapture;
               RTI.SendEventOnCaptureCount; //for direct capture....
            end;
        
        except
          {
          on E : EAPDException do
            if (E is EBadHandle) then begin
              ...fatal memory overwrite or programming error
              halt;
            end else if E is EBufferIsEmpty then begin
              ...protocol error, 128 bytes expected
              raise;

            end; }
        end; //except
  end; //while
//  if ((CaptureStopTime>0) and (now>=CaptureStopTime))
//    then begin
//    StopCapture;
//  end;
  //ShowSerialStatus;
end;

procedure TForm1.Port1TriggerEchoOut(CP: TObject; Msg, TriggerHandle, Data: Word);
var NumCharsToRead : word;
    Block : array[0..1023] of Char;
begin
  //check for data and write to echo port if it is on...
  while CheckBoxEchoOn.Checked and ( Port1.InBuffUsed > 0 ) and EchoPort.Open and (EchoPort.OutBuffFree>=sizeof(Block))
         and ((EchoPort.DeviceLayer<>dlWinsock) or FEchoPortConnected) //when telnet,only if there is somewhere for the chars to go.
      do begin
        NumCharsToRead:=Port1.InBuffUsed;
        if (NumCharsToRead > sizeof(Block))
            then NumCharsToRead:= sizeof(Block);
        try
          Port1.GetBlock(Block, NumCharsToRead);
          EchoPort.PutBlock(Block,NumCharsToRead);
        except
          raise;
          {
          on E : EAPDException do
            if (E is EBadHandle) then begin
              ...fatal memory overwrite or programming error
              halt;
            end else if E is EBufferIsEmpty then begin
              ...protocol error, 128 bytes expected
              raise;

            end; }
        end; //except
  end; //while
end;


//gets chars from the echo port and sends them to PORT1 if it is open
procedure TForm1.EchoPortTrigger(CP: TObject; Msg, TriggerHandle,
  Data: Word);
var NumCharsToRead : word;
    Block : array[0..1023] of Char;
  procedure PutBlockInTerminal;
  var i:word;
  begin
    for i:=0 to (NumCharsToRead-1) do begin
      assert((i>=0) and (i<=1023));
      AdTerminal1.WriteChar(Block[i]);
    end;
  end;

begin
  //check for data and write to a file...
  if (Port1.open and CheckBoxEchoOn.Checked) //echo to port1
    then begin //there is somewhere to put them...
      while ( EchoPort.InBuffUsed > 0 ) and (Port1.OutBuffFree> sizeof(Block)) do begin
            NumCharsToRead:=EchoPort.InBuffUsed;
            if (NumCharsToRead > sizeof(Block))
                then NumCharsToRead:= sizeof(Block);
 //           try
              EchoPort.GetBlock(Block, NumCharsToRead);
              Port1.PutBlock(Block,NumCharsToRead);
              if CheckBoxEchoPortMonitoring.Checked then PutBlockInTerminal;
 //           except
 //                 raise;
              {
              on E : EAPDException do
                if (E is EBadHandle) then begin
                  ...fatal memory overwrite or programming error
                  halt;
                end else if E is EBufferIsEmpty then begin
                  ...protocol error, 128 bytes expected
                  raise;

                end; }
//            end; //except
      end; //while
      end
    else begin
      while ( EchoPort.InBuffUsed > 0 ) do begin
        NumCharsToRead:=EchoPort.InBuffUsed;
        if (NumCharsToRead > sizeof(Block))
              then NumCharsToRead:= sizeof(Block);
        EchoPort.GetBlock(Block, NumCharsToRead); //default is to leave the port open and just empty the buffer
        if CheckBoxEchoPortMonitoring.Checked then PutBlockInTerminal;
      end; //while
    end; //if

end; //proc


procedure TForm1.ButtonCaptureStopClick(Sender: TObject);
begin
  CaptureAutoQuit:=false; //don't autoquit when stop button pressed
  StopCapture;
end;

procedure TForm1.SetCharCount(CC: cardinal);
begin
  fCharCount:=CC;
  if CC=0      //ensure that lastcharcount is always <= Charcount
    then begin
      LastCharCount:=0;
    end;
end; //TForm1.SetCharCount
procedure TForm1.IncCharCount(Increment:cardinal); //always safely wraps to 0
begin
  try
    fCharCount:=fCharCount+Increment;
  except
    fCharCount:=0;
  end;
end; //TForm1.IncCharCount
procedure TForm1.UpdateTrayIcon(Name:string);
//sets to the icon NAME, if Iconname is '', animates the icon
var
  AppIcon : TIcon;
  ChangeIcon : boolean;
  //CapIcons : TIcon[1:4];
  IconName : String;
  const AnimateSequence :integer =1;
begin
  // Copied from TrayTest
  //we're loading icons from the EXE file - they're in the resource file and
  // compiled in.
  ChangeIcon:=false;
  if length(Name)=0
    then begin
  if IsCapturing
    then IconName:='R'
    else if IsCurrentDataTrigger
        then IconName:='Y'
        else IconName:='G';

  if CPS>=1
    then begin
      ChangeIcon:=true;
      AnimateSequence := AnimateSequence + 1;
      if AnimateSequence > 4 then begin
        AnimateSequence := 1;
      end;
    end;
    IconName:=format('%s%d',[ IconName,AnimateSequence ]);
    end
    else begin
      IconName:=Name;
      ChangeIcon:=true;
    end;

 if ChangeIcon then begin
  AppIcon := TIcon.Create;
  AppIcon.Handle := LoadIcon( HInstance ,pchar(IconName) );
  //AppIcon.Handle := LoadIcon( HInstance, pchar('ICON_1'));
//D3  if AppIcon.Handle <> null
  if AppIcon.Handle <> 0
    then begin
      if TrayIcon1.Active  then TrayIcon1.Icon := AppIcon;
      if Visible then begin
        Application.Icon:= AppIcon;
        Form1.Icon:=AppIcon;
      end;  
    end;
  AppIcon.Free;
 end;
end; //updatetrayicon
procedure TForm1.ShowSerialStatus(ForceShow:boolean);
  var CC:cardinal;
  //const LastCharCount:cardinal = 0;
  LineErrorStr:string;
  const LineErrorLightTimer :cardinal =0;
begin
  CC:=CharCount;

  if (LastCharCount<>CC) or ForceShow
    then begin
      StatusBar1.Panels[StatusBarPanelCharCount].Text:= 'Char Count:'+IntToStr(CC);
      //LabelCharCount.caption:=IntToStr(CC);
        try //trap numeric overflow problems
          CPS:=(CC-LastCharCount)*1000 div Timer1.Interval;
        except
          CPS:=0;
        end;

      end
    else begin //last=this ie no data
      CPS:=0;
    end;
  //LabelCPS.caption:=IntToStr(CPS);
  StatusBar1.Panels[StatusBarPanelCPS].Text:='CPS:'+IntToStr(CPS);
  LastCharCount:=CC;
  ApdStatusLightRTS.Lit:=Port1.RTS;
  ApdStatusLightDTR.Lit:=Port1.DTR;
//  if Port1.LineError <> 0 then begin
    case ( Port1.LineError ) of
      leNoError     : LineErrorStr:='';//'No line error';
      leBuffer      : LineErrorStr:='Buffer overrun in COMM.DRV';
      leOverrun     : LineErrorStr:='UART receiver overrun';
      leParity      : LineErrorStr:='UART receiver parity error';
      leFraming     : LineErrorStr:='UART receiver framing error';
      leCTSTO       : LineErrorStr:='Transmit timeout waiting for CTS';
      leDSRTO       : LineErrorStr:='Transmit timeout waiting for DSR';
      leDCDTO       : LineErrorStr:='Transmit timeout waiting for RLSD';
      leTxFull      : LineErrorStr:='Transmit queue is full';
      leBreak       : LineErrorStr:='Break condition received';
    else

    end;
  if LineErrorStr<>'' then begin  //this will only set the lineerror, not clear them...
    ApdStatusERROR.hint:=LineErrorStr;
    LabelAPdStatusError.hint:=LineErrorStr;
    StatusBar1.Panels[StatusBarPanelHints].Text:=LineErrorStr;
    LineErrorLightTimer:=5; //set how long it shows for 1 sec
  end else begin  //don't clear the linerror string, user doubleclicks to clear it
    if LineErrorLightTimer>0 then begin
      dec(LineErrorLightTimer);
      if LineErrorLightTimer<=0 then ApdStatusError.Lit:=false;
    end;
  end;

  if DataTriggerLightTimer>0
      then begin
        dec(DataTriggerLightTimer);
        ApdStatusLightDataTrigger.Lit:=true;
      end
      else begin
        IsCurrentDataTrigger:=false;
        ApdStatusLightDataTrigger.Lit:=false;
      end;

//  end;

  if HexEmulator.IsSyncCountChanged then begin
    LabelSyncCount.Caption:=inttostr(HexEmulator.SyncCount);
    if HexEmulator.SyncCount>0 then SetDataTriggerLight;
  end;

//  if ApdProtocol1.InProgress
//     then LabelProtocolError.Caption:='In-Progress'
//     else LabelProtocolError.Caption:='Error Not In-Progress';
  UpdateTrayIcon('');
end; //TForm1.ShowSerialStatus
procedure TForm1.LabelApdStatusErrorDblClick(Sender: TObject);
begin
    ApdStatusERROR.hint:='';
    LabelAPdStatusError.hint:='';
    StatusBar1.Panels[StatusBarPanelHints].Text:='';
end;
procedure TForm1.InvertAndMaskChars(Character: char; var ReplaceWith:String);
begin
  if CheckboxInvertData.Checked
    then begin
        Character:=char(not(byte(Character)));
        ReplaceWith:=Character;
        end;
  if CheckboxMaskMSB.Checked
    then begin
        Character:=char(127 and byte(Character));
        ReplaceWith:=Character;
    end;
end; //fn
//base emulator that just passes chars thru...
procedure TForm1.AdEmulator_PlainProcessChar(Sender: TObject;
  Character: Char; var ReplaceWith: String; Commands: TAdEmuCommandList;
  CharSource: TAdCharSource);
begin
  //Command.Cmd:= eChar;
  InvertAndMaskChars(Character,ReplaceWith);
//  if CheckboxInvertData.Checked
//    then begin
//        Character:=char(not(byte(Character)));
//        ReplaceWith:=Character;
//        end
//    else  ;//Command.Ch :=C;
//  if CheckboxMaskMSB.Checked
//    then begin
//        Character:=char(127 and byte(Character));
//        ReplaceWith:=Character;
//    end;

  //IncCharCount(1);
  SetTerminalCharColor(Sender,CharSource);
(*  with sender as TAdTerminalEmulator do begin
  case CharSource of
    csUnknown: ;
    csKeyboard: Buffer.ForeColor:= Color4Keyboard;
    csPort: begin
              IncCharCount(1);
              Buffer.ForeColor    := Color4Port;
            end;
    csWriteChar: Buffer.ForeColor:=Color4WriteChar;
    //else
  end; //case
  end; //with
  *)

end;

procedure TForm1.AdEmulator_ShowAllProcessChar(Sender: TObject;
  Character: Char; var ReplaceWith: String; Commands: TAdEmuCommandList;
  CharSource: TAdCharSource);
begin
  //Command.Cmd:= eChar;
  InvertAndMaskChars(Character,ReplaceWith);
//  if CheckboxInvertData.Checked
//    then begin
//        Character:=char(not(byte(Character)));
//        ReplaceWith:=Character;
//        end
//    else  ;//Command.Ch :=C;
  //IncCharCount(1);
  with sender as TAdTerminalEmulator do begin
    SetTerminalCharColor(Sender,CharSource);
    if CharSource = csPort then IncCharCount(1);
  //case CharSource of
  //  csUnknown: ;
  //  csKeyboard: ;
  //  csPort: IncCharCount(1);
  //  csWriteChar: ;
    //else
  //end; //case
  end;
end;
{procedure TForm1.AdEmulator_PlainProcessCharOld(CP: TObject; C: Char;
  var Command: TEmuCommand);
begin
  Command.Cmd:= eChar;
  if CheckboxInvertData.Checked
    then Command.Ch:=char(not(byte(C)))
    else  Command.Ch :=C;
  IncCharCount(1);
end;}



{
procedure TForm1.AdEmulator1ProcessChar_Hex(CP: TObject; C: Char;
  var Command: TEmuCommand);
  var CPrintable:char;
begin
  Command.Cmd:= eString;
  Command.OtherStr := HexB(Byte(C))+C;
  inc(CharCount);
end;
}
procedure TForm1.Timer1Timer(Sender: TObject);
var CaptureTimeRemaining:double; // in days
    CharsLeft:integer;
begin
   {//diagnostic messages
   case Comserver.StartMode of
     smAutomation: form1.Caption:='smAutomation';
     smStandalone: form1.Caption:='smStandAlone';
     else  ;
   end; //case
   if Port1.Open
     then Form1.Caption:=Form1.Caption+' open'
     else Form1.Caption:=Form1.Caption+' closed';
   }
  if QuitNow then Form1.Close;

  ShowSerialStatus(false);
  if PendingInvisible then begin //held over from parsing of commandline
    //Form1.Visible:=false;
    MenuItemShow.checked:=true; //will leave restore button in correct state
    MenuItemShowClick(nil);
    PendingInvisible:=false;
  end;
  if PendingHelp then begin
    PendingHelp:=false;
    Help1Click(nil);
  end; //if
  if PicProg.Open
    then begin
      ApdStatusLightRB7.Lit:=PicProg.RB7;
    end;
  //Formclose is moved here to remove an error thrown with "capquit" when it was in stopcapture
  if (CaptureAutoQuit and not IsCapturing) then begin
    Form1.close;
    exit;
  end;
  if IsCapturing then begin
    if (CaptureTime>0)
      then begin
        CaptureTimeRemaining:=CaptureStopTime-now;
        if ( CaptureTimeRemaining>0 ) then begin //still going
          end
          else begin //time to stop
            StopCapture;
        end;
    //show progress bar
        CaptureTimeLeft:=floor(CaptureTimeRemaining*24*3600); //in secs
        ProgressBarCapture.position:=CaptureTime-CaptureTimeLeft;
      end;
    if ( CaptureSize>0 ) then begin
        ProgressBarCapture.position:=CharCount;
        CharsLeft:=CaptureSize-CharCount;
        if CPS>0 then  //try to deal with mystery div by 0 in capture
          CaptureTimeLeft:=(CharsLeft div CPS); //an approximation
    end;
  end; //if capturing
//  if (Port1.Dispatchermode=dlWinsock) and (Port1.wsMode=wsClient) and Port1.open
//    and fPort1Connected

end;
procedure TForm1.SetDataTriggerLight; //this is also being used by binary sync events....
begin
  DataTriggerLightTimer:=5; //light stays on for N ticks of the main timer
  IsCurrentDataTrigger:=true;
end;

procedure TForm1.SetDisplayWidth;
  var N:integer;
begin
  N:= SpinEditFrameSize.Value;
  if CheckBoxSingleFrame.Checked
    then begin
      N:= -N;
    end;
  if (AdTerminal1.Emulator = AdEmulator_Hex)
     then begin
       N:=N * HexEmulator.NumChars;
     end;
  OptimiseTerminalWidth(N);
end; //SetDisplayWidth
procedure TForm1.OptimiseTerminalWidth(N:integer);
  var NewWidth:byte;
begin
  case ( N ) of
    1,2,4,5,8,10,16,20,40,80: NewWidth:=80;
    3,6,9,12,18,24,36,72 : NewWidth:=72;
    7,14,21,28,42,84: NewWidth:=84;
    11:NewWidth:=77;
    13,26,39:NewWidth:=78;
    22,33:NewWidth:=66;
    17,34:NewWidth:=68;
    19,38:NewWidth:=76;
    32,64: NewWidth:=64;
    15,30: NewWidth:=60;
    else begin
      NewWidth:=N; //default if we can't squeeze 2 or more cols in
      if {(-80<=N) and }(N<=-1)  then begin //force single frame
          NewWidth:=byte(abs(N));
        end
      else begin
        //if N > 84            //max width is84  (no point really)
          //then NewWidth:=80;
        if N*3 <=84
          then begin
            NewWidth:=N*3;
            N:=1000;
          end;
        if N*2 <=84
          then begin
            NewWidth:=N*2;
            //N:=1000;
          end;

      end; //else
    end;
  end; //case
  assert((NewWidth<255) and (NewWidth>0));
  AdTerminal1.Columns:=NewWidth;
  SpinEditTerminalCols.Value:=AdTerminal1.Columns;
  //  AdTerminal1.DisplayColumns:=NewWidth;
  //if AdTerminal1.DisplayColumns<10 then AdTerminal1.DisplayColumns:=10;
end; //TForm1.OptimiseTerminalWidth(N:byte)



procedure TForm1.RadioGroupDisplayTypeClick(Sender: TObject);
begin
  AdTerminal1.Emulator:= AdEmulator_Hex; // most use this emulator...
  AdEmulator_Hex.OnProcessChar:=HexEmulator.ProcessChar;
  GroupboxBinarySync.Visible:=true;
  GroupboxHexCSV.Visible:=false;
  StatusBarFormattedData.Visible:=false;
  HexEmulator.NumChars:=1; //used to setup terminal even when emulator not used
  case ( RadioGroupDisplayType.ItemIndex ) of
    0: begin                                             //ascii
         AdTerminal1.Emulator:=AdShowAllEmulator;
         GroupboxBinarySync.Visible:=false;
       end;
    1: begin                                            //ansi
           AdTerminal1.Emulator:= AdEmulator_Plain;
           GroupboxBinarySync.Visible:=false;
       end;
    2: HexEmulator.Init(false,true,true ,false,false,HexStr,3);         //hex
    3: HexEmulator.Init( true,true,true ,false,false,HexStr,4);         //hex + ascii
    4: HexEmulator.Init(false,true,true ,false,false,UInt8Str,4);
    5: HexEmulator.Init(false,true,true ,false,false,Int8Str,5);
    6: HexEmulator.Init(false,true,false,false,false,HexStr,2);
    7: HexEmulator.Init(false,true,true ,false,false,Int16Str,6);
    8: HexEmulator.Init(false,true,true ,false,false,Uint16Str,5);
    9: HexEmulator.Init(true,false,false,false,false,NoStr,2);
   10: HexEmulator.Init(false,true,true ,false,false,BinaryStr,9);  //binary string
   11: HexEmulator.Init(false,true,true ,false,false,NibbleStr,10);
   12: HexEmulator.Init(false,true,true ,false,false,Float4Str,10);
   13: begin                                             //ascii
         AdTerminal1.Emulator:=AdShowAllEmulator;
         GroupboxBinarySync.Visible:=false;
         GroupboxHexCSV.Visible:=true;
         ShowHideStatusBarFormattedData;
       end;
    else begin
      RadioGroupDisplayType.ItemIndex:=0;
      showmessage('not implemented yet')
    end;
  end; //case
  case ( RadioGroupDisplayType.ItemIndex ) of
    7,8,12: CheckBoxBigEndian.Enabled:=true;
    else CheckBoxBigEndian.Enabled:=false;
  end; //case
  HexEmulator.InvertData:=CheckBoxInvertData.Checked;
  HexEmulator.MaskMSB:=CheckBoxMaskMSB.Checked;
  //OptimiseTerminalWidth(SpinEditFrameSize.Value * HexEmulator.NumChars);
  SetDisplayWidth;
  AdTerminal1.Emulator.Buffer.UseNewLineMode:=CheckBoxNewLine.checked;
  if CheckBoxClearTerminalOnDisplayChange.Checked
    then begin
      //AdTerminal1.ClearAll;
      ButtonClearClick(nil);
    end;
end;
(*
procedure TForm1.AdEmulator_HexProcessChar(Sender: TObject;
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
    if HexEmulator.BigEndian
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
  if ( HexEmulator.InvertData ) then begin
    C:= char(not byte(C));
  end;
  //History string is the last N chars
//  HexEmulator.SyncLength:=length(HexEmulator.SyncString);
//  if length(HexEmulator.HistoryString) < HexEmulator.SyncLength //length(HexEmulator.SyncString)
//    then HexEmulator.HistoryString:=HexEmulator.HistoryString+C
//    else HexEmulator.HistoryString:= copy(HexEmulator.HistoryString,2,HexEmulator.SyncLength)+C;
  //FrameEnd:=(HexEmulator.HistoryString=HexEmulator.SyncString);
//  for i:=1:SyncLength
//  FrameEnd:=(HexEmulator.HistoryString=(HexEmulator.SyncString xor HexEmulator.SyncXOR and HexEmulator.SyncAND));
  HexEmulator.NewChar(C);
  FrameEnd:=HexEmulator.IsFrameEnd;
//  HexEmulator.HistoryWrPos:= HexEmulator.HistoryWrPos mod sizeof(HexEmulator.History);
//  HexEmulator.HistoryWrPos:= HexEmulator.HistoryWrPos+1;
//  if HexEmulator.HistoryLength < sizeof(HexEmulator.History)
//    then begin
//      inc(HexEmulator.HistoryLength);
//    end;
//  if ( HexEmulator.InvertData ) then begin
//    C:= char(not byte(C));
//  end;
//  HexEmulator.History[HexEmulator.HistoryWrPos]:=byte(C);
//  FrameEnd:= (59=(HexEmulator.History[HexEmulator.HistoryWrPos-1 mod sizeof(HexEmulator.History)+1]))
//             and (95=byte(C));

  //Command.Cmd:= eString;
  if HexEmulator.ShowChar
    then begin
        if HexEmulator.UnprintablesBlank
             and ((byte(C)<32) or (byte(C)>127))
          then CShow:=' ' //don't try to print control codes
          else CShow:=C;
      end
    else CShow:='';
  case HexEmulator.ShowAs of
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
                  if HexEmulator.ShowAs=Int16Str
                    then begin
                      if HexEmulator.BigEndian
                        then BinStr:=IntToStr(MakeInteger16(byte(LastC),byte(C)))
                        else BinStr:=IntToStr(MakeInteger16(byte(C),byte(LastC)));
                      BinStr:=LeftPadS(BinStr,6);
                    end
                    else begin //uint16
                      if HexEmulator.BigEndian
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
  if (HexEmulator.HasTrailingSpace) {and not (HexEmulator.ShowAs = Uint8str)}
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
      //Command.OtherStr:=Command.OtherStr+char(13)+char(10);
      ReplaceWith := ReplaceWith + char(13)+char(10);
    end;
  if HexEmulator.GulpCount>=1
    then begin
      dec(HexEmulator.GulpCount);
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
  with sender as TAdTerminalEmulator do begin
  case CharSource of
    csUnknown: ;
    csKeyboard: Buffer.ForeColor:= Color4Keyboard;
    csPort: begin
              IncCharCount(1);
              Buffer.ForeColor    := Color4Port;
            end;
    csWriteChar: Buffer.ForeColor:=Color4WriteChar;
    //else
  end; //case
  end; //with
end;
*)
(*
procedure TForm1.AdEmulator_HexProcessCharOld(CP: TObject; C: Char;
    var Command: TEmuCommand);
  var CShow:string; //char to actually display
      BinStr: string;
      //LeadingSpaces:byte;
      FrameEnd:boolean;
  const PendingChars:integer=0; //used where displayed numbers are multi-byte
  const WordInFrameCount:integer=0; //used to allow formatted frames to be displayed
  const LastC:Char=char(0);
begin
  PendingChars:=PendingChars+1; //as at least C is pending
  //we do a raw invert before any other processing at all
  if ( HexEmulator.InvertData ) then begin
    C:= char(not byte(C));
  end;
  //History string is the last N chars
  if length(HexEmulator.HistoryString) < length(HexEmulator.SyncString)
    then HexEmulator.HistoryString:=HexEmulator.HistoryString+C
    else HexEmulator.HistoryString:= copy(HexEmulator.HistoryString,2,255)+C;
  FrameEnd:=( HexEmulator.HistoryString=HexEmulator.SyncString);
//  HexEmulator.HistoryWrPos:= HexEmulator.HistoryWrPos mod sizeof(HexEmulator.History);
//  HexEmulator.HistoryWrPos:= HexEmulator.HistoryWrPos+1;
//  if HexEmulator.HistoryLength < sizeof(HexEmulator.History)
//    then begin
//      inc(HexEmulator.HistoryLength);
//    end;
//  if ( HexEmulator.InvertData ) then begin
//    C:= char(not byte(C));
//  end;
//  HexEmulator.History[HexEmulator.HistoryWrPos]:=byte(C);
//  FrameEnd:= (59=(HexEmulator.History[HexEmulator.HistoryWrPos-1 mod sizeof(HexEmulator.History)+1]))
//             and (95=byte(C));

  Command.Cmd:= eString;
  if HexEmulator.ShowChar
    then begin
        if HexEmulator.UnprintablesBlank
             and ((byte(C)<32) or (byte(C)>127))
          then CShow:=' ' //don't try to print control codes
          else CShow:=C;
      end
    else CShow:='';
  case HexEmulator.ShowAs of
    NoStr   : BinStr:='';
    HexStr  : BinStr:=IntToHex(Byte(C),2);
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
                  if HexEmulator.ShowAs=Int16Str
                    then begin
                      if HexEmulator.BigEndian
                        then BinStr:=IntToStr(MakeInteger16(byte(LastC),byte(C)))
                        else BinStr:=IntToStr(MakeInteger16(byte(C),byte(LastC)));
                      BinStr:=LeftPadS(BinStr,6);
                    end
                    else begin //uint16
                      if HexEmulator.BigEndian
                        then BinStr:=IntToStr(MakeWord(byte(LastC),byte(C)))
                        else BinStr:=IntToStr(MakeWord(byte(C),byte(LastC)));
                      BinStr:=LeftPadS(BinStr,5);
                    end;
                  PendingChars:=0; //used them
                  end; //pending
              end;
  end; //case
  Command.OtherStr := CShow+BinStr;
  if (HexEmulator.HasTrailingSpace) {and not (HexEmulator.ShowAs = Uint8str)}
    then Command.OtherStr:=Command.OtherStr+' '
    else begin
//      if (CharCount and 1)<>0  //trys to give alternating colors...
//        then begin
//          Command.FColor:=Command.Fcolor xor 255;
//          Command.bColor:=Command.bcolor xor 255;
//        end;
    end;
  IncCharCount(1);
  if FrameEnd
    then begin
      Command.OtherStr:=Command.OtherStr+char(13)+char(10);
    end;
  if HexEmulator.GulpCount>=1
    then begin
      dec(HexEmulator.GulpCount);
      Command.Cmd:=eNone; // swallow this char
    end;
  Command.Ch:=char(0); //try to prevent spurious screen resizing
  assert(length(Command.OtherStr)<=10); // is this valid or too late?
  LastC:=C;
  if FrameEnd then begin
    PendingChars:=0; // forces some sort of sync...
    WordInFrameCount:=0;
  end;
end;
*)
procedure TForm1.SpinEditFrameSizeChange(Sender: TObject);
begin
  //OptimiseTerminalWidth(SpinEditFrameSize.Value * HexEmulator.NumChars);
  SetDisplayWidth;
end;

procedure TForm1.ButtonFreezeClick(Sender: TObject);
//This routine is unchanged from the early days. Behaviour of terminal must have changed, so a new method of freezing the terminal window is needed
begin
  //Scrollback doesn't freeze like it used to in old versions
  //Enabled doesn't seem to do anything, it still gathers chars
  //Active stops it, but loses chars rx'd during inactive period
  //AdTerminal1.Active:= not AdTerminal1.Active;
  //if not AdTerminal1.Active
    //then ButtonFreeze.Caption:='Resume'
    //else ButtonFreeze.Caption:='Freeze';

{  AdTerminal1.Scrollback:= not AdTerminal1.Scrollback;
  if AdTerminal1.Scrollback
    then ButtonFreeze.Caption:='Resume'
    else ButtonFreeze.Caption:='Freeze';}
end;
function Get_ComPort(Com:TApdWinsockPort): WideString;
begin
  //with Com do begin
    if Com.DeviceLayer=dlWinsock
      then begin
        if (Com.wsMode = wsServer)
           then result:='server'
           else result:=Com.WsAddress;
        if Com.WsPort<>''
          then result:=result+':'+Com.WsPort;
      end
      else begin
        result:=inttostr(Com.ComNumber);
      end;
  //end;
end;
procedure Set_ComPort(Com:TApdWinsockPort; Value: WideString);
      procedure Set_Winsock(Com:TApdWinsockPort; const Value:string);
        var ColonPos:integer; Address:string;
      begin
          ColonPos:=AnsiPos(':',Value);
          if (ColonPos=0)
            then begin
              Address:=Value ;
              Com.WsPort:='telnet';
              end
            else begin
              Address:=copy(Value,1,ColonPos-1);
              Com.WsPort:=copy(Value,ColonPos+1, length(Value)-ColonPos);
            end;
          if LowerCase(Address)='server'
            then begin
              Com.WsMode:=wsServer;
              end
            else begin
              Com.WsMode:=wsClient;
              Com.wsAddress:=Address;
            end;
          Com.DeviceLayer:=dlWinSock;
          Com.ComNumber:=0;
      end; //fn
    procedure TrimToFirstSpace(var Value: WideString) ;
    var Pos:integer;
    begin
      Pos:=AnsiPos(' ',Value);
      if Pos > 1
        then begin
          Value:=copy(Value,1,Pos-1);
        //implicit else no space so leave alone.
        end;
    end;//fn

  var Num, code :integer;
      SaveOpen:boolean;

begin
  // Parse comport string to determine what type it is
  // eg a simple number: must be a physical comport#
  // a string starting with backslash (eg \VCP0) must be a registry entry
  // a string with dots or non numeric chars: must be telnet
  // if a : exists, pre: is wsaddress, post:is wsport
  if Value<>get_ComPort(Com)
    then begin
      SaveOpen:=Com.Open;
      if Com.Open then Com.Open:=false;
      //fComportString=Value;
      Com.open:=false;
      if Value[1]='\'
        then begin //must be a key name from registry
          val(GetCommNumberByKey(Value),Num,Code);
          if code=0 then begin  //must be a number
            //Num:=strtoint(Value);
            Com.ComNumber:=Num;
            Com.DeviceLayer:=DLWin32;
          end
          else begin //didn't find a matching key
          end
        end // \keyname
        else begin //either a com number or a winsock port
          TrimToFirstSpace(Value);  //so allows strings in form "1 = /serial3"
          val(Value ,Num,Code);
          if code=0 then begin  //must be a number
            //Num:=strtoint(Value);
            Com.ComNumber:=Num;
            Com.DeviceLayer:=DLWin32;
          end
          else begin //not a plain number so try to open as winsock
            Set_Winsock(Com,Value);
          end; //was winsock....
        end;
     //Com.open:=SaveOpen;
      Com.Open:=SaveOpen;
      if Form1.CheckBoxClearTerminalOnPortChange.Checked
        then begin
          Form1.ButtonClearClick(nil);
        end;
      end;
end;

function GetPhysicalComNumber(const Value: WideString):integer;
  var ComNumber, code:integer;
begin
  // Parse comport string to find numbered comport
  // eg a simple number: must be a physical comport#
  result:=-1; //invalid
  val(Value,ComNumber,Code);
  if code=0
    then begin //is a numeric port
      result:=ComNumber;
    end;
end;

procedure TForm1.SetPortClick(Sender: TObject);
begin
  //Port1.close;
  BitBtnSetPortClick(Sender);
end;


procedure TForm1.Port1WsConnect(Sender: TObject);
begin
  AdTerminal1.enabled:=true;
  ApdStatusLightConnected.lit:=true;
  LabelConnected.Caption:='Connected';
  SignalWsConnectedThroughRTSDTR(true,EchoPort);
end;

procedure TForm1.Port1WsDisconnect(Sender: TObject);
//called when port closes (even if serial), or when server loses connection
const AlreadyTryingToClosePort:boolean=false;
begin
  if AlreadyTryingToClosePort then exit; //kludge as closing port calls this
  AdTerminal1.enabled:=false;
  ApdStatusLightConnected.lit:=false;
  SignalWsConnectedThroughRTSDTR(false,EchoPort);
  //ApdStatusLightConnected2.lit:=false;
  LabelConnected.Caption:='Disconnect';
  if (Port1.wsMode=wsClient) and (Port1.DeviceLayer=dlWinsock) and Port1.Open //not if a server
    then begin
      AlreadyTryingToClosePort:=true;
//      Port1.Open:=false; //force the port to close, since they don't reconnect anyway
      SpeedButtonPort1Open.Down:=false;
    end;
  AlreadyTryingToClosePort:=false;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CommSpy1.IsNoneCommHooked
    then CommSpy1.Opened:=false
    else begin
      if MessageDlg('You must close the comport (ie the application you are spying on) before you will be able to exit Realterm',
                mtWarning,[mbCancel,mbIgnore],0) = mrCancel
                then begin
                  Action:=caNone;
                  exit;
                end;
    end;
  if ApdProtocol1.InProgress then begin //stop send before capture
      BitBtnAbortSendFileClick(nil);
  end;
  if CaptureMode<>cmoff then begin
    StopCapture;
  end;
  Port1.open:=false;
//  if CommSpy1.IsNoneCommHooked
//    then CommSpy1.Opened:=false
//    else ShowMessage('You must close the comport (ie the application you are spying on) before you will be able to exit Realterm');

  //CommSpy1.Opened:=false;
  //SpeedButtonPort1Open.Down:=Port1.Open;
  EchoPort.open:=false;
  Timer1.enabled:=false;
//  LabelConnected.Caption:='Disconnect';
  UpdateTrayIcon('MAINICON'); //restore the icon to normal
  TrayIcon1.Active:=false; //try to make it disappear immediately
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
// if QuitNow then self.Visible:=false;
  //EditComPort.text:=get_ComPort(Port1); //init from port component
//  ComboBoxComPort.text:=get_ComPort(Port1); //init from port component
//  MenuItemPort.Caption:='Port: '+ComboBoxComPort.text;
//  MenuItemBaud.caption:='Baud: '+ComboBoxBaud.text;
//  //EditBaud.text:=inttostr(Port1.baud);
//  ComboBoxBaud.text:=inttostr(Port1.baud);
//  ApdSLController1.monitoring:=true;
//  ApdSLControllerEcho.monitoring:=true;

 end;

procedure TForm1.Port1WsAccept(Sender: TObject; Addr: TInAddr;
  var Accept: Boolean);
begin
  Accept:=true;
  //AdTerminal1.enabled:=true;
  ApdStatusLightConnected.lit:=true;
  //ApdStatusLightConnected2.lit:=true;
  LabelConnected.Caption:='Accepted';
  SignalWsConnectedThroughRTSDTR(true,EchoPort);
end;

procedure TForm1.CheckBoxSingleFrameClick(Sender: TObject);
begin
  SetDisplayWidth;
end;

procedure TForm1.ButtonGulp1Click(Sender: TObject);
begin
  HexEmulator.GulpCount:=1; //using count might allow for gulp>1
end;

procedure TForm1.ComboBoxCaptureSizeChange(Sender: TObject);
var CS:integer;
begin
  CS:=strtoint(ComboboxCaptureSize.text);
  if (IsCapturing) and (CS<CharCount) and (CS<>0) then begin //don't change it if already captured more...
    ComboboxCaptureSize.color:=clRed; //show problem
        //ComboboxCaptureSize.text:=inttostr(CaptureSize);
  end
  else begin          //otherwise there is no problem
    if ( RadioGroupCaptureSizeUnits.itemindex=0 ) 
      then begin //bytes
        CaptureTime:=0;
        CaptureSize:=CS;
      end 
      else begin //seconds
        CaptureTime:=CS;
        CaptureSize:=0;
    end; 
    ComboboxCaptureSize.color:=clWindow; //show problem
    if ( CS<>0 ) then begin
      ProgressBarCapture.min:=0;
      ProgressBarCapture.max:=CS;
    end;
  end;
    
end;
procedure TForm1.ParameterParamMatch(Sender: TObject; CaseMatch: Boolean;
  Param, Reference: String);
  var value:integer;
      IsRemoteCommand:boolean;
  procedure DataBitsFormatErrorMessage;
  begin
    messageDlg('Command Line Parameter Error: DATA= option is 3 chars eg "7N1" #Bits,Parity,Stop. Values are 8-5,[N,O,E,M,S],1-2',
                mtWarning,[mbOK],0);
  end;

  function BooleanOrText(Reference:String; var Text:TComboBox): boolean; //detects no refernce, 1or0 or a filename
  begin
    result:=true;  //defaults to true with nothing or filename
    if length(Reference)=0 then result:=true;
    if (length(reference)=1) and (reference[1]='1')
       then result:=true
       else begin
         if (length(reference)=1) and (reference[1]='0')
           then Result:=false
           else Text.Text:=Reference; //allows 1 chars filenames except 0 and 1
       end;
     if length(reference)>=2 then Text.Text:=Reference;
  end;
  function CaptureModeOrText(Reference:String; var Text:TComboBox): TAdCaptureMode; //detects no refernce, capturemode or a filename
    procedure SetText;
      begin
        Text.Text:=Reference;
        result:=cmOn;
      end;
  begin
    //defaults to true with nothing or filename
    case length(Reference) of
      0: result:=cmOn;
      1: case reference[1] of
           '0': result:=cmOff;
           '1': result:=cmOn;
           '2': result:=cmAppend;
           else SetText ;
         end//case
       else SetText;
    end; //case
  end;
  procedure SetFlow(Reference:string;Group:TRadioGroup;Port:TApdWinsockPort;var PortChanged:boolean);
  // Used by the commandline parser to us N in FLOW=N and set flow
    var value:integer;
  begin
    if Reference='X' or Reference='x'
      then begin  //enable software flow control
        ReceiveFlowBox.Checked:=true;
        TransmitFlowBox.Checked:=true;
      end else begin
     value:=strtoint(Reference);
     if (Value>=Group.Items.Count) or (value<0)
       then Value:=0;
     Group.ItemIndex:=value;
     ItemIndexToHWFlowOptions(Group.ItemIndex,Port);
     PortChanged:=true;
     end; //if
  end;

begin
{baud=9600 port=server:telnet capcount=9876 capfile=c:\temp\smap.xxx framesize=7 display=3 bigend=1 visible=0 RTS=0 DTR=1 flow=2}
   Reference:=AnsiDequotedStr(Reference,'"'); // remove quotes that have come through the first instance message passing
   if QuitNow then exit; //don't process any more when going to quit
   param:=uppercase(param);
   IsRemoteCommand:=(Sender=ParameterRemote);

   if (param='BAUD') or (param='BD') then begin
     ComboBoxBaud.text:=Reference;
     Port1Changed:=true;
   end;
   if (param='PORT') or (param='PT') then begin
     ComboBoxComPort.text:=Reference;
     Port1Changed:=true;
   end;
   if (param='CAPFILE') or (param='CF') then begin
     ComboBoxSaveFname.text:=Reference;
   end;
   if (param='FRAMESIZE') or (param='FS') then begin
     SpinEditFrameSize.value:= strtoint(Reference);
   end;
   if (param='CAPCOUNT' ) or (param='CC') then begin
     ComboBoxCaptureSize.text:=Reference;
     RadioGroupCaptureSizeUnits.ItemIndex:=0;  //bytes
     ComboBoxCaptureSizeChange(nil);
   end;
   if (param='CAPSECS' ) or (param='CS') then begin
     ComboBoxCaptureSize.text:=Reference;
     RadioGroupCaptureSizeUnits.ItemIndex:=1; //secs
     ComboBoxCaptureSizeChange(nil);
   end;

   if (param='CAPHEX' ) or (param='CX') then begin
     CheckBoxCaptureAsHex.Checked:=not (Reference='0');
   end;
   if (param='TIMESTAMP' ) or (param='TS') then begin
     value:=strtoint(Reference);
     if (Value>=RadioGroupTimeStamp.Items.Count) or (value<0)
       then Value:=0;
     RadioGroupTimeStamp.ItemIndex:=Value; //secs
   end;

   if (param='CAPTURE') or (param='CP') then begin
     if IsRemoteCommand
      then begin
        StartCapture(CaptureModeOrText(reference,ComboBoxSaveFname));
        //if BooleanOrText(reference,ComboBoxSaveFname)
        //  then StartCapture(cmOn)
        //  else StartCapture(cmOff);
      end
      else begin
        CaptureAutoStart:=CaptureModeOrText(reference,ComboBoxSaveFname);
        //CaptureAutostart:=cmOn;
      end;
   end;
   if (param='CAPQUIT') or (param='CQ') then begin
     CaptureAutostart:=cmOn;
     CaptureAutoQuit:=true;
     if length(reference)>0 then ComboBoxSaveFname.text:=Reference;
   end;
   if (Param='CAPDIRECT') or (param='CD') then begin
     CheckboxDirectCapture.Checked:=not (Reference='0');
   end;
//   if (param='CAP' ) then begin
//     //AutostartCapture
//   end;
   if (param='DISPLAY'  ) or (param='DS') then begin
     value:=strtoint(Reference);
     if (Value>=Form1.RadioGroupDisplayType.Items.Count) or (value<0)
       then Value:=0;
     Form1.RadioGroupDisplayType.ItemIndex:=value;
   end;
   if (param='VISIBLE') or (param='VS')then begin  //form is created after this is parsed....
     if IsRemoteCommand 
       then Form1.visible:=not (Reference='0')
       else PendingInvisible:= (Reference='0');
   end;
   if (param='BIGEND'  ) or (param='BN') then begin
     CheckBoxBigEndian.checked:=(Reference='1');
     CheckBoxBigEndianClick(nil);
   end;
   if (param='FLOW'  ) or (param='FW') then begin
     SetFlow(Reference,Form1.HardwareFlowGroup,Port1,Port1Changed);
//     value:=strtoint(Reference);
//     if (Value>=Form1.HardwareFlowGroup.Items.Count) or (value<0)
//       then Value:=0;
//     Form1.HardwareFlowGroup.ItemIndex:=value;
//     ItemIndexToHWFlowOptions(Form1.HardwareFlowGroup.ItemIndex,Port1);
//     Port1Changed:=true;
   end;
   if (param='EFLOW'  ) or (param='EFW') then begin
       SetFlow(Reference,Form1.EchoHardwareFlowGroup,EchoPort,EchoPortChanged);
   end;

   if (param='RTS')  then begin
     Port1.RTS:=(Reference='1');
   end;
   if (param='DTR')  then begin
     Port1.DTR:=(Reference='1');
   end;
   if (param='CLOSED') then begin
     if IsRemoteCommand
       then Port1.Open:= not (reference='1')
       else Port1.AutoOpen:= not (reference='1');
   end;
   if (param='OPEN') then begin
     if IsRemoteCommand
       then Port1.Open:= not (reference='0')
       else Port1.AutoOpen:= not (reference='0');
   end;
   if (param='SPY') then begin
     if IsRemoteCommand
       then begin
         SpyModeOpen(not (reference='0'));
       end
       else SpyModeAutoStart:= not (reference='0');
   end;
   if (param='TAB') then begin
     if not SelectTabSheet(Reference) then begin //select the tabsheet by name
       showmessage('Unknown tabsheet name "' + Reference +'"');
     end;
   end;
   if (param='EBAUD') then begin
     ComboBoxEchoBaud.text:=Reference;
     EchoPortChanged:=true;
   end;

   if (param='ECHO') then begin
     if (length(Reference)<>0) then ComboBoxEchoPort.text:=Reference;
     BitBtnSetEchoPortClick(nil);
     CheckBoxEchoOn.checked:=true;
     CheckBoxEchoOnClick(nil); //and open the port
     EchoPortChanged:=true;
   end;
   if (param='HALF') then begin
     if length(Reference)=0
       then CheckboxHalfDuplex.checked:=true
       else CheckboxHalfDuplex.checked:= (Reference='1');
   end;
   if (param='LFNL') then begin
     if length(Reference)=0
       then CheckboxNewLine.checked:=true
       else CheckboxNewLine.checked:= (Reference='1');
   end;

   if (param='CAPTION') then begin
     Caption:=Reference;
     MenuItemTitle.Caption:=Reference;
     Application.Title:=Reference; //shown on start bar when minimised
   end;
   if (param='CONTROLS') then begin
     HideControls1.Checked:= (Reference='1');
     HideControls1Click(nil);
   end;
   if (param='MONITOR') then begin
     CheckBoxEchoPortMonitoring.checked:=(Reference='1') or (Reference='');
     CheckBoxEchoPortMonitoringClick(nil);
   end;
   if (param='DATA') then begin //sets data format
     case Reference[1] of
       '8': Port1.DataBits:=8;
       '7': Port1.DataBits:=7;
       '6': Port1.DataBits:=6;
       '5': Port1.DataBits:=5;
       else
         DataBitsFormatErrorMessage;
     end; //case
     case uppercase(Reference)[2] of
       'N': Port1.Parity:=pNone;
       'O': Port1.Parity:=pOdd;
       'E': Port1.Parity:=pEven;
       'M': Port1.Parity:=pMark;
       'S': Port1.Parity:=pSpace;
       else
         DataBitsFormatErrorMessage;
     end; //case
     case Reference[3] of
       '1': Port1.StopBits:=1;
       '2': Port1.StopBits:=2;
       else
         DataBitsFormatErrorMessage;
     end; //case
     Port1Changed:=true;
   end; //DATA
   if (param='EDATA') then begin //sets data format
     case Reference[1] of
       '8': EchoPort.DataBits:=8;
       '7': EchoPort.DataBits:=7;
       '6': EchoPort.DataBits:=6;
       '5': EchoPort.DataBits:=5;
       else
         DataBitsFormatErrorMessage;
     end; //case
     case uppercase(Reference)[2] of
       'N': EchoPort.Parity:=pNone;
       'O': EchoPort.Parity:=pOdd;
       'E': EchoPort.Parity:=pEven;
       'M': EchoPort.Parity:=pMark;
       'S': EchoPort.Parity:=pSpace;
       else
         DataBitsFormatErrorMessage;
     end; //case
     case Reference[3] of
       '1': EchoPort.StopBits:=1;
       '2': EchoPort.StopBits:=2;
       else
         DataBitsFormatErrorMessage;
     end; //case
    EchoPortChanged:=true;
   end; //edata

   if (param='CHARDLY') then begin //set char delay
     value:=strtoint(Reference);
     if (value<0) then Value:=0;
     Form1.SpinEditAsciiCharDelay.Value:=Value;
   end;
   if (param='LINEDLY') then begin //set char delay
     value:=strtoint(Reference);
     if (value<0) then Value:=0;
     Form1.SpinEditAsciiLineDelay.Value:=Value;
   end;
   if (param='ROWS') then begin
     value:=strtoint(Reference);
     if (value<=0) then Value:=16;
     Form1.SpinEditTerminalRows.Value:= Value;
   end; //ROWS
   if (param='COLS') then begin
     value:=strtoint(Reference);
     if (value<=0) then Value:=16;
     Form1.SpinEditTerminalCols.Value:= Value;
   end; //ROWS

   if (param='SENDFILE') then begin
     if IsRemoteCommand
      then begin
        if BooleanOrText(reference,ComboBoxSendFname)
          then ButtonSendFileClick(nil)
          else BitBtnAbortSendFileClick(nil);
      end
      else begin //from commandline
        ComboboxSendFname.text:=Reference;
        SendFileAutostart:=true;
      end;
   end;
   if (param='SENDQUIT') then begin
     if length(Reference)>0 then ComboboxSendFname.text:=Reference;
     SendFileAutostart:=true;
     SendFileAutoQuit:=true;
   end;
   if (param='SENDDLY') then begin
     value:=strtoint(Reference);
     Form1.SpinEditFileSendDelay.Value:= Value;
     //Form1.SpinEditFileSendRepeats.Value:=0; //default to endless
   end; //SENDDLY
   if (param='SENDREP') then begin
     value:=strtoint(Reference);
     Form1.SpinEditFileSendRepeats.Value:= Value;
   end; //SENDREP
   if (param='FIRST') then begin
     if not IsFirstInstance then begin
       ActivateFirstCommandline;
       QuitNow:=true;
       exit;
       //halt;
       //Application.Terminate;
     end;
   end;
   if (param='QUIT') or (param='EXIT') then begin
     //Application.Terminate;
//     showmessage('Closing');
//     Form1.Close;
     QuitNow:=true;
     exit;
   end;
   if (param='SENDSTR')  then begin
     ComboBoxPushString(ComboboxSend1,reference,100);
     //ComboboxSend1.text:=reference;
     if ( IsRemoteCommand ) then begin
       ButtonSendAscii1Click(nil);
     end
     else begin  //command line parameters it will push into BOTH comboboxes
       ComboBoxPushString(ComboboxSend2,reference,100);
     end;
   end;
   if (param='SENDNUM') then begin
     //ComboboxSend1.text:=reference;
     ComboBoxPushString(ComboboxSend1,reference,100);
     if ( IsRemoteCommand ) then begin
       ButtonSendNumbers1Click(nil);
     end
     else begin  //command line parameters it will push into BOTH comboboxes
       ComboBoxPushString(ComboboxSend2,reference,100);
     end;
   end;
   if (param='CR') then begin
     CheckBoxCR1.checked:=not (reference='0');
   end;
   if (param='LF') then begin
     CheckBoxLF1.checked:=not (reference='0');
   end;
   if (param='SCANPORTS') then begin
     //SuppressPortScan:= (reference='0');
     PortScanLastPortOnStartup:=strtoint(reference);
   end;
   if (param='HELP') then begin
      PendingHelp:=true;
   end;
   if (param='I2CADD') then begin
     ComboBoxIAddress.Text:=reference;
   end;
   if (param='SCROLLBACK') then begin
     value:=strtoint(Reference);
     Form1.SpinEditScrollbackRows.Value:= Value;
     CheckboxScrollback.checked:=true;
   end; //SCROLL
   if (param='COLORS') then begin
     //SetColors(Reference);
     EditColors.Text:=Reference;
   end;//COLORS
   if (param='INSTALL') then begin
     PendingHelp:=true;
     PortScanLastPortOnStartup:=4;
   end;//COLORS
   if (param='HEXCSV') then begin
     ComboBoxPushString(ComboBoxHexCSVFormat,reference,100);
   end;
end;


{*
procedure GetSerialCommNames;
//doesn't seem to do what I want, gets a list with lots of dead devs,
// and no current USB ports
//copied from http://community.borland.com/article/0,1410,16774,00.html
var
  reg : TRegistry;
  ts : TStrings;
//  i : integer;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('hardware\devicemap\serialcomm',
              false);
  ts := TStringList.Create;
  reg.GetValueNames(ts);
//  for i := 0 to ts.Count -1 do begin
//    memo1.lines.add(reg.ReadString(ts.Strings[i]));
//  end;
  ts.Free;
  reg.CloseKey;
  reg.free;
//  result:=ts;
end; *}

//populates the comboboxes with com numbers found on this system. Pushes down existing strings
procedure TForm1.PopulateComNumbers(LastComport:integer; ShowForm:boolean);
//Windoes98 doesn't have the registry entries for ports
begin
  if (Win32Platform=VER_PLATFORM_WIN32_WINDOWS)	or (Win32Platform=VER_PLATFORM_WIN32s)
    then PopulateComNumbersBySearch(LastComport,ShowForm) //<=Win98 (probably WinME)
    else PopulateComNumbersFromRegistry(LastComport, ShowForm); //>=WinNT
end ;
procedure TForm1.PopulateComNumbersFromRegistry(LastComport:integer; ShowForm:boolean);
//procedure AddComList(var ComboboxComport:TComboBox);
 var AList:TStrings;
     I:integer;
     S:string;
begin
    AList:=TStringList.Create;
    //FirstAvailablePort:=0;
    GetComDevicesList(AList, FirstAvailablePort, 2,true);
    if AList.Count<1 then exit; //avoid errors if this is empty for some reason
    //implicit else
    for i:=AList.Count-1 downto 0 do begin
      S:=AList[i];
      if ComboBoxComport.Items.IndexOf(S)=-1  //not already in combobox
        then begin
          ComboBoxComport.Items.Insert(0,S);
          ComboBoxEchoPort.Items.Insert(0,S);
        end;

    end; //for
    AList.Free;
end;//fn

//If LastComport<=0, then will search first 4 ports for the firstavailablecomport
procedure TForm1.PopulateComNumbersBySearch(LastComport:integer; ShowForm:boolean);
var
  I, InsertPoint : Integer;
  S : string;
  OnlyFindFirstPort:boolean;
begin
  //AddComList(ComboBoxComport);
  FirstAvailablePort:=0;
  OnlyFindFirstPort:=LastComport<=0;
  if OnlyFindFirstPort then LastComport:=4;
  //if LastComport<=0  then exit; //handle case of scanports=0
  if ShowForm then FormScanPorts.Show;
  FormScanPorts.StartScanning(LastComPort);
  S:='';
  InsertPoint:=0;
  for I := 1 to LastComport do begin   //MaxComHandles is constant
    FormScanPorts.Scanning(I,LastComport);
    if FormScanPorts.AbortScanning then break;
    if IsPortAvailable(I) then begin
      S := inttostr(I);
      if ComboBoxComport.Items.IndexOf(S)=-1  //not already in combobox
        then begin
          ComboBoxComport.Items.Insert(InsertPoint,S);
          ComboBoxEchoPort.Items.Insert(InsertPoint,S);
          inc(InsertPoint);
        end;
      if FirstAvailablePort=0
          then begin
            FirstAvailablePort:=I;
            if OnlyFindFirstPort then break;
          end;

    end;
  end; //for
  FormScanPorts.EndScanning;
end;

function ParityStartStopAsString(Port:TApdWinsockport):string;
  var P:char; 
begin
  case Port.Parity of
    pNone: P:='N';
    pEven: P:='E';
    pOdd : P:='O';
    pMark: P:='M';
    pSpace:P:='S';
    else P:='?';
  end; //case
  result:=inttostr(Port.Databits) + P +inttostr(Port.Stopbits);
end;
function HandshakingAsString(Port:TApdWinsockport) :string ;

begin
  result:=Form1.HardwareFlowGroup.Items[Form1.HardwareFlowGroup.ItemIndex];

  case Port.SWFlowOptions of
   swfNone: ; //already has a string from HWFlow above
   swfBoth, swfReceive, swfTransmit:
     if (Form1.HardwareFlowGroup.ItemIndex=0)
       then result:='XonXoff'
       else result:=result+ '+XonXoff';
   else result:=result+'?';
  end; //case
end; //HandshakingAsString
procedure TForm1.SetPortAndBaudCaptions;
var BaudStr:string;
begin
  BaudStr:='';
  MenuItemPort.Caption:='Port: Closed';
  MenuItemBaud.Caption:='Baud: ----';
  if Port1.open 
    then begin
      MenuItemPort.Caption:='Port: '+ComboBoxComPort.text;
      if Port1.DeviceLayer<>dlWinsock
        then begin
          BaudStr:=ComboBoxBaud.text + ' ' +ParityStartStopAsString(Port1) +' '+HandshakingAsString(Port1);
          MenuItemBaud.caption:='Baud: '+BaudStr;
          end
        else MenuItemBaud.caption:='Baud: ----';
    end
    else begin //port is closed 
      if SpeedButtonSpy1.Down 
        then begin
          MenuItemPort.Caption:='Port: '+ComboBoxComPort.text;
          MenuItemBaud.Caption:=' Spying';
          BaudStr:='Spying';
          end;
    end;
  StatusBar1.Panels[StatusBarPanelEnd].text:= MenuItemPort.caption+' '+BaudStr;

end; //SetPortAndBaudCaptions
procedure TForm1.FormCreate(Sender: TObject);
  var Port1AutoOpen:boolean;
begin
  //TP_GlobalIgnoreClassProperty(TAdTerminal);
  //TranslateComponent(self); //translation should come first
  Parameter1.SwitchWatch:=Parameter1.ParamWatch;
  ParameterRemote.SwitchWatch:=ParameterRemote.ParamWatch;
  Parameter1.useProgramParams:=true;
  Parameter1.execute;

  //Having Port1.AutoOpen causes extra trap errors during IsComAvailable and causes terminal rx problem

  Port1AutoOpen:=Port1.AutoOpen; //So now save the value to another var
  Port1.AutoOpen:=false;  //and clear the port var that seems to be causing the problems

  if QuitNow then begin
    //Port1.AutoOpen:=false; //needed to prevent a ecPortOpen warning when sending to FIRST instance from command line
    self.WindowState:=wsMinimized; //and stop the form flashing up
    Application.Terminate;  //put the terminate message into the q
    exit;
  end;

  Application.OnHint := DisplayHint; //puts tooltips into status bar
  Application.HintHidePause:=3500; //default is 2500ms. lengthen by request
  Application.HintShortCuts:=true;
  NoNagAboutSpy:=SpyDriversInstalled; 
  {set default values}
  {get values into controls from port}
  SetColors(EditColors.Text);
  //Color4Keyboard:=clRed;
  //Color4Port    :=clYellow;
  //Color4WriteChar:=clLime;
  //Color4SpyTx:=clRed;
  //Color4SpyRx:=clYellow;
  fEchoPortConnected:=false;
  CannedStrings:=TStringlist.create;
  //SpyAutoStart:=
  //PendingInvisible:=false;
  //CaptureAutoQuit:=false;

  AdShowAllEmulator := TAdShowAllEmulator.create(Form1);
  AdShowAllEmulator.OnProcessChar:=AdEmulator_ShowAllProcessChar;
  //AdShowAllEmulator.ControlCharShowStyles :=(ssShowControlChars,ssShowCRLF,ssAlwaysLFatCR,{ssNoCRLFActions,}ssShowBackspace{, ssNoTabAction});
  RadioGroupDisplayTypeClick(nil); //set emulator
  //AdTerminal1.Emulator := AdShowAllEmulator;
  if length(ComboboxComPort.text)=0 then ComboboxComPort.text:=get_Comport(Port1);
  if length(ComboboxBaud.text)=0 then ComboboxBaud.text:= inttostr(Port1.baud);

  ParityGroup.ItemIndex   := Ord(Port1.Parity);
  DataBitsGroup.ItemIndex := 8 - Port1.Databits;
  StopBitsGroup.ItemIndex := Port1.Stopbits - 1;


  if (hwfUseRTS in Port1.HWFlowOptions) or (hwfRequireCTS in Port1.HWFlowOptions) then
    HardwareFlowGroup.ItemIndex := 2
  else if (hwfUseDTR in Port1.HWFlowOptions) or (hwfRequireDSR in Port1.HWFlowOptions) then
    HardwareFlowGroup.ItemIndex := 1
  else  if Port1.RS485Mode then
    HardwareFlowGroup.ItemIndex:=3
  else
    begin
      HardwareFlowGroup.ItemIndex := 0;
      StatusBar1.Panels[StatusBarPanelHints].text:='Warning: No handshaking';
    end;

  case Port1.SWFlowOptions of
    swfReceive : ReceiveFlowBox.Checked  := True;
    swfTransmit: TransmitFlowBox.Checked := True;
    swfBoth    :
      begin
        ReceiveFlowBox.Checked  := True;
        TransmitFlowBox.Checked := True;
      end;
  end;

  XonCharEdit.Text  := IntToStr(Ord(Port1.XonChar));
  XoffCharEdit.Text := IntToStr(ord(Port1.XoffChar));
  //if PicProg.Open
  //  then begin
    //  GroupBoxPP.Enabled:=false;
 //     GroupBoxPP.Hint:='Unable to open DLPORTIO Driver';
 //   end


 //MenuItemTitle.Caption:=Caption;
 //MenuItemBaud.caption:='Baud: '+ComboBoxBaud.text;

 //StatusBar1.Panels[6].text:=
 //now over-ride with any commandline values
 //Parameter1.execute_line(ParamStr);
 //now set any changed values...
 BitBtnSetPortClick(nil);
 BitBtnSetEchoPortClick(nil);


 // Now try to scan for ports and set the default port
 // Don't scan unless smStandAlone
 // Don't scan if PORT set on commandline, unless scanports is set on commandline
  if  (Comserver.StartMode=smStandAlone) and
     ((Port1.ComNumber=0) or (PortScanLastPortOnStartup<>MaxComHandles))
       then begin
    PopulateComNumbers(PortScanLastPortOnStartup,false); //finds FirstAvailablePort too
  end; //if
  if (Port1.ComNumber=0) then begin  //means that commandline didn't set it
    if (FirstAvailablePort>0)  //so we did find one
      then Port1.ComNumber:=FirstAvailablePort
      else begin
        Port1.ComNumber:=1;  //what else can I do?
        Port1AutoOpen:=false; //but don't autoopen
      end;
  end;

 //now open the port
 if Comserver.StartMode=smAutomation then begin
   Port1AutoOpen:=false;
 end;

  if Comserver.StartMode=smStandAlone then begin //only open the port immediately in standalone mode
//    if false then begin
    if SpyModeAutostart
      then SpyModeOpen(true)
      else
        try
          Port1.open:=Port1AutoOpen;
          //Port1.AutoOpen:=false;
//          if IsPortAvailable(Port1.ComNumber)
//            then Port1.open:=Port1AutoOpen
//            else begin
//              MessageDlg('Port not available. Probably PORT does not exist', mtInformation, [mbOK], 0);
//              Port1AutoOpen:=false;
//            end;
        except
          on E: EAlreadyOpen do begin
        //E.Message:= 'Port is already open. You must change Port'+char(13)+E.Message;
        //raise;
        MessageDlg('Port is already open. You must change Port'+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        Port1.AutoOpen:=false;
        end;
      on E: eBadId do begin
        MessageDlg('BadID, Probably PORT does not exist'+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;
      on E: eBaudRate do begin
        MessageDlg('BaudRate Error, Probably an impossible baudrate'+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;
      on E: EOpenComm do begin
        MessageDlg('Error Opening Comm, '+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;

//      ecByteSize
//      ecDefault
//      ecHardware
//      ecMemory
//      ecCommNotOpen
//      ecAlreadyOpen
//      ecNoHandles
//      ecNoTimers
//      ecNoPortSelected
    end;
    Form1.SpeedButtonPort1Open.down:=Port1.Open;
    if (Comserver.StartMode=smAutomation) then begin
      TabsheetEvents.TabVisible:= true;
      RadioGroupSendEvent.Enabled:=true; //only useful in automation state
    end else begin
      TabsheetEvents.TabVisible:= false;
      RadioGroupSendEvent.Enabled:=false;
    end;
  end;
  //----- Moved from on activate
  //Re-display these values incase the port changed them (eg baud rate) when opening
  ComboBoxComPort.text:=get_ComPort(Port1); //init from port component
  ComboBoxBaud.text:=inttostr(Port1.baud);
  SetPortAndBaudCaptions;
  ApdSLController1.monitoring:=true;
  ApdSLControllerEcho.monitoring:=true;
  if Port1.open and (CaptureAutostart<>cmoff ) then begin
    StartCapture(CaptureAutoStart);
  end;
//  if Port1.open and (length(SendStringAutostartString)>0) then begin
//    SendString(SendStringAutostartString);
//  end;
  if Port1.open and SendFileAutostart then begin
    ButtonSendFileClick(nil); //start sending file
  end;
  if Caption=''
    then begin
      //Default capton is set in AFVersion Caption now
      case Comserver.StartMode of
     smAutomation: AFVersionCaption1.InfoPrefix:='Realterm: Automation Server';
     smStandalone: AFVersionCaption1.InfoPrefix:='RealTerm: Serial Capture Program';
     else  ;
   end; //case
      //AFVersionCaption1.InfoPrefix:=AFVersionCaption1.InfoPrefix+' Automation Server';
      AFVersionCaption1.execute;
    end;
  Port1Changed:=false;  //might have been set by cmdline, and only active for "first" mode
  EchoPortChanged:=false;

end;


procedure TForm1.ItemIndexToHWFlowOptions(ItemIndex:integer;Port:TApdWinsockPort);
begin
    Port.RS485Mode :=false;
    case ItemIndex of
      0: Port.HWFlowOptions := [];
      1: Port.HWFlowOptions := [hwfUseDTR, hwfRequireDSR];
      2: Port.HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
      3: begin
           Port.HWFlowOptions := [];
           Port.RS485Mode :=true;
         end;
    end;
end;
function Baud2Int(S,SMult:string):integer;
var  L,m,mult:integer;
begin
  L:=length(S);
  case S[L] of
    'M','m': begin
               m:=1000000;
               dec(L);
              end;
    'K','k': begin
               m:=1000;
               dec(L);
              end;
    else m:=1;
    end; //case
    S:=LeftStr(S,L); //remove the multiplier
  result:=strtoint(S)*m div strtoint(SMult);
end;
procedure TForm1.SetComPortClick(Sender: TObject);
  var
    E    : Integer;
    Temp : Byte;
    SerialControlsColor, SerialTextColor, WinsockTextColor: TColor;

  begin
    //change the port itself
    Set_Comport(Port1,comboboxstring(ComboBoxComPort));

    Port1.Parity   := TParity(ParityGroup.ItemIndex);
    Port1.Databits := 8 - DataBitsGroup.ItemIndex;
    Port1.Stopbits := StopBitsGroup.ItemIndex + 1;

    ItemIndexToHWFlowOptions(HardwareFlowGroup.ItemIndex, Port1);

    if TransmitFlowBox.Checked and ReceiveFlowBox.Checked then
      Port1.SWFlowOptions := swfBoth
    else if not TransmitFlowBox.Checked and not ReceiveFlowBox.Checked then
      Port1.SWFlowOptions := swfNone
    else if TransmitFlowBox.Checked then
      Port1.SWFlowOptions := swfTransmit
    else if ReceiveFlowBox.Checked then
      Port1.SWFlowOptions := swfReceive;

    Val(XonCharEdit.Text, Temp, E);
    if (E = 0) then
      Port1.XonChar := Char(Temp);
    Val(XoffCharEdit.Text, Temp, E);
    if (E = 0) then
      Port1.XoffChar := Char(Temp);
    try
    Port1.baud:=Baud2Int(ComboBoxBaud.text,ComboboxBaudMult.text); //strtoint(ComboBoxBaud.text);
    except
      on E:EInOutError do MessageDlg('"'+E.Message+'"'+char(10)+char(10)+'Probably the requested baud rate is not possible on this adaptor',mtError,[mbOK],0);
    end;
    ComboBoxBaud.text:=inttostr(Port1.Baud);
    ComboBoxComPort.text:=Get_Comport(Port1);
  //  MenuItemPort.Caption := 'Port: '+ComboBoxComPort.text;
  //  MenuItemBaud.caption:='Baud: '+ComboBoxBaud.text;
    SetPortAndBaudCaptions;
    //do we need to disable the terminal until the telnet connects????
    //if ( ApdPort1.DeviceLayer=dlWinsock ) then begin
    if Port1.DeviceLayer=dlWinsock //grey if not a real port
      then begin
        SerialControlsColor:=clInactiveBorder;
        SerialTextColor:=clGrayText;
        WinsockTextColor:=clWindowText;
        end
      else begin
        SerialControlsColor:=clWindow;
        SerialTextColor:=clWindowText;
        WinsockTextColor:=clGrayText;
      end;
    //end;
    ComboBoxBaud.color:=SerialControlsColor;
    PanelBaud1.font.color:=SerialTextColor;
    ParityGroup.font.color:=SerialTextColor;
    DataBitsGroup.font.color:=SerialTextColor;
    StopBitsGroup.font.color:=SerialTextColor;
    HardwareFlowGroup.font.color:=SerialTextColor;
    RadioGroupWsTelnet.font.color:=WinsockTextColor;
    RadioGroupEchoWsTelnet.font.color:=WinsockTextColor;
    SoftwareFlowGroup.font.Color:=SerialTextColor;

    if Port1.Open then begin
      AdTerminal1.enabled:=true;
      ApdSLController1.monitoring:=true;
    end;
    Port1Changed:=false;
end; //SetPortClick

procedure TForm1.BitBtnSetPortClick(Sender: TObject);
begin
  if SpeedButtonSpy1.Down
    then SpeedButtonPort1OpenClick(nil) //this will change the Spy port
    else SetComPortClick(nil);             //this changes the comport
  {if CheckBoxClearTerminalOnPortChange.Checked
    then begin
      ButtonClearClick(nil);
    end;}
end;
{function PortSettingsString:string;
begin
  if Form1.Port1.open
    then begin

    end
    else begin
        
    end;
end;  }
procedure TForm1.CheckBoxInvertDataClick(Sender: TObject);
begin
  HexEmulator.InvertData:=CheckBoxInvertData.Checked;
end;
procedure TForm1.CheckBoxMaskMSBClick(Sender: TObject);
begin
  HexEmulator.MaskMSB:=CheckBoxMaskMSB.Checked;
end;

procedure TForm1.ButtonSetRTSClick(Sender: TObject);
begin
  Port1.RTS:=true;
end;

procedure TForm1.ButtonClrRTSClick(Sender: TObject);
begin
  Port1.RTS:=false;
end;

procedure TForm1.ButtonSetDTRClick(Sender: TObject);
begin
  Port1.DTR:=true;
end;

procedure TForm1.ButtonClearDTRClick(Sender: TObject);
begin
  Port1.DTR:=false;
end;

procedure TForm1.Button500msBreakClick(Sender: TObject);
begin
  Port1.SendBreak(10,true);
end;

procedure TForm1.SendString(S:string); //sends actual string once
//var i:integer;
begin
//  for i:=1 to SpinEditNumTimesToSend.value do
    //begin
      while (Port1.OutBuffFree<length(S)) do //room to fit this string in the buffer
        begin
          sleep(0); //yield remainder of thread...
          Port1.ProcessCommunications;
        end;
      Port1.PutString(S);
      if CheckBoxHalfDuplex.checked then AdTerminal1.WriteString(S);
    //end;
end;

procedure TForm1.SendTabSendString(S:string); //sends string, controlled by SendTab global controls: CRC, Repeats etc

var i:integer;
begin
  if CheckBoxCRC.checked
    then begin
      case ComboboxCRC.ItemIndex of
        0: S:=S+CRC8_SMBUS(S);
        1: S:=S+CRC8_DALLAS(S);
        2: S:=S+ModbusCrc16String(S);
        3: S:=S+Checksum8(S);
        4: S:=S+Checksum16(S);
        else ;
      end; //case
    end;
  for i:=1 to SpinEditNumTimesToSend.value do
    begin
      if CheckboxNLBefore.Checked then TerminalNewLine;
      while (Port1.OutBuffFree<length(S)) do //room to fit this string in the buffer
        begin
          sleep(0); //yield remainder of thread...
          Port1.ProcessCommunications;
        end;
      if CheckBoxHalfDuplex.checked then AdTerminal1.WriteString(S);
      //have to write to buffer or else the newline and chars will be in wrong order
//      AdTerminal1.Emulator.Buffer.ForeColor:=clLime;
//      if CheckBoxHalfDuplex.checked then AdTerminal1.Emulator.Buffer.WriteString(S);
      if CheckboxNLAfter.Checked then TerminalNewLine;
      Port1.PutString(S);
    end;
end;
{procedure TForm1.SendTabSendString(S:string); //sends string, controlled by SendTab global controls: CRC, Repeats etc
var i:integer;
begin
  if CheckBoxCRC16.checked
    then begin
      S:=S+ModbusCrc16String(S);
    end;
  for i:=1 to SpinEditNumTimesToSend.value do
    begin
      while (Port1.OutBuffFree<length(S)) do //room to fit this string in the buffer
        begin
          sleep(0); //yield remainder of thread...
          Port1.ProcessCommunications;
        end;
      Port1.PutString(S);
      if CheckBoxHalfDuplex.checked then AdTerminal1.WriteString(S);
    end;
end;}

procedure TForm1.SendASCIIString(S:string;AppendCR,AppendLF,StripSpaces:boolean);
begin
  if StripSpaces then begin
    S:=filterl(S,' '); // remove spaces
  end;
  if AppendCR then S:=S+char(13);
  if AppendLF then S:=S+char(10);
  SendString(S);
end; //send asciistring

procedure TForm1.SendTabSendASCIIString(S:string;AppendCR,AppendLF,StripSpaces:boolean);
begin
  if StripSpaces then begin
    S:=filterl(S,' '); // remove spaces
  end;
  if AppendCR then S:=S+char(13);
  if AppendLF then S:=S+char(10);
  SendTabSendString(S);
end; //send asciistring

procedure TForm1.ButtonSendAscii1Click(Sender: TObject);
begin
  //Port1.PutString(comboboxstring(ComboBoxSend1));
  SendTabSendAsciiString(comboboxconvertstring(ComboBoxSend1,false,CheckBoxLiteralStrings.Checked),CheckBoxCR1.Checked,CheckBoxLF1.Checked,CheckBoxStripSpaces.Checked);
end;

procedure TForm1.ButtonSendAscii2Click(Sender: TObject);
begin
  //SendAsciiString(comboboxstring(ComboBoxSend2),CheckBoxCR2.Checked,CheckBoxLF2.Checked,CheckBoxStripSpaces.Checked);
  SendTabSendAsciiString(comboboxconvertstring(ComboBoxSend2,false,CheckBoxLiteralStrings.Checked),CheckBoxCR2.Checked,CheckBoxLF2.Checked,CheckBoxStripSpaces.Checked);
end;

procedure TForm1.CheckBoxHalfDuplexClick(Sender: TObject);
begin
  AdTerminal1.HalfDuplex:=CheckBoxHalfDuplex.checked;
end;

procedure TForm1.ButtonSetBreakClick(Sender: TObject);
begin
  Port1.SendBreak($FFFF,true);
end;

procedure TForm1.ButtonClearBreakClick(Sender: TObject);
begin
  Port1.SendBreak(0,true);
end;

procedure TForm1.ButtonSendFileClick(Sender: TObject);
begin
//    SelectTabsheet('Capture');
  SelectTabsheet('Send');
  //ApdProtocol1.Filemask:=comboboxstring(ComboBoxSendFName);
  ComboBoxPutStringAtTop(ComboBoxSendFName,10);
  ApdProtocol1.Filemask:=ComboBoxSendFName.text;
  ProgressBarSendFile.Min:=0;
  IsSendingFile:=false;
  try
    ApdProtocol1.StartTransmit;
    ProgressBarSendFile.Max:=ApdProtocol1.FileLength;
    GroupBoxSendFile.color:=clRed;
    //LabelRepeats.Caption:='# 1';
    SendFileCounter:=1;
    IsSendingFile:=true;
    labelprotocolerror.Caption:='Sending';
  except

  end;
end;

procedure TForm1.BitBtnAbortSendFileClick(Sender: TObject);
begin
  //SendFileCounter:=SpinEditFileSendRepeats.value; //make this last....
  TimerSendFile.Enabled:=false;
  SendFileCounter:=0; //forces a stop....
  if ApdProtocol1.InProgress
    then ApdProtocol1.CancelProtocol //which will call finish
    else ApdProtocol1.OnProtocolFinish(nil,-6005); //must call explicitly to clean up display
  SendFileAutoQuit:=false; //don't close when manual cancel

end;

procedure TForm1.SpinEditLPTChange(Sender: TObject);
begin
  //PICProg.LPTNumber:=SpinEditLPT.value;
end;

procedure TForm1.BitBtnChangeBinarySyncClick(Sender: TObject);
  var SyncString: string;
begin
  case RadioGroupSyncIs.ItemIndex of
    0: SyncString:='';
    1: SyncString:=comboboxstring(ComboBoxSyncString);
    2: SyncString:=ComboBoxConvertString(ComboBoxSyncString,true,true);
    else begin
        MessageDlg('Unknown SyncType', mtInformation, [mbOK], 0);
        RadioGroupSyncIs.ItemIndex:=0;
        SyncString:='';
    end;//else
  end; //case
  HexEmulator.SetSync(SyncString,
  ComboBoxConvertString(ComboBoxSyncXOR,true,true),
  ComboBoxConvertString(ComboBoxSyncAND,true,true), CheckBoxLeadingSync.Checked);
  HexEmulator.SyncCount:=0;
end;
(*
procedure TForm1.BitBtnChangeBinarySyncClick(Sender: TObject);
begin
  case RadioGroupSyncIs.ItemIndex of
    0: HexEmulator.SyncString:='';
    1: HexEmulator.SyncString:=comboboxstring(ComboBoxSyncString);
    2: HexEmulator.SyncString:=ComboBoxConvertString(ComboBoxSyncString,true,true);
    else begin
        MessageDlg('Unknown SyncType', mtInformation, [mbOK], 0);
        RadioGroupSyncIs.ItemIndex:=0;
    end;//else
  end; //case
  HexEmulator.SyncAND:= ComboBoxConvertString(ComboBoxSyncAND,true,true);
  if length(HexEmulator.SyncAND)<>length(HexEmulator.SyncString)
    then begin
      HexEmulator.SyncAND:=CharStrS(#255,length(HexEmulator.SyncString));
    end;
  HexEmulator.SyncXOR:= ComboBoxConvertString(ComboBoxSyncXOR,true,true);
  if length(HexEmulator.SyncXOR)<>length(HexEmulator.SyncAnd)
    then begin
      HexEmulator.SyncXOR:=CharStrS(#0,length(HexEmulator.SyncAND));
    end;

end;
*)
procedure TForm1.ButtonSendNumbers1Click(Sender: TObject);
begin
  SendTabSendString(ComboBoxConvertString(ComboBoxSend1,true,true));
end;

procedure TForm1.ButtonSendNumbers2Click(Sender: TObject);
begin
  SendTabSendString(ComboBoxConvertString(ComboBoxSend2,true,true));
end;

procedure TForm1.ButtonSaveFNameClick(Sender: TObject);
begin
  SaveDialog1.FileName:=ComboBoxSaveFName.text;
  if SaveDialog1.Execute then                              { Display Save dialog box}
    begin
      ComboBoxSaveFName.text:=SaveDialog1.FileName;
    end;
end;
procedure TForm1.ButtonTraceFNameClick(Sender: TObject);
begin
  SaveDialog1.FileName:=ComboBoxTraceFName.text;
  if SaveDialog1.Execute then                              { Display Save dialog box}
    begin
      ComboBoxTraceFName.text:=SaveDialog1.FileName; //will have extension coerced later
      ButtonChangeTraceFNameClick(nil);
    end;
end;
procedure TForm1.ButtonSendFNameClick(Sender: TObject);
begin
  OpenDialog1.Filename:= ComboBoxSendFName.text;
  if OpenDialog1.Execute then                              { Display Open dialog box}
    begin
      ComboBoxSendFName.text:=OpenDialog1.FileName;
    end;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  PageControl1.SelectNextPage(false);
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  PageControl1.SelectNextPage(true);
end;

procedure TForm1.SpeedButtonPowerClick(Sender: TObject);
begin
  PicProg.Power:=SpeedButtonPower.down;
  //if SpeedButtonPower.down
  //  then SpeedButtonPower.font.color:=cllime
  //  else SpeedButtonPower.font.color:=clwindowtext
end;

procedure TForm1.ButtonResetBothClick(Sender: TObject);
begin
  PicProg.Reset(0);
end;

procedure TForm1.ButtonReset1Click(Sender: TObject);
begin
  PicProg.Reset(1);
end;

procedure TForm1.ButtonReset2Click(Sender: TObject);
begin
  PicProg.Reset(2);
end;

procedure TForm1.PortTriggerAvail(CP: TObject; Count: Word);
var PortIn,PortOut:TApdWinsockPort;
    Block : array[0..1020] of Char; //this must be << OutBufSize, eg 1/4 or less
    ThisCount:word;
begin
  if (Count>0) and (EchoPort.open)
    then begin
  if CP=Port1
    then begin
      PortIn:=Port1;
      PortOut:=EchoPort;
    end
    else begin
      PortIn:=EchoPort;
      PortOut:=Port1;
    end; //if
    //Now transfer the block of data...
    while (count>0) and ((PortOut.OutBuffFree>=Count) or (PortOut.OutBuffFree>=sizeof(block)) ) do begin
      if count> sizeof(block)
        then begin
            ThisCount:=sizeof(block);
            count:=count-sizeof(block);
            end
        else begin
            ThisCount:=count;
        end;
  //    try
        PortIn.GetBlock(Block, ThisCount);
        PortOut.PutBlock(Block, ThisCount); //checked for space above
//except
//  on E : EAPDException do
//    if (E is EBadHandle) then begin
//      ...fatal memory overwrite or programming error
//      halt;
//    end else if E is EBufferIsEmpty then begin
//      ...protocol error, 128 bytes expected
//      raise;

//    end;
//end;

    end; // while




  end; //if
end;

procedure TForm1.EchoPortWsAccept(Sender: TObject; Addr: TInAddr;
  var Accept: Boolean);
begin
  Accept:=true;
  ApdStatusLightEchoConnected.lit:=true;
  LabelEchoConnected.Caption:='Accepted';
  fEchoPortConnected:=true;
  SignalWsConnectedThroughRTSDTR(true,Port1);
end;

procedure TForm1.BitBtnSetEchoPortClick(Sender: TObject);
var
  E    : Integer;
  Temp : Byte;
  SerialControlsColor: TColor;
begin
  EchoPort.Parity   := TParity(EchoParityGroup.ItemIndex);
  EchoPort.Databits := 8 - EchoDataBitsGroup.ItemIndex;
  EchoPort.Stopbits := EchoStopBitsGroup.ItemIndex + 1;

  case HardwareFlowGroup.ItemIndex of
    0: EchoPort.HWFlowOptions := [];
    1: EchoPort.HWFlowOptions := [hwfUseDTR, hwfRequireDSR];
    2: EchoPort.HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
  end;

  if EchoTransmitFlowBox.Checked and EchoReceiveFlowBox.Checked then
    EchoPort.SWFlowOptions := swfBoth
  else if EchoTransmitFlowBox.Checked then
    EchoPort.SWFlowOptions := swfTransmit
  else if EchoReceiveFlowBox.Checked then
    EchoPort.SWFlowOptions := swfReceive;

  Val(EchoXonCharEdit.Text, Temp, E);
  if (E = 0) then
    EchoPort.XonChar := Char(Temp);
  Val(EchoXoffCharEdit.Text, Temp, E);
  if (E = 0) then
    EchoPort.XoffChar := Char(Temp);
  EchoPort.baud:=strtoint(ComboBoxEchoBaud.text);
  ComboBoxEchoBaud.text:=inttostr(EchoPort.Baud);
  Set_Comport(EchoPort,comboboxstring(ComboBoxEchoPort));
  ApdSLControllerEcho.monitoring:=EchoPort.open;
  ComboBoxEchoPort.text:=Get_Comport(EchoPort);
  //do we need to disable the terminal until the telnet connects????
  //if ( ApdPort1.DeviceLayer=dlWinsock ) then begin
  if EchoPort.DeviceLayer=dlWinsock //grey if not a real port
    then SerialControlsColor:=clInactiveBorder
    else SerialControlsColor:=clWindow;
  //end;
  ComboBoxEchoBaud.color:=SerialControlsColor;
  //ParityGroup.color:=SerialControlsColor;
  EchoPortChanged:=false;
end;
//if echo goes on, check echo. If it goes off, uncheck echo and monitor, and close port
// if monitor goes on, open port. If it goes off, uncheck monitor, close port if both off
procedure TForm1.CheckBoxEchoOnClick(Sender: TObject); //enables echoing
begin

//  if (Sender as TCheckBox).Checked
//  then begin

    try
      //EchoPort.open:=(Sender as TCheckBox).Checked;
      EchoPort.open:= (CheckBoxEchoOn.Checked);
    except
      on E: EAlreadyOpen do
        MessageDlg('Port is already open. You must change Port'+char(13)+E.Message, mtInformation, [mbOK], 0);
    end;
//  end;
//  (Sender as TCheckBox).Checked := EchoPort.open;
    CheckBoxEchoOn.Checked := EchoPort.open;
    ApdSLControllerEcho.monitoring:=EchoPort.open;
    if not CheckBoxEchoOn.Checked  //turning it ON
      then begin
        CheckBoxEchoPortMonitoring.checked := false;
      end ;
    MenuItemEcho.Checked:=  EchoPort.open;
    MenuItemEcho.caption:= 'Echo to: '+ ComboBoxEchoPort.text;
end;
procedure TForm1.CheckBoxEchoPortMonitoringClick(Sender: TObject);
begin
    try
      //EchoPort.open:=(Sender as TCheckBox).Checked;
      EchoPort.open:= (CheckBoxEchoOn.Checked or CheckBoxEchoPortMonitoring.checked);
    except
      on E: EAlreadyOpen do
        MessageDlg('Port is already open. You must change Port'+char(13)+E.Message, mtInformation, [mbOK], 0);
    end;
    CheckBoxEchoPortMonitoring.checked:= EchoPort.open and CheckBoxEchoPortMonitoring.checked;
    ApdSLControllerEcho.monitoring:=EchoPort.open;
end;
//D3 procedure TForm1.FontDialog1Apply(Sender: TObject; Wnd: Integer);
procedure TForm1.FontDialog1Apply(Sender: TObject; Wnd: HWND);
begin
       AdTerminal1.Active:=false;
       AdTerminal1.Enabled:=false;
       //AdTerminal1.Font.Name:=FontDialog1.Font.Name;
       AdTerminal1.Font:=FontDialog1.Font;
       AdTerminal1.Enabled:=true;
       AdTerminal1.Active:=true;
end;
procedure TForm1.ButtonFontClick(Sender: TObject);
begin
   //FontDialog1.Options := FontDialog1.Options + fdApplyButton;
   //FontDialog1.Font.Name:='Terminal_Hex';
   FontDialog1.Font:=AdTerminal1.Font;
   if FontDialog1.Execute
     then begin
       FontDialog1Apply(nil,0);
    end;
end;

procedure TForm1.CheckBoxBigEndianClick(Sender: TObject);
begin
  HexEmulator.BigEndian:=CheckBoxBigEndian.Checked;
end;

procedure TForm1.CheckBoxTraceClick(Sender: TObject);
begin
  if CheckBoxTrace.Checked
    then  Port1.Tracing :=tlOn
    else  Port1.Tracing :=tlOff;
end;

procedure TForm1.CheckBoxLogClick(Sender: TObject);
begin
  if CheckBoxLog.Checked
    then  Port1.Logging :=tlOn
    else  Port1.Logging :=tlOff;
end;


procedure TForm1.ComboBoxTraceFNameChange(Sender: TObject);
begin
  ButtonChangeTraceFName.Visible:=true;
end;



procedure TForm1.ButtonOpenLPTClick(Sender: TObject);
var NT:string;
    PortResultString:string;
begin
//  messagedlg('Not available yet in Delphi 7 version. Use V1.99.34 or earlier',mtWarning,[mbOK],0);
//  exit;
  PICProg.LPTNumber:=SpinEditLPT.value;
  PicProg.Open:=true;
  //PicProg.LPTNumber:=1;
  //PicProg.OpenDriver;
  if PicProg.RunningWinNT
    then NT:='NT'
    else NT:='9x';
  PortResultString:='Win'+NT+' '+inttohex(PicProg.LPTBasePort,8);
  //buttonOpenLPT.caption:=PortResultString;
  {PicProg.Port[$378+2]:=2;}
  //PicProg.SetOpen(true);
  // PicProg.Power:=true;
  //ButtonOpenLPT.height:=40;
  if PicProg.ActiveHW and PicProg.Open and (PicProg.LPTBasePort<>0)
    then begin
      //ButtonOpenLPT.height:=40;
      ButtonResetBoth.Enabled:=true;
      ButtonReset1.Enabled:=true;
      ButtonReset2.Enabled:=true;
      SpeedButtonPower.Enabled:=true;
      GroupBoxPP.color:=clAqua;
      GroupBoxPP.Hint:=PortResultString;
      end
    else begin
      //ButtonOpenLPT.height:=15;
      GroupBoxPP.color:=clRed;
      GroupBoxPP.Hint:='Failed to open LPT'+inttostr(PicProg.LPTNumber)+' '+PortResultString;
    end;
end;

procedure TForm1.MenuItemShowClick(Sender: TObject);
begin
  MenuItemShow.checked:=not MenuItemShow.checked;
  if MenuItemShow.checked then begin
    Visible:=true;
    WindowState:=wsNormal;
    show;
    ShowWindow( Application.Handle, SW_RESTORE );
    end
  else begin
      Visible:=false;
  end;
end;

procedure TForm1.MenuItemCloseClick(Sender: TObject);
begin
  form1.close;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  //popupmenu1.Popup(0,0);
end;

procedure TForm1.MenuItemCaptureClick(Sender: TObject);
begin
  if IsCapturing//MenuItemCapture.Checked
    then begin
      CaptureAutoQuit:=false; //don't autoquit when stop button pressed
      StartCapture(cmOff);
      end
    else begin
      StartCapture(cmOn);
    end;
end;

procedure TForm1.MenuItemPortClick(Sender: TObject);
begin
  Form1.SelectTabSheet('Port');
  Form1.MenuItemShow.checked:=false;//will be inverted
  Form1.MenuItemShowClick(Sender);
end;

{
procedure UnhookAllSpies(Spy:TVicCommSpy); //used to remove all hooks
  var i:Integer;
begin
  for i:=1 to MaxComHandles do begin
    if Spy.IsHooked[i] then Spy.Unhook(i);
  end;
end;
}
procedure TForm1.SpyModeOpen(Open:boolean); //programatically enter start mode.
begin
  SpeedButtonSpy1.Down:=Open;
  SpeedButtonPort1OpenClick(nil);
end;

procedure SpyExplanationMessage;
begin
      showmessage(
         'The port (ie the other application you are trying to spy on) must be closed before you start SPY.'
         +CRLF+' You must close the other application before you stop spying.'
         +CRLF+' Once you start SPY, Realterm is unable to quit, until the other application has closed.'
         +CRLF
         +CRLF+' [Start Realterm][Press SPY] [Start Other App] [do stuff you want to spy on] [Close Other App][Stop Spy][Close Realterm]'
         +CRLF
         +CRLF+' You can try opening the port before SPY to see if it is free before starting'
         +CRLF+' Demo version is limited in how long it operates'
          );
end;
procedure TForm1.SpyOpen(State:boolean);
    begin
      if State=true
        then begin

        end
        else begin
                CommSpy1.UnhookAll;
      if CommSpy1.IsNoneCommHooked
        then CommSpy1.Opened:=false
        else begin
          ShowMessage('You must close the comport before you will be able to exit Realterm or reconnect the spy'
             +CRLF+'(ie close the application you are spying on)');
          sleep(0);
//          CommSpy1.Opened:=false;
        end;
        end;//if
    end;

const FirstComportNumber=1; //for windows not unix

function TForm1.SpyDriversInstalled:boolean; //detect an install of the driver, using the Realterm driver installer.
// Just using dirty directory detection, so I don't waste too much time on it.
begin
  result:=DirectoryExists('C:\Program Files\BEL\Realterm\SpyDrivers'); //xp32 default
  result:=result or DirectoryExists('C:\Program Files64\BEL\Realterm\SpyDrivers'); //I think this is for vista
  result:=result or DirectoryExists(JustPathNameL(Application.ExeName)+'\SpyDrivers'); //and try where the exe is
  //showmessage(JustPathNameL(Application.ExeName)+'\SpyDrivers');
end;

procedure TForm1.SpeedButtonPort1OpenClick(Sender: TObject);
  var ComNumber:integer;
begin
   if not NoNagAboutSpy and SpeedButtonSpy1.Down
     then begin
       //SpyNagDlg:=TOKBottomdlg.Create;
       SpyNagDlg.ShowModal;
       //SpyNagDlg.Destroy;
       NoNagAboutSpy:=true;
     end;
  if not SpeedButtonPort1Open.Down
    then begin //button up
      Port1.open:=false;
      AdTerminal1.Enabled:=true; //so that scrollback still works when port is closed?
    end;
  if not SpeedButtonSpy1.Down
    then begin  //un-spy
      //SpeedButtonSpy1.Down:=false;
      SpeedButtonSpy1Click(nil);
      //CommSpy1.opened:=true;
      SpyOpen(false);
{      CommSpy1.UnhookAll;
      if CommSpy1.IsNoneCommHooked
        then CommSpy1.Opened:=false
        else begin
          ShowMessage('You must close the comport before you will be able to exit Realterm or reconnect the spy'
             +CRLF+'(ie close the application you are spying on)');
          sleep(0);
//          CommSpy1.Opened:=false;
        end; }
    end;
  //Perhaps should try to unload driver always here, even though it will stall


  if SpeedButtonPort1Open.Down
    then begin
      BitBtnSetPortClick(nil);
      if (Port1.DeviceLayer=dlWinsock) and (Port1.WsMode=wsClient)
        then Port1.Open:=false; //attempt to force a reconnect - ugly kludge
    try
      Port1.open:=true;
    except
      on E: EAlreadyOpen do begin
        MessageDlg('Port is already open. You must change Port'+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;
      on E: eBadId do begin
        MessageDlg('BadID, Probably PORT does not exist'+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;
      on E: eBaudRate do begin
        MessageDlg('BaudRate Error, Probably an impossible baudrate'+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;
      on E: EOpenComm do begin
        MessageDlg('Error Opening Comm, '+char(13)+E.Message, mtInformation, [mbOK], 0);
        Port1.open:=false;
        end;
      end;
     end;
  if Port1.Open then begin
    AdTerminal1.enabled:=true;
    ApdSLController1.monitoring:=true;
  end;

  SpeedButtonPort1Open.Down:=Port1.Open;

  if SpeedButtonSpy1.Down
    then begin  //spy
      ComNumber:=GetPhysicalComNumber(ComboBoxComPort.text);
      if  ComNumber>=FirstComportNumber
        then begin //valid comport so try to hook
          CommSpy1.opened:=true; //open it
          if not CommSpy1.Opened then showmessage('Failed to open ComSpy. Probably drivers are not installed');
          if not CommSpy1.IsHooked[ComNumber] then CommSpy1.hook(ComNumber);
          if CommSpy1.IsHooked[ComNumber]
             then begin  //success
               SpeedButtonSpy1.Down:=true;
               end
             else begin //failure
               SpeedButtonSpy1.Down:=false;
               SpyExplanationMessage;
             end;
          end
        else begin //not a comport so don't try to hook
          SpeedButtonSpy1.Down:=false;
          CommSpy1.UnhookAll;
        end;
    end;
  SetPortAndBaudCaptions;
//  if not (SpeedButtonPort1Open.Down or SpeedButtonSpy1.Down)
//    then AdTerminal1.
end;

procedure TForm1.Hide1Click(Sender: TObject);
begin
  Form1.visible:=false
end;
procedure TForm1.PositionFloatingButtons;
begin
  PanelFloatingButtons.Left:=PageControl1.Width-PanelFloatingButtons.Width-10;
  PanelFloatingButtons.Top:=PageControl1.Top+1;
  GroupBoxStatus.Left:=PageControl1.Width-GroupBoxStatus.Width-10;
  GroupBoxStatus.Top:=PageControl1.Top+TabSheetDisplay.Top;

end;
procedure TForm1.FormResize(Sender: TObject);
var NumRows, CharHeight:integer;
begin
//  PositionFloatingButtons;

{  try
    NumRows:=SpinEditTerminalRows.Value;
   except //catches non numeric values
    on EConvertError do exit;
  end;
  if not (NumRows>=2) then exit; //validate

  AdTerminal1.Rows:=SpinEditTerminalRows.Value;
  CharHeight:=AdTerminal1.GetTotalCharHeight;
  AdTerminal1.Height:=CharHeight*AdTerminal1.Rows+9;
}  if PageControl1.Visible
    then begin
      AdTerminal1.Height:=Form1.ClientHeight -PageControl1.Height -StatusBar1.Height;
      StatusBar1.Align:=alBottom;
      PositionFloatingButtons;
      end
    else begin
      AdTerminal1.Height:=Form1.ClientHeight - StatusBar1.Height
    end;
end;

procedure TForm1.EchoPortWsDisconnect(Sender: TObject);
const AlreadyTryingToClosePort:boolean=false;
begin
  if AlreadyTryingToClosePort then exit; //kludge as closing port calls this
  ApdStatusLightEchoConnected.lit:=false;
  LabelEchoConnected.Caption:='Disconnect';
  fEchoPortConnected:=false;
  SignalWsConnectedThroughRTSDTR(false,Port1);
  if (EchoPort.wsMode=wsClient) and (EchoPort.DeviceLayer=dlWinsock) and EchoPort.Open //not if a server
    then begin
      AlreadyTryingToClosePort:=true;
//      EchoPort.Open:=false; //force the port to close, since they don't reconnect anyway
      CheckBoxEchoOn.checked:=false;
    end;
   AlreadyTryingToClosePort:=false;
end;

//uses DTR or RTS to signal state of the winsock connection through the comport pins of the echoing serial port
procedure TForm1.SignalWsConnectedThroughRTSDTR(Connected:boolean; OtherPort:TApdWinsockPort);
begin
  if CheckboxEchoOn.checked and OtherPort.open and (OtherPort.DeviceLayer<>dlWinsock)
    then begin
      if (CheckBoxSignalWsWithDTR.checked)
        then begin
          OtherPort.DTR:=Connected;
        end;
      if (CheckBoxSignalWsWithRTS.checked)
        then begin
          OtherPort.RTS:=Connected;
        end;
  end;
end;

procedure TForm1.EchoPortWsConnect(Sender: TObject);
begin
  ApdStatusLightEchoConnected.lit:=true;
  LabelEchoConnected.Caption:='Connected';
  fEchoPortConnected:=true;
  SignalWsConnectedThroughRTSDTR(true,Port1);
end;


procedure TForm1.MenuItemEchoClick(Sender: TObject);
begin
  CheckBoxEchoOn.checked:= not CheckBoxEchoOn.checked;
  CheckBoxEchoOnClick(nil);
end;

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  if (SendFileCounter=0)
      or( (SendFileCounter>=cardinal(SpinEditFileSendRepeats.value))
           and (SpinEditFileSendRepeats.value<>0)
         )
    then begin //end of transmit
      case ErrorCode of
        0: LabelProtocolError.Caption:='Done';
        -6005:LabelProtocolError.Caption:='Stopped';
        else LabelProtocolError.Caption:='Error '+inttostr(ErrorCode);
      end; //case
      GroupBoxSendFile.color:=clBtnFace;
      LabelRepeats.Caption:='&Repeats';
      if SendFileAutoquit then begin
        if CaptureMode<>cmoff then begin
          sleep(500); //snooze for a bit for capture to complete
          StopCapture;
        end;
        Form1.Close;
      end;
      IsSendingFile:=false;
    end
    else begin  //there is another repeat to do
      SendFileCounter:=SendFileCounter+1;
      if SpinEditFileSendDelay.Value<50
        then begin  //short delays just use sleep
          sleep(SpinEditFileSendDelay.Value);
          TimerSendFileTimer(nil); //starts
          end
        else begin  //longer delays use the timer
          TimerSendFile.Interval:=SpinEditFileSendDelay.Value;
          TimerSendFile.Enabled:=true;
          LabelProtocolError.Caption:='Pause '+inttostr(SpinEditFileSendDelay.Value)+'ms #'+inttostr(SendFileCounter);
        end; //if
    end;
end;
procedure TForm1.TimerSendFileTimer(Sender: TObject);
begin
      //LabelProtocolError.Caption:='# '+inttostr(SendFileCounter);
      ApdProtocol1.StartTransmit;
      if ApdProtocol1.InProgress
        then LabelProtocolError.Caption:='Sending #'+inttostr(SendFileCounter)//InProgress'
        else LabelProtocolError.Caption:='Error: Not InProgress when expected';
      TimerSendFile.Enabled:=false; //timer is a 1 shot delay
end;
procedure TForm1.TimerCallbackTimer(Sender: TObject);
begin
  RTI.SendEventOnTimer;
end;
procedure TForm1.ApdProtocol1ProtocolStatus(CP: TObject; Options: Word);
begin
  ProgressBarSendFile.Position:=ApdProtocol1.BytesTransferred;
end;

procedure TForm1.HideControls1Click(Sender: TObject);
begin
  HideControls1.Checked:= not HideControls1.Checked;
  PageControl1.Visible:=not HideControls1.Checked;
  GroupBoxStatus.Visible:=not HideControls1.Checked;
//  ButtonFreeze.Visible:= not HideControls1.Checked;
  PanelFloatingButtons.Visible:= not HideControls1.Checked;
  if HideControls1.Checked
    then begin
      //Form1.ClientHeight-
      SpinEditTerminalRows.Value:=43;
      SpinEditTerminalRowsChange(nil);
      //AdTerminal1.Rows:=43;//AdTerminal1.PageHeight:=43;
      //AdTerminal1.DisplayRows:=AdTerminal1.PageHeight;
      //AdTerminal1.Align:=alClient;
    end
    else begin
      SpinEditTerminalRows.Value:=16;
      SpinEditTerminalRowsChange(nil);

//      AdTerminal1.Rows:=16;//AdTerminal1.PageHeight:=16;
      //AdTerminal1.DisplayRows:=AdTerminal1.PageHeight;
//      AdTerminal1.Align:=alTop;
    end;
    //ApdTermianl1.Resize;
end;

procedure TForm1.SpinEditAsciiCharDelayChange(Sender: TObject);
begin
  ApdProtocol1.AsciiCharDelay:=SpineditAsciiCharDelay.value;
end;

procedure TForm1.SpinEditAsciiLineDelayChange(Sender: TObject);
begin
  ApdProtocol1.AsciiLineDelay:=SpineditAsciiLineDelay.value;
end;



procedure TForm1.ButtonClearClick(Sender: TObject);
begin
  AdTerminal1.Clear;
  AdTerminal1.Emulator.Buffer.SetCursorPosition(1,1);
  CharCount:=0;
  ShowSerialStatus(true);
  if AdTerminal1.Enabled
    then ActiveControl:=AdTerminal1;
  HexEmulator.SyncCount:=0;
end;
procedure TForm1.SpinEditTerminalColsChange(Sender: TObject);
  var NumCols : integer;
begin

  try
    NumCols:=SpinEditTerminalCols.Value;
   except //catches non numeric values
    on EConvertError do exit;
  end;
  if not (NumCols>=2) then NumCols:=2; //validate

  AdTerminal1.Columns:=NumCols;
  SpinEditTerminalCols.Value:=AdTerminal1.Columns;
  //possibly we shoudl be calling optimise here to get best width, rather than user selected width
end;

procedure TForm1.SpinEditTerminalRowsChange(Sender: TObject);
var NumRows, CharHeight:integer;
begin
  try
    NumRows:=SpinEditTerminalRows.Value;
   except //catches non numeric values
    on EConvertError do exit;
  end;
  if not (NumRows>=2) then exit; //validate

  AdTerminal1.Rows:=SpinEditTerminalRows.Value;
  CharHeight:=AdTerminal1.GetTotalCharHeight;
  AdTerminal1.Height:=CharHeight*AdTerminal1.Rows+9;
  if PageControl1.Visible
    then begin
      Form1.ClientHeight:=AdTerminal1.Height +PageControl1.Height+StatusBar1.Height;
      StatusBar1.Align:=alBottom;
      PositionFloatingButtons;
      end
    else begin
      Form1.ClientHeight:=AdTerminal1.Height +StatusBar1.Height;
    end;
   {if Sender=nil then} //Form1.Resize;
  //Form1.ClientHeight:=Form1.Height+1;
end;

procedure TForm1.AdTerminal1Click(Sender: TObject);
begin
  PageControl1.Hint:='Ctrl+Tab to step through tab sheets'; //override 1st hint
end;


procedure TForm1.RadioGroupBusNumClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  //ComboBoxBusNum.text:=ComboBoxBusNum.Items[RadioGroupBusNum.ItemIndex+1];
  SendAsciiString('G'+inttohex(RadioGroupBusNum.ItemIndex+1,1),false,false,true);
end;
procedure TForm1.SetHalfDuplex(State:boolean);
begin
  if (State and (not CheckBoxHalfDuplex.checked)) then CheckBoxHalfDuplex.checked:=true;
  if ((not State) and CheckBoxHalfDuplex.checked) then CheckBoxHalfDuplex.checked:=false;
end;

procedure TForm1.ButtonIStartClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  //I2CBusy:=true;
  SendString('S');
end;

procedure TForm1.ButtonIStopClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendString('P');
  //I2CBusy:=false;
end;
{procedure TForm1.IChipAddress(Address:word; Name:string);
begin
  Address:=Address  and $FFFE; //in case given as read
  if GetI2CAddress(false)=Address then return; //not change so do nothing....

  Form1.ComboboxIAddress.text:=Name+' '+str2hex(Address,4); //put in the combobox
  ComboBoxPutStringAtTop(Form1.ComboboxIAddress,100);

end   }

function GetI2CAddress(IncludeSubAddress:boolean):word;
var BaseAddress,SubAddress,WC:word;
    DeviceAddressStr,Delims: string;
begin
  SubAddress:=2*Form1.SpinEditISubAddress.value;
  Delims:=' :,;';
  WC:=WordCountS(Form1.ComboboxIAddress.text,Delims);
  DeviceAddressStr:=ExtractWordS(WC,Form1.ComboboxIAddress.text,Delims);
  if str2wordl(DeviceAddressStr,BaseAddress)
  //if str2wordl(Form1.EditIAddress.text,BaseAddress)
    then begin
      ComboBoxPutStringAtTop(Form1.ComboboxIAddress,100);
      if (BaseAddress and 1)>0 //force to be 0 in write bit
        then begin
        BaseAddress:=BaseAddress and $FFFE;
        //Form1.EditIAddress.text:='0x'+inttohex(BaseAddress,2);
      end;
      result:=BaseAddress;
      if IncludeSubAddress then result:=BaseAddress+SubAddress;
    end
    else begin
       //Form1.EditIAddress.text:='0x00';
       result:=0;
    end;
    Form1.GroupboxIaddress.Caption:= 'Address:'+'0x'+inttohex(result,2);
end;
procedure TForm1.IRead(BytesToRead:byte);
  var Address:word;
begin
  SetHalfDuplex(true);
  Address:=GetI2CAddress(true);
  Address:=Address or 1;  //force read
  SendString('S'+inttohex(Address,2)+inttohex(BytesToRead,2)+'P');
end;
procedure TForm1.ButtonIReadClick(Sender: TObject);
  //var Address:word;

begin
  //SetHalfDuplex(true);
  //Address:=GetI2CAddress;
  //Address:=Address or 1;
  IRead(SpinEditIBytes2Read.value);
end;
{procedure ICheckAddress(BaseAddress:word; Name:string); //checks that address has been set for this type of chip...
begin
  if GetI2CAddress(false)<>BaseAddress
    then begin
       //prompt

       ComboBoxIAddress.text:=Name+' 0x'+inttohex(BaseAddress,2); //make it the combobox value

    end;
end; }

procedure TForm1.IWrite(S:string);
  var Address:word;
begin
  SetHalfDuplex(true);
  Address:=GetI2CAddress(true);
  Address:=Address and (not 1);
  SendAsciiString('S'+inttohex(Address,2)+uppercase(S)+'P',false,false,true);
end;

procedure TForm1.ButtonIWriteClick(Sender: TObject);
//  var Address:word;
begin
//  SetHalfDuplex(true);
//  Address:=GetI2CAddress;
//  Address:=Address and (not 1);
//  SendAsciiString('S'+inttohex(Address,2)+uppercase(EditIData2Write.text)+'P',false,false,true);
  IWrite(EditIData2Write.text);
end;
procedure TForm1.IWriteThenRead(WriteData:string;BytesToRead:byte);
var Address:byte;
begin
  SetHalfDuplex(true);
  Address:=GetI2CAddress(true);
  Address:=Address and $FE;
  SendString('S'+inttohex(Address,2)+WriteData +'R'+inttohex(BytesToRead,2)+'P');
end;

procedure TForm1.ButtonIRead1WireIDClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendAsciiString(':S33R08',false,true,true);
end;

procedure TForm1.ButtonIGetStatusClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendString('?');
end;


procedure TForm1.ButtonIQueryPinsClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendString('Q');
end;

procedure TForm1.ButtonNewLineClick(Sender: TObject);
begin
//    AdTerminal1.Emulator.Buffer.DoLineFeed;
//    AdTerminal1.Emulator.Buffer.DoCarriageReturn;
    TerminalNewLine;
    ActiveControl:=AdTerminal1;
end;
procedure TForm1.TerminalNewLine;
begin
    AdTerminal1.Emulator.Buffer.DoLineFeed;
    AdTerminal1.Emulator.Buffer.DoCarriageReturn;
end;

procedure TForm1.CheckBoxNewLineClick(Sender: TObject);
begin
  //Note that this must be duplicated in the change emulator routine
  AdTerminal1.Emulator.Buffer.UseNewLineMode:=CheckBoxNewLine.checked;
end;


procedure TForm1.SpinEditFileSendRepeatsChange(Sender: TObject);
begin
  SpinEditFileSendDelay.enabled:= not(SpinEditFileSendRepeats.value=1);
end;

//D3 procedure TForm1.StWMDataCopy1DataReceived(Sender: TObject;
//  CopyData: TCopyDataStruct);
procedure TForm1.StWMDataCopy1DataReceived(Sender: TObject;
  CopyData: tagCOPYDATASTRUCT);
var
  S : string;
begin
  S := String(PChar(CopyData.lpData));
  ParameterRemote.Execute_Line(S);
  if Port1Changed then BitBtnSetPortClick(nil);
  if EchoPortChanged then BitBtnSetEchoPortClick(nil);

end;

procedure TForm1.TrayIcon1RightClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MenuItemShowClick(Sender);
end;




procedure TForm1.ApdProtocol1ProtocolError(CP: TObject;
  ErrorCode: Integer);
begin
  LabelProtocolError.Caption:='Error';
end;

procedure TForm1.ButtonSMBusAlertClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendString('S1901P');
end;

procedure TForm1.ButtonI2CGCAResetClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendString('S0006'+'P');
end;

procedure TForm1.ButtonI2CSend2M5451D4Click(Sender: TObject);
  const FirstTime:boolean=true;
  var S:string;
begin
    SetHalfDuplex(true);
    if FirstTime then begin
      ButtonM5451ClearClick(Sender);
      //SendString('Y W000000000000 '); //send 6 bytes of zeros to ensure sync the first time
      FirstTime:=false;
    end;
    S:=EditI2CDigits.Text;
    if CheckBoxI2CM5451_Color.Checked  then S:=S+'.';
    SendAsciiString('Y101 '+ Str2M5451D4(S),false,true,false);
end;

procedure TForm1.ButtonGPIBCtrlCClick(Sender: TObject);
  var EntryFlowOptions: THWFlowOptionSet;
      C:char;
begin
  EntryFlowOptions:=Port1.HWFlowOptions;
  Port1.HWFlowOptions:=[]; //now flow control so it WILL be sent
  C:= char(3);
  Port1.PutChar(C); //^C
  if CheckBoxHalfDuplex.checked then AdTerminal1.WriteString(C);
  Port1.HWFlowOptions:=EntryFlowOptions; //restore
end;

procedure TForm1.ButtonGPIBSetupClick(Sender: TObject);
begin
  ComboBoxBaud.text:='9600';
  HardwareFlowGroup.ItemIndex:=1; //DTR/DSR
  ParityGroup.ItemIndex:=0; //none
  DataBitsGroup.ItemIndex:=0; //8 bit
  BitBtnSetPortClick(nil);
  
  CheckBoxHalfDuplex.Checked:=true;
  CheckBoxNewLine.Checked:=true;

  CheckBoxLF1.Checked:=true;
  CheckBoxLF2.Checked:=true;
  CheckBoxCR1.Checked:=false;
  CheckBoxCR2.Checked:=false;

  SpinEditNumTimesToSend.value:=1;
end;

procedure TForm1.ButtonGPIBRSTClick(Sender: TObject);
begin
  SendAsciiString('*RST',False,True,false);
end;

procedure TForm1.ButtonGPIBIDNClick(Sender: TObject);
begin
  SendAsciiString('*IDN?',False,True,false);
end;

procedure TForm1.ButtonGPIBTSTClick(Sender: TObject);
begin
  SendAsciiString('*TST?',False,True,false);
end;

procedure TForm1.ButtonGPIBERRClick(Sender: TObject);
begin
  SendAsciiString('SYST:ERR?',False,True,false);
end;

procedure TForm1.ButtonSend0Click(Sender: TObject);
begin
  Port1PutChar(chr(0));
end;

procedure TForm1.ButtonSend3Click(Sender: TObject);
begin
  Port1PutChar(chr(3));
end;

procedure TForm1.EditSendNumericChange(Sender: TObject);
  var S:string;
      L:integer;
  procedure PutValidString;
  begin
    if ( NumericStringToChars(S) ) then begin
      Port1PutString(S);
    end;
  end; //PutValidString
begin
  S:=EditSendNumeric.text;
  L:=length(S);
  if (L>1) then begin //when a space is typed....
    case ( S[L] ) of
      ' ',',': begin
             PutValidString;
             EditSendNumeric.text:=''; //clear last value out
           end;
 {     '$': begin
             S:=copy(S,1,L-1); //remove trailing $
             PutValidString;
             EditSendNumeric.text:='$'; //clear last value out
            end;
 }     else ; //wait for more chars
    end;

  end;
end;
procedure TForm1.SendCannedString(Index:integer); //index is 0 based
begin
  if (Index<=CannedStrings.count) 
    then begin
      Port1PutString(CannedStrings[Index]);
    end;
end; //SendCannedString

procedure TForm1.MenuItemSendStringClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    SendCannedString(Tag);
end;

procedure TForm1.SpeedButtonSpy1Click(Sender: TObject);
begin
  if SpeedButtonSpy1.Down
    then begin //try to spy
//      if SpeedButtonPort1Open.Down then begin
//        SpeedButtonPort1Open.Down:=false;
//        SpeedButtonPort1OpenClick(nil);
//      end;
//      VicCommSpy1.hook(1);

//      BitBtnSetPortClick(nil);
//      if (Port1.DeviceLayer=dlWinsock) and (Port1.WsMode=wsClient)
//        then Port1.Open:=false; //attempt to force a reconnect - ugly kludge
//      Port1.Open:=true;
      end
    else begin //button open port for spying
//      VicCommSpy1.unhook(1);
//      Port1.open:=false; //close port

//      end;
//  if Port1.Open then begin
//    AdTerminal1.enabled:=true;
//    ApdSLController1.monitoring:=true;
  end;
//  SpeedButtonSpy1.Down:=VicCommSpy1.IsHooked[1];
end;
{
procedure TForm1.VicCommSpy1Received(ComNumber: Byte; sValue: String);
//  var SaveColor:TColor;
begin
//  SaveColor:=Color4WriteChar;
  Color4WriteChar:=Color4SpyRx;
//  sleep(0);
  AdTerminal1.WriteString(sValue);
//  sleep(0);
  //Color4WriteChar:=SaveColor;
end;

procedure TForm1.VicCommSpy1Sent(ComNumber: Byte; sValue: String);
//  var SaveColor:TColor;
begin
//  SaveColor:=Color4WriteChar;
  Color4WriteChar:=Color4SpyTx;
//  sleep(0);
  AdTerminal1.WriteString(sValue);
//  sleep(0);
  //Color4WriteChar:=SaveColor;
end;
}
procedure TForm1.MenuItemCopyTerminalClick(Sender: TObject);
begin
  AdTerminal1.CopyToClipboard;
end;

procedure TForm1.MenuItemPasteTerminalClick(Sender: TObject);
begin
  AdTerminal1.PasteFromClipboard;
end;

procedure TForm1.ButtonIWrite00Click(Sender: TObject);
begin
  //IWrite('00');
  EditIData2Write.text:=EditIData2Write.text+'00 ';
end;

procedure TForm1.ButtonIWriteFFClick(Sender: TObject);
begin
  //IWrite('FF');
  EditIData2Write.text:=EditIData2Write.text+'FF ';
end;

procedure TForm1.ButtonM5451ClearClick(Sender: TObject);
begin
  SetHalfDuplex(true);
//  SendString('Y W0000000000 Y101 0000000000 '); //send 6 bytes of zeros to ensure sync, then send zeros
  SendString(ClearM5451D4Str);
end;


procedure TForm1.ButtonIWAsciiClick(Sender: TObject);
var S:string;
begin
//  EditIData2Write.text:=EditIData2Write.text+IAscii2Hex(EditIWAscii.Text, CheckboxIWCompactAscii.checked)+' ';
  S:=ComboBoxConvertString(ComboboxIWAscii,false,CheckboxIWAsciiLiteral.checked);
  S:=IAscii2Hex(S, CheckboxIWCompactAscii.checked);
  EditIData2Write.text:=EditIData2Write.text+S+' ';

end;

procedure TForm1.ButtonIWClearClick(Sender: TObject);
begin
  EditIData2Write.text:='';
end;

procedure TForm1.ButtonIWByteClick(Sender: TObject);
var value:byte;
begin
  value:=byte(strtoint(StExpressionEditIW.text));
  EditIData2Write.text:=EditIData2Write.text+inttohex(value,2)+' ';
  StExpressionEditIW.text:=inttostr(value);
end;

procedure TForm1.ButtonIWWordBEClick(Sender: TObject);
var value:integer;
begin
  value:=word(strtoint(StExpressionEditIW.text));
  EditIData2Write.text:=EditIData2Write.text+inttohex(value,4)+' ';
  StExpressionEditIW.text:=inttostr(value);
end;

procedure TForm1.ButtonIWWordLEClick(Sender: TObject);
var value:integer;
    S:shortstring;
begin
  value:=word(strtoint(StExpressionEditIW.text));
  S:=inttohex(value,4);
  EditIData2Write.text:=EditIData2Write.text+S[3]+S[4]+S[1]+S[2]+' ';
  StExpressionEditIW.text:=inttostr(value);
end;

function TForm1.IWBitValue:byte;
begin
  result:=0;
  if SpeedButtonIWBit7.Down then result:=result+128 ;
  if SpeedButtonIWBit6.Down then result:=result+64 ;
  if SpeedButtonIWBit5.Down then result:=result+32 ;
  if SpeedButtonIWBit4.Down then result:=result+16 ;

  if SpeedButtonIWBit3.Down then result:=result+8 ;
  if SpeedButtonIWBit2.Down then result:=result+4 ;
  if SpeedButtonIWBit1.Down then result:=result+2 ;
  if SpeedButtonIWBit0.Down then result:=result+1 ;
end;

procedure TForm1.ButtonIWBitClearClick(Sender: TObject);
  var NewState:boolean;

begin
  NewState:= (IWBitValue=0);
  SpeedButtonIWBit7.Down:=NewState;
  SpeedButtonIWBit6.Down:=NewState;
  SpeedButtonIWBit5.Down:=NewState;
  SpeedButtonIWBit4.Down:=NewState;

  SpeedButtonIWBit3.Down:=NewState;
  SpeedButtonIWBit2.Down:=NewState;
  SpeedButtonIWBit1.Down:=NewState;
  SpeedButtonIWBit0.Down:=NewState;

end;

procedure TForm1.ButtonIWBitClick(Sender: TObject);
  var value:byte;
begin
  value:=IWBitValue;
  EditIData2Write.text:=EditIData2Write.text+inttohex(value,2)+' ';
  StExpressionEditIW.text:=inttostr(value);
end;

procedure TForm1.ButtonIWNotBitClick(Sender: TObject);
  var value:byte;
begin
  value:=255 xor IWBitValue;
  EditIData2Write.text:=EditIData2Write.text+inttohex(value,2)+' ';
  StExpressionEditIW.text:=inttostr(value);
end;
procedure RadioGroupTelnetClick(RadioGroupWsTelnet:TRadioGroup; Port: TApdWinsockPort);
  var wstold,wstnew:boolean;
begin

  wstold:= Port.WsTelnet;
  wstnew:=(RadioGroupWsTelnet.ItemIndex=1);
  Port.WsTelnet:=wstnew;
  if (Port.DeviceLayer=dlWinsock) and (Port.Open) and (wstold<>wstnew)
    then begin
      messageDlg('You need to close and reopen the port for the change to happen',
                mtWarning,[mbOK],0);
    end;
end;

procedure TForm1.RadioGroupWsTelnetClick(Sender: TObject);
begin
  RadioGroupTelnetClick(TRadioGroup(Sender),Port1);
end;
procedure TForm1.RadioGroupEchoWsTelnetClick(Sender: TObject);
begin
  RadioGroupTelnetClick(TRadioGroup(Sender),EchoPort);
end;


procedure TForm1.ComboBoxComPortDblClick(Sender: TObject);
begin
  //FormScanPorts.Show;  //not needed if using registry....
  PopulateComNumbers(PortScanLastPort,true);
  ComboBoxComPort.DroppedDown:=true;
end;



procedure TForm1.CommSpy1Received(CommIndex: Byte; Data: String;
  Info: Cardinal);
begin
  Color4WriteChar:=Color4SpyRx;
  AdTerminal1.WriteStringSource(Data,csPort);
end;

procedure TForm1.CommSpy1Sent(CommIndex: Byte; Data: String;
  Info: Cardinal);
begin
  Color4WriteChar:=Color4SpyTx;
  AdTerminal1.WriteStringSource(Data,csKeyboard);
end;


procedure TForm1.CheckboxScrollbackClick(Sender: TObject);
begin
  AdTerminal1.Scrollback:=CheckboxScrollback.checked;
  SpinEditScrollbackRows.Visible:=CheckboxScrollback.checked;
  if CheckboxScrollback.checked then begin
    SpinEditScrollbackRows.value:=AdTerminal1.ScrollbackRows;
    //AdTerminal1.ScrollbackRows:=SpinEditScrollbackRows.value;
  end;
end;

{procedure TForm1.LabelI2CChipClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
  'http://www.i2cchip.com',nil,nil, SW_SHOWNORMAL);
end;}
procedure TForm1.LabelHTMLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar((Sender as TLabel).Caption),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.Help1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
  'http://realterm.sourceforge.net',nil,nil, SW_SHOWNORMAL);
  ShellExecute(Handle, 'open',
  'http://realterm.sourceforge.net/rss.xml',nil,nil, SW_SHOWNORMAL);
  //writeln('F1 is the help key');
  ShellExecute(Handle, 'open',
  'file://C:\Program Files\BEL\Realterm\change_log.txt',nil,nil, SW_SHOWNORMAL);

  AboutBox.showmodal;
end;


procedure TForm1.SHT(S:string);
  const FirstTime:boolean=true;
begin
    if FirstTime then begin
       SetHalfDuplex(true);
    end;
    if FirstTime or (S='')
      then begin
        SendAsciiString('PY1WFFFFP',false,true,false); //send the clear string
    end;
    FirstTime:=false;
    SendAsciiString(S,false,true,false);
end;
function SHTStr(command,delay,WriteData:string;NRead:cardinal):string;
  var PreambleStr,CRCStr,WrAckStr:string;
begin
  case (1+Form1.RadioGroupBusNum.ItemIndex) of
  1,5: PreambleStr:= 'O00FD00FC00FD00FF00FE00FC';
  2,6: PreambleStr:= 'O 00F7 00F3 00F7 00FF 00FB 00F3';
  3,7: PreambleStr:= 'O 007F 003F 007F 00FF 00BF 003F';
  else showmessage('Preamble string only done for Bus1-3. Using Bus 1 string...')
  end; //case

  if Form1.CheckBoxSHTCRC.Checked
    then CRCStr:='YR01Y1W00'
    else CRCStr:='';
  if Form1.CheckboxSHTWrHideAck.Checked
    then WrAckStr:='Y1W01'
    else WrAckStr:='Y1R01';

  result:=PreambleStr+'YW'+command+WrAckStr;
  
  if Writedata<>''
    then result:=result+'YW'+WriteData+WrAckStr;

  case NRead of
    0: ;
    1: result:=result+'L'+delay+CRCStr+'YR01Y1WFF';
    2: result:=result+'L'+delay+'YR01Y1W00'+CRCStr+'YR01Y1WFF';
    else 
      result:='??????????????????';
  end; //case

  result:=result+'P';
  //result:=PreambleStr+'YW'+command+'Y1R01L'+delay+'YR01Y1W00'+CRCStr+'YR01Y1WFFP';
end;

procedure TForm1.ButtonSHTClearClick(Sender: TObject);
begin
  SHT('');
end;

procedure TForm1.ButtonSHTReadTempClick(Sender: TObject);
begin
    SHT(SHTStr('03','0100','',2));
end;
procedure TForm1.ButtonSHTReadHumidityClick(Sender: TObject);
begin
  //SHT(SHTPreambleStr+'YW05Y1R01L0050YR01Y1W00YR01Y1WFFP');
  SHT(SHTStr('05','0050','',2));

end;

procedure TForm1.ButtonSHTReadStatusClick(Sender: TObject);
begin
  SHT(SHTStr('07','0100','',1));
end;

procedure TForm1.ButtonSHTSoftResetClick(Sender: TObject);
begin
  SHT(SHTStr('1E','0100','',0));
end;

procedure TForm1.ButtonSHTWriteStatusClick(Sender: TObject);
begin
  SHT(SHTStr('06','0000',EditSHTStatus.Text,0));
end;

procedure TForm1.CheckBoxTraceHexClick(Sender: TObject);
begin
  Port1.TraceHex:=CheckboxTraceHex.Checked;
end;

procedure TForm1.CheckBoxLogHexClick(Sender: TObject);
begin
  Port1.LogHex:=CheckboxLogHex.Checked;
end;

procedure TForm1.ButtonIWriteThenReadClick(Sender: TObject);
//var Address:byte;
begin
  IWriteThenRead(LabeledEditIWriteB4Data.Text,SpinEditIBytes2Read2.value);
{  SetHalfDuplex(true);
  Address:=GetI2CAddress;
  Address:=Address and $FE;
  SendString('S'+inttohex(Address,2)+LabeledEditIWriteB4Data.Text +'R'+inttohex(SpinEditIBytes2Read.value,2)+'P');
}
end;

procedure TForm1.SpeedButtonBL301ClearLedButtonsClick(Sender: TObject);
  var NewState:boolean;
begin
  NewState:= (BL301LedBitValue=0);
  SpeedButtonBL301Leds7.Down:=NewState;
  SpeedButtonBL301Leds6.Down:=NewState;
  SpeedButtonBL301Leds5.Down:=NewState;
  SpeedButtonBL301Leds4.Down:=NewState;

  SpeedButtonBL301Leds3.Down:=NewState;
  SpeedButtonBL301Leds2.Down:=NewState;
  SpeedButtonBL301Leds1.Down:=NewState;
  SpeedButtonBL301Leds0.Down:=NewState;

end;
function TForm1.BL301LEDBitValue:byte;
begin
  result:=0;
  if SpeedButtonBL301Leds7.Down then result:=result+128 ;
  if SpeedButtonBL301Leds6.Down then result:=result+64 ;
  if SpeedButtonBL301Leds5.Down then result:=result+32 ;
  if SpeedButtonBL301Leds4.Down then result:=result+16 ;

  if SpeedButtonBL301Leds3.Down then result:=result+8 ;
  if SpeedButtonBL301Leds2.Down then result:=result+4 ;
  if SpeedButtonBL301Leds1.Down then result:=result+2 ;
  if SpeedButtonBL301Leds0.Down then result:=result+1 ;
end;
procedure TForm1.ButtonBL301WriteAscii2LCDClick(Sender: TObject);
 var S:string;
begin
  S:=ComboBoxConvertString(ComboboxBL301Ascii,false,CheckboxBL301AsciiLiteral.checked);
  S:=IAscii2Hex(S, false);
  IWrite(S);
end;

procedure TForm1.ButtonBL301InitLCDClick(Sender: TObject);
begin
  IWrite('C0');
end;



procedure TForm1.ButtonBL301SetContrastClick(Sender: TObject);
begin
    IWrite('F0'+inttohex(SpinEditBL301Contrast.Value,2));
end;

procedure TForm1.ButtonBL301SetLedsClick(Sender: TObject);
begin
  IWrite('F2'+inttohex(BL301LEDBitValue,2));
end;

procedure TForm1.ButtonBL301ReadSwitchesClick(Sender: TObject);
begin
  IWriteThenRead('F1',1);
end;
procedure TForm1.ButtonBL301MInitClick(Sender: TObject);
begin
  IWrite('D0');
end;
procedure TForm1.ButtonBL301MAsciiClick(Sender: TObject);
 var S:string;
begin
  S:=ComboBoxConvertString(ComboboxBL301MString,false,CheckboxBL301AsciiLiteral.checked);
  S:=IAscii2Hex(S, false);
  IWrite('E'+inttohex(SpinEditBL301MNumDisplay.Value,1)+'00'+S);
end;

var SSS:string;
procedure TForm1.Button4Click(Sender: TObject);
//var ET:EventTimer;
//var i:word;
begin
label9.Caption:='-';
  Port1.TriggerLength:=1;
  IWriteThenRead('00',1); //high byte
  IWriteThenRead('15',1); //low byte

  sleep(500);
  Port1.ProcessCommunications;
  //while Port1.CharReady do begin
    //SSS:=SSS+Port1.GetChar;
  //end;
  //NewTimer(ET,10);
  //repeat
    //Port1.ProcessCommunications;
  //until TimerExpired(ET);
  //label9.Caption:=inttostr(Port1.InBuffUsed);
//  label27.Caption:=inttostr(Port1.InBuffUsed);
  label27.Caption:=SSS;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  IWriteThenRead('01',1); //hi byte
  IWriteThenRead('10',1); //low byte
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
  IWriteThenRead('02',1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  IWriteThenRead('03',1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  IWriteThenRead('04',1);

end;
//type
{procedure GetChars(N:Word; MaxMS:word)
begin
  Sleep(WaitMs); //wait for the data to arrive...
  Port1.TriggerLength:=N;

end; }
procedure TForm1.Port1TriggerAvail(CP: TObject; Count: Word);
const CharCount:integer=0;
var i:word;
begin
  //CharCount:=Charcount+Count;
  IncCharCount(Count);
  label9.Caption:=inttostr(count)+' '+inttostr(Port1.InBuffUsed)+' '+inttostr(CharCount);
  for i:=1 to Count do begin
    //SSS:=SSS+Port1.GetChar;
  end
end;

procedure TForm1.SpiCSButtonClick(Sender:TObject; CommandStr:string);
 procedure ButtonHighlight(Button:TButton; Highlight:boolean);
 begin
   if Highlight
     then begin
       Button.Font.Color:=clLime;
       Button.Font.Style:=[fsBold];
       end
     else begin
       Button.Font.Color:=clBtnFace;
       Button.Font.Style:=[];
     end;
 end;
begin
  SendAsciiString(commandStr,false,true,true);
  ButtonHighlight(ButtonSpiCS00,false);
  ButtonHighlight(ButtonSpiCS01,false);
  ButtonHighlight(ButtonSpiCS10,false);
  ButtonHighlight(ButtonSpiCS11,false);

  ButtonHighlight(Sender as TButton,true);
end;

procedure TForm1.ButtonSpiCSInitClick(Sender: TObject);
begin
  ButtonSpiCS00.Enabled:=true;
  ButtonSpiCS01.Enabled:=true;
  ButtonSpiCS10.Enabled:=true;
  ButtonSpiCS11.Enabled:=true;

  SetHalfDuplex(true);
  SpiCSButtonClick(ButtonSpiCS11, 'PO30CF');
end;

procedure TForm1.ButtonSpiCS00Click(Sender: TObject);
begin
  SpiCsButtonClick(Sender,'O00');
end;

 procedure TForm1.ButtonSpiCS01Click(Sender: TObject);
begin
  SpiCsButtonClick(Sender,'O20');
end;

procedure TForm1.ButtonSpiCS10Click(Sender: TObject);
begin
  SpiCsButtonClick(Sender,'O10');
end;

procedure TForm1.ButtonSpiCS11Click(Sender: TObject);
begin
  SpiCsButtonClick(Sender,'O30');
end;

procedure TForm1.ButtonIRead1WireDS1820Click(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendAsciiString(':SCC44 L0400 SCCBER09',false,true,true);
end;

procedure TForm1.SpinEditScrollbackRowsChange(Sender: TObject);
begin
  //AdTerminal1.Active:=false;
  if SpinEditScrollbackRows.value<AdTerminal1.Rows
    then begin
      AdTerminal1.ScrollbackRows:=AdTerminal1.Rows;
      SpinEditScrollbackRows.value:=AdTerminal1.Rows;
    end
    else begin
      AdTerminal1.ScrollbackRows:=SpinEditScrollbackRows.value;
    end;
  //AdTerminal1.Active:=true;
end;

procedure TForm1.RadioGroupPCA9544BusNumClick(Sender: TObject);
begin
  if (RadioGroupPCA9544BusNum.ItemIndex=0)
    then IWrite('00')
    else IWrite(inttohex(RadioGroupPCA9544BusNum.ItemIndex-1+4,2));
end;

procedure TForm1.ButtonPCA9544StatusClick(Sender: TObject);
begin
  IRead(1);
end;

procedure TForm1.ButtonWriteTranslatorLogFileClick(Sender: TObject);
begin
{$ifdef DXGETTEXTDEBUG}
  DefaultInstance.DebugLogToFile('dxgettext-log.txt');
{$endif}
{$ifndef DXGETTEXTDEBUG}
  showmessage('Debugging mode not enabled: must change in source code and recompile');
{$endif}
end;

procedure TForm1.TabSheetI2CShow(Sender: TObject);
begin
  //Throws errors with GroupBoxIAddress, but not with new box with same controls inside
  //GroupBoxIAddress.Visible:=false;
  //GroupBoxIAddress.Enabled:=false;
  //GroupBoxIAddress.Parent:= nil;
  //GroupBoxIAddress.Parent:=TabSheetI2C2.Parent;//(Sender as TTabsheet);
  //GroupBox9.Parent:= TabSheetI2C2;
  {if Sender=TabSheetI2C
    then begin
    end;                   }

end;

procedure TForm1.ButtonChangeTraceFNameClick(Sender: TObject);
  var SaveTraceState, SaveLogState: TTraceLogState;
begin
  SaveTraceState:=Port1.Tracing;
  SaveLogState:=Port1.Logging;
  Port1.Tracing:=tlOff;
  Port1.Logging:=tlOff;

  Port1.TraceName:=forceextensionL(ComboBoxTraceFName.text,'trc');
  ComboBoxTraceFname.Text:=Port1.LogName; //update coerced string
  Port1.LogName:=forceextensionL(ComboBoxTraceFName.text,'log');
  ButtonChangeTraceFName.Visible:=false;
  ComboBoxPutStringAtTop(ComboBoxTraceFName,10);

  Port1.Tracing:=SaveTraceState;
  Port1.Logging:= SaveLogState;
end;

procedure TForm1.ButtonClearTraceLogClick(Sender: TObject);
  var SaveTraceState, SaveLogState: TTraceLogState;
begin
  SaveTraceState:=Port1.Tracing;
  SaveLogState:=Port1.Logging;
  Port1.Tracing:=tlClear;
  Port1.Logging:=tlClear;
  Port1.Tracing:=SaveTraceState;
  Port1.Logging:= SaveLogState;
end;

procedure TForm1.ButtonDumpTraceLogClick(Sender: TObject);
  var SaveTraceState, SaveLogState: TTraceLogState;
begin
  SaveTraceState:=Port1.Tracing;
  SaveLogState:=Port1.Logging;
  Port1.Tracing:=tlDump;
  Port1.Logging:=tlDump;
  Port1.Tracing:=SaveTraceState;
  Port1.Logging:= SaveLogState;
end;

procedure TForm1.ButtonUser1Click(Sender: TObject);
begin
  SendTabSendAsciiString(comboboxconvertstring(ComboBoxSend1,false,CheckBoxLiteralStrings.Checked),CheckBoxCR1.Checked,CheckBoxLF1.Checked,CheckBoxStripSpaces.Checked);
end;

function TForm1.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp:=false;
  Help1Click(nil);
  //showmessage(form1.HelpFile);
end;
procedure TForm1.ButtonBSEnterATClick(Sender: TObject);
begin
  SendAsciiString('+++',true,false,false);
end;

procedure TForm1.ButtonBSExitATClick(Sender: TObject);
begin
  SendAsciiString('ATMD',true,false,false);
end;

procedure TForm1.ButtonBSFastModeClick(Sender: TObject);
begin
  SendAsciiString('ATMF',true,false,false);
end;


procedure TForm1.ButtonBSBaudClick(Sender: TObject);
procedure BSSetBaud;
  procedure PutASTW(Baud:integer);
  begin
    Baud:=round(Baud*0.004096);
    SendAsciiString('ATSW20,'+inttostr(Baud)+',0,0,1',true,false,false);
  end;
  function ActualBaud(Baud:integer):integer;
    var BaudNumber:integer;
  begin
    BaudNumber:=round(Baud*0.004096);
    result:= round(BaudNumber/0.004096);
  end;
  var baud:integer;
begin
  try
{    if ComboboxBSBaud.ItemIndex>=1
      then ComboboxBSBaud.Text:=ComboboxBSBaud.Items[ComboboxBSBaud.ItemIndex];
    baud:=strtoint(ComboBoxBSBaud.text); }
    if ComboboxBSBaud.ItemIndex>=0
      then baud:=strtoint(ComboboxBSBaud.Items[ComboboxBSBaud.ItemIndex])
      else baud:=strtoint(ComboBoxBSBaud.text);
    PutASTW(baud);
    ComboBoxPutStringAtTop(ComboBoxBSBaud,20); //only if baud string was valid
    //ComboBoxBSBaud.Text:=inttostr(ActualBaud(Baud));
  except
  end; //try
end;
begin
  BSSetBaud;
end;

procedure TForm1.ButtonBSQueryBaudClick(Sender: TObject);
begin
  SendAsciiString('ATSI,8',true,false,false);
  //returned value is the stored count number in HEX. Multiply by 244 to get actual baud rate
end;

procedure TForm1.ButtonBSRSSIClick(Sender: TObject);
begin
  SendAsciiString('ATRSSI',true,false,false);
end;

procedure TForm1.ButtonBSParkClick(Sender: TObject);
begin
  SendAsciiString('ATPARK',true,false,false);
end;



procedure TForm1.ButtonSendLFClick(Sender: TObject);
begin
  Port1PutChar(chr($0A));
end;

procedure TForm1.ButtonMax127ReadClick(Sender: TObject);
  var Command:byte;
//      S:string;
begin
  Command:= 128+ (SpinEditMax127Channel.Value*16)+(RadioGroupMax127Range.ItemIndex*4);
  IWrite(inttohex(Command,2)+'P R02');
end;

procedure TForm1.RadioGroupSendEventClick(Sender: TObject);

begin

  if ComServer.StartMode=smAutomation then
  begin
    RTI.SendEvent(RadioGroupSendEvent.ItemIndex);
  end ;
  RadioGroupSendEvent.ItemIndex:=0;
end;


procedure TForm1.CheckBoxDirectCaptureClick(Sender: TObject);
begin
  PanelSpecialCapture.Visible:= (CheckBoxDirectCapture.Checked);
end;

procedure TForm1.ButtonEditDataTrigger1Click(Sender: TObject);
begin
  //SetDataTriggerLight;
  EditPacket(ApdDataPacket1,'Data Trigger 1');
  CheckboxDataTrigger1.Checked:=ApdDataPacket1.Enabled;

end;

procedure TForm1.CheckBoxDataTrigger1Click(Sender: TObject);
begin
  ApdDataPacket1.Enabled:= CheckBoxDataTrigger1.checked;
end;
procedure TForm1.ApdDataPacket1Packet(Sender: TObject; Data: Pointer;
  Size: Integer);
  var S:string;
begin
  SetDataTriggerLight;
  if RTI<>nil
    then begin
        RTI.SendEventOnDataTrigger(1,ApdDataPacket1);
    end
    else begin
      ApdDataPacket1.GetCollectedString(S);
      LabeledEditDataTriggerLastString1.Text:=S;
    end;
end;

procedure TForm1.StatusBar1DblClick(Sender: TObject);
begin
  StatusBar1.SimplePanel:=not StatusBar1.SimplePanel;
  if StatusBar1.SimplePanel
    then StatusBar1.Hint:='Doubleclick here to toggle Status information'
    else StatusBar1.Hint:='Doubleclick here to toggle extended Help';
end;

procedure TForm1.ButtonBL233_BitBashIdleClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendAsciiString('0 00 FF ',false,true,true);
  SpeedButtonP0.Down:=false;
  SpeedButtonP1.Down:=false;
  SpeedButtonP2.Down:=false;
  SpeedButtonP3.Down:=false;
  SpeedButtonP4.Down:=false;
  SpeedButtonP5.Down:=false;
  SpeedButtonP6.Down:=false;
  SpeedButtonP7.Down:=false;

end;
{ Attempt to add CRLF key.

  if AdTerminal1.Emulator.KeyboardMapping=nil then begin
      //exit;
      AdTerminal1.Emulator.KeyboardMapping.Create;
  end;
  AdTerminal1.Active:=false;
  AdTerminal1.Emulator.KeyboardMapping.Add('\x0D','VK_RETURN');
  AdTerminal1.Emulator.KeyboardMapping.Add('shift+VK_RETURN','DEC_CRLF');
  AdTerminal1.Emulator.KeyboardMapping.Add('shift+VK_EXECUTE','DEC_CRLF');
  AdTerminal1.Emulator.KeyboardMapping.Add('DEC_CRLF','\0x0D\0x0A');
  AdTerminal1.Active:=true;
}
procedure TForm1.ApdDataPacket1Timeout(Sender: TObject);
begin
  RTI.SendEventOnDataTimeout;
end;

procedure TForm1.LabelApdStatusTXDDblClick(Sender: TObject);
begin
  Port1.SendBreak(10,true);
end;

procedure TForm1.PanelBaud1DblClick(Sender: TObject);
begin
  ComboBoxBaudMult.Visible:= not ComboBoxBaudMult.Visible;
end;





procedure TForm1.CheckBoxCRCClick(Sender: TObject);
begin
  ComboBoxCRC.Enabled:=TCheckBox(Sender).Checked;
end;

procedure TForm1.ButtonPCA9545StatusClick(Sender: TObject);
begin
  IRead(1);
end;

procedure TForm1.CheckBox9545_BusXClick(Sender: TObject);
  var B:byte;
begin
    B:=0;
    if CheckBox9545_Bus0.Checked then B:=B+ 1;
    if CheckBox9545_Bus1.Checked then B:=B+ 2;
    if CheckBox9545_Bus2.Checked then B:=B+ 4;
    if CheckBox9545_Bus3.Checked then B:=B+ 8;
    //CheckBox9545_AllOff.Checked:=(B=0);
    IWrite(inttohex(B,2));
end;
{
procedure TForm1.CheckBox9545_AllOffClick(Sender: TObject);
begin
    if CheckBox9545_AllOff.Checked
      then begin
        //B:=0;
        CheckBox9545_Bus0.Checked:=false;
        CheckBox9545_Bus1.Checked:=false;
        CheckBox9545_Bus2.Checked:=false;
        CheckBox9545_Bus3.Checked:=false;

      end ;
      if CheckBox9545_AllOff.Checked and
         not(CheckBox9545_Bus0.Checked or CheckBox9545_Bus1.Checked or
             CheckBox9545_Bus2.Checked or CheckBox9545_Bus3.Checked)
             then CheckBox9545_BusXClick(Sender);

end;
}



procedure TForm1.SendBreak1Click(Sender: TObject);
begin
  Port1.SendBreak(1,true);
end;

procedure TForm1.C1Click(Sender: TObject);
begin
  //Port1.PutChar(char(3));
  Port1PutChar(chr(3)); //echos to terminal in half duplex
end;

procedure TForm1.ButtonI2CTestM5451Click(Sender: TObject);
  const FirstTime:boolean=true;
  var i,digit,displaycolor:integer;
   S:string;
   procedure SendString(S:shortstring);
   begin
     if displaycolor=2 then S:=S+'.';
     with Sender as TButton do begin

 //      if displaycolor=1   //appears that we can't actually change the text color in practice
 //        then Font.Color:=clLime
 //        else Font.Color:=clRed;
       Caption:=S;
       Update;  
      end; //with
     SendAsciiString('Y101 '+ Str2M5451D4(S),false,true,false);
     sleep(330);
   end;
begin
    SetHalfDuplex(true);
    if FirstTime then begin
      ButtonM5451ClearClick(Sender);
      //SendString('Y W000000000000 '); //send 6 bytes of zeros to ensure sync the first time
      FirstTime:=false;
    end;
    for displaycolor:=1 to 2 do begin
    for digit:=4 downto 1 do begin
    for i:=0 to 10  do begin
    S:='    ';
    if i=10
      then S[digit]:='.'
      else S[digit]:=char(i+ integer('0'));
    //if color=2 then S:=S+'.';


    SendString(S);
    end; // for i
    end; //for digit
    SendString('1    ');
    SendString('.    ');
    SendString(' ');
    SendString('1.8888');
    end; // for color
    with Sender as TButton do begin
      Caption:='Test'; //restore
      Font.Color:=clWindowText;
      end; //with
end;

procedure TForm1.CheckBoxI2CM5451_ColorClick(Sender: TObject);
begin
  with Sender as TCheckbox do begin
  if checked
    then Color:=clRed
    else Color:=clLime;
  end
end;

(*
type TCharSourceColors = object
    Color4Keyboard: TColor;
    Color4Port: TColor;
    Color4WriteChar: TColor;
    Color4SpyTx : TColor;
    Color4SpyRx : TColor;
    constructor Create;

end; //tcharsourcecolors

procedure TCharSourceColors.Create;
begin
  Color4Keyboard:=clRed;
  Color4Port    :=clYellow;
  Color4WriteChar:=clLime;
  Color4SpyTx:=clRed;
  Color4SpyRx:=clYellow;
end;

function TCharSourceColors.CharSource2Color(CharSource:TAdCharSource):TColor;
begin
  case CharSource of
    csUnknown: ;
    csKeyboard: Buffer.ForeColor:= Color4Keyboard;
    csPort: begin
              IncCharCount(1);
              Buffer.ForeColor    := Color4Port;
            end;
    csWriteChar: Buffer.ForeColor:=Color4WriteChar;
    //else
  end; //case
end;
*)


procedure TForm1.ButtonTerminalEnableClick(Sender: TObject);
begin
  AdTerminal1.enabled:=true;
end;

procedure TForm1.ButtonTerminalActiveClick(Sender: TObject);
begin
  AdTerminal1.active:=true;
end;

procedure TForm1.ButtonPopupMenuClick(Sender: TObject);
begin
  PopupMenu1.Popup(Form1.Left,form1.Top);
end;



procedure TForm1.ButtonAddCannedStringClick(Sender: TObject);
begin
  AddCannedString(EditCannedStringTitle.Text, EditCannedStringContents.Text);
end;



procedure TForm1.SpeedButtonP0Click(Sender: TObject);
var D:byte; commandStr:shortstring;
procedure DoButton(N:integer;Button:TSpeedButton);
begin
  if Button.Down then begin
    D:=D or N;
  end;
end;
begin
  D:=0;
  DoButton(1,SpeedButtonP0);
  DoButton(2,SpeedButtonP1);
  DoButton(4,SpeedButtonP2);
  DoButton(8,SpeedButtonP3);
  DoButton(16,SpeedButtonP4);
  DoButton(32,SpeedButtonP5);
  DoButton(64,SpeedButtonP6);
  DoButton(128,SpeedButtonP7);

  SetHalfDuplex(true);
  commandStr:='O 00'+inttohex(D xor 255,2);
  SendAsciiString(commandStr,false,true,true);

end;

procedure TForm1.ButtonBL233ReadPinsClick(Sender: TObject);
begin
  SetHalfDuplex(true);
  SendAsciiString('Q',false,true,true);
end;

procedure TForm1.LabelSyncCountClick(Sender: TObject);
begin
  HexEmulator.SyncCount:=0;
end;

procedure TForm1.EditColorsChange(Sender: TObject);
begin
  SetColors((Sender as TEdit).Text);
end;

procedure TForm1.SetColors(ColorString:string);
//Sets the colors used in the terminal from a ASCII string of single letters for each color
function ParseColorChar(C:char):TColor;
begin
  //C:=uppercase(C);
  if C>='a' then
    C:= chr(byte(C)- (byte('a') - byte('A')) ); //upper case char
  case C of
    'R':result:=clRed;
    'G':result:=clGreen;
    'B':result:=clBlue;
    'C':result:=clAqua;
    'Y':result:=clYellow;
    'M':result:=clFuchsia;
    'K':result:=clBlack;
    'W':result:=clWhite;
    'T':result:=clTeal;
    'P':result:=clPurple;
    'L':result:=clLime;
    'O':result:=clOlive;
    'N':result:=clMaroon;
    else result:=clGray;
    end; //case
end; //fn
var i:integer;
    ThisColor:TColor;
const DefaultColorString='RYLRYK';
begin
  //default is 'RYLRYK'
  for i:=1 to length(DefaultColorString) do begin
    if i<=length(ColorString)
      then ThisColor:=ParseColorChar(ColorString[i])
      else ThisColor:=ParseColorChar(DefaultColorString[i]);
    case i of
      1: Color4Keyboard:=ThisColor;
      2: Color4Port:=ThisColor;
      3: Color4WriteChar:=ThisColor;
      4: Color4SpyTx:=ThisColor;
      5: Color4SpyRx:=ThisColor;
      6: AdTerminal1.Color:=ThisColor;
      else
    end; //case
    end; //for
end;
procedure TForm1.ButtonScanBusClick(Sender: TObject);
  var Address:integer;
begin
  //clear screen
  AdTerminal1.Clear;
  AdTerminal1.Emulator.Buffer.SetCursorPosition(1,1);

  //half duplex off
  SetHalfDuplex(false);
  SendAsciiString('J0A',false,false,true); //enable ACK/NACK mode
  //setup
  SendAsciiString('T'+IAscii2Hex('Add 0 2 4 6 8 A C E   0 2 4 6 8 A C E '+CRLF,false),false,false,true);
  Address:=$0;
  while Address<=$FE do begin
    if (Address and $1F)=0 then begin //start of each line
      //type address
      SendAsciiString('T0D0A'+'T'+IAscii2Hex(inttohex(Address,2)+'  ',false),false,false,true);
    end;
    if (Address and $1F)=$10 then begin //middle of each line
      SendAsciiString('T2020',false,false,true); //spaces betwen blocks
    end;
    SendAsciiString(':S'+inttohex(Address,2)+'P'+chr(10)+'T20',false,false,true);
//    Port1.ProcessCommunications;
//    AdTerminal1.Update;
    inc(Address,2);
    //sleep(10);
  end;
  SendString('T'+IAscii2Hex(CRLF,false));
  SendString('J'+inttohex(ICRBitValue,2)+' ');
  SetHalfDuplex(true);
  end;

procedure TForm1.ButtonI2CCRMoreClick(Sender: TObject);
  var P:TPoint;
begin
  P:=GroupBoxI2CControlRegister.ClientOrigin;
  PopupMenuI2CControlRegister.Popup(P.x,P.y);
end;

function TForm1.ICRBitValue:byte;
begin
  result:=0;
  if MenuItemCR7.Checked then result:=result+128 ;
  if MenuItemCR6.Checked then result:=result+64 ;
  if MenuItemCR5.Checked then result:=result+32 ;
  if MenuItemCR4.Checked then result:=result+16 ;

  if MenuItemCR3.Checked then result:=result+8 ;
  if MenuItemCR2.Checked then result:=result+4 ;
  if MenuItemCR1.Checked then result:=result+2 ;
  if MenuItemCR0.Checked then result:=result+1 ;

  //sync the items
  CheckBoxMenuItemCR7.Checked :=MenuItemCR7.Checked ;
  CheckBoxMenuItemCR1.Checked :=MenuItemCR1.Checked ;
end;

procedure TForm1.CheckBoxMenuItemCR7Click(Sender: TObject);
begin
  MenuItemCR7.Checked:=(Sender as TCheckbox).Checked;
  MenuItemCRClick(Sender);
end;

procedure TForm1.CheckBoxMenuItemCR1Click(Sender: TObject);
begin
  MenuItemCR1.Checked:=(Sender as TCheckbox).Checked;
  MenuItemCRClick(Sender);
end;

procedure TForm1.PopupMenuI2CControlRegisterChange(Sender: TObject;
  Source: TMenuItem; Rebuild: Boolean);
  var value:byte;
begin
  value:=ICRBitValue;
  SetHalfDuplex(true);
  //I2CBusy:=true;
  SendString('J'+inttohex(value,2)+' ');
end;

procedure TForm1.MenuItemCRClick(Sender: TObject);
  var value:byte;
begin
  value:=ICRBitValue;
  SetHalfDuplex(true);
  //I2CBusy:=true;
  SendString('J'+inttohex(value,2)+' ');
end;

procedure TForm1.MenuItemCRDefaultClick(Sender: TObject);
begin
  MenuItemCR7.Checked :=false ;
  MenuItemCR6.Checked :=false;
  MenuItemCR5.Checked :=false ;
  MenuItemCR4.Checked :=false ;

  MenuItemCR3.Checked :=true ;
  MenuItemCR2.Checked :=false ;
  MenuItemCR1.Checked :=false ;
  MenuItemCR0.Checked :=false ;
  MenuItemCRClick(Sender);
end;

procedure TForm1.ButtonShowEventsTabClick(Sender: TObject);
begin
TabSheetEvents.TabVisible:=true;
PageControl1.ActivePage:=TabSheetEvents;
end;

procedure TForm1.SpeedButtonShowFormattedDataClick(Sender: TObject);
begin
  StatusBarFormattedData.Visible:= SpeedButtonShowFormattedData.Down;
end;

procedure TForm1.ButtonHexCSVFormatClick(Sender: TObject);
var P:TPoint;
begin
  P:=GroupBoxHexCSV.ClientOrigin;
  PopupMenuHexCSVFormat.Popup(P.x,P.y);
end;

procedure TForm1.ComboBoxHexCSVFormatDblClick(Sender: TObject);
begin
  ButtonHexCSVFormatClick(nil);
end;

procedure TForm1.HexCSVFormatChars1Click(Sender: TObject);
begin
    ComboBoxHexCSVFormat.Text:=ComboBoxHexCSVFormat.Text+(Sender as TMenuitem).Caption[2];
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  ComboBoxHexCSVFormat.Text:='';
end;

procedure TForm1.RadioGroupHexCSVTerminalShowsClick(Sender: TObject);
begin
  if RadioGroupHexCSVTerminalShows.ItemIndex=0
    then RadioGroupHexCSVStatusShows.Items[1]:= RadioGroupHexCSVTerminalShows.Items[1]
    else RadioGroupHexCSVStatusShows.Items[1]:= RadioGroupHexCSVTerminalShows.Items[0];
end;
procedure TForm1.ShowHideStatusBarFormattedData;
begin
  StatusBarFormattedData.Visible:= (RadioGroupHexCSVStatusShows.ItemIndex=1);
end;

procedure TForm1.RadioGroupHexCSVStatusShowsClick(Sender: TObject);
begin
  ShowHideStatusBarFormattedData;
end;


end.




































































































