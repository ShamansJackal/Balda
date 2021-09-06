unit DialogUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TDialogFORM = class(TForm)
    Filler: TPanel;
    YesBTN: TButton;
    NoBTN: TButton;
    rstBTN: TButton;
    StatusLBL: TLabel;
    StaticText1: TStaticText;
    procedure rstBTNClick(Sender: TObject);
    procedure YesBTNClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DialogFORM: TDialogFORM;

implementation

{$R *.dfm}

uses BoardUnit, Logic, Mainmenu;

procedure TDialogFORM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Action := caFree;
end;

procedure TDialogFORM.rstBTNClick(Sender: TObject);
begin
  // if BoardFORM.CloseQuery then

  Logic.rmDIct(dict);

  new(dict);
  dict.Key := ' ';
  dict.Word := '';
  dict.NextKey := nil;
  dict.NextLvL := nil;

  Logic.ReadDict;
  self.Destroy;
  DialogFORM := nil;

  BoardFORM.PlayerLST.Clear;
  BoardFORM.CompLST.Clear;

  BoardFORM.ScoreLBL.Caption := 'явер 0/0';
  BoardFORM.CompScore := 0;
  BoardFORM.PlayerScore := 0;

  BoardFORM.DelBoard;
  setLength(TurnsArr, 0);
  BoardFORM.OnCreate(nil);
  BoardFORM.OnShow(nil);

  BoardFORM.DefBTN.Enabled := true;
  BoardFORM.SkipBTN.Enabled := true;
  BoardFORM.ApplyWrdBTN.Enabled := true;
end;

procedure TDialogFORM.YesBTNClick(Sender: TObject);
begin
  self.Destroy;
  DialogFORM := nil;
  if TButton(Sender).Tag = 1 then
    BoardFORM.Destroy;
end;

end.
