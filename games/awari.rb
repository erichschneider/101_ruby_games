#!/usr/bin/env ruby

# Awari - classic West African game
# Original author: Geoff Wyvill

def print_header
  printf("%34s%s\n", "", "AWARI")
  printf("%15s%s\n", "", "CREATIVE COMPUTING  MORRISTWON, NEW JERSEY")
end

class Awari
  @@nonwinning_games = []

  def initialize
    @board = 14.times.map { |i| (i+1) % 7 == 0 ? 0 : 3 }
    @end_state = :continue
    @move_sequence = []
  end

  def score_difference ; @board[6] - @board[13] ; end

  def end_check
    if @board[0..5].select {|i| i > 0}.empty? or
        @board[7..12].select {|i| i > 0}.empty?
      return [:draw, :human, :computer][@board[6] <=> @board[13]]
    else
      return :continue
    end
  end
        
  def process_move(move)
    home_pit = move < 6 ? 6 : 13
    final = (move + @board[move]) % 14
    1.upto(@board[move]) { |i| @board[(move+i) % 14] += 1 }
    @board[move] = 0
    # bonus move if the final stone sowed is in player's score pit
    grant_bonus = final == home_pit
    # if the final stone sowed is in an empty pit opposite a pit with stones,
    # move all of those stones to the player's score pit
    if @board[final] == 1 and final != 6 and final != 13 and @board[12-final]>0
      @board[home_pit] += @board[12-final] + 1
      @board[final] = @board[12-final] = 0
    end
    @move_sequence << move % 7 if @move_sequence.length < 8
    @end_state = end_check
    return grant_bonus
  end

  def human_move(is_bonus)
    begin
      print is_bonus ? "AGAIN" : "YOUR MOVE"
      print "? "
      move = gets.chomp.to_i - 1
      move = (move < 0 or move > 5 or @board[move]==0) ? nil : move
    end until move
    grant_bonus = process_move(move)
    return move, grant_bonus
  end


# F is initialized to 0 everywhere
# N is initialized to 0
# After each move, for the first 8 moves F(N) is set to F(N)*6 + K (the move)
# => so essentially it stores the first 8 moves of the game
# N is incremented for each computer non-win
# 
# Then when evaluating computer moves, it looks at all past games in F
# If the value it would get by computing the F(N) update for the current move
# would be the same as the value for a past game in the array, it decrements 
# the of Q for the game by 2 each time that happens
# i.e. it avoids making moves that led to non-winning games

# computer move algorithm:
# set D to -99
# save the board
# -> find the legal move that maximizes "Q", a modified version of the net
#    gain the computer makes by making that move and then the player's
#    next move
# for each legal move that exists:
#   process that move
#   -> compute Q, maximum possible score human could make
#   examine human's side; for each pit that has stones:
#     -> compute R, human's possible score by picking that pit
#     set L to # of stones plus its position 0-5 and R to 0
#     set L to L%14 and R to L/14
#     if B(L) is 0 and L is not a home pit set R to B(12-L)+R
#     set Q to R if R > Q        
#   set Q to computer's score advantage minus Q
#   if current move count is 8 or less:
#     set K to current possible move pit minus 7 (computer's label persepctive)
#     for I from 0 to N-1, if F(N)*6+K = int(F(I)/6^(7-C)+.1) Q= Q-2
#   reset the board
#   if Q >= D set A to the current legal move and D to Q
# the computer's move is A

  def computer_move
    move_sequence_len = @move_sequence.length
    current_score_difference = score_difference
    legal_moves = 7.upto(12).reject { |i| @board[i] == 0 }
    evaluations = legal_moves.map do |choice|
      saved_board = @board.clone
      process_move(choice)
      human_moves = 0.upto(5).reject { |i| @board[i] == 0 }
      human_max = human_moves.map do |human_choice|
        saved_board2 = @board.clone
        process_move(human_choice)
        net = score_difference - current_score_difference
        @board = saved_board2
        net
      end.max
      human_max = 0 if human_max = nil
      check_sequence = 
        if move_sequence_len < 7
          @move_sequence.first(move_sequence_len).clone << choice
        else
          @move_sequence.first(8)
        end
      losing_game_mod = @@nonwinning_games.inject(0) do |total, past_game|
        total + check_sequence == past_game.first(check_sequence.count) ? 2 : 0
      end
      @board = saved_board
      human_max + losing_game_mod
    end
    choice = legal_moves[evaluations.index(evaluations.min)]
    @move_sequence = @move_sequence.first(move_sequence_len)
    return choice, process_move(choice)
  end

  def computer_moves
    move, bonus = computer_move
    print "MY MOVE IS #{1+move%7}"
    if @end_state == :continue and bonus
      move, bonus = computer_move
      print ", #{1+move%7}"
    end
    puts
  end

  def print_board
    puts
    print "   "
    12.downto(7) { |i| printf(" %02s ", @board[i].to_s) }
    puts
    printf(" %02s%24s%02s\n", @board[13].to_s, "", @board[6].to_s)
    print "   "
    0.upto(5) { |i| printf(" %02s ", @board[i].to_s) }
    2.times { puts }
  end

  def play_game
    print_board
    begin
      chosen, bonus = human_move(false)
      print_board
      if @end_state == :continue and bonus
        human_move(true)
        print_board
      end
      if @end_state == :continue
        computer_moves
        print_board
      end
    end while @end_state == :continue
    puts "GAME OVER"
    case @end_state
    when :human
      @@nonwinning_games << @move_sequence
      puts "YOU WIN BY #{score_difference} POINTS"
    when :computer
      puts "I WIN BY #{-score_difference} POINTS"
    when :draw
      @@nonwinning_games << @move_sequence
      puts "DRAWN GAME"
    end
  end
end

print_header
while true
  2.times { puts }
  Awari.new.play_game
end

