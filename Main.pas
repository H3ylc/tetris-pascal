program tetris;
uses crt;

const
	FieldHeight = 20;
	FieldWeight = 10;
	TetriminoChar = '[]';
type
	TetriminosArray = record
		x, y: array[1..4] of integer;
	end;
var
	Field: array[1..FieldWeight, 1..FieldHeight] of boolean;
	{ True if cell is not empty }
	PatternsOfTetriminos: array[0..7] of TetriminosArray;

procedure WriteObject(x, y: integer; color: word; obj: string);
begin
	GotoXY(x, y);
	TextColor(color);
	write(obj);
	TextColor(White);
	GotoXY(1,1);
end;

procedure ClearObject(x, y: integer);
begin
	GotoXY(x, y);
	write('  ');
	GotoXY(1,1);
end;

procedure FieldInit;
var 
	x, y: integer;
begin
	WriteObject(1, 1, WHITE, '+');
	WriteObject(1, 22, WHITE, '+');
	WriteObject(22, 1, WHITE, '+');
	WriteObject(22, 22, WHITE, '+');
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
	for x := 1 to 10 do
		for y := 1 to 20 do
			Field[x,y] := false;
end;

procedure TetriminosPatternsInit;
begin
	{square}
	PatternsOfTetriminos[0].x[1] := 12;
	PatternsOfTetriminos[0].y[1] := 2;
	PatternsOfTetriminos[0].x[2] := 12;
	PatternsOfTetriminos[0].y[2] := 3;
	PatternsOfTetriminos[0].x[3] := 10;
	PatternsOfTetriminos[0].y[3] := 2;
	PatternsOfTetriminos[0].x[4] := 10;
	PatternsOfTetriminos[0].y[4] := 3;
end;

procedure WriteTetrimino(tetr: TetriminosArray);
var
	i, j: integer; 
begin
	for i := 1 to 4 do
	begin
		for j := 1 to 4 do
		begin
			WriteObject(tetr.x[i], tetr.y[j],
				BLUE, TetriminoChar);
		end;
	end;
end;

procedure ClearTetrimino(tetr: TetriminosArray);
var
	i, j: integer; 
begin
	for i := 1 to 4 do
	begin
		for j := 1 to 4 do
		begin
			ClearObject(tetr.x[i], tetr.y[j]);
		end;
	end;
end;

procedure CreateTetrimino(var tetr: TetriminosArray);
var
	id: integer;
begin
	id := 0;
	{id := random(7) + 1;}
	tetr := PatternsOfTetriminos[id];
	WriteTetrimino(tetr);
end;

function IsThereSomething(tetr: TetriminosArray): boolean;
var
	i, j, lx, ly: integer;
begin
	for i := 1 to 4 do
	begin
		for j := 1 to 4 do
		begin
			lx := tetr.x[i] div 2;
			ly := tetr.y[j] - 1;
			if (Field[lx, ly]) or (ly = 20) then
			begin
				IsThereSomething := true;
				exit;
			end;
		end;
	end;
	IsThereSomething := false;
end;

function TetriminoFall(var tetr: TetriminosArray): boolean;
var 
	i: integer;
begin
	if IsThereSomething(tetr) then
	begin
		TetriminoFall := true;
		exit;
	end;
	ClearTetrimino(tetr);
	for i := 1 to 4 do
	begin
		tetr.y[i] := tetr.y[i] + 1;
	end;
	WriteTetrimino(tetr);
	TetriminoFall := false;
end;

{
procedure MoveBlocksDown;
procedure RotateTetrimino;
procedure DeleteLineOfTetriminos;
}

var
	x, y: integer;
	CurrentTetrimino: TetriminosArray;
begin
	randomize();
	clrscr();
	FieldInit();
	TetriminosPatternsInit();
	CreateTetrimino(CurrentTetrimino);
	while true do
	begin
		delay(250);
		if TetriminoFall(CurrentTetrimino) then
			break;
	end;
	readkey();
	clrscr();
end.
