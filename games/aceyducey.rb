#!/usr/bin/env ruby

INITIAL_STAKE = 100

def print_instructions
  puts " "*26 + "ACEY DUCEY CARD GAME"
  puts " "*15 + "CREATIVE COMPUTING  MORRISTOWN,NEW JERSEY"
  3.times { puts }
  puts <<EOM
ACEY-DUCEY IS PLAYED IN THE FOLLOWING MANNER 
THE DEALER (COMPUTER) DEALS TWO CARDS FACE UP
YOU HAVE AN OPTION TO BET OR NOT BET DEPENDING
ON WHETHER OR NOT YOU FEEL THE CARD WILL HVAE
A VALUE BETWEEN THE FIRST TWO.
IF YOU DO NOT WANT TO BET, INPUT A 0
EOM
end

def random_card
  card = 0
  while card < 2 or card > 14
    card = rand(14) + 2
  end
  return card
end

FACE_CARDS = %w(JACK QUEEN KING ACE)

def print_card(card)
  case card
  when 2..10
    puts card
  when 11..14
    puts FACE_CARDS[card-11]
  end
end

print_instructions()
game_done = false
while (!game_done) do
  stake = INITIAL_STAKE
  puts "YOU NOW HAVE #{stake} DOLLARS"
  puts

  done = false
  while (!done) do
    puts "HERE ARE YOUR NEXT TWO CARDS "
    first_card = random_card()
    second_card = random_card()
    first_card,second_card = second_card,first_card if second_card < first_card

    print_card(first_card)
    print_card(second_card)
    puts

    begin
      printf("WHAT IS YOUR BET? ")
      bet = gets.chomp.to_i
      if (bet > stake) 
        puts "SORRY, MY FRIEND BUT YOU BET TOO MUCH"
        puts "YOU ONLY HAVE #{stake} DOLLARS TO BET"
      end
    end while bet > stake

    if bet == 0
      puts "CHICKEN!!"
      puts
    else
      print_card(third_card = random_card())
      if first_card < third_card and third_card < second_card
        puts "YOU WIN!!"
        stake = stake+bet
      else
        puts "SORRY, YOU LOSE"
        stake = stake-bet
      end
      puts "YOU NOW HAVE #{stake} DOLLARS"
      puts
    end    
    done = stake <= 0
  end
  puts "SORRY, FRIEND BUT YOU BLEW YOUR WAD"
  printf("TRY AGAIN (YES OR NO)? ")
  answer = gets.chomp
  game_done = answer != "YES"
end
puts "OK HOPE YOU HAD FUN"



