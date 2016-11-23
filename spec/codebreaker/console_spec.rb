require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    let(:console) {Console.new}
    let(:game) {console.instance_variable_get(:@game)}

    context '#initialize' do

      it 'should create a game' do 
        expect(console.instance_variable_get(:@game)).to be_an_instance_of(Game)
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
        allow(game.current_user.name).to receive(:get_action).and_return('Bob')
        console.send(:intro)
        expect(game.current_user.name).to eq('Bob')
       
      end
    end

    context ' #play' do

      context "when input = 'hint'" do

      end
      context "when input = 'exit'" do

      end

      context "when input = 'exit'" do

      end
    end




  end
end