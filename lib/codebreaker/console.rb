require 'yaml'
require 'pry'

module Codebreaker
  
  class Console    

    def initialize(name = 'John Doe')
      @game = Game.new(name)
    end
    
    def play

      intro

      begin
        puts "Now #{@game.current_user.name}, try to break me!"
        action = get_action

        case action

          when 'hint'
             puts @game.get_hint             
          when 'exit'
            break
          else
            puts @game.break_the_code(action)         
        end
          #binding.pry
        save_score if @game.send(:won?)
      end until game_over?
      play_again
    end
  
    private
    
    def get_action
      gets.chomp
    end

    def intro
      puts "Wellcome to Code-bereaker!\n
      Codebreaker is a logic game in which You tries\n
      to break a secret code of four numbers between 1 and 6\n
      created by a code-maker.\n       
      _____________Rules!_________________\n
      You have #{Game::TRIES} tries to break the code\n
      also You have #{Game::HINTS} hint(s). To get one use 'hint'\n
      For exit the game use 'exit'.\n\n"

      puts "Please, enter your name\n"
      @game.current_user.name = get_action
    end

    def game_over?
      @game.send(:losing?) || @game.send(:won?)
    end

    def play_again
      puts "Would You like to play again? (y/n)"
      get_action == 'y' or exit
      @game = Game.new('John Doe')
      play      
    end

    #def save_score
    #  puts "Would You like to save score? (y/n)"
    #  get_action == 'y' or exit
    #  buffer = ["Name: #{@game.current_user.name}", ["hints: #{@game.hints}",
    #            "tries: #{@game.tries_used}"]]
    #  File.open('score.yml', 'a') do |string|
    #    string.write buffer.to_yaml
    #  end  
    #end

    def write_data(file)
      buffer = ["Name: #{@game.current_user.name}", ["hints: #{@game.hints}",
                "tries: #{@game.tries_used}"]]        
      file.write buffer.to_yaml
       
    end

    def save_score
      puts "Would You like to save score? (y/n)"
      get_action == 'y' or exit
      path = File.open('score.yml', 'a')
      write_data(path)
    end
  end
end