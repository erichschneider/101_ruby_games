#!/usr/bin/env ruby

# Produce a maze of arbitrary size with one guaranteed path through.
# Original author: Jack Hauber, Windsor, CT

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
    @visited = []
    @x = 0
    @y = 0
    @can_exit = false
    @exit_found = false

    @height.times { @visited << @width.times.map { 0 } }
    @height.times { @state << @width.times.map { 0 } }
    @x = @start_x = rand(width)
    @count = 1
    @visited[0][@x] = @count
    @count += 1

    while not done?
      @stuck = false
      if not at_left? and unvisited_left?
        if not at_top? and unvisited_above?
          if not at_right? and unvisited_right?
            case rand(3)
            when 0
              open_and_move_left()
            when 1
              open_and_move_up()
            when 2
              open_and_move_right()
            end
          else   # can't go right, can go left and up
            if can_go_down?
              case rand(3)
              when 0
                open_and_move_left()
              when 1
                open_and_move_up()
              when 2
                open_and_move_down()
              end
            else
              case rand(2)
              when 0
                open_and_move_left()
              when 1
                open_and_move_up()
              end
            end
          end
        else # can't go up, can go left
          if not at_right? and unvisited_right?
            if can_go_down?
              case rand(3)
              when 0
                open_and_move_left()
              when 1
                open_and_move_right()
              when 2
                open_and_move_down()
              end
            else
              case rand(2)
              when 0
                open_and_move_left()
              when 1
                open_and_move_right()
              end
            end
          else # can't go up or right, can go left
            if can_go_down?
              case rand(2)
              when 0
                open_and_move_left()
              when 1
                open_and_move_down()
              end
            else
              open_and_move_left()
            end
          end
        end
      else   # can't go left
        if not at_top? and unvisited_above?
          if not at_right? and unvisited_right?
            if can_go_down?
              case rand(3)
              when 0
                open_and_move_up()
              when 1
                open_and_move_right()
              when 2
                open_and_move_down()
              end
            else # can't go left or down
              case rand(2)
              when 0
                open_and_move_up()
              when 1
                open_and_move_right()
              end
            end
          else # can't go left or right
            if can_go_down?
              case rand(2)
              when 0
                open_and_move_up()
              when 1
                open_and_move_down()
              end
            else
              open_and_move_up()
            end
          end
        else  # can't go left or up
          if not at_right? and unvisited_right?
            if can_go_down?
              case rand(2)
              when 0
                open_and_move_right()
              when 1
                open_and_move_down()
              end
            else 
              open_and_move_right()
            end
          else
            if can_go_down?
              open_and_move_down()
            else
              @stuck = true
            end
          end
        end
      end
      if @stuck
        # raster scan for a spot we've visited already
        begin
          @x, @y = raster_advance(@x, @y)
        end while @visited[@y][@x] == 0
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

  def mark_current
    @visited[@y][@x] = @count
    @count += 1
  end

  def done? ; @count > @height * @width ; end
  def at_top? ; @y == 0 ; end
  def at_bottom? ; @y == @height-1 ; end
  def at_left? ; @x == 0 ; end
  def at_right? ; @x == @width - 1 ; end
  def unvisited_above? ; @visited[@y-1][@x] == 0 ; end
  def unvisited_below? ; @visited[@y+1][@x] == 0 ; end
  def unvisited_left? ; @visited[@y][@x-1] == 0 ; end
  def unvisited_right? ; @visited[@y][@x+1] == 0 ; end

  def open_and_move_right()
    @state[@y][@x] = @state[@y][@x] == 0 ? 2 : 3
    @x += 1
    mark_current()
  end

  def open_and_move_left()
    @x -= 1
    @state[@y][@x] = 2
    mark_current()
    @can_exit = false
  end

  def open_and_move_down()
    @state[@y][@x] = @state[@y][@x] == 0 ? 1 : 3
    if @can_exit
      @exit_found = true
      @can_exit = false
      @stuck = true
    else
      @y += 1
      mark_current()
    end
  end

  def open_and_move_up()
    @y -= 1
    @state[@y][@x] = @state[@y][@x] == 0 ? 1 : 3
    mark_current()
    @can_exit = false
  end

  def print_maze
    print @width.times.map { |i| i != @start_x ? ".--" : ".  " }.join("") + ".\n"
    @state.each do |row|
      print "I"
      row.each { |cell| print "  " + (cell < 2 ? "I" : " ") }
      print "\n"
      row.each { |cell| print ":" + (cell % 2 == 0 ? "--" : "  ") }
      print ":\n"
    end
  end
end

print_header()
Maze.new(*(get_dimensions())).print_maze()
