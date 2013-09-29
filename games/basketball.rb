#!/usr/bin/env ruby

# Simulate a game of college basketball - Dartmouth vs. team of your choice
# Original author: Charles Bacheller, Dartmouth College

def print_header
  printf("%31sBASKETBALL\n", "")
  printf("%15sCREATIVE COMPUTING  MORRISTOWN, NEW JERSEY", "")
  3.times { puts }
  print <<EOM
THIS IS DARTMOUTH COLLEGE BASKETBALL.  YOU WILL BE DARTMOUTH
  CAPTAIN AND PLAYMAKER.  CALL SHOTS AS FOLLOWS: 1. LONG
  (30 FT.) JUMP SHOT; 2. SHORT (15 FT.) JUMP SHOT; 3. LAY
  UP; 4. SET SHOT.
BOTH TEAMS WILL USE THE SAME DEFENSE.  CALL DEFENSE AS
FOLLOWS:  6. PRESS; 6.5 MAN-TO MAN; 7.ZONE; 7.5 NONE.
  TO CHANGE DEFENSE, JUST TYPE  0  AS YOUR NEXT SHOT.
EOM
end

class BasketballGame
  def initialize
    get_defense(true)
    puts
    printf("CHOOSE YOUR OPPONENT? ")
    @opponent = gets.chomp.upcase
    @control = nil
    @scores = {dartmouth: 0, opponent: 0}
    @clock = 0
    @forced_shot = nil
    @rng = Random.new()
  end

  def get_defense(is_starting)
    prompt = is_starting ? "YOUR STARTING DEFENSE WILL BE? " :
      "YOUR NEW DEFENSIVE ALIGNMENT IS? "
    @defense = 0
    begin
      print prompt
      @defense = gets.chomp.to_i
      prompt = "YOUR NEW DEFENSIVE ALIGNMENT IS? "
    end while @defense < 6
  end

  def get_shot
    printf("YOUR SHOT? ")
    shot = -1
    begin
      shot_s = gets.chomp
      if shot_s != shot_s.to_i.to_s
        puts "INCORRECT ANSWER.  RETYPE IT. "
      else
        shot = shot_s.to_i
        if shot < 0 || shot > 4
          puts "INCORRECT ANSWER. RETYPE IT."
          shot = -1
        end
      end
    end while shot < 0
    return shot
  end

  def rand_test(val)
    return @rng.rand(1.0) <= val
  end

  def center_jump
    puts "CENTER JUMP"
    @control = rand_test(3.0/5) ? :dartmouth : :opponent
    puts "#{@control == :dartmouth ? "DARTMOUTH" : @opponent} CONTROLS THE TAP."
    puts if @control == :dartmouth
  end

  def score(side, amt)
    @scores[side] += amt
    puts "SCORE:  #{@scores[:dartmouth]} TO #{@scores[:opponent]}"
  end

  def free_throws(side)
    if rand_test(0.49)
      puts "SHOOTER MAKES BOTH SHOTS."
      score(side, 2)
    elsif rand_test(0.75)
      puts "SHOOTER MAKES ONE SHOT AND MISSES ONE."
      score(side, 1)
    else
      puts "BOTH SHOTS MISSED."
    end
  end

  def resolve_dartmouth_jump_shot
    puts "JUMP SHOT."
    if rand_test(0.341 * @defense/8)
      puts "SHOT IS GOOD."
      score(:dartmouth, 2)
      @control = :opponent
    elsif rand_test(0.682 * @defense/8)
      puts "SHOT IS OFF TARGET."
      if rand_test(0.45 * 6 / @defense)
        puts "DARTMOUTH CONTROLS THE REBOUND."
        if rand_test(0.4)
          @forced_shot = 3
        else
          if @defense != 6 || rand_test(0.6)
            puts "BALL PASSED BACK TO YOU."
          else
            puts "PASS STOLEN BY #{@opponent} EASY LAYUP."
            score(:opponent, 2)
            puts
          end
        end
      else
        puts "REBOUND TO #{@opponent}."
        @control = :opponent
      end
    elsif rand_test(0.782 * @defense / 8)
      @control = rand_test(0.5) ? :dartmouth : :opponent
      print "SHOT IS BLOCKED.  BALL CONTROLLED BY "
      print (@control == :dartmouth ? "DARTMOUTH" : @opponent)
      puts "."
    elsif rand_test(0.843 * @defense / 8)
      puts "SHOOTER IS FOULED.  TWO SHOTS."
      free_throws(:dartmouth)
      @control = :opponent
    else
      puts "CHARGING FOUL.  DARTMOUTH LOSES BALL."
      @control = :opponent
    end

    # NB there is a code segment in the BASIC inserted between the
    # "shot off target" section and the "shot block check" section
    # that is not called anywhere. It would look like this:
    # elsif rand_test(0.9)
    #   puts "PLAYER FOULED, TWO SHOTS."
    #   free_throws(:dartmouth)
    #   @control = :opponent
    # else
    #   puts "BALL STOLEN.  #{@opponent}'S BALL."
    #   @control = :opponent
    # end

  end

  def resolve_dartmouth_other_shot(shot)
    puts shot == 3 ? "LAY UP." : "SET SHOT."
    if rand_test(0.4 * @defense / 7)
      puts "SHOT IS GOOD.  TWO POINTS."
      score(:dartmouth, 2)
      @control = :opponent
    elsif rand_test(0.7 * @defense / 7)
      puts "SHOT IS OFF THE RIM."
      if rand_test(2.0/3)
        puts "#{@opponent} CONTROLS THE REBOUND."
        @control = :opponent
      else
        puts "DARTMOUTH CONTROLS THE REBOUND."
        if rand_test(0.4)
          @forced_shot = shot
        else
          puts "BALL PASSED BACK TO YOU."
        end
      end
    elsif rand_test(0.875 * @defense / 7)
      puts "SHOOTER FOULED.  TWO SHOTS."
      free_throws(:dartmouth)
      @control = :opponent
    elsif rand_test(0.925 * @defense/7)
      puts "SHOT BLOCKED. #{@opponent}'S BALL."
      @control = :opponent
    else
      puts "CHARGING FOUL.  DARTMOUTH LOSES THE BALL."
      @control = :opponent
    end
  end    
      
  def resolve_opponent_shot
    if @forced_shot.nil?
      shot = 10.0 / 4 * rand(1.0) + 1
    else
      shot = @forced_shot
      @forced_shot = nil
    end
    if shot <= 2
      puts "JUMP SHOT."
      if rand_test(0.35 * @defense / 8)
        puts "SHOT IS GOOD."
        score(:opponent, 2)
        puts
        @control = :dartmouth
      elsif rand_test(0.75 * @defense / 8)
        puts "SHOT IS OFF THE RIM."
        opponent_shot_off_rim()
      elsif rand_test(0.9 * @defense / 8)
        puts "PLAYER FOULED.  TWO SHOTS."
        free_throws(:opponent)
        puts
        @control = :dartmouth
      else
        puts "OFFENSIVE FOUL.  DARTMOUTH'S BALL."
        puts
        @control = :dartmouth
      end
    else
      puts shot > 3 ? "SET SHOT." : "LAY UP."
      if rand_test(0.413 * @defense / 7)
        puts "SHOT IS GOOD."
        score(:opponent, 2)
        puts
        @control = :dartmouth
      else
        puts "SHOT IS MISSED."
        opponent_shot_off_rim()
      end
    end
  end

  def opponent_shot_off_rim()
    if rand_test(0.5 * 6 / @defense)
      puts "DARTMOUTH CONTROLS THE REBOUND."
      puts
      @control = :dartmouth
    else
      puts "#{@opponent} CONTROLS THE REBOUND."
      if @defense == 6
        if rand_test(0.75)
          if rand_test(0.5)
            puts "PASS BACK TO #{@opponent} GUARD."
          else
            @forced_shot = 3
          end
        else
          puts "BALL STOLEN.  EASY LAY UP FOR DARTMOUTH."
          score(:dartmouth, 2)
        end
      else
        if rand_test(0.5)
          puts "PASS BACK TO #{@opponent} GUARD."
        else
          @forced_shot = 3
        end
      end
    end
  end    

  def first_half_end()
    puts "   ***** END OF FIRST HALF *****"
    puts "SCORE: DARTMOUTH #{@scores[:dartmouth]} #{@opponent} #{@scores[:opponent]}"
    puts ; puts
    center_jump()
  end

  def two_minutes_left()
    puts 
    puts "   *** TWO MINUTES LEFT IN THE GAME ***"
    puts
  end

  # returns a boolean saying whether game is over
  def second_half_end()
    puts
    if @scores[:dartmouth] == @scores[:opponent]
      puts "   ***** END OF SECOND HALF *****"
      puts "SCORE AT END OF REGULATION TIME:"
      puts "        DARTMOUTH #{@scores[:dartmouth]} #{@opponent} #{@scores[:opponent]}"
      puts
      puts "BEGIN TWO MINUTE OVERTIME PERIOD"
      @clock = 93
      center_jump()
      return false
    else
      puts "   ***** END OF GAME *****"
      puts "FINAL SCORE: DARTMOUTH #{@scores[:dartmouth]} #{@opponent} #{@scores[:opponent]}"
      return true
    end
  end
    

  def play_game
    game_over = false
    center_jump() 
    while !game_over
      if @control == :dartmouth
        if @forced_shot.nil?
          shot = get_shot
        else
          shot = @forced_shot
          @forced_shot = nil
        end
        if (@rng.rand(1.0) < 0.5 || @clock < 100)
          @clock += 1
          if @clock == 50
            first_half_end()
          else
            two_minutes_left() if @clock == 92
            if shot == 0
              get_defense(false)
              puts
            elsif shot == 1 || shot == 2
              resolve_dartmouth_jump_shot()
            else
              resolve_dartmouth_other_shot(shot)
            end
          end
        else
          game_over = second_half_end()
        end
      else
        # opponent
        @clock += 1
        if @clock == 50
          first_half_end()
          # NB there is a line in the BASIC that is never reached that
          # invokes the "two minute warning" subroutine
        else
          puts
          resolve_opponent_shot()
        end
      end
    end
  end

  print_header()
  game = BasketballGame.new()
  game.play_game()
end

