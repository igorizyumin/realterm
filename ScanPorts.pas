unit ScanPorts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Grids, ValEdit;

type
  TFormScanPorts = class(TForm)
    Timer1: TTimer;
    Label2: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    BitBtnAbort: TBitBtn;
    BitBtnOK: TBitBtn;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    ValueListEditorComDevices: TValueListEditor;
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnAbortClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    StartTime:TDateTime;
    LastTime:TDateTime;
    AutoStart:boolean;
  public
    { Public declarations }
    AbortScanning:boolean;
    procedure StartScanning(LastPort:integer);
    procedure EndScanning;
    procedure Scanning(CurrentPort,LastPort:integer);
  end;

var
  FormScanPorts: TFormScanPorts;

implementation
uses DateUtils,ComportFinder;
{$R *.dfm}
procedure TFormScanPorts.StartScanning(LastPort:integer);
begin
  ProgressBar1.Max:=LastPort;
  StartTime:=GetTime;
  LastTime:=StartTime;
  AbortScanning:=false;
  BitBtnAbort.visible:=true;
  BitBtnOK.Visible:=false;
  AutoStart:=true;
  //Timer1.Enabled:=true;
  //show;
end;
procedure TFormScanPorts.EndScanning;
begin
  BitBtnAbort.visible:=false;
  BitBtnOK.Visible:=true;
end;

procedure TFormScanPorts.Scanning(CurrentPort,LastPort:integer);
  var TookMilliSeconds: Integer;
  var Now:TDateTime;
 
begin
    //if not WithinPastMilliSeconds(GetTime,StartTime,1000)   then begin
    //  showmessage('Realterm is scanning for Comports @ Com'+inttostr(I)+' If this is taking too long you may have Bluetooth enabled.');
    //
    //end;
  Now:=GetTime;
  //TookMilliseconds:=MilliSecondsBetween(Now,LastTime);
  TookMilliseconds:=MilliSecondsBetween(Now,StartTime);
  if (not visible) {and AutoStart} and (TookMilliseconds>500)
    then begin
      Show; //display form
      Timer1.Enabled:=true; //make it auto hide after a period of inactivity
    end;

  if visible then begin
     Timer1.Enabled:=false; Timer1.Enabled:=true; //restart
     ProgressBar1.Position:=CurrentPort;
     if CurrentPort<>LastPort
       then Label1.Caption:=inttostr(CurrentPort)
       else Label1.Caption:='done '+inttostr(CurrentPort);
//     BitBtnAbort.Caption:='Abort Scanning now';
//     Repaint;
     //Update;
//     sleep(50);
     if (TookMilliSeconds > 2000) //if it is really slow, stall and bring up a dialog
       then begin
         if (mrAbort=MessageDlg('Abort Scanning Now?',mtConfirmation,mbAbortIgnore,0))
           then begin
             BitBtnAbortClick(nil);
             end else begin
               BitBtnAbort.Caption:='Abort Scanning (after this port)';
               Repaint;
             end;
       end
       else begin
         BitBtnAbort.Caption:='Abort Scanning (after this port)';
         Repaint;
     end;
     BitBtnAbort.Caption:='Abort Scanning (after this port)';
     Repaint;

  end;
  Application.ProcessMessages(); //so we can respond to buttons
  LastTime:=GetTime; //Dialogs etc might take a while....
end;

procedure TFormScanPorts.Timer1Timer(Sender: TObject);
begin
  Close; //hide the form
  //Hide;
  //show;
end;

procedure TFormScanPorts.BitBtnOKClick(Sender: TObject);
begin
  //AutoStart:=false; //don't restart if user clicked continue...
  //Close;
  Hide;
end;

procedure TFormScanPorts.BitBtnAbortClick(Sender: TObject);
begin
  AbortScanning:=true;
  Timer1.Interval:=500; //make it close quickly even if not explicitly closed
end;

procedure TFormScanPorts.FormShow(Sender: TObject);
 var AList:TStrings; FirstAvailablePort:word ;
begin
    ALIst:=TStringList.Create;
    GetComDevicesList(AList,FirstAvailablePort,1);
    ValueListEditorComDevices.Strings.assign(AList);
    AList.Free;
end;

end.
