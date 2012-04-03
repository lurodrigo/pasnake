program _snake;

uses Crt, SnakeLib;	
	
var snake: tSnake;
	block: array [1..100] of tTemporaryPoint;
	speed, auxBrightFood, contCrazyFood, blockFrequency: byte;
	foods, score, snakeLength, auxCrazyFood, blockLength: word;
	food: tPoint;
	brightFood, crazyFood: tTemporaryPoint;
	brightFoodOn, crazyFoodOn: Boolean;

	cheat: array [1..5] of tCheat;

	MainMenuOp, OptionsMenuOp, ColorsMenuOp: integer;

	chdcolor, hdcolor, color, hcolor, foodColor, brightFoodColor, crazyFoodColor, snakeColor: byte;

{ Logo procedures }

procedure drawLogo(x, y: byte); forward;

{ Essential procedures }

procedure initDefaults; forward;
procedure initSnake; forward;
procedure initGame; forward;
procedure initCheats; forward;

{ Gaming functions }

function inSnake(p: tPoint; ini: integer): boolean; forward;
function inBlock(p: tPoint): boolean; forward;
procedure increaseSnake; forward;
function isValidPosition(point: tPoint): boolean; forward;
function isCheat(password: string): integer; forward;
function oppositeTo(ch: char): char; forward;
procedure moveTo(ch: char; var lose: boolean); forward;
procedure play; forward;

{ Drawing procedures }

procedure restore; forward;
procedure drawHeader; forward;
procedure drawScenario; forward;
procedure drawSnake; forward;
procedure eraseSnake; forward;

{ Block related procedures }

procedure addBlock; forward;
procedure drawBlocks; forward;
procedure manageBlocks; forward;

{ Food related procedures }

procedure generateFood; forward;
procedure drawFood; forward;
procedure generateBrightFood; forward;
procedure drawBrightFood; forward;
procedure manageBrightFood; forward;
procedure generateCrazyFood; forward;
procedure manageCrazyFood; forward;
procedure moveCrazyFood; forward;
procedure drawCrazyFood; forward;
procedure eraseCrazyFood; forward;
procedure checkFoods; forward;

{ Best Scores }

var scoresFile: file of tRecordInfo;

procedure openScoresFile; forward;
function isRecord(score: word): boolean; forward;
procedure insertRecord(rec: tRecordInfo); forward;

{ Navigation menus }

procedure mainMenu; forward;
procedure bestScoresMenu; forward;
procedure cheatsMenu; forward;
function pauseMenu: boolean; forward;
function youLoseScreen: boolean; forward;
procedure optionsMenu; forward;
procedure colorsMenu; forward;

{ Logo procedures }

procedure drawLogo(x, y: byte);
const logoy = 23;
const logo: array [1..logoy] of string[80] = (
'   .. ... . . . . .                    ........................................',
'  . . ....... .....................Copyright 2009 By Luiz Rodrigo a.k.a LuLu...',
'..... . $NNNMNN....                     ... ... ....... Some rights reversed...',
'......DNMMNNMNDM:    .   .   .   .   .  ... ...$NNM.... ... ... ... ... ... ...',
'.....MMNMN8ZONNNN  .                    ... .. NNMN.... ... ... ... ... ... ...',
'. .. NMNMM  .NMDN ?NMN    . ..     ,NNMNND7... NNMN.... ... ... .+OZOO? ... ...',
'. .. NNNMM?  DMDN NMNMMNMNMNNN. .DMMMMMNNNMN.. NNMD. .,NNMMN .,NNMMMNMNND.   ..',
'......NNMMNNI .   NMMMNMMDMMDNM .NNNNMM8MMMNZ..MMMM. ZMMNNZ..ZMMDNMNMNMMM7  ...',
'....  .=MMDNNMN7  MNNN     OMNM$ MNNN~  MMNMN. MMNM NNMMM   ZMNND. ... NNM.  ..',
'....   ..,NDNMNDM MNNN     =NMDM     . .NMMNN .NMMMMNNMM... NDMD7.. .. NMM  ...',
'.........   MMNMM.NNND     :MMDN   8NMMMNNMMM  NMNMMNNN  .  MDNNNNMMNMNNNM~  ..',
'. .  .MNMZ   NDMN NNMM.     MMNM.8MMNMMMNMMNN. NMDNNMNNN,.  MNMMMMMNMMNNDN   ..',
'.....MMNM8II?NNDM NNNN.     MMMM,MMMNM. .NMNN..NMDMNMMNNM$  MMMNM..... . .. ...',
'. .  ~NNMNNMNMMD$ MDNM      NMMN:NNMNN ..MMMD  MMNDM.MNNMMM MMNDM.    MNND   ..',
'. ..  INNNMMNMN. .MNNM      MMMN MNNNMMNMDMMN .MMNDM,.ZMNMMZ.MNMNNNMMNMMN=.....',
'.  .   .?ND$.     .NNM      N v 1.0 final NNM .NNMMN ...NN. ..DNNMNMNMMN... ...',
'.                                        $= ..  ..  ..  ..  ..  :NMNN7. ..  ...',
'.........  Chuck Norris Quality Seal . ........................................',
'.                                        .   .   .   .   .   .   .   .   .   ..',
'.   Licensed by Chuck Norris Software Attribution 3.0:     .  .  .   ..   .... ',
'.   Chuck Norris is watching you... ..   .   .   .   .   .   .   .   ..   .... ',
'   .. ... . . . . .                    ........................................',
'      .. ... . . . . .                    .....................................'
);
var i: integer;
begin
	for i:= 1 to logoy do begin
		gotoxy(x, y + i - 1);
		writeln(logo[i]);
	end;
end;

{ Essential }

procedure initDefaults;
begin
	randomize;

	color:= lightgray;
	hcolor:= white;

	foodColor:= green;
	brightFoodColor:= yellow + blink;
	crazyFoodColor:= red + blink;
	snakeColor:= white;

	MainMenuOp:= 1;
	OptionsMenuOp:= 1;
	ColorsMenuOp:= 1;

	BlockFrequency:= 3;
	brightFoodOn:= true;
	crazyFoodOn:= true;
	speed:= 5;
	initCheats;
end;

procedure initSnake;
var i: integer;
begin
	snakeLength:= 3;
	snake[1].x:= width div 2;
	snake[1].y:= height div 2;

	for i:=2 to SnakeLength do begin
		snake[i].x:= snake[i - 1].x - 1;
		snake[i].y:= snake[i - 1].y;
	end;
end;

procedure initGame;
begin
	blockLength:= 0;
	auxBrightFood:= 0;
	brightfood.plays:= 0;
	auxCrazyFood:= 0;
	crazyfood.plays:= 0;
	score:= 0;
	foods:= 0;
	hdcolor:= snakecolor;
	chdcolor:= 0;
	drawScenario;
	initSnake;
	drawSnake;
	generateFood;
end;

procedure initCheats;
begin	
	cheat[PhantomCheat].password:= 'PHNTMFTHPR';
	cheat[PhantomCheat].description:= 
'With "Phantom of the Opera" cheat, you can go within the walls! If you go into a wall, you''ll appear at the opposite wall.';
	cheat[PhantomCheat].activated:= false;
	
	cheat[ChildCheat].password:= 'PTRPN';
	cheat[ChildCheat].description:= 
'With "Peter Pan" cheat, the snake will ever be little and won''t ever grow, like your dick.';
	cheat[ChildCheat].activated:= false;
	
	cheat[SlowlyCrazyFoodCheat].password:= 'SPDFLGHT';
	cheat[SlowlyCrazyFoodCheat].description:= 
'With "Speed of Light" cheat, the crazy food will move less frequently.';
	cheat[SlowlyCrazyFoodCheat].activated:= false;
	
	cheat[BrightFoodForeverCheat].password:= 'KNGFYMMK';
	cheat[BrightFoodForeverCheat].description:= 
'With "King of Yamimakai" cheat, there will ever be a bright food.';
	cheat[BrightFoodForeverCheat].activated:= false;
	
	cheat[CrazyFoodForeverCheat].password:= 'VDLKCMDNTBDSS';
	cheat[CrazyFoodForeverCheat].description:= 
'With "Vida Loka Comanda NT Obedesse" cheat, there will ever be a crazy food.';
	cheat[CrazyFoodForeverCheat].activated:= false;
end;

{ Gaming }

function inSnake(p: tPoint; ini: integer): boolean;
var i: integer;
begin
	for i:= ini to snakeLength do
		if (p.x = snake[i].x) and (p.y = snake[i].y) then begin
			inSnake:= true;
			exit;
		end;

	inSnake:= false;
end;

function inBlock(p: tPoint): boolean;
var i: integer;
begin
	if blockFrequency = 0 then begin
		inBlock:= false;
		exit;
	end;

	for i:= 1 to blockLength do
		if ( p.x = block[i].x) and ( p.y = block[i].y ) then begin
			inBlock:= true;
			exit;
		end;

	inBlock:= false;
end;

procedure increaseSnake;
begin
	inc(snakeLength);
	snake[snakeLength]:= snake[snakeLength - 1];
        if snake[1].x <> (snake[snakeLength].x + 1) then
           inc(snake[snakeLength].x)
        else if snake[1].x <> (snake[snakeLength].x - 1) then
             dec(snake[snakeLength].x)
        else if snake[1].y <> (snake[snakeLength].y - 1) then
             dec(snake[snakeLength].y)
        else if snake[1].y <> (snake[snakeLength].y - 1) then
             inc(snake[snakeLength].y)
        else dec(snakeLength);
end;

function isValidPosition(point: tPoint): boolean;
begin
	isValidPosition:= (point.x in [1..width]) and (point.y in [1..height]) and not inBlock(point);
end;

function oppositeTo(ch: char): char;
begin
	if ch = up then oppositeTo:= down
	else if ch = down then oppositeTo:= up
	else if ch = left then oppositeTo:= right
	else if ch = right then oppositeTo:= left
	else oppositeTo:= #0;
end;

procedure moveTo(ch: char; var lose: boolean);
var i: integer;
begin
	manageBlocks;
	
	if not (ch in [up, down, left, right]) then exit;

	for i:=snakeLength downto 2 do
		snake[i]:= snake[i - 1];

	case ch of
	up: dec(snake[1].y);
	down: inc(snake[1].y);
	left: dec(snake[1].x);
	right: inc(snake[1].x);
	end;

	if cheat[PhantomCheat].activated then
		if snake[1].x = 0 then
		   snake[1].x:= width
		else if snake[1].y = 0 then
			 snake[1].y:= height
		else if snake[1].x = (width + 1) then
			 snake[1].x:= 1
		else if snake[1].y = (height + 1) then
			 snake[1].y:= 1;

	if inSnake(snake[1], 2) or (not isValidPosition(snake[1])) then begin
		lose:= true;
		exit;
	end;
	checkFoods;
	lose:= false;

end;

procedure play;
var mov, movaux, mov2: char;
	lose, quit: boolean;
	i: integer;
	cont: array [1..5] of integer;
begin
	repeat
		mov:= right;
		movaux:= right;
		mov2:= right;
		for i:= 1 to 5 do
			cont[i]:= 0;
		repeat
			delay( (10 - speed) * 50 div 3);

			if blockFrequency > 0 then begin

				for i:=1 to blockFrequency do begin
					if cont[i] = 0 then
						cont[i]:= 50 + random(50) + random(100) + random(i * i);
					if cont[i] = 1 then
						addBlock;
					if cont[i] > 0 then
						dec(cont[i]);
				end;
			end;

			mov2:= movaux;
 			movaux:= mov;
			if keypressed then
				mov:= readkey;
			if mov = oppositeTo(mov2) then
				mov:= mov2;

			if mov = esc then
				if pauseMenu then begin
					for i:= 1 to 5 do
						cheat[i].activated:= false;
					exit;
				end
				else begin
					mov:= mov2;
					restore;
				end;

			eraseSnake;
			moveTo(mov, lose);
			if lose then begin
				drawSnake;
				delay(1000);
				if youLoseScreen then begin
					initGame;
					auxBrightFood:= 0;
					break;
				end
				else exit;
			end;
			drawSnake;
		until false;
	until false;
end;

{ Drawing }

procedure restore;
begin
	drawScenario;
	drawSnake;
	if blockFrequency > 0 then
		drawBlocks;
	drawFood;
	if BrightFoodOn and (brightFood.plays <> 0) then
		drawBrightFood;
	if CrazyFoodOn and (crazyFood.plays <> 0) then
		drawCrazyFood;
end;

procedure drawHeader;
begin
	textcolor(color);
	gotoxy(1, 1);
	write('Speed: ');
	textcolor(hcolor);
	write(speed:2,'x');

	textcolor(color);
	gotoxy(20, 1);
	write('Block frequency: ');
	textcolor(hcolor);
	write(blockFrequency:2,'x');

	textcolor(color);
	gotoxy(50, 1);
	write('Foods: ');
	textcolor(hcolor);
	write(foods:2);

	textcolor(color);
	gotoxy(69, 1);
	write('Score: ');
	textcolor(hcolor);
	write(score:4);
end;

procedure drawScenario;
var i: integer;
begin
	clrscr;
	drawHeader;
	textcolor(color);
	gotoxy(minX, minY);
	for i:=minX to (minX + width + 1) do
		write(fillHoriz);

	gotoxy(minX, minY + height + 1);
	for i:=minX to (minx + width + 1) do
		write(fillHoriz);

	for i:=minY to (minY + height + 1) do begin
		gotoxy(minX, i);
		write(fillVert);
		gotoxy(minX + width + 1, i);
		write(fillVert);
	end;

	gotoxy(minX, minY);
	write(fillNW);
	gotoxy(minX + width + 1, minY);
	write(fillNE);
	gotoxy(minX, minY + height + 1);
	write(fillSW);
	gotoxy(minX + width + 1, minY + height + 1);
	write(fillSE);
end;

procedure drawSnake;
var i: integer;
begin

	textcolor(snakeColor);
	for i:=2 to snakeLength do begin
		gotoxy(snake[i].x + minX, snake[i].y + minY);
		write(snakeBody);
	end;

	textcolor(hdcolor);
	gotoxy(snake[1].x + minX, snake[1].y + minY);
	write(snakeHead);

	textcolor(color);
end;

procedure eraseSnake;
var i: integer;
begin
	for i:=1 to snakeLength do begin
		gotoxy(snake[i].x + minX, snake[i].y + minY);
		write(' ');
	end;
end;

{ Blocks }

procedure addBlock;
begin
	repeat
		block[blockLength + 1].x:= random(width - 1) + 1;
		block[blockLength + 1].y:= random(height - 1) + 1;
	until (not inSnake(food, 1)) and
			( (block[blockLength + 1].x <> food.x) or (block[blockLength + 1].y <> food.y) ) and
			( (block[blockLength + 1].x <> brightFood.x) or (block[blockLength + 1].y <> brightFood.y) ) and
			( (block[blockLength + 1].x <> crazyFood.x) or (block[blockLength + 1].y <> crazyFood.y) ) and
                        (abs( snake[1].x - block[blockLength + 1].x ) >= 3) and
                        (abs( snake[1].y - block[blockLength + 1].y ) >= 3);
	inc(blockLength);
	block[blockLength].plays:= 100 * ( 10 - blockFrequency ); 
	gotoxy(block[blockLength].x + minX, block[blockLength].y + minY);
	write(blockChar);
end;

procedure drawBlocks;
var i: integer;
begin
	for i:= 1 to blockLength do begin
		gotoxy(block[i].x + minX, block[i].y + minY);
		write(blockChar);
	end;
end;

procedure manageBlocks;
var i, j: integer;
begin
	for i:= 1 to BlockLength do
		if block[i].plays = 0 then begin
			gotoxy(block[i].x + minX, block[i].y + minY);
			write(' ');
			for j:= i  to blockLength - 1 do
				block[j]:= block[j + 1];
			dec(blockLength);
		end
		else
			dec(block[i].plays);
end;

{ Foods }

procedure generateFood;
begin
	repeat
		food.x:= random(width - 1) + 1;
		food.y:= random(height - 1) + 1;
	until not inSnake(food, 1) and not inBlock(food);
	drawFood;
end;

procedure drawFood;
begin
	textcolor(foodColor);
	gotoxy(minX + food.x, minY + food.y);
	write(foodChar);
	textcolor(color);
end;

procedure generateBrightFood;
begin
	repeat
		brightFood.x:= random(width - 1) + 1;
		brightFood.y:= random(height - 1) + 1;
	until not inSnake(brightFood, 1) and not((brightFood.x = food.x) and (brightFood.y = food.y)) and not inBlock(brightFood);
	brightFood.plays:= 30 + random(30) + abs(snake[1].x - brightFood.x) + abs(snake[1].y - brightFood.y);
	drawBrightFood;
end;

procedure drawBrightFood;
begin
	textcolor(brightFoodColor);
	gotoxy(minX + brightFood.x, minY + brightFood.y);
	write(foodChar);
	textcolor(color);
end;

procedure manageBrightFood;
begin
	if auxBrightFood = 1 then begin
		generateBrightFood;
		dec(auxBrightFood);
	end;
	
	if brightFood.plays > 0 then begin
		dec(brightFood.plays);
		exit;
	end;
	
	if brightFood.plays = 0 then begin
		gotoxy(brightFood.x + minX, brightFood.y + MinY);
		write(' ');
	end;
	
	if cheat[BrightFoodForeverCheat].activated then
		auxBrightFood:= 1
	else if auxBrightFood = 0 then
		auxBrightFood:= random(250)
	else
		dec(auxBrightFood);
end;

procedure generateCrazyFood;
begin
	repeat
		crazyFood.x:= random(width - 1) + 1;
		crazyFood.y:= random(height - 1) + 1;
	until not inSnake(crazyFood, 1) and not inBlock(crazyFood) and
			not( (crazyFood.x = food.x) and (crazyFood.y = food.y)) and
			not( (crazyFood.x = brightFood.x) and (crazyFood.y = brightFood.y));

	crazyFood.plays:= 10 + random(20) + abs(snake[1].x - crazyFood.x) + abs(snake[1].y - crazyFood.y);
	drawCrazyFood;
end;

procedure manageCrazyFood;
begin
	if auxCrazyFood = 1 then begin
		generateCrazyFood;
		
		if cheat[SlowlyCrazyFoodCheat].activated then
			contCrazyFood:= 6;
		dec(auxCrazyFood);
	end;
	
	if crazyFood.plays > 0 then begin
		dec(crazyFood.plays);
		
		if cheat[SlowlyCrazyFoodCheat].activated then begin
			if contCrazyFood = 0 then begin
				contCrazyFood:= 6;
				eraseCrazyFood;
				moveCrazyFood;
				drawCrazyFood;
			end
			else 
				dec(contCrazyFood);
		end
		else begin
			eraseCrazyFood;
			moveCrazyFood;
			drawCrazyFood;
		end;
		
		exit;
	end;
	
	if crazyFood.plays = 0 then begin
		gotoxy(crazyFood.x + minX, crazyFood.y + MinY);
		write(' ');
	end;
	
	if cheat[CrazyFoodForeverCheat].activated then
		auxCrazyFood:= 1
	else if auxCrazyFood = 0 then
		auxCrazyFood:= 100 + random(500)
	else
		dec(auxCrazyFood);
end;

procedure moveCrazyFood;
var aux: tPoint;
	r, c: integer;
begin
	c:= 0;

	repeat
		inc(c);
		aux:= crazyFood;
		r:= random(4) + 1;
		if c = 10 then exit;
		case r of
		1: dec(aux.x);
		2: inc(aux.x);
		3: dec(aux.y);
		4: inc(aux.y);
		end;
	until (isValidPosition(aux) and not inSnake(aux, 1)) and 
			not( (crazyFood.x = food.x) and (crazyFood.y = food.y)) and
			not( (crazyFood.x = brightFood.x) and (crazyFood.y = brightFood.y));

	crazyFood.x:= aux.x;
	crazyFood.y:= aux.y;

end;

procedure drawCrazyFood;
begin
	textcolor(CrazyFoodColor);
	gotoxy(minX + crazyFood.x, minY + crazyFood.y);
	write(foodChar);
	textcolor(color);
end;

procedure eraseCrazyFood;
begin
	gotoxy(minX + crazyFood.x, minY + crazyFood.y);
	write(' ');
end;

procedure checkFoods;
var i, aux: integer;
	b: boolean;
begin
	b:= false;
	if (snake[1].x = food.x) and (snake[1].y = food.y) then	begin
		hdcolor:= foodcolor;
		chdcolor:= 15;
		b:= true;

		inc(foods);
		inc(score, speed + blockFrequency);
		drawHeader;
		generateFood;
		if not cheat[ChildCheat].activated then
			increaseSnake;
	end;

	if BrightFoodOn then begin
		if (brightFood.plays <> 0) and (snake[1].x = brightFood.x) and (snake[1].y = brightFood.y) then	begin
			hdcolor:= brightFoodColor - blink;
			chdcolor:= 15;
			b:= true;

			inc(foods);
			aux:= random(3) + 3;
			inc(score, (speed + blockFrequency) * brightFood.plays div aux);
			drawHeader;
			auxBrightFood:= 0;
			brightFood.plays:= 0;
			
			if not cheat[ChildCheat].activated then
				for i:=1 to aux do
					increaseSnake;
		end;

		manageBrightFood;
	end;

	if CrazyFoodOn then begin
		if (crazyFood.plays <> 0) and (snake[1].x = crazyFood.x) and (snake[1].y = crazyFood.y) then begin
			hdcolor:= CrazyFoodColor - blink;
			chdcolor:= 15;
			b:= true;

			inc(foods);
			aux:= random(2) + 3;
			inc(score, (speed + blockFrequency) * crazyFood.plays * aux);

			drawHeader;
			auxCrazyFood:= 0;
			crazyFood.plays:= 0;
			
			if not cheat[ChildCheat].activated then
				for i:= 1 to aux do
					increaseSnake;
		end;

		manageCrazyFood;
	end;

	if chdcolor > 0 then begin
		dec(chdcolor);
		exit;
	end;
	if b then exit;
	hdcolor:= snakeColor;
end;

{ Best Scores }

procedure openScoresFile;
begin
	assign(scoresFile, 'records.snk');
	{$I-}
	reset(scoresFile);
	{$I+}
	if IOResult <> 0 then begin
		rewrite(scoresFile);
		reset(scoresFile);
	end;
end;

function isRecord(score: word): boolean;
var rInfo: tRecordInfo;
begin
	openScoresFile;

	if filesize(scoresFile) < 5 then begin
		isRecord:= true;
		exit;
	end;

	while not eof(scoresFile) do begin
		read(scoresFile, rInfo);
		if (score > rInfo.score) then begin
			isRecord:= true;
			close(scoresFile);
			exit;
		end;
	end;
	isRecord:= false;
	close(scoresFile);
end;

procedure insertRecord(rec: tRecordInfo);
var s: array [1..5] of tRecordInfo;
	len, i, j: integer;
begin
	openScoresFile;

	len:= 0;
	while (not eof(scoresFile)) and (filepos(scoresFile) < 5) do begin
		inc(len);
		read(scoresFile, s[len]);
	end;

	if len < 5 then
		inc(len);

	for i:= 1 to len do
		if rec.score > s[i].score then
			break;

	for j:= len downto i + 1 do
		s[j]:= s[j - 1];

	s[i]:= rec;
	seek(scoresFile, 0);
	for i:= 1 to len do
		write(scoresFile, s[i]);

	close(scoresFile);
end;

{ Menus }

procedure mainMenu;
var menuop: tMenuOptions;
begin
	repeat
		clrscr;
		textcolor(color);
		drawLogo(1, 3);
		menuop[1]:= 'New Game';
		menuop[2]:= 'Best Scores';
		menuop[3]:= 'Cheats';
		menuop[4]:= 'Options';
		menuop[5]:= 'Exit';
		MainMenuOP:= selectMenu(menuop, 5, 30, 30, color, hcolor, MainMenuOp);
		case MainMenuOp of
		1: begin
			initGame;
			play;
			end;
		2: bestScoresMenu;
		3: cheatsMenu;
		4: optionsMenu;
		5, 6: exit;
		end;
	until false;
end;

procedure bestScoresMenu;
var rec: tRecordInfo;
	i: integer;
begin
	i:= 0;
	
	clrscr;
	textcolor(color);
	drawLogo(1, 3);
	
	textcolor(hcolor);
	
	gotoxy(35, 30);
	write('Blacklist');
	gotoxy(25, 32);
	write('Nick');
	gotoxy(50, 32);
	write('Score');
	
	openScoresFile;
	textcolor(color);
	while not eof(scoresFile) do begin
		inc(i);
		read(scoresFile, rec);
		gotoxy(25, 34 + 2 * filepos(scoresFile));
		write(rec.name);
		gotoxy(50, 34 + 2 * filepos(scoresFile));
		write(rec.score:5);
	end;
	close(scoresFile);
	readkey;
end;

function isCheat(password: string): integer;
var i: integer;
begin
	for i:= 1 to 5 do
		if upperCase(password) = cheat[i].password then begin
			isCheat:= i;
			exit;
		end;

	isCheat:= 0;
end; 

procedure cheatsMenu;
var password: string[20];
	menu: TMenuOptions;
	i, op: integer;
begin
	menu[1]:= 'Activate';
	menu[2]:= 'Deactivate';
	menu[3]:= 'Exit';
	repeat
		clrscr;
		textcolor(color);
		drawLogo(1, 3);
		
		textcolor(hcolor);
		gotoxy(30, 30);
		write('Password: ');
		
		textcolor(color);
		readln(password);
		
		if password = '' then 
			exit;
		
		i:= isCheat(password);
		
		if i = 0 then begin	
			gotoxy(32, 32);
			textcolor(hcolor);
			writeln('Invalid Password');
			readkey;
		end
		else begin
			textcolor(hcolor);
			
			gotoxy(1, 32);
			write('Password: ');
			textcolor(color);
			writeln(cheat[i].password);
			
			textcolor(hcolor);
			write('Description: ');
			textcolor(color);
			writeln(cheat[i].description);
			
			textcolor(hcolor);
			write('Status: ');
			textcolor(color);
			if cheat[i].activated then
				writeln('on')
			else
				writeln('off');
				
			op:= horizontalMenu(menu, 3, 27, 40, color, hcolor, 2);
			case op of
			1: begin
				cheat[i].activated:= true;
				textcolor(hcolor);
				gotoxy(30, 44);
				write('Activate Successfull!');
				end;
			2: begin
				cheat[i].activated:= false;
				textcolor(hcolor);
				gotoxy(29, 44);
				write('Deactivate Succesfull!');
				end;
			3: exit;
			end;
			readkey;
		end;
	until false;		
end;

function pauseMenu: boolean;
var menuop, menuop2: tMenuOptions;
	op, op2: integer;
begin
	
	menuop[1]:= 'Resume';
	menuop[2]:= 'Quit game';
	
	repeat
		clrscr;		
		textcolor(color);
		drawLogo(1, 3);
		op:= selectMenu(menuop, 2, 30, 30, color, hcolor, 1);
		case op of 
		1: begin
			pauseMenu:= false;
			exit;
		end;
		2: begin
			textcolor(color);
			gotoxy(25, 39);
			write('Are you sure you want to quit?');
			
			menuop2[1]:= 'Yes';
			menuop2[2]:= 'No';
			op:= horizontalMenu(menuop2, 2, 35, 41, color, hcolor, 2); 
			if op = 1 then begin
				pauseMenu:= true;
				exit;
			end;
			end;
		end;
	until false;
end;

function youLoseScreen: boolean;
var menuop: tMenuOptions;
	rec: tRecordInfo;
	isrec: boolean;
	i: integer;
begin
	clrscr;
	textcolor(color);
	drawLogo(1, 3);
	
	while keypressed do readkey;
	
	if score >= 5000 then begin
		gotoxy(64, 8);
		write('# ',cheat[5].password);
	end;
	if score >= 3750 then begin
		gotoxy(64, 10);
		write('# ',cheat[4].password);
	end;
	if score >= 2500 then begin
		gotoxy(64, 12);
		write('# ',cheat[3].password);
	end;
	if score >= 1500 then begin
		gotoxy(64, 14);
		write('# ',cheat[2].password);
	end;
	if score >= 800 then begin
		gotoxy(64, 16);
		write('# ',cheat[1].password);
	end;
	
	isrec:= isRecord(score);
	
	for i:= 1 to 5 do
		cheat[i].activated:= false;
		
	if isrec then begin
		textColor(blue);
		gotoxy(29, 30);	
		write('You are a new recordist!');
	end
	else begin
		gotoxy(34, 32);	
		textColor(red);
		write('You are a loser!');
	end;
	
	textColor(color);
	gotoxy(34, 34);
	write('Your score: ', score:3);
	
	if isrec then begin
		gotoxy(34, 32);
		write('Your nick: ');
		readln(rec.name);
		rec.score:= score;
		insertRecord(rec);
	end;
	
	gotoxy(36, 38);
	write('Play Again?');
	
	menuOp[1]:= 'Yes';
	menuOp[2]:= 'No';
	if horizontalMenu(menuop, 2, 37, 40, color, hcolor, 1) = 1 then
		youLoseScreen:= true
	else
		youLoseScreen:= false;
	
end;

procedure optionsMenu;
var menuOp: tMenuOptions;
	op, aux: integer;
begin
	menuop[5]:= 'Colors';

	repeat
		clrscr;
		
		textcolor(color);
		drawLogo(1, 3);
		
		menuop[1]:= 'Snake Speed       ';
		menuop[2]:= 'Bright Food       ';
		menuop[3]:= 'Crazy Food        ';
		menuop[4]:= 'Block Frequency   ';
		
		menuop[1]:= menuop[1] + '  ' + chr(speed + ord('0'));
		
		if brightFoodOn then
			menuop[2]:= menuop[2] + ' on'
		else
			menuop[2]:= menuop[2] + 'off';
			
		if crazyFoodOn then
			menuop[3]:= menuop[3] + ' on'
		else
			menuop[3]:= menuop[3] + 'off';
		
		menuop[4]:= menuop[4] + '  ' + chr(blockFrequency + ord('0'));
		
		aux:= selectMenu(menuop, 5, 30, 30, color, hcolor, optionsMenuOp);
		if (aux <= 5) then
			optionsMenuOp:= aux;
		case aux of
		1: begin
			textcolor(hcolor);
			gotoxy(53, 32);
			readln(aux);
			if aux in [1..9] then
				speed:= aux;
			end;
		2: brightFoodOn:= not brightFoodOn;
		3: crazyFoodOn:= not crazyFoodOn;
		4: begin
			textcolor(hcolor);
			gotoxy(53, 38);
			readln(aux);
			if aux in [0..5] then
				blockFrequency:= aux;
			end;
		5: colorsMenu;
		6: exit;
		end;
	until false;
end;

procedure colorsMenu;
var menuop, colors: tMenuOptions;
	i, op, aux: integer;
begin	
	colors[1]:=  'Black         ';
	colors[2]:=  'Blue          ';
	colors[3]:=  'Green         ';
	colors[4]:=  'Cyan          ';
	colors[5]:=  'Red           ';
	colors[6]:=  'Magenta       ';
	colors[7]:=  'Brown         ';
	colors[8]:=  'Light Gray    ';
	colors[9]:=  'Dark Gray     ';
	colors[10]:= 'Light Blue    ';
	colors[11]:= 'Light Green   ';
	colors[12]:= 'Light Cyan    ';
	colors[13]:= 'Light Red     ';
	colors[14]:= 'Light Magenta ';
	colors[15]:= 'Yellow        ';
	colors[16]:= 'White         ';
	
	repeat
		clrscr;
		textcolor(color);
		drawLogo(1, 3);
		menuop[1]:= 'Main Color           ' + colors[color + 1];
		menuop[2]:= 'Highlighted Color    ' + colors[hcolor + 1];
		menuop[3]:= 'Snake Color          ' + colors[snakeColor + 1];
		menuop[4]:= 'Food Color           ' + colors[foodColor + 1];
		menuop[5]:= 'Bright Food Color    ' + colors[brightFoodColor - blink + 1];
		menuop[6]:= 'Crazy Food Color     ' + colors[crazyFoodColor - blink + 1];
		op:= selectMenu(menuop, 6, 15, 30, color, hcolor, ColorsMenuOp);
		if op <= 6 then begin
			ColorsMenuOp:= op;
			case op of
			1: aux:= selectMenu(colors, 16, 60, 10, color, hcolor, color + 1);
			2: aux:= selectMenu(colors, 16, 60, 10, color, hcolor, hcolor + 1);
			3: aux:= selectMenu(colors, 16, 60, 10, color, hcolor, snakeColor + 1);
			4: aux:= selectMenu(colors, 16, 60, 10, color, hcolor, foodColor + 1);
			5: aux:= selectMenu(colors, 16, 60, 10, color, hcolor, brightFoodColor - blink + 1);
			6: aux:= selectMenu(colors, 16, 60, 10, color, hcolor, crazyFoodColor - blink + 1);
			end;
			if (aux - 1) in [black .. white] then 
				case op of
				1: color:= aux - 1;
				2: hcolor:= aux - 1;
				3: snakeColor:= aux - 1;
				4: foodColor:= aux - 1;
				5: brightFoodColor:= aux - 1 + blink;
				6: crazyFoodColor:= aux - 1 + blink;
				end;
		end
		else exit;
	until false;

end;

{ Main Block }

begin
	initDefaults;
	mainMenu;
end. 