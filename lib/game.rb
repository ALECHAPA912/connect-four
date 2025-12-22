require_relative 'miscellaneous.rb'

class Game
  
  include Miscellaneous

  def initialize
    @players = [red_token, yellow_token]
    @current_player = 0
    @board = Array.new(7) { Array.new(6, white_token) }
    @WINNING_COMBINATIONS = winning_combinations
  end

  def play
    greetings 
    print_board
    until check_winner || board_full? do
      do_a_play
      switch_current_player
      print_board
    end
    if draw?
      puts "I'ts a draw! Play again!"
    else
      puts "Congratulations player #{check_winner} you WON the game!"
    end
  end

  def do_a_play
    puts "It's your turn player #{@players[@current_player]}, select a column! (1-7)"
    selection = verify_input(gets.chomp)
    until selection do
      selection = verify_input(gets.chomp)
    end
    put_token(@players[@current_player], selection.to_i-1)
  end

  def draw?
    board_full? && check_winner.nil?
  end

  def board_full?
    @board.all? { |column| column_full?(column) }
  end

  private

  def put_token(current_player, column)
    row = next_empty_row(column)
    @board[column][row] = current_player
  end

  def verify_input(input)
    if !input.match?(/\A[1-7]\z/)
      puts "\nIncorrect input player #{@players[@current_player]}, insert a valid input! (1-7)"
    elsif column_full?(@board[input.to_i-1])
      puts "\nColumn #{input} is full player #{@players[@current_player]}! Please choose other column."
    else
      return input
    end
    nil
  end

  def column_full?(column)
    column.all? { |row| row != white_token }
  end

  def greetings
    puts "\nWelcome to Alejandro's Connect Four Game!"
  end

  def print_board
    puts "\n"
    puts (1..@board.count).map { |n| " #{n} ".center(3) }.join(" ")
    
    puts "---------------------------"

    (0..5).each do |row|
      (0..6).each do |col|
        print " #{@board[col][row]} "
        print "\n\n" if col == 6
      end
    end
    
    puts "---------------------------"
    puts "\n"
  end

  def switch_current_player
    @current_player = @current_player == 1 ? 0 : 1
  end

  def next_empty_row(column)
    row = 5
    until @board[column][row] == white_token do
      row -= 1
    end
    row
  end

  def check_winner
    # Iteramos sobre las 69 combinaciones pre-calculadas
    @WINNING_COMBINATIONS.each do |combination|
      # combination es algo como: [[0,0], [0,1], [0,2], [0,3]]
    
      # Extraemos los valores del tablero actual
      # Usamos safe navigation (&.) o chequeo de nil porque tu fila puede no tener 6 elementos aún
      tokens = combination.map do |col, row|
        @board[col][row]
      end

      # Si los 4 son iguales y no son nil, tenemos ganador
      if tokens.all? { |token| token == red_token } # O el símbolo que uses para Rojo
        return red_token
      elsif tokens.all? { |token| token == yellow_token } # O el símbolo para Amarillo
        return yellow_token
      end
    end

    nil # No hay ganador
  end

  def winning_combinations
    # Array con todas las combinaciones posibles
    # Cada combinación es un array de 4 coordenadas: [[c,r], [c,r], [c,r], [c,r]]
    result = []
    # 1. Verticales (|)
    # Recorremos las 7 columnas. Las filas solo pueden empezar de 0 a 2 para que quepan 4 fichas.
    (0..6).each do |col|
      (0..2).each do |row|
        result << [[col, row], [col, row+1], [col, row+2], [col, row+3]]
      end
    end
    # 2. Horizontales (-)
    # Las columnas solo de 0 a 3 para que quepan 4 fichas. Recorremos las 6 filas.
    (0..3).each do |col|
      (0..5).each do |row|
        result << [[col, row], [col+1, row], [col+2, row], [col+3, row]]
      end
    end
    # 3. Diagonales ascendentes (/)
    # Hacia arriba y derecha. Columna max 3, Fila max 2.
    (0..3).each do |col|
      (0..2).each do |row|
        result << [[col, row], [col+1, row+1], [col+2, row+2], [col+3, row+3]]
      end
    end
    # 4. Diagonales descendentes (\)
    # Hacia abajo y derecha. Columna max 3, Fila min 3 (para tener espacio hacia abajo).
    (0..3).each do |col|
      (3..5).each do |row|
        result << [[col, row], [col+1, row-1], [col+2, row-2], [col+3, row-3]]
      end
    end
    result
  end
end