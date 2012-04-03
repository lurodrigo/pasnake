unit SnakeLib;

interface

	uses crt;
	
	const 
	up = #72;
	left = #75;
	right = #77;
	down = #80;
	esc = #27;
	enter = #13;
	
	blockChar = #219;
	foodChar = '*';
	snakeHead = #153;
	snakeBody = #240;
	
	fillHoriz = #205;
	fillVert = #186;
	fillNW = #201;
	fillNE = #187;
	fillSW = #200;
	fillSE = #188;
	
	width = 78;
	height = 45;
	minX = 1;
	minY = 3;
	maxSnakeLength = 3000;

	type tPoint = object
		x, y: byte;
	end;

	type tTemporaryPoint = object(tPoint)
		plays: word;
	end;

	type tSnake = array [1..maxSnakeLength] of tPoint;
	
	type tCheat = record
		password: string[15];
		description: string[160];
		activated: boolean;
	end;
	
	const 
		PhantomCheat = 1;
		ChildCheat = 2;
		BrightFoodForeverCheat = 3;
		CrazyFoodForeverCheat = 4;	
		SlowlyCrazyFoodCheat = 5;		
	
	type tRecordInfo = record
		name: string[20];
		score: word;
	end;
	
	type tMenuOptions =  array [1..16] of string[40];
	
	function selectMenu(options: tMenuOptions; nOptions: integer; x, y, color, hcolor: byte; op: integer): integer;
	function horizontalMenu(options: tMenuOptions; nOptions: integer; x, y, color, hcolor: byte; op: integer): integer;
	function upperCase(s: string): string;
	
implementation

	function selectMenu(options: tMenuOptions; nOptions: integer; x, y, color, hcolor: byte; op: integer): integer;
	var i: integer;
		key: char;
	begin
		if op > nOptions then
			op:= 1;
		
		repeat
			for i:=1 to nOptions do begin
				if (i = op) then begin
					textcolor(hcolor);
					gotoxy(x, y + 2 * i);
					write(#16);
				end
				else begin
					textcolor(color);
					gotoxy(x, y + 2 * i);
					write(' ');
				end;
	
				gotoxy(x + 3, y + 2 * i);
				write(options[i]);
				gotoxy(x + 3, y + 2 * i + 1);
				write('              ');
			end;
			
			repeat until keypressed;
			key:= readkey;
			
			if key = esc then begin	
				selectMenu:= nOptions + 1;
				exit;
			end;
			if key = enter then break;
			if key in [up, left] then dec(op);
			if key in [down, right] then inc(op);
			if op = 0 then op:= nOptions;
			if op = (nOptions + 1) then op:= 1;
		until false;
		selectMenu:= op;
	end;
	
	function horizontalMenu(options: tMenuOptions; nOptions: integer; x, y, color, hcolor: byte; op: integer): integer;
	var i: integer;
		key: char;
	begin
		if op > nOptions then
			op:= 1;
		
		repeat
			gotoxy(x, y);
			
			for i:=1 to nOptions do begin
				if (i = op) then
					textcolor(hcolor)
				else
					textcolor(color);
	
				write(options[i], '    ');
			end;
			
			repeat until keypressed;
			key:= readkey;
			if key = enter then break;
			if key in [up, left] then dec(op);
			if key in [down, right] then inc(op);
			if op = 0 then op:= nOptions;
			if op = (nOptions + 1) then op:= 1;
		until false;
		horizontalMenu:= op;
	end;
	
	function upperCase(s: string): string;
	var i: integer;
	begin
		for i:= 1 to length(s) do
			s[i]:= upcase(s[i]);
			
		upperCase:= s;
	end;
	
end. 