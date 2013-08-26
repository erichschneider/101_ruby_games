#!/usr/bin/env ruby

# Animal - the computer tries to guess the animal you are thinking of
# by asking you questions.
# Original authors: 
# Arthur Luehrmann, Dartmouth College
# Nathan Teichholtz, DEC
# Steve North, Creative Computing

class AnimalDatabase
  def initialize
    @root = Question.new("DOES IT SWIM")
    @root.add_yes_answer(Animal.new("FISH"))
    @root.add_no_answer(Animal.new("BIRD"))
  end

  def list_animals
    puts "ANIMALS I ALREADY KNOW ARE:"
    
    out_str = ""
    @root.list_array.each_with_index do |a, i|
      out_str += sprintf("%-12s", a)
      out_str += "\n" if i % 5 == 4 
    end
    puts out_str
  end
  
  def guess_animal
    print "ARE YOU THINKING OF AN ANIMAL? "
    answer = gets.chomp
    if answer == "LIST"
      list_animals
    elsif answer =~ /^y/i
      node = @root
      begin
        node = node.ask_question
        if not node.is_question?
          print "IS IT A #{node.text}? "
          answer = gets
          if answer =~ /y/i
            puts "WHY NOT TRY ANOTHER ANIMAL?"
          else
            print "THE ANIMAL YOU WERE THINKING OF WAS A ? "
            new_animal = gets.chomp.upcase
            puts "PLEASE TYPE IN A QUESTION THAT WOULD DISTINGUISH A "
            puts "#{new_animal} FROM A #{node.text}"
            print "? "
            new_question = gets.chomp.upcase
            begin
              puts "FOR A #{new_animal} THE ANSWER WOULD BE "
              print "? "
              new_answer = gets[0].upcase
            end while new_answer != 'Y' and new_answer != 'N'
            node.replace_with_question(new_question, new_animal, new_answer)
          end
        end 
      end while node.is_question?
    end
  end
end

class Node
  attr_accessor :parent
  attr_accessor :yes_node
  attr_accessor :no_node
  attr_reader :text
  def initialize(text)
    @text = text
    @yes_node = nil
    @no_node = nil
  end

  def is_question? ; self.class == Question ; end
  def add_yes_answer(a)
    (@yes_node = a).parent = self
  end

  def add_no_answer(a)
    (@no_node = a).parent = self
  end

  def replace(new_node)
    parent.send(self == parent.yes_node ? :add_yes_answer : :add_no_answer, 
                new_node)
  end

  def list_array
    ret = [self.list_text]
    ret << @yes_node.list_array if @yes_node
    ret << @no_node.list_array if @no_node
    return ret.flatten.compact
  end
end

class Question < Node
  def ask_question
    print text + "? "
    begin
      if (answer = gets) =~ /^[yn]/
        return answer[0].upcase == 'Y' ? yes_node : no_node
      end
    end while answer !~ /^[yn]/i
  end

  def list_text; nil; end
end    

class Animal < Node
  def replace_with_question(question, new_animal, answer)
    self.replace(new_q = Question.new(question))
    new_a = Animal.new(new_animal)
    new_q.add_yes_answer(answer =~ /y/i ? new_a : self)
    new_q.add_no_answer(answer =~ /n/i ? new_a : self)
  end

  def list_text ; text ; end
end
    
def print_header
  puts ' '*32 + "ANIMAL"
  puts ' '*15 + "CREATIVE COMTPUTING  MORRISTOWN, NEW JERSEY"
  3.times { puts }
  puts "PLAY 'GUESS THE ANIMAL'"
  puts "THINK OF AN ANIMAL AND THE COMPUTER WILL TRY TO GUESS IT."
  puts
end

print_header
db = AnimalDatabase.new
while true
  db.guess_animal
end
