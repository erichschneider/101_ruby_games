#!/usr/bin/env ruby

# Banner - print messages in big letters
# Original by Leonard Rosendust, Brooklyn, NY
# Two bugs fixed from original:
# -> "CENTERED" prompt was "CENTEED"
# -> "6" character was mirrored

chardata = {
  '!' => [1, 1, 1, 384, 1, 1, 1],
  '*' => [69, 41, 17, 512, 17, 41, 69],
  '.' => [1, 1, 129, 449, 129, 1, 1],
  '0' => [57, 69, 131, 258, 131, 69, 57],
  '1' => [0, 0, 261, 259, 512, 257, 257],
  '2' => [261, 387, 322, 290, 274, 267, 261],
  '3' => [66, 130, 258, 274, 266, 150, 100],
  '4' => [33, 49, 41, 37,35, 512, 33],
  '5' => [160, 274, 274, 274, 274, 274, 226],
  '6' => [193, 289, 305, 297, 293, 291, 194],
  '7' => [258, 130, 66, 34, 18, 10, 8],
  '8' => [69, 171, 274, 274, 274, 171, 69],
  '9' => [263, 138, 74, 42, 26, 10, 7],
  '=' => [41, 41, 41, 41, 41, 41, 41],
  '?' => [5, 3, 2, 354, 18, 11, 5],
  'A' => [505,37,35,34,35,37,505],
  'B' => [512, 274, 274, 274, 274, 274, 239],
  'C' => [125, 131, 258, 258, 258, 131, 69],
  'D' => [512, 258, 258, 258, 258, 131, 125],
  'E' => [512, 274, 274, 274, 274, 258, 258],
  'F' => [512, 18, 18, 18, 18, 2, 2],
  'G' => [125,131,258,258,290,163,101],
  'H' => [512, 17, 17, 17, 17 , 17, 512],
  'I' => [258, 258, 258, 512, 258, 258, 258],
  'J' => [65, 129, 257, 257, 257, 129, 128],
  'K' => [512, 17, 17, 41, 69, 131, 258],
  'L' => [512, 257, 257, 257, 257, 257, 257],
  'M' => [512, 7, 13, 25, 13, 7, 512],
  'N' => [512, 7, 9, 17, 33, 193, 512],
  'O' => [125, 131, 258, 258, 258, 131, 125],
  'P' => [512, 18, 18, 18, 18, 18, 15],
  'Q' => [125, 131, 258, 258, 322, 131, 381],
  'R' => [512, 18, 18, 50, 82, 146, 271],
  'S' => [69, 139, 274, 274, 274, 163, 69],
  'T' => [2, 2, 2, 512, 2, 2, 2],
  'U' => [128, 129, 257, 257, 257, 129, 128],
  'V' => [64, 65, 129, 257, 129, 65, 64],
  'W' => [256, 257, 129, 65, 129, 257, 256],
  'X' => [388, 69, 41, 17, 41, 69, 388],
  'Y' => [8, 9, 17, 481, 17, 9, 8],
  'Z' => [386, 322, 290, 274, 266, 262, 260],
}

printf("HORIZONTAL? ")
horizontal = gets.chomp.to_i

printf("VERTICAL? ")
vertical = gets.chomp.to_i

printf("CENTERED? ")
centered = gets.chomp =~ /^[p-z]/i

printf("CHARACTER (TYPE 'ALL' IF YOU WANT CHARACTER BEING PRINTED)? ")
character = gets.chomp

printf("STATEMENT? ")
statement = gets.chomp

printf("SET PAGE? ")
gets


powers = 8.downto(0).map { |i| 1 << i }
statement.split("").each do |c|
  if c == ' '
    (7*horizontal).times { puts }
  else
    str_to_print = character == "ALL" ? c : character
    blank_str = " " * str_to_print.length
    chardata[c.upcase].each do |rowdata|
      rowdata -= 1 if rowdata != 0 
      horizontal.times do
        printf("%s",' '*((63-4.5*vertical)/(str_to_print.length+1))) if centered
        puts powers.map { |val| 
          (val & rowdata != 0 ? str_to_print : blank_str)*vertical 
        }.join
      end
    end
    (2*horizontal).times { puts }
  end
end
# 75.times { puts }
