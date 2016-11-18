require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    


    context '#initialize' do
      let(:game) {Game.new('Bob')}

      it 'current_user must be a Gamer' do 
        expect(game.current_user).to be_an_instance_of(Gamer)
      end

      it 'current_user\'s name is present' do
        expect(game.current_user.name).to eq('Bob')
      end

      
      it 'generates random secret code' do
      expect(game.send(:generate_secret_code)).to be_kind_of(String)      
      end
      it 'secret code is present' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'generates secret code of 4 numbers from 1 to 6' do
        allow(game).to receive(:generate_secret_code)
        expect(game.instance_variable_get(:@secret_code)).to match(/\A[1-6]{4}\Z/)
      end
    end

    context 'when #guess code' do
      let(:game) {Game.new('Bob')}

      context 'consist of numbers 1-6' do        
        it '#is_valid' do      
          expect(game.send(:code_valid?,'1231')).to be_truthy
        end
        it '@gamer_guess is not empty' do
          allow(game).to receive(:code_valid?).and_return(true)
          game.guess_code('1231')
          expect(game.gamer_guess).not_to be_empty
        end
      end
      context ' consist of numbers 0-9' do
        it '#is_not_valid' do    
          expect(game.send(:code_valid?,'1039')).to be_falsy
        end
        it '@gamer_guess is empty' do
          allow(game).to receive(:code_valid?).and_return(false)
          game.guess_code('1039')
          expect(game.gamer_guess).to be_nil
        end
      end
      it 'should decrease tries_left by 1' do        
        expect {game.guess_code('1234')}.to change{ game.tries_left }.by(-1)
      end
      context 'cause #game_over?' do 
        it 'tries_left = 0' do
          game.tries_left = 1
          expect(game.guess_code('1234')).to eq('GAME OVER')
        end    
        it 'guess_code == secret_code' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.guess_code('1234')).to eq('++++')
        end
      end
      #context ''

      
    end  

  end
end
#gamer = Gamer.new('Kovalenko')
#allow_any_instance_of(Game).to receive(:new).with(gamer)