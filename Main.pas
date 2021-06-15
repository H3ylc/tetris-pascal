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
	Colors: array[1..7] of word = (
		YELLOW, CYAN, MAGENTA, GREEN, RED, LIGHTRED, BLUE );
	speed: integer = 150;
	Field: array[1..FieldWidth, 1..FieldHeight] of boolean;
	{ True if there is something }
	TetriminosPatterns: array[1..7] of TetriminosArray;
	{ There is only 7 different types of tetriminos }

procedure Quit;
begin
	clrscr();
	halt;
end;

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
	{ Check window resolution }
	if (ScreenWidth < 22) or (ScreenHeight < 22) then
	begin
		WriteObject(1, 1, RED, 'TooSmallWindow');
		delay(750);
		Quit;
	end;
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
		WriteObject(tetrim.x[i], tetrim.y[i], Colors[tetrim.id], TetriminoBlock);
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
var
	i: byte;
begin
	{ 1. O }
	i := 1;
	TetriminosPatterns[i].id := 1;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 10;
	TetriminosPatterns[i].y[1] := 2;
	TetriminosPatterns[i].x[2] := 12;
	TetriminosPatterns[i].y[2] := 2;
	TetriminosPatterns[i].x[3] := 10;
	TetriminosPatterns[i].y[3] := 3;
	TetriminosPatterns[i].x[4] := 12;
	TetriminosPatterns[i].y[4] := 3;
	{ 2. I }
	i := 2;
	TetriminosPatterns[i].id := 2;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 2;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 2;
	TetriminosPatterns[i].x[3] := 12;
	TetriminosPatterns[i].y[3] := 2;
	TetriminosPatterns[i].x[4] := 14;
	TetriminosPatterns[i].y[4] := 2;
	{ 3. T }
	i := 3;
	TetriminosPatterns[i].id := 3;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 2;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 2;
	TetriminosPatterns[i].x[3] := 12;
	TetriminosPatterns[i].y[3] := 2;
	TetriminosPatterns[i].x[4] := 10;
	TetriminosPatterns[i].y[4] := 3;
	{ 4. S }
	i := 4;
	TetriminosPatterns[i].id := 4;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 3;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 2;
	TetriminosPatterns[i].x[3] := 12;
	TetriminosPatterns[i].y[3] := 2;
	TetriminosPatterns[i].x[4] := 10;
	TetriminosPatterns[i].y[4] := 3;
	{ 5. Z }
	i := 5;
	TetriminosPatterns[i].id := 5;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 2;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 2;
	TetriminosPatterns[i].x[3] := 12;
	TetriminosPatterns[i].y[3] := 3;
	TetriminosPatterns[i].x[4] := 10;
	TetriminosPatterns[i].y[4] := 3;
	{ 6. J }
	i := 6;
	TetriminosPatterns[i].id := 6;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 3;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 3;
	TetriminosPatterns[i].x[3] := 12;
	TetriminosPatterns[i].y[3] := 2;
	TetriminosPatterns[i].x[4] := 12;
	TetriminosPatterns[i].y[4] := 3;
	{ 7. L }
	i := 7;
	TetriminosPatterns[i].id := 7;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 2;
	TetriminosPatterns[i].x[2] := 8;
	TetriminosPatterns[i].y[2] := 3;
	TetriminosPatterns[i].x[3] := 10;
	TetriminosPatterns[i].y[3] := 3;
	TetriminosPatterns[i].x[4] := 12;
	TetriminosPatterns[i].y[4] := 3;
end;

procedure CreateTetrimino(var tetrim: TetriminosArray);
var
	id: integer;
begin
	id := random(7) + 1;
	tetrim := TetriminosPatterns[id];
	WriteTetrimino(tetrim);
end;

procedure SaveInField(tetrim: TetriminosArray);
var
	lx, ly, i: integer;
begin
	for i := 1 to 4 do
	begin
		if tetrim.y[i] <= 1 then
			exit;
		lx := tetrim.x[i] div 2 - 1;
		ly := tetrim.y[i] - 1;
		Field[lx, ly] := True;
	end;
end;

function IsThereBlock(tetrim: TetriminosArray; save: boolean): boolean;
var
	lx, ly, i, modif: integer;
begin
	{ WITHOUT -1 TO 'ly' MOVEMENT WILL WORK WRONG }
	modif := 0;
	if not save then
		modif := 1;

	for i := 1 to 4 do
	begin
		lx := tetrim.x[i] div 2 - 1;
		ly := tetrim.y[i] - modif;

		if (Field[lx, ly]) or (ly = 21) then
		begin
			if save then
				SaveInField(tetrim);
			IsThereBlock := true;
			exit;
		end;
	end;
	IsThereBlock := false;
end;

function TetriminoFall(var tetrim: TetriminosArray): boolean;
{ If true then tetrimino fell on something }
var
	i: integer;
begin
	if IsThereBlock(tetrim, true) then
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

procedure TetriminoMove(var tetrim: TetriminosArray; direction: byte);
{ direction = 1 - left; 2 - right }
var
	i, shift: integer;
	temptetr: TetriminosArray;
begin
	if direction = 1 then
		shift := -2 
	else if direction = 2 then
		shift := 2;

	temptetr := tetrim;

	for i := 1 to 4 do
	begin
		temptetr.x[i] := temptetr.x[i] + shift;
		{ Check if it in border or not at something }
		if (temptetr.x[i] < 2) or (temptetr.x[i] >= 22) or
			IsThereBlock(temptetr, false) then
			exit;
	end;

	ClearTetrimino(tetrim);
	tetrim := temptetr;
	WriteTetrimino(tetrim);
	delay(speed);
end;

{procedure TetriminoRotate;}

procedure Lose;
begin
	WriteObject(ScreenWidth div 2 - 4, 1, RED, 'LOSE');
	delay(1000);
	Quit();
end;

var
	CurrentTetrimino: TetriminosArray;
	ch: char;
	i: integer;
	spmod: byte; { speed modifier }
begin
	randomize();
	clrscr();
	FieldInit();
	TetriminosPatternsInit();
	CreateTetrimino(CurrentTetrimino);
	spmod := 1;
	while true do
	begin
		while not keypressed do
		begin
			{ the lower the value, the higher the speed }
			delay(speed div spmod);

			{ Check the top of the field. }
			{ From 4 to 8 because new tetrimino parts }
			{ appear at these coordinates.            }
			for i := 4 to 8 do
			begin
				if Field[i, 2] then
					Lose;
			end;

			if TetriminoFall(CurrentTetrimino) then
			begin
				CreateTetrimino(CurrentTetrimino);
				spmod := 1; { reset modifier }
			end;
		end;
		ch := readkey();
		case ch of
			'q': Quit();
			'a': TetriminoMove(CurrentTetrimino, 1);
			'd': TetriminoMove(CurrentTetrimino, 2);
			's': spmod := 2;
		end;
	end;
	clrscr();
end.
