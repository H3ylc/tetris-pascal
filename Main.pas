program tetris;
uses crt;

const
	FieldHeight = 20;
	FieldWidth = 10;
	TetriminoBlock = '[]';
type
	TetriminosArray = record
		x, y: array[1..4] of integer;
		{ Tetriminos can have only 4 blocks }
		id: 1..7;
		{ There is only 7 different types of tetriminos }
		rotationPos: 1..4;
		{ 4 different rotation positions }
	end;
var
	Field: array[1..FieldWidth, 1..FieldHeight] of boolean;
	{ True if there is something }
	TetriminosPatterns: array[1..7] of TetriminosArray;
	{ There is only 7 different types of tetriminos }


procedure WriteObject(x, y: integer; color: word; obj: string);
begin
	GotoXY(x, y);
	TextColor(color);
	write(obj);
	TextColor(WHITE);
	GotoXY(1, 1);
end;

procedure ClearObject(x, y: integer);
begin
	GotoXY(x, y);
	write('  ');
	GotoXY(1, 1);
end;

procedure FieldInit;
var
	x, y: integer;
begin
	{ Field is empty }
	for x := 1 to 10 do
	begin
		for y := 1 to 20 do
		begin
			Field[x, y] := false;
		end;
	end;
	{ Corners }
	WriteObject(1, 1, WHITE, '+');
	WriteObject(22, 1, WHITE, '+');
	WriteObject(1, 22, WHITE, '+');
	WriteObject(22, 22, WHITE, '+');
	{ Borders }
	for x := 2 to 21 do
	begin
		WriteObject(x, 1, WHITE, '-');
		WriteObject(x, 22, WHITE, '-');
	end;
	for y := 2 to 21 do
	begin
		WriteObject(1, y, WHITE, '|');
		WriteObject(22, y, WHITE, '|');
	end;
end;

{ TETRIMINOS }
procedure WriteTetrimino(tetrim: TetriminosArray);
var
	i: integer;
begin
	for i := 1 to 4 do
	begin
		WriteObject(tetrim.x[i], tetrim.y[i], BLUE, TetriminoBlock);
	end;
end;

procedure ClearTetrimino(tetrim: TetriminosArray);
var
	i: integer;
begin
	for i := 1 to 4 do
	begin
		ClearObject(tetrim.x[i], tetrim.y[i]);
	end;
end;

procedure TetriminosPatternsInit;
begin
	{ 1. Square }
	TetriminosPatterns[1].id := 1;
	TetriminosPatterns[1].rotationPos := 1;
	TetriminosPatterns[1].x[1] := 10;
	TetriminosPatterns[1].y[1] := 2;
	TetriminosPatterns[1].x[2] := 12;
	TetriminosPatterns[1].y[2] := 2;
	TetriminosPatterns[1].x[3] := 10;
	TetriminosPatterns[1].y[3] := 3;
	TetriminosPatterns[1].x[4] := 12;
	TetriminosPatterns[1].y[4] := 3;
end;


procedure SaveInField(tetrim: TetriminosArray);
var
	lx, ly, i: integer;
begin
	for i := 1 to 4 do
	begin
		lx := tetrim.x[i] div 2 - 1;
		ly := tetrim.y[i] - 1;
		Field[lx, ly] := True;
	end;
end;

function IsThereBlock(tetrim: TetriminosArray): boolean;
var
	lx, ly, i: integer;
begin
	for i := 1 to 4 do
	begin
		lx := tetrim.x[i] div 2 - 1;
		ly := tetrim.y[i];
		if (Field[lx, ly]) or (ly = 21) then
		begin
			SaveInField(tetrim);
			IsThereBlock := true;
			exit;
		end;
	end;
	IsThereBlock := false;
end;

procedure CreateTetrimino(var tetrim: TetriminosArray);
var
	id: integer;
begin
	id := random(7) + 1;
	id := 1;
	tetrim := TetriminosPatterns[id];
	WriteTetrimino(tetrim);
end;

function TetriminoFall(var tetrim: TetriminosArray): boolean;
{ If true then tetrimino fell on something }
var
	i: integer;
begin
	if IsThereBlock(tetrim) then
	begin
		TetriminoFall := true;
		exit;
	end;
	TetriminoFall := false;
	ClearTetrimino(tetrim);
	for i := 1 to 4 do
	begin
		tetrim.y[i] := tetrim.y[i] + 1;
	end;
	WriteTetrimino(tetrim);
end;
{procedure TetriminoMove;
procedure TetriminoRotate;}

procedure Lose;
begin
	WriteObject(ScreenWidth div 2 - 4, 1, RED, 'LOSE');
	delay(1000);
	clrscr();
	halt();
end;

var
	CurrentTetrimino: TetriminosArray;
	ch: char;
	i: integer;
begin
	randomize();
	clrscr();
	FieldInit();
	TetriminosPatternsInit();
	CreateTetrimino(CurrentTetrimino);
	while true do
	begin
		delay(100);
		for i := 4 to 8 do
		begin
			if (Field[i, 2]) or (Field[i, 1]) then
				Lose;
		end;
		if TetriminoFall(CurrentTetrimino) then
		begin
			CreateTetrimino(CurrentTetrimino);
		end;
		ch := readkey();
		if ch = 'q' then
		begin
			clrscr();
			halt;
		end;
	end;
	readkey();
	clrscr();
end.
