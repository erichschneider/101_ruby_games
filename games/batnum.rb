#!/usr/bin/env ruby

def print_header()
  printf("%18sBATNUM\n", "")
  puts("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY")
  2.times { puts }
  print <<EOM
THIS PROGRAM IS A 'BATTLE OF NUMBERS'
GAME, WHERE THE COMPUTER IS YOUR OPPONENT

THE GAME STARTS WITH AN ASSUMED PILE OF OBJECTS.
YOU AND YOUR OPPONENT ALTERNATELY REMOVE OBJECTS FROM
THE PILE.  WINNING IS DEFINED IN ADVANCE AS TAKING THE
LAST OBJECT OR NOT.  YOU CAN ALSO SPECIFY SOME OTHER
BEGINNING CONDITIONS.  DON'T USE ZERO, HOWEVER, IN
PLAYING THE GAME.

EOM
end

class BatnumGame
  def initialize
    done = false
    until done
      print "ENTER PILE SIZE? "
      @n = gets.chomp
      if @n.to_i != 0
        if @n.to_i.to_s == @n && @n.to_i > 0
          done = true
          @n = @n.to_i
        else
          10.times { puts }
        end
      end
    end

    begin
      print "ENTER WIN OPTION - 1 TO TAKE LAST, 2 TO AVOID LAST: ? "
      m = gets.chomp.to_i
    end until m == 1 || m == 2
    @take_last = m == 1

    done = false
    until done
      print "ENTER MIN AND MAX ? "
      @min, @max = gets.chomp.split(",")
      if @min.to_i.to_s == @min && @max.to_i.to_s
        @min = @min.to_i
        @max = @max.to_i
        if 0 < @min && @min <= @max 
          done = true
        end
      end
    end
    
    begin
      print "ENTER START OPTION - 1 COMPUTER FIRST, 2 YOU FIRST ? "
      s = gets.chomp.to_i
    end until s == 1 || s == 2
    @skip_first = s == 2
  end

  def play
    @game_over = false
    until @game_over
      if @skip_first
        @skip_first = false
      else
        computer_move()
      end
      human_move() unless @game_over
    end
  end

  def computer_move
    q = @n - (@take_last ? 0 : 1)
    if @take_last && @n <= @max
      @game_over = true
      puts "COMPUTER TAKES #{@n} AND WINS."
    elsif !@take_last && @n <= @min
      @game_over = true
      puts "COMPUTER TAKES #{@n} AND LOSES."
    else
      p = [@min, q % (@min+@max), @max].sort[1]
      @n -= p
      puts "COMPUTER TAKES #{p} AND LEAVES #{@n}"
    end
  end

  def human_move
    print "YOUR MOVE ? "
    done = false
    until done
      p = gets.chomp
      if p.to_i.to_s == p
        p = p.to_i
        done = p == 0 || (p <= @min && p == @n) || 
          (p >= @min && p <= @max && p <= @n)
      end
      puts "ILLEGAL MOVE, REENTER IT " unless done
    end
    if p == 0
      puts "I TOLD YOU NOT TO USE ZERO! COMPUTER WINS BY FORFEIT."
      @game_over = true
    else
      @n -= p
      if @n == 0
        @game_over = true
        puts (@take_last ? "CONGRATULATIONS, YOU WIN." : 
              "TOUGH LUCK, YOU LOSE.")
      end
    end
  end
end

print_header()
while true
  game = BatnumGame.new
  game.play
  10.times { puts }
end
