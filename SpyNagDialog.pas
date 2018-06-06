unit SpyNagDialog;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ShellAPI;

type
  TSpyNagDlg = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    OKBtn: TButton;
    ButtonDonate: TButton;
    procedure OKBtnClick(Sender: TObject);
    procedure ButtonDonateClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  SpyNagDlg: TSpyNagDlg;

implementation

const MillisecondsUntilShow=1500;
{$R *.dfm}

procedure TSpyNagDlg.OKBtnClick(Sender: TObject);
begin
  SpyNagDlg.Hide;
end;

procedure TSpyNagDlg.ButtonDonateClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://sourceforge.net/project/project_donations.php?group_id=67297',nil,nil, SW_SHOWNORMAL);
end;

end.
