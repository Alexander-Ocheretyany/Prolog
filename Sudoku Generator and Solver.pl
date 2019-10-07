%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Course project of Alexander Ocheretyany %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sudoku generator %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  22/05/2018 Charles University, Prague %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=Generator=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate(-Puzzle) :- Starts the puzzle generator without solution
generate(Puzzle) :- write('\nWelcome!'),
				    nl,
					write('\nThis program generates a random sudoku puzzle. '),
					write('A puzzle is given by a number of horizontal (width) and vertical (height) cells.'),
					nl,
					write('\n-> Please, set the size of a puzzle in the form Width * Height (don\'t forget to put a dot after it): '),
					nl,
					read(X * Y),
					write('\nPlease, set difficulty (1-3): '),
					read(D),
					D =< 3,
					D >= 1,
					(repeat,
                                        makePuzzle(X, Y, D, Puzzle),
                                        solve(X, Y, Puzzle, Solution1),
                                        solve(X, Y, Puzzle, Solution2),
                                        solve(X, Y, Puzzle, Solution3),
                                        Solution1 == Solution2,
                                        Solution2 == Solution3,
                                        writeln('\nPuzzle:\n'),
                                        printPuzzle(Puzzle, X, Y),
					!);
					write('\nERROR\n'),
					!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate(-Puzzle, -Solution) :- Starts the puzzle generator and gives the solution
generate(Puzzle, Solution) :- write('\nWelcome!'),
							  nl,
							  write('\nThis program generates a random sudoku puzzle. '),
							  write('A puzzle is given by a number of horizontal (width) and vertical (height) cells.'),
							  nl,
							  write('\n-> Please, set the size of a puzzle in the form Width * Height (don\'t forget to put a dot after it): '),
							  nl,
							  read(X * Y),
							  write('\nPlease, set difficulty (1-3): '),
							  read(D),
							  D =< 3,
							  D >= 1,
                                                          (repeat,
                                                          makePuzzleAndSolution(X, Y, D, Puzzle, Solution),
                                                          solve(X, Y, Puzzle, Solution1),
                                                          solve(X, Y, Puzzle, Solution2),
                                                          solve(X, Y, Puzzle, Solution3),
                                                          Solution1 == Solution2,
                                                          Solution2 == Solution3,
                                                          writeln('\nPuzzle:\n'),
                                                          printPuzzle(Puzzle, X, Y),
                                                          writeln('\nSolution:\n'),
                                                          printPuzzle(Solution, X, Y),
                                                          !);
							  write('\nERROR\n'),
							  !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% makePuzzle(+Width, +Height, +Difficulty, -Puzzle) :- Creates a puzzle of a given size with a given difficulty
makePuzzle(Width, Height, Difficulty, Randomized) :- generatePuzzle(Width, Height, Puzzle),
						     numberOfEmptyPlaces(Difficulty, Width, Height, Number),
						     randomize(Number, Height, Width, Puzzle, Randomized).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% makePuzzleAndSolution(+Width, +Height, +Difficulty, -Puzzle, -Solution) :- Creates a puzzle of a given size with a given difficulty and gives the solution
makePuzzleAndSolution(Width, Height, Difficulty, Randomized, Puzzle) :- generatePuzzle(Width, Height, Puzzle),
									numberOfEmptyPlaces(Difficulty, Width, Height, Number),
									randomize(Number, Height, Width, Puzzle, Randomized).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% numberOfEmptyPlaces(+Difficulty, +Width, +Height, -Number) :- Number is a number of empty places in each row of a puzzle
numberOfEmptyPlaces(_, 1, _, 0) :- !.
numberOfEmptyPlaces(_, _, 1, 0) :- !.
numberOfEmptyPlaces(1, Width, Height, Number) :- Width > 1,
						 Height > 1,
						 Number is Width - 1,
						 !.
numberOfEmptyPlaces(2, Width, Height, Number) :- Width > 1,
						 Height > 1,
						 Number is Width,
						 !.
numberOfEmptyPlaces(3, Width, Height, Number) :- Width > 1,
                                                 Height > 1,
                                                 Max is Width * Height,
                                                 T is Max mod 2,
                                                 T \= 0,
                                                 K is Width div 2 - 1,
                                                 Number is Max div 2 + 1 - (K * 2),
						 !.
numberOfEmptyPlaces(3, Width, Height, Number) :- Width > 1,
                                                 Height > 1,
                                                 Max is Width * Height,
                                                 T is Max mod 2,
                                                 T == 0,
                                                 K is Width div 2 - 1,
                                                 Number is Max div 2 - (K * 2),
						 !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generatePuzzle(+Width, +Height, -Puzzle) :- Puzzle is a sudoku puzzle of size Width * Height
generatePuzzle(Width, Height, Puzzle) :- emptyPuzzle(Width, Height, EmptyPuzzle),
                                         Max is (Width * Height) ^ 2,
                                         generatePuzzle(Max, 0, 1, Height, Width, EmptyPuzzle, Puzzle),
                                         !.
generatePuzzle(Max, PosX, PosY, _, _, PuzzleToFill, PuzzleToFill) :- R is PosX * PosY,
                                                                     R == Max.
generatePuzzle(Max, PosX, PosY, Height, Width, PuzzleToFill, Puzzle) :- R is PosX * PosY,
                                                                        R \= Max,
                                                                        NextX is (PosX + 1) mod (Width * Height + 1),
                                                                        NextX == 0,
                                                                        NextY is PosY + 1,
                                                                        addRandomNumber(NextY, 1, Height, Width, PuzzleToFill, AuxPuzzle),
                                                                        generatePuzzle(Max, 1, NextY, Height, Width, AuxPuzzle, Puzzle).
generatePuzzle(Max, PosX, PosY, Height, Width, PuzzleToFill, Puzzle) :- R is PosX * PosY,
                                                                        R \= Max,
                                                                        NextX is (PosX + 1) mod (Width * Height + 1),
                                                                        NextX \= 0,
                                                                        addRandomNumber(PosY, NextX, Height, Width, PuzzleToFill, AuxPuzzle),
                                                                        generatePuzzle(Max, NextX, PosY, Height, Width, AuxPuzzle, Puzzle).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getRow(+Num, +Height, +Xs, -Row) :- Row is the Num-th row of a sudoku puzzle Xs
getRow(Num, Height, Xs, Row) :- R is Num mod Height,
                                R \= 0,
                                P is Num div Height + 1,
                                getRowCells(P, Xs, Cells),
                                getRowInCells(R, Cells, [], Rs),
                                buildList(Rs, [], Row),
								!.
getRow(Num, Height, Xs, Row) :- R is Num mod Height,
                                R == 0,
                                P is Num div Height,
                                getRowCells(P, Xs, Cells),
                                getRowInCells(Height, Cells, [], Rs),
                                buildList(Rs, [], Row),
								!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getRowCells(+Num, +Xs, -Row) :- Row is the Num-th row of cells from a sudoku puzzle Xs
getRowCells(1, [Row|_], Row) :- !.
getRowCells(Num, [_|Xs], Row) :- Num \= 1,
                                 K is Num - 1,
                                 getRowCells(K, Xs, Row).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getRowInCells(+Num, +Cells, +Acc, -Row) :- Row is the Num-th row of Cells
getRowInCells(_, [], Acc, Acc) :- !.
getRowInCells(_, [[]|_], Acc, Acc) :- !.
getRowInCells(1, [X|Xs], Acc, Row) :- X = [A|_],
                                      append(Acc, [A], Rcc),
                                      getRowInCells(1, Xs, Rcc, Row).
getRowInCells(Num, Cells, Acc, Row) :- Num \= 1,
                                       K is Num - 1,
                                       cutCells(K, Cells, Result),
                                       getRowInCells(1, Result, Acc, Row).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cutTopCells(+Xs, -Rs) :- Rs is the sudoku puzzle left after cutting the top most cells of Xs
cutTopCells([], []) :- !.
cutTopCells([_|Xs], Xs) :- !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cutCells(+Num, +Cells, -Result) :- Result is the set of Cells without first Num-th rows
cutCells(0, Cells, Cells) :- !.
cutCells(Num, Cells, Result) :- Num \= 0,
                                cutHead(Cells, [], Offcut),
                                K is Num - 1,
                                cutCells(K, Offcut, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cutHead(+Cells, +Acc, -Offcut) :- Offcut is a set of Cells without the first row
cutHead(Cells, _, Cells) :- Cells = [[]|_],
						!.
cutHead([], Acc, Acc) :- !.
cutHead([X|Xs], Acc, Offcut) :- X = [_|B],
                                append(Acc, [B], Rcc),
                                cutHead(Xs, Rcc, Offcut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% buildList(+Xss, +Acc, -Xs) :- Xs is the list made of lists of Xss
buildList([], Acc, Acc) :- !.
buildList([X|Xs], Acc, Result) :- append(Acc, X, R),
                                  buildList(Xs, R, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% areDifferent(+Xs) :- returns true if all elements of Xs are different
areDifferent([]) :- !.
areDifferent([X|Xs]) :- differentFrom(Xs, X),
                        areDifferent(Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% differentFrom(+Xs, +A) :- returns true if all elements of Xs are different from A
differentFrom([], _) :- !.
differentFrom([X|Xs], A) :- X \= A,
                            differentFrom(Xs, A).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% listsAreDifferent(+Xs, +Ys) :- returns true if Xs and Ys have different elements
listsAreDifferent([], _) :- !.
listsAreDifferent(_, []) :- !.
listsAreDifferent([X|Xs], Ys) :- differentFrom(Ys, X),
                                 listsAreDifferent(Xs, Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cellToList(+Cell, +Acc, -Xs) :- Xs is the list of all elements of Cell
cellToList([], Acc, Acc) :- !.
cellToList([Y|Ys], Acc, Xs) :- append(Acc, Y, Rs),
                               cellToList(Ys, Rs, Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% correctCell(+Cell) :- returns true if all elements of a cell are different (correct cell)
correctCell(Cell) :- cellToList(Cell, [], Rs),
                     areDifferent(Rs),
					 !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getColumnCells(+Num, +Xs, -Column) :- Column is the Num-th column of cells from a sudoku puzzle Xs
getColumnCells(_, [], []) :- !.
getColumnCells(1, Xs, Column) :- getLeftCells(Xs, [], Column).
getColumnCells(Num, Xs, Column) :- Num \= 1,
                                   cutLeftCells(Xs, [], Rs),
                                   K is Num - 1,
                                   getColumnCells(K, Rs, Column).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getLeftCells(+Xs, +Acc, -Rs) :- Rs is the list of left most cells of Xs
getLeftCells([], Acc, Acc) :- !.
getLeftCells(Xs, Acc, Rs) :- getRowCells(1, Xs, [T|_]),
                             append(Acc, [T], Kss),
                             cutTopCells(Xs, Ys),
                             getLeftCells(Ys, Kss, Rs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cutLeftCells(+Xs, +Acc, -Rs) :- Rs is the sudoku puzzle Xs without the leftmost column
cutLeftCells([], Acc, Acc) :- !.
cutLeftCells(Xs, Acc, Rs) :- getRowCells(1, Xs, [_|Ts]),
                             cutTopCells(Xs, Ys),
                             append(Acc, [Ts], Kss),
                             cutLeftCells(Ys, Kss, Rs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getColumn(+Num, +Width, +Xs, -Column) :- Column is the Num-th column of a sudoku puzzle Xs
getColumn(Num, Width, Xs, Column) :- P is (Num - 1) div Width + 1,
                                     getCellColumn(P, Xs, [], Cells),
									 Pos is (Num - 1) mod Width + 1,
								     getColumnInCells(Pos, Cells, [], Column),
									 !.

getCellColumn(_, [], Acc, Acc) :- !.
getCellColumn(Num, [X|Xs], Acc, Column) :- getElement(Num, X, Cell),
										   append(Acc, [Cell], Rcc),
										   getCellColumn(Num, Xs, Rcc, Column).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getColumnInCells(+Num, +Cells, +Acc, -Column) :- Column is the Num-th column of Cells
getColumnInCells(_, [], Acc, Acc) :- !.
getColumnInCells(1, [X|Xs], Acc, Column) :- getColumnInCell(1, X, [], R),
                                            append(Acc, R, Rss),
                                            getColumnInCells(1, Xs, Rss, Column).
getColumnInCells(Num, Cells, Acc, Column) :- Num \= 1,
                                             cutLeftSide(Cells, [], Offcut),
                                             K is Num - 1,
                                             getColumnInCells(K, Offcut, Acc, Column).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cutLeftSide(+Cells, +Acc, -Offcut) :- Offcut is Cells without the leftmost column
cutLeftSide([], Acc, Acc) :- !.
cutLeftSide([X|Xs], Acc, Offcut) :- cutLeftColumnInCell(X, [], Rs),
                                    append(Acc, [Rs], Rcc),
                                    cutLeftSide(Xs, Rcc, Offcut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getColumnInCell(+Num, +Cell, +Acc, -Column) :- Column is the Num-th column of Cell
getColumnInCell(_, [], Acc, Acc) :- !.
getColumnInCell(_, [[]|_], Acc, Acc) :- !.
getColumnInCell(1, [X|Xs], Acc, Column) :- X = [R|_],
                                           append(Acc, [R], Rcc),
                                           getColumnInCell(1, Xs, Rcc, Column).
getColumnInCell(Num, Cell, Acc, Column) :- Num \= 1,
                                           cutLeftColumnInCell(Cell, [], Offcut),
                                           K is Num - 1,
                                           getColumnInCell(K, Offcut, Acc, Column).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cutLeftColumnInCell(+Cell, +Acc, -Offcut) :- Offcut is Cell without the left most column
cutLeftColumnInCell([], Acc, Acc) :- !.
cutLeftColumnInCell([[]|_], Acc, Acc) :- !.
cutLeftColumnInCell([X|Xs], Acc, Offcut) :- X = [_|Rs],
                                            append(Acc, [Rs], Rcc),
                                            cutLeftColumnInCell(Xs, Rcc, Offcut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% correctRow(+Num, +Height, +Xs) :- returns true if the Num-th row of Xs is correct
correctRow(Num, Height, Xs) :- getRow(Num, Height, Xs, Row),
                               areDifferent(Row).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% correctColumn(+Num, +Width, +Xs) :- returns true if the Num-th column of Xs is correct
correctColumn(Num, Width, Xs) :- getColumn(Num, Width, Xs, Column),
                                 areDifferent(Column).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getLeftSideCells(+Num, +Row, +Acc, -LeftCells) :- LeftCells are the first Num cells in Row
getLeftSideCells(0, _, Acc, Acc).
getLeftSideCells(Num, [X|Xs], Acc, LeftCells) :- Num \= 0,
                                                 append(Acc, [X], Rcc),
                                                 K is Num - 1,
                                                 getLeftSideCells(K, Xs, Rcc, LeftCells).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% removeLeftSideCells(+Num, +Xs, -Rs) :- Rs is the list of cells Xs without first Num cells
removeLeftSideCells(0, Xs, Xs) :- !.
removeLeftSideCells(Num, [_|Xs], Rs) :- K is Num - 1,
                                        removeLeftSideCells(K, Xs, Rs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getRightSideCells(+Num, +Row, -RightCells) :- RightCells are the last Num cells in Row
getRightSideCells(0, _, []).
getRightSideCells(Num, Row, RightCells) :- reverse(Row, Reversed),
                                           getLeftSideCells(Num, Reversed, [], Remained),
										   reverse(Remained, RightCells).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getFirstRows(+Num, +Xs, +Acc, -Rows) :- Rows are first Num cell rows of Xs
getFirstRows(0, _, Acc, Acc) :- !.
getFirstRows(Num, [X|Xs], Acc, Rows) :- append(Acc, [X], Rcc),
                                        K is Num - 1,
                                        getFirstRows(K, Xs, Rcc, Rows).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getLastRows(+Num, +Xs, +Acc, -Rows) :- Rows are last Num cell rows of Xs
getLastRows(0, _, []) :- !.
getLastRows(Num, Xs, Rows) :- length(Xs, L),
                              P is L - Num,
                              P >= 0,
                              dropRows(P, Xs, Rows),
							  !.
getLastRows(Num, Xs, Xs) :- length(Xs, L),
                            P is L - Num,
                            P < 0,
							!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dropRows(+Num, +Xs, -Rows) :- Rows are the rows of a sudoku puzzle Xs left after dropping first Num rows
dropRows(_, [], []) :- !.
dropRows(0, Xs, Xs) :- !.
dropRows(Num, Xs, Rows) :- cutTopCells(Xs, Ys),
                           K is Num - 1,
                           dropRows(K, Ys, Rows).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getCellInRow(+Num, +Row, - Cell) :- Cell is the Num-th cell of Row
getCellInRow(Num, Row, Cell) :- K is Num - 1,
                                removeLeftSideCells(K, Row, [Cell|_]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getFirstElements(+Num, +Cell, +Acc, +FirstElements) :- FirstElements are first Num rows of Cell
getFirstElements(0, _, Acc, Acc) :- !.
getFirstElements(Num, [X|Xs], Acc, FirstElements) :- Num \= 0,
                                                     append(Acc, [X], Rcc),
                                                     K is Num - 1,
                                                     getFirstElements(K, Xs, Rcc, FirstElements).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getLastElements(+Num, +Cell, +LastElements) :- LastElements are Last Num rows of Cell
getLastElements(_, [], []) :- !.
getLastElements(Num, Xs, LastElements) :- length(Xs, L),
                                          Num =< L,
                                          reverse(Xs, Ys),
                                          getFirstElements(Num, Ys, [], FirstElements),
                                          reverse(FirstElements, LastElements),
										  !.
getLastElements(Num, Xs, Xs) :- length(Xs, L),
                                Num > L,
								!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getRowInACell(+Num, +Cell, -Row) :- Row is the Num-th row of Cell
getRowInACell(1, [X|_], X) :- !.
getRowInACell(Num, [_|Xs], Row) :- Num \= 1,
                                   K is Num - 1,
                                   getRowInACell(K, Xs, Row).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% insert(+Figure, +Pos, +Xs, -Ys) :- Ys is Xs with inserted Figure at position Pos
insert(Figure, Pos, Xs, Ys) :- getHead(Pos, Xs, [], Hs),
                               getTail(Pos, Xs, Ts),
                               append(Hs, [Figure], Ms),
                               append(Ms, Ts, Ys),
							   !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getHead(+Pos, +Xs, +Acc, +Ys) :- Ys is the head of Xs before position Pos
getHead(0, _, _, []) :- !.
getHead(1, _, Acc, Acc) :- !.
getHead(_, [], Acc, Acc) :- !.
getHead(Pos, [X|Xs], Acc, Ys) :- Pos > 1,
                                 append(Acc, [X], Rcc),
                                 K is Pos - 1,
                                 getHead(K, Xs, Rcc, Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getTail(+Pos, +Xs, -Ys) :- Ys is the tail of Xs after position Pos
getTail(Pos, Xs, Ys) :- length(Xs, L),
                        K is L - Pos + 1,
                        K > 0,
                        reverse(Xs, Rs),
                        getHead(K, Rs, [], Bs),
                        reverse(Bs, Ys),
						!.
getTail(Pos, Xs, []) :- length(Xs, L),
                        K is L - Pos + 1,
                        K =< 0,
						!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% addRandomNumber(+RowN, +ColumnN, +Height, +Width, +Xs, -Ys) :- adds a random number Number into a sudoku puzzle Xs at the position RowN / ColumnN
addRandomNumber(RowN, ColumnN, Height, Width, Xs, Ys) :- K is (RowN - 1) div Height + 1,
                                                         First is K - 1,
                                                         length(Xs, LengthOfPuzzle),
                                                         Last is LengthOfPuzzle - K,
                                                         getFirstRows(First, Xs, [], FirstRows),
                                                         getLastRows(Last, Xs, LastRows),
                                                         getRowCells(K, Xs, CurrentRow),
                                                         C is (ColumnN - 1) div Width + 1,
                                                         LeftSide is C - 1,
                                                         length(CurrentRow, LengthOfARow),
                                                         RightSide is LengthOfARow - C,
                                                         getLeftSideCells(LeftSide, CurrentRow, [], LeftCells),
                                                         getRightSideCells(RightSide, CurrentRow, RightCells),
                                                         getCellInRow(C, CurrentRow, CurrentCell),
                                                         PosX is ColumnN - (Width * LeftSide),
                                                         PosY is RowN - (Height * First),
                                                         FirstElementsSize is PosY - 1,
                                                         LastElementsSize is Height - PosY,
                                                         getFirstElements(FirstElementsSize, CurrentCell, [], FirstElements),                                                               getLastElements(LastElementsSize, CurrentCell, LastElements),
                                                         getRowInACell(PosY, CurrentCell, CurrentRowInCell),
                                                         Max is Width * Height,
                                                         cellToList(CurrentCell, [], Cell),
                                                         getRow(RowN, Height, Xs, Row),
                                                         getColumn(ColumnN, Width, Xs, Column),
                                                         getNextRandom(Max, Cell, Row, Column, Number),
                                                         insert(Number, PosX, CurrentRowInCell, Inserted),
                                                         append(FirstElements, [Inserted], Aux1),
                                                         append(Aux1, LastElements, NewCell),
                                                         append(LeftCells, [NewCell], Aux2),
                                                         append(Aux2, RightCells, NewRow),
                                                         append(FirstRows, [NewRow], Aux3),
                                                         append(Aux3, LastRows, Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% emptyPuzzle(+Width, +Height, -EmptyPuzzle) :- EmptyPuzzle is an empty Sudoku puzzle table with cells of size Width * Height
emptyPuzzle(Width, Height, EmptyPuzzle) :- emptyCellRow(Width, Height, EmptyRow),
                                           emptyPuzzle(Width, EmptyRow, [], EmptyPuzzle).
emptyPuzzle(0, _, Acc, Acc) :- !.
emptyPuzzle(Width, EmptyRow, Acc, EmptyPuzzle) :- Width >= 1,
                                                  append(Acc, [EmptyRow], Rcc),
                                                  K is Width - 1,
                                                  emptyPuzzle(K, EmptyRow, Rcc, EmptyPuzzle).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% emptyCell(+Height, +Acc, -EmptyCell) :- EmptyCell is an empty cell of height Height
emptyCell(1, [], [[]]) :- !.
emptyCell(1, Acc, Acc) :- Acc \= [],
						  !.
emptyCell(Height, [], EmptyCell) :- Height > 1,
                                    K is Height - 1,
                                    emptyCell(K, [[], []], EmptyCell),
									!.
emptyCell(Height, Acc, EmptyCell) :- Acc \= [],
									 Height > 1,
                                     append(Acc, [[]], Rcc),
                                     K is Height - 1,
                                     emptyCell(K, Rcc, EmptyCell),
									 !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% emptyCellRow(+Width, +Height, -EmptyRow) :- EmptyRow is an empty row with cells of size Width * Height
emptyCellRow(Width, Height, EmptyRow) :- Width >= 1,
                                         emptyCell(Height, [], EmptyCell),
                                         emptyCellRow(Height, EmptyCell, [], EmptyRow).
emptyCellRow(0, _, Acc, Acc) :- !.
emptyCellRow(Num, EmptyCell, Acc, EmptyRow) :- Num > 0,
                                               append(Acc, [EmptyCell], Rcc),
                                               K is Num - 1,
                                               emptyCellRow(K, EmptyCell, Rcc, EmptyRow).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% randomNumber(+Last, -Number) :- Number is a number between 1 and Last
randomNumber(Last, Number) :- Number is random(Last) + 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getNextRandom(+Max, +UsedInCell, +UsedInRow, +UsedInColumn, -Number) :- Number is a random number from 1 to Max which was not used in the current row, column and cell
getNextRandom(Max, UsedInCell, UsedInRow, UsedInColumn, Number) :- consecutiveList(Max, [], FullList),
                                                                   subtract(FullList, UsedInCell, Aux1),
                                                                   subtract(Aux1, UsedInColumn, Aux2),
								   subtract(Aux2, UsedInRow, RemainedList),
								   length(RemainedList, Length),
								   Length \= 0,
								   Random is random(Length) + 1,
								   getElement(Random, RemainedList, Number).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% consecutiveList(+Max, +Acc, -List) :- List is a list of numbers from 1 to Max
consecutiveList(0, Acc, List) :- reverse(Acc, List),
                                 !.
consecutiveList(Max, Acc, List) :- Max > 0,
				   append(Acc, [Max], Rcc),
				   K is Max - 1,
				   consecutiveList(K, Rcc, List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getElement(+Num, +Xs, -Element) :- Element is the element of Xs at the position Num
getElement(1, [X|_], X) :- !.
getElement(Num, [_|Xs], Element) :- Num \= 1,
                                    Next is Num - 1,
                                    Next > 0,
                                    getElement(Next, Xs, Element).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=CHECKER=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checker(+Width, +Height, +Xs) :- returns true if a puzzle Xs is complete and correct
checker(Width, Height, Xs) :- Max is Height * Width,
			      checkRows(Max, 1, Height, Xs),
			      checkColumns(Max, 1, Width, Xs),
			      checkCells(Max, 1, Width, Xs),
                              !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checkRows(+Max, +Current, +Height, +Xs) :- returns true if all the rows of Xs are complete and correct
checkRows(Max, Current, _, _) :- Current > Max,
                                 !.
checkRows(Max, Current, Height, Xs) :- getRow(Current, Height, Xs, Row),
                                       length(Row, Length),
                                       Length == Max,
				       areDifferent(Row),
				       K is Current + 1,
				       checkRows(Max, K, Height, Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checkColumns(+Max, +Current, +Width, +Xs) :- returns true if all the columns of Xs are complete and correct
checkColumns(Max, Current, _, _) :- Current > Max,
									!.
checkColumns(Max, Current, Width, Xs) :- getColumn(Current, Width, Xs, Column),
                                         length(Column, Length),
					 Length == Max,
					 areDifferent(Column),
					 K is Current + 1,
					 checkColumns(Max, K, Width, Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checkCells(+Max, +Current, +Width +Xs) :- returns true if all the cells of Xs are complete and correct
checkCells(_, Current, Width, _) :- Current > Width.
checkCells(Max, Current, Width, Xs) :- getRowCells(Current, Xs, Row),
                                       checkCellsInARow(Max, Row),
                                       K is Current + 1,
                                       checkCells(Max, K, Width, Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checkCellsInARow(+Max, +Xs) :- returns true if all the cells in a row of cells Xs are complete and correct
checkCellsInARow(_, []) :- !.
checkCellsInARow(Max, [X|Xs]) :- checkCell(Max, X),
                                 checkCellsInARow(Max, Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checkCell(+Max, +Cell) :- returns true if all Cell is complete and correct
checkCell(Max, Cell) :- cellToList(Cell, [], List),
			length(List, Length),
			Length == Max,
			areDifferent(List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=Randomizer=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% randomize(+Num, +Height, +Width, +Puzzle, -Randomized) :- Randomized is a randomized puzzle from Puzzle
randomize(Num, Height, Width, Puzzle, Cleared) :- Max is Height * Width,
                                                  clearRowsRandomly(Num, 1, Max, Height, Width, Puzzle, Cleared),
												  !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clearElement(+ColumnN, +RowN, +Height, +Width, +Puzzle, -Cleared) :- Cleared is Puzzle with an empty element at the ColumnN and RowN
clearElement(ColumnN, RowN, Height, Width, Xs, Cleared) :- K is (RowN - 1) div Height + 1,
                                                           First is K - 1,
                                                           length(Xs, LengthOfPuzzle),
                                                           Last is LengthOfPuzzle - K,
                                                           getFirstRows(First, Xs, [], FirstRows),
                                                           getLastRows(Last, Xs, LastRows),
                                                           getRowCells(K, Xs, CurrentRow),
                                                           C is (ColumnN - 1) div Width + 1,
                                                           LeftSide is C - 1,
                                                           length(CurrentRow, LengthOfARow),
                                                           RightSide is LengthOfARow - C,
                                                           getLeftSideCells(LeftSide, CurrentRow, [], LeftCells),
                                                           getRightSideCells(RightSide, CurrentRow, RightCells),
                                                           getCellInRow(C, CurrentRow, CurrentCell),
                                                           PosX is ColumnN - (Width * LeftSide),
                                                           PosY is RowN - (Height * First),
                                                           FirstElementsSize is PosY - 1,
                                                           LastElementsSize is Height - PosY,
                                                           getFirstElements(FirstElementsSize, CurrentCell, [], FirstElements),                                                               getLastElements(LastElementsSize, CurrentCell, LastElements),
                                                           getRowInACell(PosY, CurrentCell, CurrentRowInCell),
                                                           insert([], PosX, CurrentRowInCell, Inserted),
                                                           append(FirstElements, [Inserted], Aux1),
                                                           append(Aux1, LastElements, NewCell),
                                                           append(LeftCells, [NewCell], Aux2),
                                                           append(Aux2, RightCells, NewRow),
                                                           append(FirstRows, [NewRow], Aux3),
                                                           append(Aux3, LastRows, Cleared),
														   !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clearInARow(+Num, +RowN, +Max, +Height, +Width, +Puzzle, -Cleared) :- Cleared is Puzzle with cleared Num places in RowN
clearInARow(Num, RowN, Max, Height, Width, Puzzle, Cleared) :- getPlaces(Num, Max, [], Places),
													           clearByAList(RowN, Height, Width, Puzzle, Places, Cleared).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getPlaces(+Num, +Max, +Acc, -Places) :- Places is the list of size Num of places in a row with indexes from 1 to Max
getPlaces(0, _, Acc, Acc) :- !.
getPlaces(Num, Max, Acc, Places) :- Num \= 0,
                                    Number is random(Max) + 1,
                                    \+ member(Number, Acc),
									!,
									append(Acc, [Number], Rcc),
									Next is Num - 1,
									getPlaces(Next, Max, Rcc, Places),
									!.
getPlaces(Num, Max, Acc, Places) :- Num \= 0,
									getPlaces(Num, Max, Acc, Places).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clearByAList(+RowN, +Height, +Width, +Puzzle, +List, +Acc, -Cleared) :- Cleared is Puzzle with cleared positions at RowN and columns from List
clearByAList(_, _, _, Puzzle, [], Puzzle) :- !.
clearByAList(RowN, Height, Width, Puzzle, [X|Xs], Cleared) :- clearElement(X, RowN, Height, Width, Puzzle, Rcc),
															  clearByAList(RowN, Height, Width, Rcc, Xs, Cleared).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clearRowsRandomly(+Num, +RowN, +Max, +Height, +Width, +Puzzle, +Cleared) :- Cleared is Puzzle with cleared Num positions at each row
clearRowsRandomly(_, RowN, Max, _, _, Puzzle, Puzzle) :- RowN > Max,
														 !.
clearRowsRandomly(Num, RowN, Max, Height, Width, Puzzle, Cleared) :- clearInARow(Num, RowN, Max, Height, Width, Puzzle, Aux),
																	 Next is RowN + 1,
																	 clearRowsRandomly(Num, Next, Max, Height, Width, Aux, Cleared).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=Solver=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% solve(+Width, +Height, +Puzzle, -Solution) :-Solution is the solution of Puzzle.
solve(Width, Height, Puzzle, Solution) :- repeat,
                                          resolve(1, 1, Width, Height, Puzzle, Puzzle, Solution),
                                          !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% resolve(+Width, +Height, +Puzzle, -Resolved) :- Resolved is the resolved Puzzle
resolve(RowN, _, Width, Height, _, Aux, Aux) :- Max is Width * Height,
						RowN > Max,
						checker(Width, Height, Aux),
						!.
resolve(RowN, ColumnN, Width, Height, Original, Aux, Puzzle) :- Max is Width * Height,
								RowN =< Max,
								getElementAt(RowN, ColumnN, Height, Original, Element),
								Element \= [],
								NextColumn is ColumnN mod Max + 1,
								NextColumn \= 1,
								resolve(RowN, NextColumn, Width, Height, Original, Aux, Puzzle).
resolve(RowN, ColumnN, Width, Height, Original, Aux, Puzzle) :- Max is Width * Height,
								RowN =< Max,
								getElementAt(RowN, ColumnN, Height, Original, Element),
								Element \= [],
								NextColumn is ColumnN mod Max + 1,
								NextColumn == 1,
								NextRow is RowN + 1,
								resolve(NextRow, NextColumn, Width, Height, Original, Aux, Puzzle).
resolve(RowN, ColumnN, Width, Height, Original, Aux, Puzzle) :- Max is Width * Height,
								RowN =< Max,
																NextColumn is ColumnN mod Max + 1,
								NextColumn \= 1,
								getElementAt(RowN, ColumnN, Height, Original, Element),
							        Element == [],
								addNextNumber(RowN, ColumnN, Height, Width, Aux, Aux2),
								resolve(RowN, NextColumn, Width, Height, Original, Aux2, Puzzle).
resolve(RowN, ColumnN, Width, Height, Original, Aux, Puzzle) :- Max is Width * Height,
								RowN =< Max,
																NextColumn is ColumnN mod Max + 1,
								NextColumn == 1,
								getElementAt(RowN, ColumnN, Height, Original, Element),
                                                                Element == [],
								NextRow is RowN + 1,
								addNextNumber(RowN, ColumnN, Height, Width, Aux, Aux2),
								resolve(NextRow, NextColumn, Width, Height, Original, Aux2, Puzzle).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% addNextNumber(+RowN, +ColumnN, +Height, +Width, +Xs, -Ys) :- adds next number Number into a sudoku puzzle Xs at the position RowN / ColumnN
addNextNumber(RowN, ColumnN, Height, Width, Xs, Ys) :- K is (RowN - 1) div Height + 1,
                                                         First is K - 1,
                                                         length(Xs, LengthOfPuzzle),
                                                         Last is LengthOfPuzzle - K,
                                                         getFirstRows(First, Xs, [], FirstRows),
                                                         getLastRows(Last, Xs, LastRows),
                                                         getRowCells(K, Xs, CurrentRow),
                                                         C is (ColumnN - 1) div Width + 1,
                                                         LeftSide is C - 1,
                                                         length(CurrentRow, LengthOfARow),
                                                         RightSide is LengthOfARow - C,
                                                         getLeftSideCells(LeftSide, CurrentRow, [], LeftCells),
                                                         getRightSideCells(RightSide, CurrentRow, RightCells),
                                                         getCellInRow(C, CurrentRow, CurrentCell),
                                                         PosX is ColumnN - (Width * LeftSide),
                                                         PosY is RowN - (Height * First),
                                                         FirstElementsSize is PosY - 1,
                                                         LastElementsSize is Height - PosY,
                                                         getFirstElements(FirstElementsSize, CurrentCell, [], FirstElements),                                                               getLastElements(LastElementsSize, CurrentCell, LastElements),
                                                         getRowInACell(PosY, CurrentCell, CurrentRowInCell),
														 getNumbers(RowN, ColumnN, Width, Height, Xs, Numbers),
                                                         getNext(Numbers, NextNumber),
                                                         insert(NextNumber, PosX, CurrentRowInCell, Inserted),
                                                         append(FirstElements, [Inserted], Aux1),
                                                         append(Aux1, LastElements, NewCell),
                                                         append(LeftCells, [NewCell], Aux2),
                                                         append(Aux2, RightCells, NewRow),
                                                         append(FirstRows, [NewRow], Aux3),
                                                         append(Aux3, LastRows, Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getNext(+List, -Num) :- Num is the first number in List
getNext([N|_], N).
getNext([_|Tail], Number) :- Tail \= [],
                             getNext(Tail, Number).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getNumbers(RowN, ColumnN, Width, Height, Puzzle, Numbers) :- Max is Width * Height,
															 consecutiveList(Max, [], FullList),
															 K is (RowN - 1) div Height + 1,
															 getRowCells(K, Puzzle, CurrentRow),
															 C is (ColumnN - 1) div Width + 1,
															 getCellInRow(C, CurrentRow, CurrentCell),
															 cellToList(CurrentCell, [], UsedInCell),
															 getRow(RowN, Height, Puzzle, UsedInRow),
															 getColumn(ColumnN, Width, Puzzle, UsedInColumn),
													subtract(FullList, UsedInCell, Aux1),
													subtract(Aux1, UsedInColumn, Aux2),
													subtract(Aux2, UsedInRow, Numbers).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getElementAt(+RowN, +ColumnN, +Height, +Puzzle, -Element) :- Element is the element of Puzzle at RowN and ColumnN
getElementAt(RowN, ColumnN, Height, Puzzle, Element) :- R is (RowN - 1) div Height + 1,
                                                        getRowCells(R, Puzzle, RowOfCells),
						        P is (RowN - 1) mod Height + 1,
							getRowInCells(P, RowOfCells, [], Row),
							buildList(Row, [], List),
							getElement(ColumnN, List, Element).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% printPuzzle(+Puzzle) :- prints out the Puzzle in a nice form
printPuzzle(Puzzle, Width, Height) :- add_module,
                                      print_rows(0, Puzzle, Height, Width).

print_rows(Limit, _, Height, Width) :- Limit #>= Width * Height + 1, !.
print_rows(N, Puzzle, Height, Width) :- ((N #= 0, N1 #= N + 1, K1 #= Height + 1, print_separator(K1, Height, Width)); (N #\= 0, N1 #= N)),
                                        getRow(N1, Height, Puzzle, Row),
                                        print_row(Row, Width),
                                        N2 #= N1 + 1,
                                        print_separator(N2, Height, Width),
                                        print_rows(N2, Puzzle, Height, Width).

print_row([], _) :- writeln('').
print_row(Row, Width) :- get_first(Row, Width, [], F1),
                         maplist(print_element, F1),
                         write('| '),
                         append(F1, F2, Row),
                         print_row(F2, Width).

get_first(_, 0, Acc, Rs) :- reverse(Acc, Rs).
get_first([X|Xs], N, Acc, Rs) :- N1 #= N - 1,
                                 get_first(Xs, N1, [X|Acc], Rs).


add_module :- use_module(library(clpfd)).

print_element([]) :- write(' _ ').
print_element(X) :- dif(X, []),
                    write(' '),
                    write(X),
                    write(' ').

print_separator(N, Height, _) :- 0 #\= (N - 1) mod Height.
print_separator(N, Height, Width) :- 0 #= (N - 1) mod Height,
                                     N1 #= 3 * Width,
                                     print_dash(N1).

print_dash(0) :- writeln('').
print_dash(N) :- N1 #= N - 1,
                 N1 #>= 0,
                 write('----'),
                 print_dash(N1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-=TEST DATA=-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

testTiny([[[[1]],[[2]]],[[[3]],[[4]]]]).

test([[[[1, 5],[6, 4]],[[5, 6], [7, 8]]], [[[11, 22],[2, 44]],[[55, 66], [77, 88]]]]).

testSudoku([[[[1,1,1], [2,3,4], [3,4,5]], [[1,4,4],[5,6,7],[6,7,8]], [[7,7,7],[8,9,10],[9,10,11]]],[[[10,10,10], [20,20,20], [30,30,30]], [[40,40,40],[50,50,50],[60,60,60]], [[70,70,70],[80,80,80],[90,90,90]]],[[[11,11,11], [22,22,22], [33,33,33]], [[44,44,44],[55,55,55],[66,66,66]], [[77,77,77],[88,88,88],[99,99,99]]]]).

testSudoku2([[[[[],[],[]],[6,8,[]],[1,9,[]]],[[2,6,[]],[[],7,[]], [[],[],4]],[[7,[],1],[[],9,[]],[5,[],[]]]], [[[8,2,[]],[[],[],4],[[],5,[]]],[[1,[],[]],[6,[],2],[[],[],3]],[[[],4,[]],[9,[],[]],[[],2,8]]], [[[[],[],9],[[],4,[]],[7,[],3]],[[3,[],[]],[[],5,[]],[[],1,8]],[[[],7,4],[[],3,6],[[],[],[]]]]]).

testSudoku3([[[[[],2,[]],[[],[],[]],[[],7,4]],[[[],[],[]],[6,[],[]], [[],8,[]]],[[[],[],[]],[[],[],3],[[],[],[]]]], [[[[],[],[]],[[],8,[]],[6,[],[]]],[[[],[],3],[[],4,[]],[5,[],[]]],[[[],[],2],[[],1,[]],[[],[],[]]]], [[[[],[],[]],[5,[],[]],[[],[],[]]],[[[],1,[]],[[],[],9],[[],[],[]]],[[7,8,[]],[[],[],[]],[[],4,[]]]]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




