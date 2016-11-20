module Codebreaker

  class Game
    attr_accessor :gamer_guess, :current_user, :tries_left, :hints, :guess

    def initialize(name)      
      @current_user = Gamer.new(name)
      @secret_code = generate_secret_code
      @tries_left = 6
      @hints = 1
    end
    
    def guess_code(code)
      if code_valid?(code)
        @gamer_guess = code
        @tries_left -= 1
      end
      game_over?
    end


    private

    def code_valid?(code)
      !!code.match(/\A[1-6]{4}\Z/)
    end

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def game_over?
      return 'GAME OVER' if @tries_left == 0
      return '++++' if @gamer_guess == @secret_code
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

  end

  




  class Gamer
    attr_accessor :name 

    def initialize(name)
      @name = name
    end
  end


end
