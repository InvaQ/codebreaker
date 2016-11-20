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
    end     

    context '#algoritm' do 
      let(:game) {Game.new('Bob')}
      [
      ['1234', '1234', '++++'], ['1234', '4321', '----'], ['1234', '6616', '-'],
      ['1234', '2552', '-'], ['1234', '6254', '++'], ['1234', '1235', '+++'], 
      ['6235', '2365', '+---'], ['5523', '5155', '+-'], ['1234', '1524', '++-'], 
      ['1234', '1243','++--'], ['6143', '4163', '++--'],['1234', '4326', '---'],
      ['1234', '3525', '--'],  ['1234', '4255', '+-'],['1234', '5431', '+--'],
      ['1115', '1231', '+-'], ['1231', '1111', '++'],['1144', '4411', '----'],
      ['1234', '5555', ''], ['1111', '2211', '++'], ['5151', '1515', '----']
        ].each do |code|
            context "When secret code is #{code[0]}, gamer guess #{code[1]}" do 
              it "should reply #{code[2]}" do
                game.instance_variable_set(:@secret_code, code[0])
                game.guess_code(code[1])
                expect(game.send(:algoritm,game.gamer_guess,
                game.instance_variable_get(:@secret_code))).to eq(code[2])
              end
            end
          end
      end
  end
end
#gamer = Gamer.new('Kovalenko')
#allow_any_instance_of(Game).to receive(:new).with(gamer)