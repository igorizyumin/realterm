unit RTAboutBox;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellApi;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Label99: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MemoParams1: TMemo;
    MemoParams2: TMemo;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    LabelVersionInfo: TLabel;
    Label19: TLabel;
    Image1: TImage;
    Label20: TLabel;
    LabelWindowsVersion: TLabel;
    procedure LabelHTMLClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses realterm1;
{uses gnugettextD5;}
{$R *.DFM}

procedure TAboutBox.LabelHTMLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar((Sender as TLabel).Caption),nil,nil, SW_SHOWNORMAL);
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  AboutBox.Close;
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
  MemoParams1.Lines:=Form1.Parameter1.ParamWatch;
  MemoParams2.Lines:=Form1.ParameterRemote.ParamWatch;
  LabelVersionInfo.Caption:=Form1.AFVersionCaption1.Caption;
  LabelWindowsVersion.Caption:='Win32Platform '+inttostr(Win32Platform);
end;

end.

