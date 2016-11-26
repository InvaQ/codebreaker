require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    let(:console) {Console.new}
    let(:game) {console.instance_variable_get(:@game)}

    context '#initialize' do

      it 'should create a game' do 
        expect(game).to be_an_instance_of(Game)
      end

      it 'current_user\'s name is present' do
        expect(game.current_user.name).to eq('John Doe')
      end
    end

    context ' #intro' do
      it 'should print count of HINTS' do 
        expect{ console.send(:intro) }.to output(/have #{Game::HINTS} hint/).to_stdout
      end
      it 'should print count of TRIES' do 
        expect{ console.send(:intro) }.to output(/have #{Game::TRIES} tries/).to_stdout
      end
      
      it 'should set gamers name' do
        allow(console).to receive(:get_action).and_return('Bob')
        console.send(:intro)
        expect(game.current_user.name).to eq('Bob')
       
      end
    end

    context ' #play' do

      it "should input = 'hint'" do
         allow(console).to receive(:get_action).and_return('hint')
         allow(game).to receive(game.send(:get_hint)).and_return(1)
         expect{ console.play }.to output(/1/).to_stdout
      end
      it "when input = 'exit'" do
        allow(console).to receive(:get_action).and_return('exit')
        allow(console).to receive(:play_again).and_return('Would You like to play again')          
        expect{ console.play }.to output(/Would You like to play again/).to_stdout
      end

      
    end




  end
end