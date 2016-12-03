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
      before do
        allow(console).to receive(:intro)
        allow(game).to receive(:won?).and_return(false)
        allow(console).to receive(:game_over?).and_return(true)
        allow(console).to receive(:play_again).and_return('Would You like to play again?')
      end

      context "when input =" do

        it "'hint', should print hint" do  
          allow(console).to receive(:get_action).and_return('hint')        
          allow(game).to receive(:get_hint).and_return(1)
          expect{ console.play }.to output(/1/).to_stdout
        end
        it "'exit', should print exit" do
          allow(console).to receive(:get_action).and_return('exit')
          expect(console.play).to eq('Would You like to play again?')
        end      
        
        it "1234, should print reply" do
          allow(console).to receive(:get_action).and_return('1234')
          allow(game).to receive(:break_the_code).and_return('--++')
          expect{ console.play }.to output(/--++/).to_stdout
        end        
      end
    end

    context 'when #save_score' do
      it 'confirmed, should append file' do
        allow(game).to receive_message_chain(:current_user, :name).and_return('Bob')        
        allow(game).to receive(:hints).and_return(1)
        allow(game).to receive(:tries_used).and_return(3)
        allow(console).to receive(:get_action).and_return('y')

        testIO = StringIO.new
        console.send(:write_data, testIO)
        expect(testIO.string).to eq("---\n- 'Name: Bob'\n- - 'hints: 1'\n  - 'tries: 3'\n")
      end
      it 'denied, should exit' do
        allow(console).to receive(:get_action).and_return('n')        
        #allow(console).to receive(:exit)
        expect{ console.send(:save_score) }.to raise_error(SystemExit)
      end
    end
    context 'when #play_again' do
      it 'confirmed, should run game again' do
        allow(console).to receive(:get_action).and_return('y')        
        expect(console).to receive(:play)
        console.send(:play_again)        
      end

      it 'denied, should return end the game' do
        allow(console).to receive(:get_action).and_return('n')
        expect{ console.send(:save_score) }.to raise_error(SystemExit)
      end

    end

  end
end