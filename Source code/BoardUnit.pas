unit BoardUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, StrUtils, logic, Vcl.Menus;

type
  // Сделать свой класс для panels с полем статуса если все пойдет плохо. А ведь так реально произошло
  // TCellOfBoard=class(TPanel)
  // Panel:TPanel;
  TDrawPan = class(TPanel)
  private
    FOnPaint: TNotifyEvent;
  protected
    procedure Paint; override;
  public
    indChr: byte;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Canvas;

  end;

  TBoardFORM = class(TForm)
    PlayerLST: TListBox;
    CompLST: TListBox;
    LeftPAN: TPanel;
    RigthPAN: TPanel;
    PlayerLBL: TLabel;
    CompLBL: TLabel;
    BoardPAN: TPanel;
    ScoreLBL: TLabel;
    CenterPAN: TPanel;
    DefBTN: TButton;
    ExitBTN: TButton;
    ButtensPAN: TPanel;
    BackBTN: TButton;
    ApplyWrdBTN: TButton;
    SkipBTN: TButton;
    ToolBar: TMainMenu;
    LoadBTN: TMenuItem;
    N2: TMenuItem;
    SaveBTN: TMenuItem;
    SavDIA: TSaveDialog;
    LoadDIA: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RigthPANMouseLeave(Sender: TObject);
    procedure ExitBTNClick(Sender: TObject);
    procedure PanelRESIZE(Sender: TObject);
    procedure CellClick(Sender: TObject);
    procedure KeyListener(Sender: TObject; var Key: char);
    procedure KeyListenerLock(Sender: TObject; var Key: char);
    procedure ApplyWrdBTNClick(Sender: TObject);
    procedure FormMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure SkipBTNClick(Sender: TObject);
    procedure Draw(Sender: TObject);
    procedure DefBTNClick(Sender: TObject);
    procedure SaveBTNClick(Sender: TObject);
    procedure FillBoard;
    procedure DrawBoard(Board: TPanel);
    procedure LoadBTNClick(Sender: TObject);
    procedure DelBoard;

  private

    procedure RerenderBoard(Board: TPanel; delay: byte);
    function GetCurCell(ID: byte): TDrawPan;
    function IsSidesNull(pos: byte): boolean;
    procedure ClearBoard;

    function IsSidesSelect(pos, prev: shortint): boolean;
    function CompareWithoutExep(pan: TPanel; State: TBevelKind): boolean;
    procedure ComputerTurn;
    procedure MarthAlgorithm(i, j: byte; node: PTnode;
      used_pos: SetOfProbNumbers; Flag: shortint; path: string);
    procedure DrawWord(const CurWord: TWOrd);
    procedure ShowScore(str: string; comp: boolean);
    procedure EndGameEvent(isConside, isHide: boolean);

  protected
    TimeAfterResize: cardinal;
    CurCell: TDrawPan;
    SelCells: SetOfProbNumbers;
    CurWord: string;
    CellsOfBoard: array of array of TDrawPan;
    IndOfNewPanel: smallint;
    IsPlayerTurn: boolean;

    { Private declarations }
  public
    ValsOfCells: strMat;
    BoardSize: byte;
    Difficult: byte;
    CompScore: Word;
    PlayerScore: Word;
    { Public declarations }
  end;

var
  BoardFORM: TBoardFORM;

implementation

{$R *.dfm}

uses Mainmenu, DialogUnit;

procedure TDrawPan.Paint;
begin
  inherited;
  if Assigned(FOnPaint) then
    FOnPaint(self);
end;

procedure TBoardFORM.Draw(Sender: TObject);
// Список цветов
const
  Colors: array [0 .. 15] of Integer = (clMaroon, clGreen, clOlive, clNavy,
    clPurple, clTeal, clGray, clSilver, clRed, clLime, clYellow, clBlue,
    clFuchsia, clAqua, clLtGray, clDkGray);
var
  i, X, Y: Integer;
begin
  with TDrawPan(Sender) do
  begin
    if indChr <> 0 then
    begin
      Canvas.Font.Height := 14;
      Canvas.TextOut(5, 5, inttostr(indChr));
    end;
  end;
end;

function TBoardFORM.GetCurCell(ID: byte): TDrawPan;
begin
  result := CellsOfBoard[ID div self.BoardSize, ID mod self.BoardSize];
end;

procedure TBoardFORM.ClearBoard();
var
  i, j: byte;
begin
  for i := 0 to self.BoardSize - 1 do
    for j := 0 to self.BoardSize - 1 do
    begin
      CellsOfBoard[i, j].BevelKind := bkTile;
      CellsOfBoard[i, j].BevelInner := bvNone;
      CellsOfBoard[i, j].BevelOuter := bvNone;
      CellsOfBoard[i, j].Font.Color := clBlack;
      CellsOfBoard[i, j].Caption := self.ValsOfCells[i + 1, j + 1];
      CellsOfBoard[i, j].indChr := 0;
    end;
  self.SelCells := [];
  self.IndOfNewPanel := -1;
  // self.CurCell.Caption := '';
  // Logic.GetPosByTag(CurCell.Tag, self.BoardSize, i, j);
  // self.ValsOfCells[i, j] := '';
  self.CurWord := '';
  self.CurCell := nil;
end;

procedure TBoardFORM.DrawWord(const CurWord: TWOrd);
var
  i, j, k, N: byte;
begin
  i := CurWord.X - 1;
  j := CurWord.Y - 1;
  N := Length(CurWord.path);

  if (i * self.BoardSize + j) = CurWord.Add_pos then
  begin
    CellsOfBoard[i, j].Font.Color := clMaroon;
    ValsOfCells[i + 1, j + 1] := CurWord.Word[N + 1];
    CellsOfBoard[i, j].Caption := CurWord.Word[N + 1];
  end
  else
    CellsOfBoard[i, j].Font.Color := clBlue;
  CellsOfBoard[i, j].indChr := N + 1;

  for k := 1 to N do
  begin

    case CurWord.path[k] of
      'L':
        dec(j);
      'R':
        inc(j);
      'U':
        dec(i);
      'D':
        inc(i);
    end;

    if (i * self.BoardSize + j) = CurWord.Add_pos then
    begin
      CellsOfBoard[i, j].Font.Color := clMaroon;
      ValsOfCells[i + 1, j + 1] := CurWord.Word[N - k + 1];
      CellsOfBoard[i, j].Caption := CurWord.Word[N - k + 1];

    end
    else
      CellsOfBoard[i, j].Font.Color := clBlue;
    CellsOfBoard[i, j].indChr := N - k + 1;
  end;

end;

procedure TBoardFORM.FillBoard;
var
  i, j: byte;
begin
  for i := 0 to High(CellsOfBoard) do
    for j := 0 to High(CellsOfBoard) do
    begin
      CellsOfBoard[i, j].Caption := ValsOfCells[i + 1, j + 1];
    end;
end;

procedure TBoardFORM.DelBoard;
var
  i, j: shortint;
begin
  for i := 0 to self.BoardSize - 1 do
    for j := 0 to self.BoardSize - 1 do
      FreeAndNil(CellsOfBoard[i, j]);
  setLength(CellsOfBoard, 0, 0);
  setLength(ValsOfCells, 0, 0);
  self.BoardSize := 0;
end;

function TBoardFORM.CompareWithoutExep(pan: TPanel; State: TBevelKind): boolean;
begin
  try
    result := (pan.BevelKind = State);
  except
    on E: Exception do
    begin
      result := false;
    end;

  end;
end;

function TBoardFORM.IsSidesNull(pos: byte): boolean;
var
  left, rigth, top, bottom: boolean;
  i, j: byte;
begin
  logic.GetPosByTag(pos, self.BoardSize, i, j);

  left := (self.ValsOfCells[i + 1, j] = '');
  rigth := (self.ValsOfCells[i + 1, j + 2] = '');
  top := (self.ValsOfCells[i + 2, j + 1] = '');
  bottom := (self.ValsOfCells[i, j + 1] = '');

  result := left and rigth and top and bottom;
end;

function TBoardFORM.IsSidesSelect(pos, prev: shortint): boolean;
var
  left, rigth, top, bottom: boolean;
  i, j, EdgeFactor: shortint;
begin
  logic.GetPosByTag(pos, self.BoardSize, byte(i), byte(j));

  left := i * self.BoardSize + abs(j - 1) = prev;

  EdgeFactor := (j + 1) div self.BoardSize;
  rigth := i * self.BoardSize + (j + (1 - 2 * EdgeFactor)) = prev;
  top := abs(i - 1) * self.BoardSize + j = prev;
  EdgeFactor := (i + 1) div self.BoardSize;
  bottom := (i + (1 - 2 * EdgeFactor)) * self.BoardSize + j = prev;

  result := left or rigth or top or bottom;
end;

procedure TBoardFORM.SaveBTNClick(Sender: TObject);
begin
  if not self.IsPlayerTurn then
    exit;

  SavDIA.FileName := self.Caption + '.sav';
  if SavDIA.Execute and self.IsPlayerTurn then
  begin
    logic.savegame(SavDIA.FileName);
  end;
end;

procedure TBoardFORM.LoadBTNClick(Sender: TObject);
var
  i: Word;
begin
  LoadDIA.FileName := '';
  if not self.IsPlayerTurn then
    exit;

  if LoadDIA.Execute then
  begin
    PlayerLST.Clear;
    CompLST.Clear;
    self.ClearBoard;
    self.DelBoard;

    logic.loadGame(LoadDIA.FileName);

    self.DrawBoard(BoardPAN);
    self.FillBoard;

    self.ScoreLBL.Caption := 'СЧЕТ 0/0';
    self.CompScore := 0;
    self.PlayerScore := 0;

    i := 0;
    while i <= high(TurnsArr) do
    begin
      if TurnsArr[i][LastDelimiter('-', TurnsArr[i]) + 1] = 'C' then
        ShowScore(copy(TurnsArr[i], 0, Length(TurnsArr[i]) - 2), true)
      else
        ShowScore(copy(TurnsArr[i], 0, Length(TurnsArr[i]) - 2), false);
      inc(i);
    end;
    self.Caption := MainMenuFORM.DiffCB.Items[self.Difficult] + ' ' +
      MainMenuFORM.BoardSizeBOX.Items[self.BoardSize - 5];

    logic.rmDIct(dict);

    new(dict);
    dict.Key := ' ';
    dict.Word := '';
    dict.NextKey := nil;
    dict.NextLvL := nil;

    logic.readDIct;

  end;
end;

procedure TBoardFORM.ShowScore(str: string; comp: boolean);
var
  N: byte;
begin
  N := Length(str);
  if comp then
  begin
    self.CompLST.AddItem((str + '-' + inttostr(N)), nil);
    inc(self.CompScore, N);
    comp := logic.IsWordInDict(str);
  end
  else
  begin
    self.PlayerLST.AddItem((str + '-' + inttostr(N)), nil);
    inc(self.PlayerScore, N);
  end;
  self.ScoreLBL.Caption := 'Счёт ' + inttostr(PlayerScore) + '/' +
    inttostr(CompScore);

end;

procedure TBoardFORM.EndGameEvent(isConside, isHide: boolean);
var
  // dialogForm: TForm;
  text: string;
begin
  // self.ToolBar.Items.Clear;
  self.IsPlayerTurn := false;

  if isHide then
  begin
    logic.writeResult('ИГРОК СДАЛСЯ', self.ScoreLBL.Caption, self.Caption);
  end
  else
  begin
    DialogFORM := TDialogFORM.Create(self);
    self.DefBTN.Enabled := false;
    self.SkipBTN.Enabled := false;
    self.ApplyWrdBTN.Enabled := false;

    DialogFORM.Show;
    if isConside then
    begin
      DialogFORM.StatusLBL.Caption := 'ИГРОК СДАЛСЯ';
      DialogFORM.StaticText1.Caption := 'Вы сдались со счётом: ' +
        inttostr(PlayerScore) + '/' + inttostr(CompScore) +
        '. Хотите выйти в меню или начать новую игру?';
      logic.writeResult('ИГРОК СДАЛСЯ', self.ScoreLBL.Caption, self.Caption);
    end
    else if self.PlayerScore > self.CompScore then
    begin
      DialogFORM.StatusLBL.Caption := 'ИГРОК ПОБЕДИЛ';
      DialogFORM.StaticText1.Caption := 'Вы победили со счётом: ' +
        inttostr(PlayerScore) + '/' + inttostr(CompScore) +
        '. Хотите выйти в меню или начать новую игру?';
      logic.writeResult('ИГРОК ПОБЕДИЛ', self.ScoreLBL.Caption, self.Caption);
    end
    else if self.PlayerScore < self.CompScore then
    begin
      DialogFORM.StatusLBL.Caption := 'ИГРОК ПРОИГРАЛ';
      DialogFORM.StaticText1.Caption := 'Вы проиграли со счётом: ' +
        inttostr(PlayerScore) + '/' + inttostr(CompScore) +
        '. Хотите выйти в меню или начать новую игру?';
      logic.writeResult('ИГРОК ПРОИГРАЛ', self.ScoreLBL.Caption, self.Caption);
    end
    else if self.PlayerScore = self.CompScore then
    begin
      DialogFORM.StatusLBL.Caption := 'НИЧЬЯ';
      DialogFORM.StaticText1.Caption := 'Ничья со счётом: ' +
        inttostr(PlayerScore) + '/' + inttostr(CompScore) +
        '. Хотите выйти в меню или начать новую игру?';
      logic.writeResult('НИЧЬЯ', self.ScoreLBL.Caption, self.Caption);
    end;

  end;
  // else if true then




  // self.ToolBar. then

  {
    dialogForm := CreateMessageDialog('jopa', mtError, [mbOK]);
    dialogForm.
  }

end;

procedure TBoardFORM.DefBTNClick(Sender: TObject);
begin
  self.EndGameEvent(true, false);
end;

procedure TBoardFORM.SkipBTNClick(Sender: TObject);
begin
  TButton(Sender).Enabled := false;
  TButton(Sender).Enabled := true;

  self.ComputerTurn;
end;

procedure TBoardFORM.MarthAlgorithm(i, j: byte; node: PTnode;
  used_pos: SetOfProbNumbers; Flag: shortint; path: string);

var
  start_node: PTnode;
begin
  if ((i - 1) * self.BoardSize + j - 1) in used_pos then
    exit;

  include(used_pos, ((i - 1) * self.BoardSize + j - 1));
  node := node^.NextLvL;
  start_node := node;
  if start_node = nil then
    exit;

  if (ValsOfCells[i, j] = '') and (Flag = -1) then
  begin
    Flag := (i - 1) * self.BoardSize + j - 1;
    while node <> nil do
    begin
      if (j > 1) then
        self.MarthAlgorithm(i, j - 1, node, used_pos, Flag, 'R' + path);

      if (j < self.BoardSize) then
        self.MarthAlgorithm(i, j + 1, node, used_pos, Flag, 'L' + path);

      if (i < self.BoardSize) then
        self.MarthAlgorithm(i + 1, j, node, used_pos, Flag, 'U' + path);

      if (i > 1) then
        self.MarthAlgorithm(i - 1, j, node, used_pos, Flag, 'D' + path);

      if node^.Word <> '' then
        logic.AddPosibleTurn(node^.Word, Flag, i, j, path);

      node := node^.NextKey;
    end
  end
  else
  begin
    while (node^.Key <> ValsOfCells[i, j]) and (node^.NextKey <> nil) do
      node := node^.NextKey;
    if node^.Key <> ValsOfCells[i, j] then // Проверка на пустоту
      exit;

    if (j > 1) then
      self.MarthAlgorithm(i, j - 1, node, used_pos, Flag, 'R' + path);

    if (j < self.BoardSize) then
      self.MarthAlgorithm(i, j + 1, node, used_pos, Flag, 'L' + path);

    if (i < self.BoardSize) then
      self.MarthAlgorithm(i + 1, j, node, used_pos, Flag, 'U' + path);

    if (i > 1) then
      self.MarthAlgorithm(i - 1, j, node, used_pos, Flag, 'D' + path);

    if (node^.Word <> '') and (Flag <> -1) then
      logic.AddPosibleTurn(node^.Word, Flag, i, j, path);

  end;

end;

procedure TBoardFORM.ApplyWrdBTNClick(Sender: TObject);
var
  N, i, j: byte;
begin

  if (logic.IsWordInDict(self.CurWord)) and (Length(self.CurWord) <> 0) then
  begin
    self.ShowScore(self.CurWord, false);
    logic.GetPosByTag(IndOfNewPanel, self.BoardSize, i, j);
    self.ValsOfCells[i + 1, j + 1] := self.CellsOfBoard[i, j].Caption[1];
    logic.AddTurn(self.CurWord, 'P');
    self.ComputerTurn;
  end
  else
  begin
    showmessage('Слово не найдено');
    self.ClearBoard;
  end;

  TButton(Sender).Enabled := false; // Сбросить фокус
  TButton(Sender).Enabled := true;

end;

procedure TBoardFORM.CellClick(Sender: TObject);
var
  i, j, prev: byte;
  Flag: boolean;
begin
  if not self.IsPlayerTurn then
    exit;

  if self.IndOfNewPanel = -1 then
  begin
    CurCell := self.GetCurCell(TPanel(Sender).Tag);
    if (CurCell.Caption <> '') or self.IsSidesNull(CurCell.Tag) then
      exit;
    CurCell.Font.Color := clRed;
    self.IndOfNewPanel := CurCell.Tag;
    self.CurCell.BevelKind := bkSoft;
    self.OnKeyPress := self.KeyListener;
  end
  else if self.CompareWithoutExep(CurCell, bkSoft) then
  begin
    self.CurCell.BevelKind := bkTile;
    if self.CurCell.Caption = '' then
      self.IndOfNewPanel := -1
    else
    begin
      logic.GetPosByTag(CurCell.Tag, self.BoardSize, i, j);
      self.ValsOfCells[i + 1, j + 1] := '';
    end;
    CurCell := nil;
    self.OnKeyPress := self.KeyListenerLock;
  end
  else
  begin
    Flag := false;
    if CurCell <> nil then
      prev := CurCell.Tag
    else
    begin
      // Чтобы в прев не попал мусор и не было входа за пределы поля
      prev := 0;
      Flag := true;
      self.CurWord := '';
    end;
    CurCell := self.GetCurCell(TDrawPan(Sender).Tag);
    if (not(byte(CurCell.Tag) in SelCells)) and
      (IsSidesSelect(CurCell.Tag, prev) or Flag) and (CurCell.Caption <> '')
    then
    begin
      include(SelCells, byte(CurCell.Tag));
      if CurCell.Font.Color <> clRed then
      begin
        CurCell.Canvas.Pen.Color := clBlue;
        CurCell.Font.Color := clBlue;
      end
      else
        CurCell.Font.Color := clMaroon;
      CurCell.Canvas.Brush.Color := clBlue;
      self.CurWord := self.CurWord + CurCell.Caption;
      // self.CurCell.Canvas.PenPos;
      // self.CurCell.Canvas.TextOut(-5, -5, inttostr(length(self.CurWord)));
      self.CurCell.ClientHeight;

      self.CurCell.Canvas.Pen.Width := 5;
      self.CurCell.Canvas.MoveTo(100, 100);
      self.CurCell.Canvas.LineTo(10, 10);
      self.CurCell.indChr := Length(self.CurWord);
    end
    else
    begin
      if Flag then
        CurCell := nil
      else
        CurCell := self.GetCurCell(prev);
    end;

  end;

end;

procedure TBoardFORM.DrawBoard(Board: TPanel);
var
  i, j: byte;
  Panel_dym: TDrawPan;
begin
  setLength(CellsOfBoard, self.BoardSize, self.BoardSize);
  setLength(ValsOfCells, self.BoardSize + 2, self.BoardSize + 2);

  for i := 0 to self.BoardSize - 1 do
    for j := 0 to self.BoardSize - 1 do
    begin
      Panel_dym := TDrawPan.Create(self);
      Panel_dym.Parent := Board;
      Panel_dym.BevelKind := bkTile;
      Panel_dym.BevelInner := bvNone;
      Panel_dym.BevelOuter := bvNone;
      Panel_dym.Font.Size := 20;
      Panel_dym.Tag := i * self.BoardSize + j;
      Panel_dym.OnClick := self.CellClick;
      Panel_dym.indChr := 0;
      Panel_dym.OnPaint := Draw;

      // Panel_dym.OnPaint:=

      CellsOfBoard[i, j] := Panel_dym;
    end;

  self.RerenderBoard(Board, 0);

end;

procedure TBoardFORM.RerenderBoard(Board: TPanel; delay: byte);
var
  j, i, k: byte;
  XStep, YStep: Word;
begin
  if (GetTickCount - self.TimeAfterResize > delay) and (self.BoardSize > 0) then
  begin

    XStep := Board.Width div self.BoardSize;
    YStep := Board.Height div self.BoardSize;
    for i := 0 to self.BoardSize - 1 do
      for j := 0 to self.BoardSize - 1 do
      begin
        CellsOfBoard[i, j].left := j * XStep;
        CellsOfBoard[i, j].top := i * YStep;
        CellsOfBoard[i, j].Width := XStep;
        CellsOfBoard[i, j].Height := YStep;
      end;
    TimeAfterResize := GetTickCount;
  end;

end;

procedure TBoardFORM.RigthPANMouseLeave(Sender: TObject);
begin
  self.RerenderBoard(BoardPAN, 0);
end;

procedure TBoardFORM.FormResize(Sender: TObject);
begin
  self.RerenderBoard(BoardPAN, 50);
end;

procedure TBoardFORM.ExitBTNClick(Sender: TObject);
begin
  if self.IsPlayerTurn then
    if (MessageDlg('При выходе будет засчитано поражение. Выйти?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      self.EndGameEvent(true, true)
    else
      exit;

  self.DelBoard;
  if DialogFORM <> nil then
  begin
    DialogFORM.Destroy;
    DialogFORM := nil;
  end;

  if Sender is TButton then
    self.Destroy;
  case TButton(Sender).Tag of
    1:
      begin
        Application.Terminate;
        logic.rmDIct(dict);
      end;
  else
    begin
      Mainmenu.MainMenuFORM.Show;
    end;
  end
end;

procedure TBoardFORM.FormCreate(Sender: TObject);
begin
  TimeAfterResize := GetTickCount;
  logic.readDIct;
  self.BoardSize := Mainmenu.MainMenuFORM.BoardSizeBOX.ItemIndex + 5;
  self.Difficult := Mainmenu.MainMenuFORM.DiffCB.ItemIndex;
  self.IndOfNewPanel := -1;
  self.IsPlayerTurn := Mainmenu.MainMenuFORM.PlayerFirstCHB.Checked;

  self.Caption := MainMenuFORM.DiffCB.Items[self.Difficult] + ' ' +
    MainMenuFORM.BoardSizeBOX.Items[self.BoardSize - 5];

  DialogFORM := nil;

end;

procedure TBoardFORM.FormMouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  self.ClearBoard;
  self.IsPlayerTurn := true;
  self.OnMouseActivate := nil;

end;

procedure TBoardFORM.KeyListener(Sender: TObject; var Key: char);
var
  jj: Word;
begin
  Key := AnsiUpperCase(Key)[1];
  if (ord(Key) = VK_ESCAPE) or (ord(Key) = VK_BACK) then // ESC и BACKSPASE
  begin
    self.CurCell.Font.Color := clBlack;
    self.CurCell.Caption := '';
    self.IndOfNewPanel := -1;
    self.CurCell.BevelKind := bkTile;
    self.OnKeyPress := nil;
  end
  else if (ord(Key) = VK_RETURN) and (self.CurCell.BevelKind = bkSoft) and
    (self.CurCell.Caption <> '') then
  begin
    self.CurCell.BevelKind := bkTile;
    self.OnKeyPress := self.KeyListenerLock;
    self.CurCell := nil;
  end
  else if (Key >= 'А') and (Key <= 'Я') then
  begin
    self.CurCell.Caption := chr(ord(Key));
  end;

end;

procedure TBoardFORM.KeyListenerLock(Sender: TObject; var Key: char);
begin
  Key := AnsiUpperCase(Key)[1];
  if (ord(Key) = VK_ESCAPE) or (ord(Key) = VK_BACK) then // ESC и BACKSPASE
  begin
    self.ClearBoard;
  end
  else if ord(Key) = VK_RETURN then
    self.ApplyWrdBTNClick(self.ApplyWrdBTN); // Возможный баги

end;

procedure TBoardFORM.FormShow(Sender: TObject);
var
  j: byte;
begin
  self.BoardSize := 5 + Mainmenu.MainMenuFORM.BoardSizeBOX.ItemIndex;
  self.DrawBoard(BoardPAN);
  case self.BoardSize of
    5:
      begin
        self.ValsOfCells[3, 1] := 'Б';
        self.ValsOfCells[3, 2] := 'А';
        self.ValsOfCells[3, 3] := 'Л';
        self.ValsOfCells[3, 4] := 'Д';
        self.ValsOfCells[3, 5] := 'А';
      end;
    6:
      begin
        self.ValsOfCells[3, 1] := 'К';
        self.ValsOfCells[3, 2] := 'У';
        self.ValsOfCells[3, 3] := 'Р';
        self.ValsOfCells[3, 4] := 'С';
        self.ValsOfCells[3, 5] := 'А';
        self.ValsOfCells[3, 6] := 'Ч';
      end;
    7:
      begin
        self.ValsOfCells[4, 1] := 'Р';
        self.ValsOfCells[4, 2] := 'Е';
        self.ValsOfCells[4, 3] := 'Г';
        self.ValsOfCells[4, 4] := 'И';
        self.ValsOfCells[4, 5] := 'С';
        self.ValsOfCells[4, 6] := 'Т';
        self.ValsOfCells[4, 7] := 'Р';
      end;
  end;

  self.FillBoard;

  if not self.IsPlayerTurn then
    self.ComputerTurn;

end;

procedure TBoardFORM.PanelRESIZE(Sender: TObject);
var
  x_pos, y_pos: byte;
  x_step, y_step: Word;
begin
  x_pos := TPanel(Sender).Tag div self.BoardSize;
  y_pos := TPanel(Sender).Tag mod self.BoardSize;

  x_step := BoardPAN.Width div self.BoardSize;
  y_step := BoardPAN.Height div self.BoardSize;

  TPanel(Sender).Width := x_step;
  TPanel(Sender).Height := y_step;
  TPanel(Sender).left := x_step * x_pos;
  TPanel(Sender).top := y_step * y_pos;
end;

procedure TBoardFORM.ComputerTurn;
var
  iCounterPerSec: TLargeInteger;
  T1, T2: TLargeInteger;
  selWord: TWOrd;
  i: Integer;
  j: Integer;
  // значение счётчика ДО и ПОСЛЕ операции
begin
  setLength(PosibleWord, 0);
  ClearBoard;
  IsPlayerTurn := false;
  OnKeyPress := nil;
  QueryPerformanceFrequency(iCounterPerSec);
  // определили частоту счётчика
  QueryPerformanceCounter(T1); // засекли время начала операции

  // Проверка на победу

  for i := 1 to self.BoardSize do
    for j := 1 to self.BoardSize do
      self.MarthAlgorithm(i, j, dict, [], -1, '');

  if Length(PosibleWord) > 0 then
  begin
    selWord := logic.SelectWord(self.Difficult);
    DrawWord(selWord);
    ShowScore(selWord.Word, true);
    logic.AddTurn(selWord.Word, 'C');
  end
  else
  begin
    self.EndGameEvent(false, false);
  end;

  setLength(PosibleWord, 0);
  for i := 1 to self.BoardSize do
    for j := 1 to self.BoardSize do
      self.MarthAlgorithm(i, j, dict, [], -1, '');

  if Length(PosibleWord) > 0 then
    self.OnMouseActivate := self.FormMouseActivate
  else
    self.EndGameEvent(false, false);

  QueryPerformanceCounter(T2);
  // showMessage(FormatFloat('0.0000', (T2 - T1) / iCounterPerSec) + ' сек.');

end;

end.
