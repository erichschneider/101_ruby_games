#!/usr/bin/env ruby

# Produce a maze of arbitrary size with one guaranteed path through.
# Original author: Jack Hauber, Windsor, CT

$/ = nil

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
    dim_str = gets
    x,y = dim_str.split(',')
    if (x > 1 and y > 1)
      valid = true
    else
      print "MEANINGLESS DIMENSIONS.  TRY AGAIN.\n"
    end
  end while not valid
  4.times { print "\n" }
  return [x,y]
end

# maze states:
# 0 - right wall closed, floor closed
# 1 - right wall closed, floor open
# 2 - right wall open, floor closed
# 3 - right wall open, floor open

class Maze
  @height = 0 
  @width = 0 
  @start_x = 0
  @state = []
  @seen = []
  @x = 0
  @y = 0
  @count = 0
  @can_exit = false  # "q"
  @exit_found = false # "z"

  def initialize(height, width)
    height.times { @seen << width.times.map { 0 } }
    height.times { @state << width.times.map { 0 } }
    @x = @start_x = rand(width)
    @count = 1
    @seen[0][@x] = @count
    @count += 1

    while not done?
      if not at_left? and unseen_left?
        if not at_top? and unseen_above?
          if not at_right? and unseen_right?
            case rand[3]
            when 0
              open_and_move_left()
            when 1
              open_and_move_up()
            when 2
              open_and_move_right()
            end
          else   # can't go right, can go left and up
            if can_go_down?
              case rand[3]   # line 350
              when 0
                open_and_move_left()
              when 1
                open_and_move_up()
              when 2
                open_and_move_down()
              end
            else
              case rand[2]
              when 0
                open_and_move_left()
              when 1
                open_and_move_up()
              end
            end
          end
        else # can't go up, can go left
          if not at_right? and unseen_right?
            if can_go_down?
              case rand[3]
              when 0
                open_and_move_left()
              when 1
                open_and_move_right()
              when 2
                open_and_move_down()
              end
            else
              case rand[2]
              when 0
                open_and_move_left()
              when 1
                open_and_move_right()
              end
            end
          else # can't go up or right, can go left
            if can_go_down?
              case rand[2]
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
      return unseen_below?
    end
  end

  def mark_current
    @seen[@y][@x] = @count
    @count += 1
  end

  def done?
    @count > @height * @width
  end

  def at_top?
    @y == 0
  end

  def at_bottom?
    @y == @height-1
  end

  def at_left?
    @x == 0
  end

  def at_right?
    @x == @width - 1
  end

  def unseen_above?
    @seen[@y-1][@x] == 0
  end

  def unseen_below?
    @seen[@y+1][@x] == 0
  end

  def unseen_left?
    @seen[@y][@x-1] == 0
  end

  def unseen_right?
    @seen[@y][@x+1] == 0
  end

  def open_and_move_right()
    @state[@y][@x] += 2
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
    @y += 1
    mark_current()
  end

  def open_and_move_up()
    @y -= 1
    @state[@y][@x] = @state[@y][@x] == 0 ? 1 : 3
    mark_current()
    @can_exit = false
  end

  def print_maze
    print @width.times.map { |i| i == @start_x ? ".--" : ".  " } + "\n"
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
width, height = get_dimensions()

# initialize the "seen" and "maze" arrays to their default states
seen = []   # we fill this up with numbers as we process each cell
height.times { seen << width.times.map { 0 } }

maze = []
height.times { maze << width.times.map { 0 } }

q = 0   # q is set when a possible path through the maze to the bottom found
z = 0   # z is set when a path through the maze has been established already
# x is "r" in orig
# y is "s" in orig

