unit ComportFinder;
interface
uses classes;

  function GetCommNumberByKey(Key:string):string;
  procedure GetComDevicesList(out List:TStrings; out FirstAvailablePort:word; Format:integer=1; Sorted:boolean=false);
implementation

uses registry , strutils, SysUtils, windows, dialogs;
//{$R *.dfm}
function GetRegistryValue(KeyName,ValName: string): string;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    // False because we do not want to create it if it doesn't exist
    Registry.OpenKey(KeyName, False);
    Result := Registry.ReadString(ValName);
  finally
    Registry.Free;
  end;
end;
function JustComNumberStr(S:string):string;
begin
  result:=AnsiRightStr(S,length(S)-length('COM'));
end;
function JustKeyStr(S:string):string;
begin
  result:=AnsiRightStr(S,length(S)-length('\Device'));
end;
const SerialCommRegKey='HARDWARE\DEVICEMAP\SERIALCOMM';
function GetCommNumberByKey(Key:string):string;
var S:string;
begin
  S:=GetRegistryValue(SerialCommRegKey,'\Device'+Key);
  S:=JustComNumberStr(S);
  result:=S;
end;

procedure GetComDevicesList(out List:TStrings; out FirstAvailablePort:word; Format:integer=1; Sorted:boolean=false);
var
  Reg: TRegistry;
  Val:TStringList;
  PortList:TStringList;
  I:Integer;
  ThisKey,ThisValue,ThisDevice,ThisPort:string;
const MAXPORTNUM=100;
procedure SortByPortNumber;//Scans through ports. Finds FirstAvailablePort, Optionally sorts
var PortNum, CurrentPos,FindPos:integer;
begin
  //CurrentPos:=0;
  for PortNum:=0 to MaxPortNum do
    begin
      FindPos:=PortList.IndexOf(inttostr(PortNum));
      if FindPos>-1  //this port is found
        then begin
          if FirstAvailablePort=0  then FirstAvailablePort:=PortNum;
          if Sorted then List.add(Val.Strings[FindPos]); //if we are sorting add them 1 by 1
        end;
    end;//for
  if not sorted then List.Assign(Val); //if we are not sorting, add all just as they are
end;//fn


begin
  Reg:=TRegistry.Create(KEY_READ);
  try
    FirstAvailablePort:=0;
    Val:=TStringList.Create;
    PortList:=TStringList.Create;
    try
      Reg.RootKey:=HKEY_LOCAL_MACHINE; // Section to look for within the registry
      if not Reg.OpenKey(SerialCommRegKey,False) then
        ShowMessage('Error in GetComDevicesList opening registry key: "'+SerialCommRegKey+'"'
              +chr(13)+chr(10)+'Please report your OS version and Realterm version to crun@users.sourceforge.net'
              +chr(13)+chr(10)+' Try using Realterm 2.0.0.69 instead until fixed')
      else
      begin
        Reg.GetValueNames(Val);

        for I:=0 to Val.Count-1 do
        begin
          ThisKey:=Val.Strings[I];
          ThisDevice:=AnsiRightStr(ThisKey, length(ThisKey)-length('\Device'));
          ThisValue:=Reg.ReadString(ThisKey);
          ThisPort:=JustComNumberStr(ThisValue);
          PortList.add(ThisPort);
          case Format of
            0: Val.Strings[I]:=ThisValue;
            1: Val.Strings[I]:=ThisDevice+'='+ThisValue;
            2: Val.Strings[I]:=ThisPort+' = '+JustKeyStr(ThisKey);
            3: Val.Strings[I]:=ThisDevice;
            else Val.Strings[I]:=ThisValue;
          end; //case
      end; //for
      SortByPortNumber;
      //if Sorted
        //then SortByPortNumber
        //else List.Assign(Val); //copy the result
      end;
    finally
      Reg.Free;
    end;
  finally
    Val.Free;
    PortList.Free;
  end;
end;

end.
