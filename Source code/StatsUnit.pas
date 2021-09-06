unit StatsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids;

type
  TStatsFORM = class(TForm)
    ListBox1: TListBox;
    Filler: TPanel;
    ClearBTN: TButton;
    OkBTN: TButton;
    StrGRID: TStringGrid;
    procedure OkBTNClick(Sender: TObject);
    procedure ClearBTNClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    procedure DrawTable(str: string; i: word);
    procedure ReadStats;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StatsFORM: TStatsFORM;

implementation

{$R *.dfm}

uses Logic;

procedure TStatsFORM.ReadStats;
var
  saveFile: TextFile;
  i: word;
  str, tmp: string;
begin
  assignfile(saveFile, StatPath);
  reset(saveFile);
  readln(saveFile, str);

  i := 1;
  while not EOF(saveFile) do
  begin
    readln(saveFile, str);
    self.DrawTable(str, i);
    inc(i);
  end;
  self.StrGRID.RowCount := i;

  closefile(saveFile);
end;

procedure TStatsFORM.ClearBTNClick(Sender: TObject);
begin
  DeleteFile(StatPath);
  StatsFORM := nil;
  self.Destroy;
end;

procedure TStatsFORM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StatsFORM := nil;
  Action := caFree;
end;

procedure TStatsFORM.FormCreate(Sender: TObject);
begin
  StrGRID.Cells[0, 0] := 'Дата';
  StrGRID.Cells[1, 0] := 'Время';
  StrGRID.Cells[2, 0] := 'Сложность';
  StrGRID.Cells[3, 0] := 'Поле';
  StrGRID.Cells[4, 0] := 'Результат';
  StrGRID.Cells[5, 0] := 'Счёт';
  if FileExists(StatPath) then
    ReadStats;
end;

procedure TStatsFORM.FormResize(Sender: TObject);
begin
  self.StrGRID.DefaultColWidth := (self.Width div 6) - 8;
end;

procedure TStatsFORM.OkBTNClick(Sender: TObject);
begin
  StatsFORM := nil;
  self.Destroy;
end;

procedure TStatsFORM.DrawTable(str: string; i: word);
begin
  self.StrGRID.Cells[0, i] := copy(str, 1, pos(' ', str) - 1);
  delete(str, 1, pos(' ', str));
  self.StrGRID.Cells[1, i] := copy(str, 1, pos('>', str) - 1);
  delete(str, 1, pos('>', str));
  self.StrGRID.Cells[2, i] := copy(str, 1, pos(' ', str) - 1);
  delete(str, 1, pos(' ', str));
  self.StrGRID.Cells[3, i] := copy(str, 6, 3);
  delete(str, 1, 9);
  self.StrGRID.Cells[4, i] := copy(str, 1, pos(' ', str, 7) - 1);
  delete(str, 1, pos(' ', str, 7));
  self.StrGRID.Cells[5, i] := copy(str, pos(' ', str),
    length(str) - pos(' ', str) + 1);
end;

end.
