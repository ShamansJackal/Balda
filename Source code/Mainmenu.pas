unit Mainmenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  TMainMenuFORM = class(TForm)
    LogohLBL: TLabel;
    MenuPAN: TPanel;
    ExitBTN: TButton;
    StartBTN: TButton;
    StatsBTN: TButton;
    BoardSizeBOX: TComboBox;
    PlayerFirstCHB: TCheckBox;
    Filler: TPanel;
    LogotypeIMG: TImage;
    DiffCB: TComboBox;
    CBPan: TPanel;
    procedure ExitBTNClick(Sender: TObject);
    procedure StartBTNClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StatsBTNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainMenuFORM: TMainMenuFORM;

implementation

{$R *.dfm}

uses BoardUnit, Logic, StatsUnit;

procedure TMainMenuFORM.ExitBTNClick(Sender: TObject);
begin
  Logic.rmDict(dict);
  Application.Terminate;
end;

procedure TMainMenuFORM.FormCreate(Sender: TObject);
begin
  StatsFORM := nil;
  Logic.InitData;
end;

procedure TMainMenuFORM.StartBTNClick(Sender: TObject);
begin
  if StatsFORM <> nil then
  begin
    StatsFORM.Destroy;
    StatsFORM := nil;
  end;
  BoardFORM := BoardUnit.TBoardFORM.Create(self);
  BoardFORM.Show;
  BoardFORM.SetFocus;
  self.Hide;
end;

procedure TMainMenuFORM.StatsBTNClick(Sender: TObject);
begin
  if not FileExists(StatPath) then
  begin
    showMessage('Ќачните играть, чтобы получить статистику');
  end
  else if StatsFORM = nil then
  begin
    StatsFORM := StatsUnit.TStatsFORM.Create(self);
    StatsFORM.Show;
  end;

end;

end.
