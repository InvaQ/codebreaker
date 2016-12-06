module Codebreaker
  
  
  class Game
    TRIES = 6
    HINTS = 1
    attr_reader :gamer_guess, :hints
    attr_accessor :tries_left

    def initialize      
      @secret_code = generate_secret_code
      @tries_left = TRIES
      @hints = HINTS
    end
    
    def guess_code(code)      
        @gamer_guess = code
        @tries_left -= 1          
    end

    def break_the_code(code)
      return 'GAME OVER' if losing?
      code_valid?(code) ? guess_code(code) : (return "You should enter 4 numbers from 1 to 6!")
      return 'Congratulation, You broke the code!' if won?
      algoritm
    end

    def get_hint
      @hints.positive? || (return 'You don\'t have any hints!')
      @hints-= 1
      "One number of the secret code is #{@secret_code[rand(4)]}"
    end

    def tries_used
      TRIES - tries_left
    end

    def game_over?
      losing? || won?
    end

    private

    def code_valid?(code)
      !!code.match(/\A[1-6]{4}\Z/)
    end

    def generate_secret_code
      Array.new(4) { rand(1..6) }.join
    end

    def losing?
      @tries_left.zero?      
    end

    def won?
      @gamer_guess == @secret_code
    end

    def algoritm
      secret = @secret_code.chars
      guess = @gamer_guess.chars
      result = ''
      guess.map.with_index do | value, index |
        if value == secret[index]
          secret[index], guess[index] = nil
          result << '+'
        end
      end
      [secret,guess].each(&:compact!)                  
      secret.each do |value| 
        if guess.include?(value)
          guess[guess.index(value)] = nil
          result << '-'            
        end                     
      end
      result
    end

  end
end
