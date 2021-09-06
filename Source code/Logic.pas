unit Logic;

interface

const
  StatPath = 'stats.txt';
  DictPath = 'dict.dat';

Type
  StrMat = array of array of string;
  Tstr = string[20];
  SetOfProbNumbers = set of 0 .. 49;

  PTNode = ^TNode;

  TNode = record // Стоит ли делать тип списка публичным????  Да
    Key: char;
    Word: string;
    NextKey, NextLvL: PTNode;
  end;

  TWord = record
    Word: String;
    Add_pos: byte;
    x: byte;
    y: byte;
    path: string;
  end;

procedure ClearMatrix(var Mat: StrMat);
procedure GetPosByTag(tag, size: integer; out i, j: byte);
procedure InitData;
procedure ReadDict;
procedure rmDIct(tmp: PTNode);
function IsWordInDict(str: string): boolean;
function SelectWord(diff: byte): TWord;
procedure AddPosibleTurn(str: string; Add_pos, x, y: byte; path: string);
procedure AddTurn(str: string; whoChr: char);
procedure SaveGame(path: string);
procedure LoadGame(path: string);
procedure WriteResult(winner, points, title: string);

var
  PosibleWord: array of TWord;
  Dict: PTNode;
  TurnsArr: array of string;

implementation

uses System.SysUtils, BoardUnit;

Const
  LenFL = 10;

Type
  FileLine = array [1 .. LenFL] of string[20];

procedure ClearMatrix(var Mat: StrMat);
var
  i, j: byte;
begin
  for i := 0 to High(Mat) do
    for j := 0 to High(Mat) do
      Mat[i, j] := '';
end;

procedure GetPosByTag(tag, size: integer; out i, j: byte);
begin
  i := tag div size;
  j := tag mod size;
end;

function isWordInTurns(str: string): boolean;
var
  i: Word;
begin
  i := 0;
  while i <= High(TurnsArr) do
  begin
    if copy(TurnsArr[i], 0, high(TurnsArr[i]) - 2) = str then
    begin
      result := true;
      exit;
    end;
    inc(i);
  end;
  result := false;

end;

procedure AddWordToDict(str: string);
var
  tmp: PTNode;
  i: byte;
begin
  tmp := Dict;
  for i := 1 to Length(str) do
  begin
    if tmp^.NextLvL = nil then
    begin
      new(tmp^.NextLvL);
      // inc(count);
      tmp^.NextLvL^.Key := str[i];
      tmp^.NextLvL^.Word := '';
      tmp^.NextLvL^.NextKey := nil;
      tmp^.NextLvL^.NextLvL := nil;
    end;
    tmp := tmp^.NextLvL;

    while tmp^.Key <> str[i] do
    begin
      if tmp^.NextKey = nil then
      begin
        new(tmp^.NextKey);
        tmp^.NextKey^.Key := str[i];
        tmp^.NextKey^.Word := '';
        tmp^.NextKey^.NextKey := nil;
        tmp^.NextKey^.NextLvL := nil;
      end;
      tmp := tmp^.NextKey;
    end;

  end;
  tmp^.Word := str;
end;

function IsWordInDict(str: string): boolean;
var
  i: byte;
  tmp: PTNode;
begin
  tmp := Dict;
  for i := 1 to Length(str) do
  begin
    if tmp^.NextLvL = nil then
    begin
      result := false;
      exit;
    end
    else
      tmp := tmp^.NextLvL;
    while str[i] <> tmp^.Key do
    begin
      if tmp^.NextKey = nil then
      begin
        result := false;
        exit;
      end;
      tmp := tmp^.NextKey;
    end;
  end;

  if str = tmp^.Word then
  begin
    result := true;
    tmp^.Word := '';
  end
  else
    result := false;
end;

procedure rmDIct(tmp: PTNode);
begin
  if tmp^.NextLvL <> nil then
    rmDIct(tmp^.NextLvL);

  if tmp^.NextKey <> nil then
    rmDIct(tmp^.NextKey);

  Dispose(tmp);
end;

procedure InitData;
begin
  Randomize;

  new(Dict);
  Dict.Key := ' '; // ???
  Dict.Word := '';
  Dict.NextKey := nil;
  Dict.NextLvL := nil;

  setLength(PosibleWord, 0);
  setLength(TurnsArr, 0);
end;

{
  function rmWord(str: string; Node: PTNode): boolean;
  begin
  if str = '' then
  exit;

  if Node^.NextLvL^.NextLvL^=nil and Node^.NextLvL^.NextKey = nil then


  while Node^.Key <> str[1] do
  Node := Node^.NextKey;

  if (Node^.NextLvL = nil) and (Node^.NextKey = nil) then
  begin
  Dispose(Node);
  result := true;
  exit
  end;

  while Node^.Key <> str[1] do
  Node := Node^.NextKey;

  end;
}

procedure ReadDict;
var
  DictFile: TextFile;
  str: string;
begin
  if not FileExists(DictPath) then
    exit;

  assign(DictFile, DictPath);
  reset(DictFile);

  while not EOF(DictFile) do
  begin
    readln(DictFile, str);
    if not isWordInTurns(str) then
      AddWordToDict(str);
  end;
  closeFile(DictFile);
end;

procedure AddTurn(str: string; whoChr: char); overload;
var
  n: byte;
begin
  n := Length(TurnsArr);
  setLength(TurnsArr, n + 1);

  TurnsArr[n] := str + '-' + whoChr;
end;

procedure AddTurn(str: string); overload;
var
  n: byte;
begin
  n := Length(TurnsArr);
  setLength(TurnsArr, n + 1);

  TurnsArr[n] := str;
end;

procedure WriteResult(winner, points, title: string);
var
  saveFile: TextFile;
begin
  assign(saveFile, StatPath);
  if not FileExists(StatPath) then
  begin
    rewrite(saveFile);
    writeln('СТАТИСТИКА ИГР');
    close(saveFile);
  end;
  Append(saveFile);
  writeln(saveFile, DateToStr(Date) + ' ' + TimeToStr(Time) + '>' + title + '-'
    + winner + ' ' + points);
  close(saveFile);

end;

procedure SaveGame(path: string);
var
  saveFile: file of FileLine;
  tmp: FileLine;
  i, j: byte;
begin
  assign(saveFile, path);
  rewrite(saveFile);
  reset(saveFile);

  tmp[1] := inttostr(BoardFORM.BoardSize);
  tmp[2] := inttostr(BoardFORM.Difficult);

  write(saveFile, tmp);
  for j := 1 to BoardFORM.BoardSize do // Помни что массива для 5 на 5, 7*7
  begin
    for i := 1 to BoardFORM.BoardSize do
      tmp[i] := BoardFORM.ValsOfCells[j, i];
    for i := i to LenFL do
      tmp[i] := '0';
    write(saveFile, tmp);
  end;
  i := 1;
  while (i <= Length(TurnsArr)) do
  begin
    tmp[(i - 1) mod LenFL + 1] := TurnsArr[i - 1];
    if i mod (LenFL) = 0 then
      write(saveFile, tmp);
    inc(i);
  end;

  tmp[(i - 1) mod LenFL + 1] := 'END';;
  if i mod (LenFL) <> 0 then
    write(saveFile, tmp);

  close(saveFile);

end;

procedure LoadGame(path: string);
var
  loadFile: file of FileLine;
  tmp: FileLine;
  i, j: byte;
begin
  if not FileExists(path) then
    exit;

  assign(loadFile, path);
  reset(loadFile);

  read(loadFile, tmp);
  BoardFORM.BoardSize := strtoint(tmp[1]);
  BoardFORM.Difficult := strtoint(tmp[2]);

  setLength(BoardFORM.ValsOfCells, BoardFORM.BoardSize + 2,
    BoardFORM.BoardSize + 2);

  // Logic.ClearMatrix(BoardFORM.ValsOfCells);
  for i := 1 to BoardFORM.BoardSize do
  begin
    read(loadFile, tmp);
    for j := 1 to BoardFORM.BoardSize do
      BoardFORM.ValsOfCells[i, j] := tmp[j];
  end;

  i := 1;
  read(loadFile, tmp);
  setLength(TurnsArr, 0);
  while tmp[i] <> 'END' do
  begin
    AddTurn(tmp[i]);

    if (i mod 10) = 0 then
    begin
      i := i mod 10;
      read(loadFile, tmp);
    end;
    inc(i);
  end;

  close(loadFile);

end;

procedure AddPosibleTurn(str: string; Add_pos, x, y: byte; path: string);
var
  n: byte;
begin
  n := Length(PosibleWord);
  setLength(PosibleWord, n + 1);

  PosibleWord[n].Word := str;
  PosibleWord[n].Add_pos := Add_pos;
  PosibleWord[n].x := x;
  PosibleWord[n].y := y;
  PosibleWord[n].path := path;
end;

function SelectWord(diff: byte): TWord;
var
  i: Word;
begin
  result := PosibleWord[0];
  case diff of
    0:
      for i := 0 to High(PosibleWord) do
        if Length(PosibleWord[i].Word) <= Length(result.Word) then
          result := PosibleWord[i];
    1:
      result := PosibleWord[random(high(PosibleWord))];
    2:
      for i := 0 to High(PosibleWord) do
        if Length(PosibleWord[i].Word) >= Length(result.Word) then
          result := PosibleWord[i];
  end;

end;

end.
