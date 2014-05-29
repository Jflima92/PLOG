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
        write('3 - Verificar possíveis ataques'), nl,
       
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
        checkValidBoard(Board, 1, 1),
        startmenu(Board).


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
        print(` `),
        print(P1),
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

changeLine([_|Resto], 1, NewElem, [NewElem|Resto]).
changeLine([Elem|Resto], Y, NewElem, [Elem|NewResto]):-
        Y > 1,
        NewY is Y-1,
        changeLine(Resto, NewY, NewElem, NewResto).

checkLines([Linha|Resto], 1, [Linha2|Resto], Y, Piece):-
        changeLine(Linha, Y, Piece, Linha2). 
checkLines([Linha|Resto], X, [Linha|NewResto], Y, Piece):-
        X > 1,
        NewX is X-1,
        checkLines(Resto, NewX, NewResto, Y, Piece).        
                                         
fillBoard(BoardIn, BoardOut, PieceNumber, X, Y):-
        piece(Piece, PieceNumber),
        checkLines(BoardIn, Y, BoardOut, X, Piece).


% Mover peça

%Verifica se Posição final está livre

checkEachLine([Var|_], 1):-
        checkPosEmpty(Var).
        
checkEachLine([_|Resto], X):-
        X > 1,
        NewX is X-1,
        checkEachLine(Resto, NewX).


checkPosForEmpty([Linha|_], X, 1):-
        checkEachLine(Linha, X). 
checkPosForEmpty([_|Resto], X, Y):-
        Y > 1,
        NewY is Y-1,
        checkPosForEmpty(Resto, X, NewY).

checkPosEmpty(' ').
             

movePiece(BoardIn, BoardOut, Xi, Yi, Xf, Yf, Piece):-
        checkPosForEmpty(BoardIn, Xf, Yf),
        \+checkPosForEmpty(BoardIn, Xi, Yi),
        piece(' ', Pnum),
        fillBoard(BoardIn, BoardFinal, Pnum, Xi, Yi),
        piece(Piece, PieceNum),
        fillBoard(BoardFinal, BoardOut, PieceNum, Xf, Yf),        print('  1 2 3 4 5 6 7 8 '),
        nl, 
        printBoard(BoardOut,1).
        
%% Verificação de ataques na mesa


nullElemCheck(Elem):-
        Elem == ' '.

/*checkColumnsFirst([Elem|Resto], [Elem|NewResto], Y, NewElem):-
        not(notNullElemCheck(Elem)),
        NewElem is Elem.


checkColumnsFirst([Elem|Resto], [Elem|NewResto], Y, NewElem):-
        Y =< 8,
        NewY is Y+1,
        checkColumnsFirst(Resto, NewResto,NewY, NewElem).
        
                
                
checkNextElem([Linha|Resto],[Linha2|Resto], X,  Y, Elem):-
         checkColumnsFirst(Linha, Linha2, X, Y, Elem).

checkNextElem([Linha|Resto], [Linha|NewResto], X, Y, Elem):-
        X =< 8,
        NewX is X+1,
        checkNextElem(Resto, NewResto, NewX, Y, Elem).*/

checkNextElem([],_,_,_).
checkNextElem([L|Ls], X, Y, FixedBoard):-
        checkColumn(L, X, Y, FixedBoard),
        NewY is Y+1,
        checkNextElem(Ls, X, NewY, FixedBoard).
        


checkColumn([], _, _,_).
checkColumn([C|Cs], X, Y, FixedBoard):-
        \+(nullElemCheck(C)),
        NewX is X+1,
        checkPieceValidMoves(FixedBoard, C, X, Y),
        checkColumn(Cs, NewX, Y, FixedBoard).

checkColumn([_|Cs], X, Y, FixedBoard):-
        NewX is X+1,
        checkColumn(Cs, NewX, Y, FixedBoard).
        
checkPieceValidMoves(Board, 'K', X, Y):-
        checkKingMovesLeft1(Board, X, Y),
        checkKingMovesLeft2(Board, X, Y),
        checkKingMovesLeft3(Board, X, Y),
        checkKingMovesTop(Board, X, Y),
        checkKingMovesBot(Board, X, Y),
        checkKingMovesRight1(Board, X, Y),
        checkKingMovesRight2(Board, X, Y),
        checkKingMovesRight3(Board, X, Y).

checkBoardLimits(X, Y):-
        X > 0,
        X =< 8,
        Y > 0,
        X =< 8.

checkKingMovesLeft1(Board, X, Y):-
        XL1 is X-1,                                                                     %             xo
        checkBoardLimits(XL1, Y),
        \+checkPosForEmpty(Board, XL1, Y),
        write('L1: '),
        write('Incompatibilidade na posição: '),write(XL1),write(', '),write(Y),nl.

checkKingMovesLeft1(_,_,_).

checkKingMovesLeft2(Board, X, Y):-
        XL1 is X-1,                                                                     %              x                                                                       %               o
        YL1 is Y-1, 
        checkBoardLimits(XL1, YL1),        
        \+checkPosForEmpty(Board, XL1, YL1),
        print('L2: '),
        write('Incompatibilidade na posição: '),write(XL1),write(', '),write(YL1),nl.

checkKingMovesLeft2(_,_,_).


checkKingMovesLeft3(Board, X, Y):-
        XL1 is X-1,                                                                     %               o
        YL1 is Y+1,                                                                     %              x 
        checkBoardLimits(XL1, YL1),
       \+checkPosForEmpty(Board, XL1, YL1),                                                            %Verify negation
        write('L3: '),
        write('Incompatibilidade na posição: '),write(XL1),write(', '),write(YL1),nl.

checkKingMovesLeft3(_,_,_).


checkKingMovesBot(Board, X, Y):-                                                       %               o
        Y1 is Y+1,                                                                     %               x 
        checkBoardLimits(X, Y1),
        \+checkPosForEmpty(Board, X, Y1),
        write('B: '),
        write('Incompatibilidade na posição: '),write(X),write(', '),write(Y1),nl.

checkKingMovesBot(_,_,_).

checkKingMovesTop(Board, X, Y):-                                                                       
        Y2 is Y-1,                                                                     %              x 
        checkBoardLimits(X, Y2),                                                      %               o
        \+checkPosForEmpty(Board, X, Y2),
        write('T: '),
        write('Incompatibilidade na posição: '),write(X),write(', '),write(Y2),nl.     

checkKingMovesTop(_,_,_).   

checkKingMovesRight1(Board, X, Y):-
        XL1 is X+1,                                                                     %             ox
        checkBoardLimits(XL1, Y),
        \+checkPosForEmpty(Board, XL1, Y),
        write('R1: '),
        write('Incompatibilidade na posição: '),write(XL1),write(', '),write(Y),nl.
checkKingMovesRight1(_,_,_).

checkKingMovesRight2(Board, X, Y):-
        XL1 is X+1,                                                                     %              o                                                                       %               o
        YL1 is Y+1,                                                                     %               x
        checkBoardLimits(XL1, YL1),        
        \+checkPosForEmpty(Board, XL1, YL1),
        write('R2: '),
        write('Incompatibilidade na posição: '),write(XL1),write(', '),write(YL1),nl.

checkKingMovesRight2(_,_,_).
        

checkKingMovesRight3(Board, X, Y):-
        XL1 is X+1,                                                                     %               x
        YL1 is Y-1,                                                                     %              o 
        checkBoardLimits(XL1, YL1),
        \+checkPosForEmpty(Board, XL1, YL1),
        write('R3: '),
        write('Incompatibilidade na posição: '),write(XL1),write(', '),write(YL1),nl.

checkKingMovesRight3(_,_,_).
        


              

checkValidBoard(Board, X, Y):-
        
        checkNextElem(Board, X, Y, Board).
        
                                                                                                                                                                                                                                                
        