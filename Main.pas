program tetris;
uses crt;

const
	FieldHeight = 20;
	FieldWidth = 10;
	MinScreenWidth = 35;
	MinScreenHeight = 22;
	TetriminoBlock = '[]';
type
	TetriminosArray = record
		x, y: array[1..4] of integer;
		{ Tetriminos can have only 4 blocks }
		id: 0..7;
		{ There is only 7 different types of tetriminos }
		rotationPos: 1..4;
		{ 4 different rotation positions }
	end;
var
	Colors: array[0..7] of word = (
		WHITE, YELLOW, CYAN, MAGENTA, GREEN, RED, LIGHTRED, BLUE );
	speed: integer = 200;
	Field: array[1..FieldWidth, 1..FieldHeight] of boolean;
	FieldColor: array[1..FieldWidth, 1..FieldHeight] of byte; 
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
	if (ScreenWidth < MinScreenWidth) or
	(ScreenHeight < MinScreenHeight) then
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
			FieldColor[x, y] := 0;
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
		WriteObject(tetrim.x[i], tetrim.y[i],
			Colors[tetrim.id], TetriminoBlock);
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
	TetriminosPatterns[i].y[1] := 3;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 3;
	TetriminosPatterns[i].x[3] := 12;
	TetriminosPatterns[i].y[3] := 3;
	TetriminosPatterns[i].x[4] := 10;
	TetriminosPatterns[i].y[4] := 2;
	{ 4. S }
	i := 4;
	TetriminosPatterns[i].id := 4;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 3;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 3;
	TetriminosPatterns[i].x[3] := 10;
	TetriminosPatterns[i].y[3] := 2;
	TetriminosPatterns[i].x[4] := 12;
	TetriminosPatterns[i].y[4] := 2;
	{ 5. Z }
	i := 5;
	TetriminosPatterns[i].id := 5;
	TetriminosPatterns[i].rotationPos := 1;
	TetriminosPatterns[i].x[1] := 8;
	TetriminosPatterns[i].y[1] := 2;
	TetriminosPatterns[i].x[2] := 10;
	TetriminosPatterns[i].y[2] := 2;
	TetriminosPatterns[i].x[3] := 10;
	TetriminosPatterns[i].y[3] := 3;
	TetriminosPatterns[i].x[4] := 12;
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
	TetriminosPatterns[i].y[3] := 3;
	TetriminosPatterns[i].x[4] := 12;
	TetriminosPatterns[i].y[4] := 2;
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

procedure FieldBlocksRewrite;
var 
	x, y: integer;
	cid, lx, ly: integer;
begin
	for x := 1 to 10 do
	begin
		for y := 1 to 20 do
		begin
			if Field[x, y] then
			begin
				cid := FieldColor[x, y];
				lx := x * 2;
				ly := y + 1;
				WriteObject(lx, ly, Colors[cid], TetriminoBlock);
			end;
		end;
	end;
end;

procedure SaveInField(tetrim: TetriminosArray);
var
	lx, ly, i: integer;
begin
	for i := 1 to 4 do
	begin
		if tetrim.y[i] <= 1 then
			exit;
		lx := tetrim.x[i] div 2;
		ly := tetrim.y[i] - 1;
		Field[lx, ly] := true;
		FieldColor[lx, ly] := tetrim.id;
	end;
end;

function IsThereBlock(tetrim: TetriminosArray; save: boolean; modif: byte): boolean;
var
	lx, ly, i: integer;
begin
	{ WITHOUT -1 TO 'ly' MOVEMENT WILL WORK WRONG }
	for i := 1 to 4 do
	begin
		lx := tetrim.x[i] div 2;
		ly := tetrim.y[i] - modif;

		if (Field[lx, ly]) or (ly >= 21) or (ly < 2) then
		begin
			if save then
				SaveInField(tetrim);
			IsThereBlock := true;
			exit;
		end;
	end;
	IsThereBlock := false;
end;

function RotateSubcheck(var tetr: TetriminosArray; temp: TetriminosArray): boolean;
var 
	i: integer;
begin
	if (IsThereBlock(temp, false, 0)) then
	begin
		RotateSubcheck := true;
		exit;
	end;
	for i := 1 to 4 do
	begin
		if (temp.x[i] < 2) or (temp.x[i] > 20) then
		begin
			RotateSubcheck := true;
			exit;
		end;
	end;
	ClearTetrimino(tetr);
	tetr := temp;
	WriteTetrimino(tetr);
end;
{ !SHITCODE ALERT! }
procedure TetriminoRotate(var tetr: TetriminosArray);
var
	temp: TetriminosArray;
begin
	case tetr.id of
		1: exit; {O}
		2: begin {I}
			if tetr.rotationPos = 1 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[4];
				temp.x[2] := temp.x[4];
				temp.x[3] := temp.x[4];
				temp.y[1] := temp.y[1] - 3;
				temp.y[2] := temp.y[2] - 2;
				temp.y[3] := temp.y[3] - 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 2
			end
			else if tetr.rotationPos = 2 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[1] - 6;
				temp.x[2] := temp.x[2] - 4;
				temp.x[3] := temp.x[3] - 2;
				temp.y[1] := temp.y[4];
				temp.y[2] := temp.y[4];
				temp.y[3] := temp.y[4];
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 1;
			end;
		end;
		3: begin {T}
			if tetr.rotationPos = 1 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[3];
				temp.x[2] := temp.x[3];
				temp.y[1] := temp.y[1] - 2;
				temp.y[2] := temp.y[2] - 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 2
			end
			else if tetr.rotationPos = 2 then
			begin
				temp := tetr;
				temp.y[3] := temp.y[1];
				temp.y[2] := temp.y[1];
				temp.x[3] := temp.x[3] - 4;
				temp.x[2] := temp.x[2] - 2;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 3
			end
			else if tetr.rotationPos = 3 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[3];
				temp.x[2] := temp.x[3];
				temp.y[1] := temp.y[1] + 2;
				temp.y[2] := temp.y[2] + 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 4
			end
			else if tetr.rotationPos = 4 then
			begin
				temp := tetr;
				temp.y[3] := temp.y[1];
				temp.y[2] := temp.y[1];
				temp.x[3] := temp.x[3] + 4;
				temp.x[2] := temp.x[2] + 2;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 1;
			end;
		end;
		4: begin {S}
			if tetr.rotationPos = 1 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[3];
				temp.y[1] := temp.y[3] - 1;
				temp.x[2] := temp.x[2] + 2;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 2
			end
			else if tetr.rotationPos = 2 then
			begin
				temp := tetr;
				temp.x[2] := temp.x[2] - 2;
				temp.y[1] := temp.y[1] + 2;
				temp.x[1] := temp.x[1] - 2;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 1;
			end;
		end;
		5: begin {Z}
			if tetr.rotationPos = 1 then
			begin
				temp := tetr;
				temp.x[3] := temp.x[1];
				temp.x[4] := temp.x[2];
				temp.y[4] := temp.y[2] - 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 2
			end
			else if tetr.rotationPos = 2 then
			begin
				temp := tetr;
				temp.x[3] := temp.x[2];
				temp.x[4] := temp.x[4] + 2;
				temp.y[4] := temp.y[2] + 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 1;
			end;
		end;
		6: begin {J}
			if tetr.rotationPos = 1 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[2];
				temp.y[1] := temp.y[2] - 1;
				temp.x[3] := temp.x[1];
				temp.y[3] := temp.y[1] - 1;
				temp.x[4] := temp.x[3] - 2;
				temp.y[4] := temp.y[3];
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 2
			end
			else if tetr.rotationPos = 2 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[4];
				temp.x[2] := temp.x[3] + 2;
				temp.y[2] := temp.y[3];
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 3
			end
			else if tetr.rotationPos = 3 then
			begin
				temp := tetr;
				temp.x[3] := temp.x[1];
				temp.y[3] := temp.y[1] + 1;
				temp.y[2] := temp.y[3];
				temp.x[2] := temp.x[3] + 2;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 4
			end
			else if tetr.rotationPos = 4 then
			begin
				temp := tetr;
				temp.y[1] := temp.y[3];
				temp.x[3] := temp.x[2] + 2;
				temp.x[4] := temp.x[3];
				temp.y[4] := temp.y[3] - 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 1;
			end;
		end;
		7: begin {L}
			if tetr.rotationPos = 1 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[4];
				temp.y[1] := temp.y[4] - 1;
				temp.x[2] := temp.x[1];
				temp.y[2] := temp.y[1] - 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 2
			end
			else if tetr.rotationPos = 2 then
			begin
				temp := tetr;
				temp.x[4] := temp.x[4] - 4;
				temp.y[4] := temp.y[2];
				temp.y[3] := temp.y[4];
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 3
			end
			else if tetr.rotationPos = 3 then
			begin
				temp := tetr;
				temp.x[1] := temp.x[4];
				temp.x[2] := temp.x[4];
				temp.y[2] := temp.y[1] + 1;
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 4
			end
			else if tetr.rotationPos = 4 then
			begin
				temp := tetr;
				temp.x[4] := temp.x[3] + 2;
				temp.y[4] := temp.y[2];
				temp.y[3] := temp.y[4];
				if RotateSubcheck(tetr, temp) then
					exit;
				tetr.rotationPos := 1;
			end;
		end;
	end;
end;

function TetriminoFall(var tetrim: TetriminosArray): boolean;
{ If true then tetrimino fell on something }
var
	i: integer;
begin
	if IsThereBlock(tetrim, true, 0) then
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
		if (temptetr.x[i] <= 1) or (temptetr.x[i] >= 22) or
			IsThereBlock(temptetr, false, 1) then
			exit;
	end;

	ClearTetrimino(tetrim);
	tetrim := temptetr;
	WriteTetrimino(tetrim);
	delay(speed);
end;

procedure TetriminoTrajectory(var traj: TetriminosArray; curr: TetriminosArray);
var
	i: integer;
begin
	ClearTetrimino(traj);
	traj := curr;
	traj.id := 0; { for color }
	while not IsThereBlock(traj, false, 0) do
	begin
		for i := 1 to 4 do
		begin
			traj.y[i] := traj.y[i] + 1;
		end;
	end;
	WriteTetrimino(traj);
end;

procedure DeleteTheLine;
var
	filled, x, y, ly, lx: integer;
	TempField: array[1..FieldWidth, 1..FieldHeight] of boolean;
	TempFieldColor: array[1..FieldWidth, 1..FieldHeight] of byte; 
begin
	filled := 0;
	for y := 1 to 20 do
	begin
		for x := 1 to 10 do
		begin
			if Field[x, y] then
				filled := filled + 1
		end;
		if filled = 10 then
		begin
			TempField := Field;
			TempFieldColor := FieldColor;

			for ly := 1 to y do
			begin
				for lx := 1 to 10 do
				begin
					TempField[lx, ly] := false;
					TempFieldColor[lx, ly] := 0;
				end;
			end;

			for ly := 2 to y do
			begin
				for lx := 1 to 10 do
				begin
					if Field[lx, ly - 1] then
					begin
						TempField[lx, ly] := Field[lx, ly - 1];
						TempFieldColor[lx, ly] := FieldColor[lx, ly -1];
					end;
				end;
			end;

			Field := TempField;
			FieldColor := TempFieldColor;
			for lx := 2 to 20 do
			begin
				for ly := 2 to 21 do
				begin
					ClearObject(lx, ly);
				end;
			end;
		end;
		filled := 0
	end;
end;

procedure Lose;
begin
	WriteObject(ScreenWidth div 2 - 4, 1, RED, 'LOSE');
	delay(1000);
	Quit();
end;

var
	CurrentTetrimino, TrajTetr: TetriminosArray;
	ch: char;
	i: integer;
	x, y: integer;
	spmod: byte; { speed modifier }
begin
	randomize();
	clrscr();
	FieldInit();
	TetriminosPatternsInit();

	CreateTetrimino(CurrentTetrimino);

	spmod := 1;

	TrajTetr := CurrentTetrimino;
	TetriminoTrajectory(TrajTetr, CurrentTetrimino);

	while true do
	begin

		TetriminoTrajectory(TrajTetr, CurrentTetrimino);

		while not keypressed do
		begin
			FieldBlocksRewrite;
			{ the lower the value, the higher the speed }

			{ Check the top of the field. }
			{ From 4 to 8 because new tetrimino parts }
			{ appear at these coordinates.            }
			for i := 4 to 8 do
			begin
				if Field[i, 2] then
					Lose;
			end;

			TetriminoTrajectory(TrajTetr, CurrentTetrimino);

			delay(speed div spmod);
			if TetriminoFall(CurrentTetrimino) then
			begin
				CreateTetrimino(CurrentTetrimino);
				DeleteTheLine();
				spmod := 1; { reset modifier }
			end;
		end;

		ch := readkey();
		case ch of
			'q': Quit();
			'a': TetriminoMove(CurrentTetrimino, 1);
			'd': TetriminoMove(CurrentTetrimino, 2);
			'r': TetriminoRotate(CurrentTetrimino);
			's': spmod := 4;
		end;
	end;
	clrscr();
end.
