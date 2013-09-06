#!/usr/bin/env ruby

# Simulate a game of college basketball - Dartmouth vs. team of your choice
# Original author: Charles Bacheller, Dartmouth College

def print_header
  printf("%31sBASKETBALL\n", "")
  printf("%15sCREATIVE COMPUTING  MORRISTOWN, NEW JERSEY", "")
  3.times { puts }
  print EOM
THIS IS DARTMOUTH COLLEGE BASKETBALL.  YOU WILL BE DARTMOUTH
  CAPTAIN AND PLAYMAKER.  CALL SHOTS AS FOLLOWS: 1. LONG
  (30 FT.) JUMP SHOT; 2. SHORT (15 FT.) JUMP SHOT; 3. LAY
  UP; 4. SET SHOT.
BOTH TEAMS WILL USE THE SAME DEFENSE.  CALL DEFENSE AS
FOLLOWS:  6. PRESS; 6.5 MAN-TO MAN; 7.ZONE; 7.5 NONE.
  TO CHANGE DEFENSE, JUST TYPE  0  AS YOUR NEXT SHOT.
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
    @rng = Random.new()
  end

  def get_defense(is_starting)
    prompt = is_starting ? "YOUR STARTING DEFENSE WILL BE? " :
      "YOUR NEW DEFENSIVE ALIGNMENT IS? "
    @defense = 0
    begin
      printd(prompt)
      @defense = gets.chomp.to_i
      prompt = "YOUR NEW DEFENSIVE ALIGNMENT IS? "
    end while @defense < 6
    puts
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
        if shot < 0 or shot > 4
          puts "INCORRECT ANSWER. RETYPE IT."
          shot = -1
        elsif shot == 0
          get_defense(false)
        end
      end
    end while shot < 1
    return shot
  end

  def rand_test(val)
    return @rng.rand(1.0) <= val
  end

  def center_jump
    puts "CENTER JUMP"
    @control = rand_test(3/5) ? :dartmouth : :opponent
    puts "#{@control ? "DARTMOUTH" : @opponent} CONTROLS THE TAP."
    puts
  end

  def clock_tick
    @clock += 1
    if clock == 50
      return false  # end of first half
    elsif clock == 92 and @control == :dartmouth
      puts "   *** TWO MINUTES LEFT IN THE GAME ***"
      puts
    end
    return true
  end

  def score(side, amt)
    @scores[side] += amt
    puts "SCORE:  #{@scores[:dartmouth]} TO #{@scores[:opponent]}"
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
          resolve_dartmouth_other_shot(3)
        else
          if @defense != 6 or rand_test(0.6)
            puts "BALL PASSED BACK TO YOU."
            

        else
          puts "REBOUND TO #{@opponent}."
          @control = :opponent
        end
    


  def play_period
    period_over = false
    while not period_over
      if @control == :dartmouth
        shot = get_shot
        if (@rng.rand(1.0) < 0.5 or @clock < 100) and clock_tick
          if shot == 1 or shot == 2
            resolve_dartmouth_jump_shot()



          else
            puts shot == 3 ? "LAY UP." : "SET SHOT."
          end

        else
          period_over = true
        end
      else
      end
      

  end

end





rng = Random.new()
control = rng.rand(1.0) < 0.6 ? :dartmouth : :opponent

puts "#{control == :dartmouth ? "DARTMOUTH" : opponent} CONTROLS THE TAP."
puts

if control == :dartmouth
  p = 0
  shot = nil
  begin
    printf("YOUR SHOT? ")
    shot = gets.chomp
    shot != shot.to_i.to_s or shot < 0 or shot > 4 ? nil : shot.to_i
    puts "INCORRECT ANSWER.  RETYPE IT. " unless shot
  end until shot

  if clock < 100 or rand(2) == 0
    if shot == 1 or shot == 2
      clock += 1
      # TODO time check here
      puts "JUMP SHOT"
      if rng.rand(1.0) <= .341 * defense / 8
        puts "SHOT IS GOOD."
        score(:dartmouth, 2)
      else
        if rng.rand(1.0) <= .682 * defense/8
          puts "SHOT IS OFF TARGET."
          if rng.rand(1.0)* (defense/6) <= 0.45
            puts "DARTMOUTH CONTROLS THE REBOUND."
          else
            puts "REBOUND TO #{opponent}"
            # change control to opponent
          end
        elsif rng.rand(1.0) <= 0.782 * defense/8
          printf("SHOT IS BLOCKED.  BALL CONTROLLED BY ")
          if rand(2) == 0
            puts "DARTMOUTH."
            # dartmouth still in control, take another shot
          else
            puts "#{opponent}."
            # change control to opponent
          end
        elsif rng.rand(1.0) <= 0.843 * defense/8
          puts("SHOOTER IS FOULED. TWO SHOTS.")
          #foul subroutine here
          #switch control to opponent
        else
          puts("CHARGING FOUL. DARTMOUTH LOSES BALL.")
          #switch control to opponent
        end
      end
    end
    # other shot types
    clock += 1
    # TODO time check here
    if shot == 0
      defense = nil
      begin
        printf "YOUR NEW DEFENSIVE ALIGNMENT IS? "
        defense = gets.chomp.to_i
      end until defense < 6
      # select another shot
    elsif shot == 3 or shot == 4
      puts shot == 3 ? "LAY UP." : "SET SHOT."
      if rng.rand(1.0) <= 0.4 * defense/7
        puts "SHOT IS GOOD. TWO POINTS."
        score(:dartmouth, 2)
      elsif rng.rand(1.0) <= 0.7 * defense/7
        puts "SHOT IS OFF THE RIM."
        if rng.rand(1.0) <= 2/3
          puts "#{opponent} CONTROLS THE REBOUND."
          # change control to opponent
        else
          puts "DARTMOUTH CONTROLS THE REBOUND."
          if rng.rand(1.0) <= 0.4
            # rerun the same shot
          else
            puts "BALL PASSED BACK TO YOU."
            # select another shot
          end
        end
      end
    end
  
  

  
