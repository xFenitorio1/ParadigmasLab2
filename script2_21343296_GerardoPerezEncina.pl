:- consult('piece_21343296_GerardoPerezEncina.pl').
:- consult('player_21343296_GerardoPerezEncina.pl').
:- consult('board_21343296_GerardoPerezEncina.pl').
:- consult('game_21343296_GerardoPerezEncina.pl').

main:-

	% 1. Crear jugadores (10 fichas cada uno para un juego corto)
	player(1, "Juan", "red", 0, 0, 0, 10, P1),
	player(2, "Mauricio", "yellow", 0, 0, 0, 10, P2),

	% 2. Crear fichas
	piece("red", RedPiece),
	piece("yellow", YellowPiece),

	% 3. Crear tablero inicial vacío
	board(EmptyBoard),

	% 4. Crear nuevo juego
	game(1, EmptyBoard, P1, P2, 1, G0),

	% 5. Realizando movimientos para crear una victoria horizontal
	player_play(G0, P1, 0, G1),    % Juan juega en columna 0
	player_play(G1, P2, 0, G2),    % Mauricio juega en columna 0
	player_play(G2, P1, 1, G3),    % Juan juega en columna 1
	player_play(G3, P2, 1, G4),    % Mauricio juega en columna 1
	player_play(G4, P1, 2, G5),    % Juan juega en columna 2
	player_play(G5, P2, 2, G6),    % Mauricio juega en columna 2
	player_play(G6, P1, 3, G7),    % Juan juega en columna 3 (victoria horizontal)

	% 6. Verificaciones del estado del juego
	write('¿Se puede jugar en el tablero vacio? '),
	can_play(EmptyBoard), % Si se puede seguir jugando, el programa continuará
	nl,
	game_get_board(G7, CurrentBoard),
	write('¿Se puede jugar despues de 7 movimientos? '),
	can_play(CurrentBoard),
	nl,

	write('Jugador actual despues de 7 movimientos: '),
	get_current_player(G7, CurrentPlayer),
	write(CurrentPlayer),
	nl,

	% 7. Verificaciones de victoria
	write('Verificacion de victoria vertical: '),
	check_vertical_win(CurrentBoard, VerticalWinner),
	write(VerticalWinner),
	nl,

	write('Verificacion de victoria horizontal: '),
	check_horizontal_win(CurrentBoard, HorizontalWinner),
	write(HorizontalWinner),
	nl,

	write('Verificacion de victoria diagonal: '),
	check_diagonal_win(CurrentBoard, DiagonalWinner),
	write(DiagonalWinner),
	nl,

	write('Verificacion de ganador: '),
	who_is_winner(CurrentBoard, Winner),
	write(Winner),
	nl,

	% 8. Verificación de empate
	write('¿Es empate? '),
	is_draw(G7, IsDraw),
	nl,

	% 9. Finalizar juego y actualizar estadísticas
	end_game(G7, EndedGame),

	% 10. Historial de movimientos
	
	write('Historial de movimientos: '),
	game_history(EndedGame, History),
	write(History),
	nl,


	% 11. Mostrar estado final del tablero
	write('Estado final del tablero: '),
	game_get_board(EndedGame, FinalBoard),
	write(FinalBoard).