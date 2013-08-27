#!/usr/bin/env ruby

# Awari - classic West African game
# Original author: Geoff Wyvill

def print_header
  printf("%34s%s\n", "", "AWARI")
  printf("%15s%s\n", "", "CREATIVE COMPUTING  MORRISTWON, NEW JERSEY")
  2.times { puts }
end

class Awari
  def initialize
    @board = 14.times.map { |i| (i+1) % 7 == 0 ? 0 : 3 }
    @g = 0
    f = 0
    n = 0
    e = 0
    c = 0
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
end

print_header
game = Awari.new()
game.print_board

  
