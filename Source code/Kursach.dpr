program Kursach;

uses
  Vcl.Forms,
  Mainmenu in 'Mainmenu.pas' {MainMenuFORM},
  BoardUnit in 'BoardUnit.pas' {BoardFORM},
  Logic in 'Logic.pas',
  DialogUnit in 'DialogUnit.pas' {DialogFORM},
  StatsUnit in 'StatsUnit.pas' {StatsFORM};

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainMenuFORM, MainMenuFORM);
  Application.Run;

end.
