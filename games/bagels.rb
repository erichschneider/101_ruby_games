#!/usr/bin/env ruby

# Bagels - guess the computer's three digit number.
# Original authors: 
# D. Resek and P. Row, Lawrence Hall of Science, Berkeley, CA

printf("%33sBAGELS\n", "")
printf("%15sCREATIVE COMPUTING  MORRISTOWN, NEW JERSEY\n", "")
3.times { puts }
printf("WOULD YOU LIKE THE RULES (YES OR NO)? ")
if gets !~ /^n/i
  puts <<EOM
I AM THINKING OF A THREE-DIGIT NUMBER. TRY TO GUESS
MY NUMBER AND I WILL GIVE YOU CLUES AS FOLLOWS:
   PICO   - ONE DIGIT CORRECT BUT IN THE WRONG POSITIONS
   FERMI  - ONE DIGIT CORRECT AND IN THE RIGHT POSITION
   BAGELS - NO DIGITS CORRECT
EOM
end

done = false
points = 0
begin
  digits = (0..9).map { |i| "#{i}" }
  num_str = (1..3).map {|i| digits.delete(digits[rand(digits.count)])}.join

  puts ; puts "O.K.  I HAVE A NUMBER IN MIND."
  found_number = false
  (1..20).each do |i|
    guess = nil
    begin
      printf("GUESS # %-6d? ", i)
      inp = gets.chomp
      if inp.length != 3
        puts "TRY GUESSING A THREE-DIGIT NUMBER."
      elsif inp !~ /^\d{3}$/
        puts "WHAT?"
      elsif inp.split("").inject({}) { |h,d| h.merge({d=>0}) }.length < 3
        puts "OH, I FORGOT TO TELL YOU THAT THE NUMBER I HAVE IN MIND"
        puts "HAS NO TWO DIGITS THE SAME."
      else
        guess = inp
      end
    end until guess

    if inp == num_str
      found_number = true
      break
    else
      found = (0..2).inject(0) { |s, i| s + (num_str.index(guess[i]) ? 1 : 0) }
      correct = (0..2).inject(0) { |s, i| s + (guess[i] == num_str[i] ? 1 : 0) }
      puts found == 0 ? "BAGELS" : "PICO "*(found-correct) + "FERMI "*correct
    end
  end
  if found_number
    puts "YOU GOT IT!!!" ; puts
    points += 1
  else
    puts "OH WELL"
    puts "THAT'S TWENTY GUESSES. MY NUMBER WAS #{num_str}."
  end

  printf "PLAY AGAIN (YES OR NO)? "
  again = gets.chomp.upcase
  done = true unless again == "YES"
end
if points > 0
  puts
  puts "A #{points} POINT BAGELS BUFF!!"
end
puts "HOPE YOU HAD FUN. BYE."


