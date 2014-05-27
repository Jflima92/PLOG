:- use_module(library(lists)).

/* Criaçao do tabuleiro */

board([['A1','A2','A3','A4','A5','A6','A7','A8'],
['B1','B2','B3','B4','B5','B6','B7','B8'],
['C1','C2','C3','C4','C5','C6','C7','C8'],
['D1','D2','D3','D4','D5','D6','D7','D8'],
['E1','E2','E3','E4','E5','E6','E7','E8'],
['F1','F2','F3','F4','F5','F6','F7','F8'],
['G1','G2','G3','G4','G5','G6','G7','G8'],
['H1','H2','H3','H4','H5','H6','H7','H8']]).

emptyboard([[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ',' ',' ',' ']]).

/* Start Menu */

intro:-

write('UnChess').

start:-
         emptyboard(Board),
         startmenu(Board).

startmenu(Board) :-
       
set_prolog_flag(fileerrors,off),
nl, intro, nl, nl,
        write('1 - Coloca peças no Tabuleiro'), nl,
        write('2 - Move peças colocadas'), nl,
       
        repeat, read(Op), Op >= 0, Op =< 12,!,
        menu(Op, Board), repeat, skip_line, get_code(_), startmenu(Board).

menu(0):- 
abort.

menu(1, Board):-
           
        printInBoard(Board,BoardOut),
        startmenu(BoardOut).

menu(2, Board):-
        
        nl, nl,
        write('Indique o X inicial: '),
        read(PosXi),
        nl, nl,
        write('Indique o Y inicial: '),
        read(PosYi),
        nl, nl,
        write('Indique o X Final: '),
        read(PosXf),
        nl, nl,
        write('Indique o Y Final: '),
        read(PosYf),
        nl, nl,
        write('Indique a peça em questão: ("K") '),
        read(Piece),
        
        
        movePiece(Board, BoardOut, PosXi, PosYi, PosXf, PosYf, Piece),
        
        startmenu(BoardOut).

menu(3, Board):-
        printBoard(Board),
        startmenu.


menu(4, Board):-
        startmenu.
        

/* Imprimir linhas do tabuleiro */

par('A',1).
par('B',2).
par('C',3).
par('D',4).
par('E',5).
par('F',6).
par('G',7).
par('H',8).

piece(' ', 0).
piece('K', 1).
piece('Q', 2).
piece('R', 3).
piece('B', 4).
piece('N', 5).
piece('P', 6).


printLine([]).
printLine([P1|Resto]):-

print(` `), print(P1),

printLine(Resto).


/* Imprimir tabuleiro */

printBoard([],9).
                    
printBoard([L1|Resto],I) :-     
        par(X,I),
        print(X),
        printLine(L1),
        nl,
        I2 is I+1,
        printBoard(Resto, I2).


        
printInBoard(Board, BoardOut):-
        print('  1 2 3 4 5 6 7 8 '),
        nl,        
        fillBoard(Board, CenasNovas, 1, 2, 2),
        fillBoard(CenasNovas, CenasMaisNovas, 2, 5, 4),
        fillBoard(CenasMaisNovas, CenasAindaMaisNovas, 3, 2, 7),
        fillBoard(CenasAindaMaisNovas, BoardOut, 5, 1, 6),
        printBoard(BoardOut,1).
       

printBoardEmpty:-
        emptyboard(Cenas),
        print('  1 2 3 4 5 6 7 8 '),
        nl,
        printBoard(Cenas,1).

/* Colocar peça */ % positions -1 

changeLine([_|Resto], 0, NewElem, [NewElem|Resto]).
changeLine([Elem|Resto], Y, NewElem, [Elem|NewResto]):-
        Y > 0,
        NewY is Y-1,
        changeLine(Resto, NewY, NewElem, NewResto).

checkLines([Linha|Resto], 0, [Linha2|Resto], Y, Piece):-
        changeLine(Linha, Y, Piece, Linha2). 
checkLines([Linha|Resto], X, [Linha|NewResto], Y, Piece):-
        X > 0,
        NewX is X-1,
        checkLines(Resto, NewX, NewResto, Y, Piece).        
                                         
fillBoard(BoardIn, BoardOut, PieceNumber, X, Y):-
        piece(Piece, PieceNumber),
        checkLines(BoardIn, Y, BoardOut, X, Piece).


% Mover peça

%Verifica se Posição final está livre

checkEachLine([Var|_], 0):-
        checkPosEmpty(Var).
        
checkEachLine([_|Resto], X):-
        X > 0,
        NewX is X-1,
        checkEachLine(Resto, NewX).


checkLinesForEmpty([Linha|_], X, 0):-
        checkEachLine(Linha, X). 
checkLinesForEmpty([_|Resto], X, Y):-
        Y > 0,
        NewY is Y-1,
        checkLinesForEmpty(Resto, X, NewY).

checkPosEmpty(' ').
             

movePiece(BoardIn, BoardOut, Xi, Yi, Xf, Yf, Piece):-
        checkLinesForEmpty(BoardIn, Xf, Yf),
        piece(' ', Pnum),
        fillBoard(BoardIn, BoardFinal, Pnum, Xi, Yi),
        piece(Piece, PieceNum),
        fillBoard(BoardFinal, BoardOut, PieceNum, Xf, Yf),
        print('    1 2 3 4 5 6 7 8 '),
        nl, 
        printBoard(BoardOut,1).
        
