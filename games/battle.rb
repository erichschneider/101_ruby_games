#!/usr/bin/env ruby

# Battleship game
# Original author: Ray Westergard, Lawrence Hall of Science, UC Berkeley

def print_header
  printf("%18sBATTLE\n", "")
  puts "CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
end

class Battleship

  def initialize
    @f = (1..6).map { (1..6).map { 0 } }
    @hits = (1..6).map { (1..6).map { false } }
    @sunk = [0,0,0]
    @hits_left = [2,2,3,3,4,4]
    @miss_count = 0
    @hit_count = 0
    [4,3,2].each do |size|  # lengths of ships: 4, 3, 2
      2.times do |num| # 2 ships of each length
        begin
          a,b,d = generate_origin_and_direction()
          ship_num = 2*(size-1) - num
          success = try_and_place(a,b,size,d,ship_num)
        end until success
      end
    end
  end

  def generate_origin_and_direction
    a,b = [0,0]
    begin
      a = rand(6)
      b = rand(6)
    end while @f[a][b] != 0
    d = [:vert, :nwse, :horiz, :nesw][rand(4)]
    return [a,b,d]
  end

  def try_and_place(a,b,size,dir, ship_num)
    # technique - we start at the relevant coordinate and try and
    # move in the relevant direction "forward".
    # If an obstruction is reached, try going "backward" from the
    # start point.
    # If that doesn't work, bail out.
    x_locs = [a,6,6,6]
    y_locs = dir == :nesw ? [b,0,0,0] : [b,6,6,6]
    x_inc = dir == :vert ? 0 : 1
    y_inc = dir == :horiz ? 0 : (dir == :nesw ? -1 : 1)
    forward = true
    (0..size-2).each do |k|
      if forward
        if dir != :vert && x_locs[k] == 5 ||
          y_inc == 1 && y_locs[k] == 5 ||
            y_inc == -1 && y_locs[k] == 0
          # we're at the edge of the world and can't move forward
          forward = false
        else
          if @f[x_locs[k]+x_inc][y_locs[k]+y_inc] != 0
            # another ship is in the next space
            forward = false
          elsif x_inc != 0 && y_inc != 0 &&
              @f[x_locs[k]][y_locs[k]+y_inc] != 0 &&
              @f[x_locs[k]][y_locs[k]+y_inc] == @f[x_locs[k]+x_inc][y_locs[k]]
            # we're moving diagonally and moving forward would go through
            # another diagonal ship
            forward = false
          else
            x_locs[k+1] = x_locs[k] + x_inc
            y_locs[k+1] = y_locs[k] + y_inc
          end
        end
      end
      if !forward
        xmin = x_locs.min
        ymin = y_inc == -1 ? y_locs.max : y_locs.min
        # next three rules - can't move off the edge of the world
        return false if x_inc > 0 && xmin == 0
        return false if y_inc > 0 && ymin == 0
        return false if y_inc < 0 && ymin == 5
        # can't move onto another ship
        return false if @f[xmin-x_inc][ymin-y_inc] > 0
        # can't interpenetrate a diagonal ship
        return false if x_inc != 0 && y_inc != 0 &&
              @f[xmin][ymin-y_inc] != 0 &&
              @f[xmin][ymin-y_inc] == @f[xmin-x_inc][ymin]
        x_locs[k+1] = xmin - x_inc
        y_locs[k+1] = ymin - y_inc
      end
    end
    (0..size-1).each do |k|
      @f[x_locs[k]][y_locs[k]] = ship_num
    end
    return true
  end

  def print_coded_display
    puts
    puts "THE FOLLOWING CODE OF THE BAD GUYS' FLEET DISPOSITION"
    puts "HAS BEEN CAPTURED BUT NOT DECODED:"
    puts
    (0..5).each { |y| puts (0..5).map { |x| " #{@f[y][x]} " }.join }
    puts
    puts "DE-CODE IT AND USE IT IF YOU CAN"
    puts "BUT KEEP THE DE-CODING METHOD A SECRET."
    puts
  end

  def play_game
    puts "START GAME"
    begin
      r, c = [0,0]
      begin
        print "? "
        inp = gets.chomp
        c,r = inp.split(",").map { |s| s.to_i }
        puts "INVALID INPUT.  TRY AGAIN." unless (1..6)===r && (1..6)===c
      end until (1..6) === r && (1..6) === c
      r = 6-r
      c -= 1
      if @f[c][r] == 0
        @miss_count += 1
        puts "SPLASH!  TRY AGAIN."
      elsif @hits_left[@f[c][r]-1] == 0
        @miss_count += 1
        puts "THERE USED TO BE A SHIP AT THAT POINT, BUT YOU SUNK IT."
        puts "SPLASH!  TRY AGAIN."
      elsif @hits[c][r]
        @miss_count += 1
        puts "YOU ALREADY PUT A HOLE IN SHIP NUMBER #{@f[c][r]} AT THAT POINT."
        puts "SPLASH!  TRY AGAIN."
      else
        @hit_count += 1
        @hits[c][r] = true
        puts "A DIRECT HIT ON SHIP NUMBER #{@f[c][r]}"
        @hits_left[@f[c][r]-1] -= 1
        if @hits_left[@f[c][r]-1] > 0
          puts "TRY AGAIN."
        else
          ship_type = ((@f[c][r]-1)/2).to_i
          @sunk[ship_type] += 1
          puts "AND YOU SUNK IT.  HURRAH FOR THE GOOD GUYS."
          puts "SO FAR, THE BAD GUYS HAVE LOST"
          puts " #{@sunk[0]} DESTROYER(S),    #{@sunk[1]} CRUISER(S), AND   #{@sunk[2]} AIRCRAFT CARRIER(S)."
          puts "YOUR CURRENT SPLASH/HIT RATIO IS #{@miss_count.to_f/@hit_count}"
        end
      end
    end while @sunk[0] + @sunk[1] + @sunk[2] < 6
    puts
    puts "YOU HAVE TOTALLY WIPED OUT THE BAD GUYS' FLEET"
    puts "WITH A FINAL SPLASH/HIT RATIO OF #{@miss_count.to_f / @hit_count}"
    if @miss_count == 0
      puts "CONGRATULATIONS -- A DIRECT HIT EVERY TIME."
    end
    puts
    puts "****************************"
    puts
  end
end

print_header()
while true
  b = Battleship.new()
  b.print_coded_display()
  b.play_game()
end
