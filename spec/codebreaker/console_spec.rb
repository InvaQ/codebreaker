require 'spec_helper'

module Codebreaker
  RSpec.describe Console do    
    let(:game) {subject.instance_variable_get(:@game)}
    let(:current_user) {subject.instance_variable_get(:@current_user)}

    context '#initialize' do

      it 'current_user must be a Gamer' do 
        expect(subject.current_user).to be_an_instance_of(Gamer)
      end

      it 'current_user\'s name is present' do
        expect(subject.current_user.name).to eq('John Doe')
      end

      it 'should create a game' do 
        expect(game).to be_an_instance_of(Game)
      end

      it 'current_user\'s name is present' do
        expect(subject.current_user.name).to eq('John Doe')
      end
    end

    context ' #intro' do
      it 'should print count of HINTS' do 
        expect{ subject.send(:intro) }.to output(/have #{Game::HINTS} hint/).to_stdout
      end
      it 'should print count of TRIES' do 
        expect{ subject.send(:intro) }.to output(/have #{Game::TRIES} tries/).to_stdout
      end
      
      it 'should set gamers name' do
        allow(subject).to receive(:get_action).and_return('Bob')
        subject.send(:intro)
        expect(subject.current_user.name).to eq('Bob')       
      end
    end 

    context ' #play' do
      before do
        allow(subject).to receive(:intro)
        allow(game).to receive(:won?).and_return(false)
        allow(game).to receive(:game_over?).and_return(true)
        allow(subject).to receive(:play_again).and_return('Would You like to play again?')
      end

      context "when input =" do

        it "'hint', should print hint" do  
          allow(subject).to receive(:get_action).and_return('hint')        
          allow(game).to receive(:get_hint).and_return(1)
          expect{ subject.play }.to output(/1/).to_stdout
        end
        it "'exit', should print exit" do
          allow(subject).to receive(:get_action).and_return('exit')
          expect(subject.play).to eq('Would You like to play again?')
        end      
        
        it "1234, should print reply" do
          allow(subject).to receive(:get_action).and_return('1234')
          allow(game).to receive(:break_the_code).and_return('--++')
          expect{ subject.play }.to output(/--++/).to_stdout
        end        
      end
    end

    context 'when #save_score' do
      it 'confirmed, should append file' do
        allow(current_user).to receive(:name).and_return('Bob')        
        allow(game).to receive(:hints).and_return(1)
        allow(game).to receive(:tries_used).and_return(3)
        allow(subject).to receive(:get_action).and_return('y')

        testIO = StringIO.new
        subject.send(:write_data, testIO)
        expect(testIO.string).to eq("---\n- 'Name: Bob'\n- - 'hints: 1'\n  - 'tries: 3'\n")
      end
      it 'denied, should exit' do
        allow(subject).to receive(:get_action).and_return('n')        
        expect{ subject.send(:save_score) }.to raise_error(SystemExit)
      end
    end

    context 'when #play_again' do
      it 'confirmed, should run game again' do
        allow(subject).to receive(:get_action).and_return('y')        
        expect(subject).to receive(:play)
        subject.send(:play_again)        
      end

      it 'denied, should return end the game' do
        allow(subject).to receive(:get_action).and_return('n')
        expect{ subject.send(:save_score) }.to raise_error(SystemExit)
      end

    end
  end
end