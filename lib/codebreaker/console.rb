require 'yaml'

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
            if @game.hints == 1
              puts "One number of the secret code is #{@game.send(:get_hint)}"
            else
              puts "You don't have any hints!"
            end
          when 'exit'
            break
          else
            puts @game.break_the_code(action)         
          end
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
      exit unless get_action == 'y' 
      @game = Game.new('John Doe')
      play      
    end
    def save_score
      puts "Would You like to save score? (y/n)"
      exit unless get_action == 'y'
      buffer = [@game.current_user.name, [@game.hints,
                Game::TRIES - @game.tries_left]]
      File.open('score.yml', 'w') do |string|
      string.write buffer.to_yaml
    end

  end
end

end