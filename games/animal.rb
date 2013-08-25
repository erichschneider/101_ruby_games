#!/usr/bin/env ruby

# Animal - the computer tries to guess the animal you are thinking of
# by asking you questions.
# Original authors: 
# Arthur Luehrmann, Dartmouth College
# Nathan Teichholtz, DEC
# Steve North, Creative Computing

def print_header
  puts ' '*32 + "ANIMAL"
  puts ' '*15 + "CREATIVE COMTPUTING  MORRISTOWN, NEW JERSEY"
  3.times { puts }
  puts "PLAY 'GUESS THE ANIMAL'"
  puts "THINK OF AN ANIMAL AND THE COMPUTER WILL TRY TO GUESS IT."
  puts
end

data = ["\\QDOES IT SWIM\\Y1\\N2\\",
        "\\AFISH",
        "\\ABIRD"]

def ask_question(data, num)
  data[num] =~ /\\Q(.*)\\Y(.*)\\N(.*)\\/
  question, yes_branch, no_branch = $1, $2, $3
  print question + "? "
  begin
    answer = gets
    case answer[0]
    when 'Y'
      branch = yes_branch
    when 'N'
      branch = no_branch
    end
  end while answer[0] != 'Y' and answer[0] != 'N'
  return Integer(branch)
end  

def list_data(data)
  puts "ANIMALS I ALREADY KNOW ARE:"
  data.each_with_index do |a, i|
    print $1, ' '*(12-$1.length) if a =~ /\\A(.*)/
    puts if i % 4 == 0
  end
  puts
end

print_header()
while true
  print "ARE YOU THINKING OF AN ANIMAL? "
  answer = gets.chomp
  if answer == "LIST"
    list_data(data)
  elsif answer[0]=='Y'
    k = 0
    leaf_node = false
    begin
      k = ask_question(data, k)
      if data[k][0..1] != '\\Q'
        leaf_node = true
        print "IS IT A #{data[k][2..-1]}? "
        answer = gets
        if answer[0] == 'Y'
          puts "WHY NOT TRY ANOTHER ANIMAL?"
        else
          print "THE ANIMAL YOU WERE THINKING OF WAS A ? "
          new_animal = gets.chomp
          puts "PLEASE TYPE IN A QUESTION THAT WOULD DISTINGUISH A "
          puts "#{new_animal} FROM A #{data[k][2..-1]}"
          print "? "
          new_question = gets.chomp
          begin
            puts "FOR A #{new_animal} THE ANSWER WOULD BE "
            print "? "
            new_answer = gets[0]
          end while new_answer != 'Y' and new_answer != 'N'
          old_answer = new_answer == 'Y' ? 'N' : 'Y'
          new_branch = data.length
          data << data[k]
          data << "\\A#{new_animal}"
          data[k] = "\\Q#{new_question}\\#{new_answer}#{new_branch+1}" +
            "\\#{old_answer}#{new_branch}\\"
        end
      end 
    end while not leaf_node
  end
end
