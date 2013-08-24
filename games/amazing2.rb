#!/usr/bin/env ruby

# Produce a maze of arbitrary size with one guaranteed path through.
# Original author: Jack Hauber, Windsor, CT
# Refactoring by Erich Schneider.

def print_header
  print " "*26 + "AMAZING PROGRAM\n"
  print " "*15 + "CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY\n"
  4.times { print "\n" }
end

def get_dimensions
  x,y = 0,0
  valid = false
  begin
    print("WHAT ARE YOUR WIDTH AND LENGTH? ")
    dim_str = gets.chomp
    x,y = dim_str.split(',').map { |s| s.to_i }
    if (x > 1 and y > 1)
      valid = true
    else
      print "MEANINGLESS DIMENSIONS.  TRY AGAIN.\n"
    end
  end while not valid
  4.times { print "\n" }
  return x,y
end

# maze states:
# 0 - right wall closed, floor closed
# 1 - right wall closed, floor open
# 2 - right wall open, floor closed
# 3 - right wall open, floor open

class Maze
  def initialize(width, height)
    @height = height
    @width = width
    @start_x = 0
    @state = []
    @x = 0
    @y = 0
    @can_exit = false
    @exit_found = false

    @height.times { @state << @width.times.map { :unvisited } }
    @x = @start_x = rand(width)
    @count = 1
    @state[0][@x] = 0
    @count += 1

    while not done?
      @stuck = false
      dir_funcs = []
      dir_funcs << self.method(:move_left) if not at_left? and unvisited_left?
      dir_funcs << self.method(:move_right) if not at_right? and unvisited_right?
      dir_funcs << self.method(:move_up) if not at_top? and unvisited_above?
      dir_funcs << self.method(:move_down) if can_go_down?
      if dir_funcs.length > 0
        dir_funcs[rand(dir_funcs.length)].call
      else
        @stuck = true
      end

      if @stuck   # note that move_down() could set @stuck to true also
        # raster scan for a spot we've visited already
        begin
          @x, @y = raster_advance(@x, @y)
        end while @state[@y][@x] == :unvisited
      end
    end
  end

  def raster_advance(x, y)
    if x == @width - 1
      x = 0
      y = y == @height-1 ? 0 : y+1
    else
      x += 1
    end
    return x,y
  end

  def can_go_down?
    if at_bottom?
      if not @exit_found
        @can_exit = true
        return true
      else
        return false
      end
    else
      return unvisited_below?
    end
  end

  def done? ; @count > @height * @width ; end
  def at_top? ; @y == 0 ; end
  def at_bottom? ; @y == @height-1 ; end
  def at_left? ; @x == 0 ; end
  def at_right? ; @x == @width - 1 ; end
  def unvisited_above? ; @state[@y-1][@x] == :unvisited ; end
  def unvisited_below? ; @state[@y+1][@x] == :unvisited ; end
  def unvisited_left? ; @state[@y][@x-1] == :unvisited ; end
  def unvisited_right? ; @state[@y][@x+1] == :unvisited ; end

  def move_right()
    @state[@y][@x] = @state[@y][@x] == 0 ? 2 : 3
    @x += 1
    @state[@y][@x] = 0
    @count += 1
  end

  def move_left()
    @x -= 1
    @state[@y][@x] = 2
    @count += 1
  end

  def move_down()
    @state[@y][@x] = @state[@y][@x] == 0 ? 1 : 3
    if @can_exit
      @exit_found = true
      @can_exit = false
      @stuck = true
    else
      @y += 1
      @count += 1
      @state[@y][@x] = 0
    end
  end

  def move_up()
    @y -= 1
    @state[@y][@x] = 1
    @count += 1
  end

  def print_maze
    print @width.times.map { |i| i != @start_x ? ".--" : ".  " }.join("") + ".\n"
    @state.each do |row|
      print "I"
      row.each { |cell| print "  " + (cell < 2 ? "I" : " ") }
      print "\n"
      row.each { |cell| print ":" + (cell % 2 == 0 ? "--" : "  ") }
      print ".\n"
    end
  end
end

print_header()
Maze.new(*(get_dimensions())).print_maze()
