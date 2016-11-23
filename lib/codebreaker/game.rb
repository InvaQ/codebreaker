module Codebreaker
  
  
  class Game
    TRIES = 6
    HINTS = 1
    attr_accessor :gamer_guess, :current_user, :tries_left, :hints

    def initialize(name)      
      @current_user = Gamer.new(name)
      @secret_code = generate_secret_code
      @tries_left = TRIES
      @hints = HINTS
    end
    
    def guess_code(code)
      if code_valid?(code)
        @gamer_guess = code
        @tries_left -= 1        
      else
        "You should enter 4 numbers from 1 to 6!"
      end      
    end

    def break_the_code(code)
      return 'GAME OVER' if losing?
      guess_code(code)
      return 'Congratulation, You have broken the code!' if won?
      algoritm(@secret_code, @gamer_guess)
    end


    #private

    def code_valid?(code)
      !!code.match(/\A[1-6]{4}\Z/)
    end

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def losing?
      @tries_left == 0      
    end

    def won?
      @gamer_guess == @secret_code
    end

    def algoritm(secret_code, gamer_guess)
      secret = secret_code.chars
      guess = gamer_guess.chars
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

    def get_hint
      @hints -= 1
      @secret_code[rand(4)]
    end

  end

  

end
