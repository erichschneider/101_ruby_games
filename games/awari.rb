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
    end
    return :continue
  end
        
  def process_move(move)
    score_pit = move < 6 ? 6 : 13
    final = (move + @board[move]) % 14
    1.upto(@board[move]) { |i| @board[(move+i) % 14] += 1 }
    @board[move] = 0
    # bonus move if the final stone sowed is in player's score pit
    grant_bonus = final == score_pit
    # if the final stone sowed is in an empty pit opposite a pit with stones,
    # move all of those stones to the player's score pit
    if @board[final] == 1 and final != 6 and final != 13 and @board[12-final]>0
      @board[score_pit] += @board[12-final] + 1
      @board[final] = @board[12-final] = 0
    end
    @end_state = end_check
    return grant_bonus
  end

  def process_and_record_move(move)
    @move_sequence << move % 7 if @move_sequence.count < 8
    return process_move(move)
  end

  def human_move(is_bonus)
    begin
      print is_bonus ? "AGAIN" : "YOUR MOVE"
      print "? "
      move = gets.chomp.to_i - 1
      move = (move < 0 or move > 5 or @board[move]==0) ? nil : move
      puts "ILLEGAL MOVE" unless move
    end until move
    return process_and_record_move(move)
  end

  def computer_move
    legal_moves = 7.upto(12).reject { |i| @board[i] == 0 }
    lowest_gain = 99
    choice = 0
    legal_moves.each do |candidate|
      saved_board = @board.clone
      process_move(candidate)
      human_moves = 0.upto(5).reject { |i| @board[i] == 0 }
      best_human_gain = human_moves.map do |human_choice|
        landing = human_choice + @board[human_choice]
        human_gain = 0
        if landing > 13
          landing = landing % 14
          human_gain = 1
        end
        if @board[landing] == 0 and landing != 6 and landing != 13
          human_gain += @board[12-landing]
        end
        human_gain
      end.max
      best_human_gain = 0 unless best_human_gain
      best_human_gain += score_difference
      if @move_sequence.count < 8
        check_sequence = @move_sequence.clone << (candidate % 7)
        check_len = check_sequence.count
        @@nonwinning_games.each do |past_game|
          best_human_gain += 
            check_sequence == past_game.first(check_len) ? 2 : 0
        end
      end

      @board = saved_board
      if best_human_gain <= lowest_gain
        lowest_gain = best_human_gain 
        choice = candidate
      end
    end
      
    return choice, process_and_record_move(choice)
  end

  def computer_moves
    move, bonus = computer_move
    print "MY MOVE IS #{1+move%7}"
    if @end_state == :continue and bonus
      move, bonus = computer_move
      print ",#{1+move%7}"
    end
    puts
  end

  def print_board
    print "\n   "
    12.downto(7) { |i| printf(" % 2s ", @board[i]) }
    puts
    printf(" % 2s%24s% 2s\n", @board[13], "", @board[6])
    print "   "
    0.upto(5) { |i| printf(" % 2s ", @board[i]) }
    2.times { puts }
  end

  def play_game
    print_board
    begin
      bonus = human_move(false)
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
      puts "YOU WIN BY #{score_difference} POINTS"
    when :computer
      puts "I WIN BY #{-score_difference} POINTS"
    when :draw
      puts "DRAWN GAME"
    end
    @@nonwinning_games << @move_sequence unless @end_state == :computer
  end
end

print_header
while true
  2.times { puts }
  Awari.new.play_game
end

