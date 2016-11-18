require 'spec_helper'

module Codebreaker
  RSpec.describe Gamer do
    
    it 'should has a name' do
      gamer = Gamer.new("Bob")
      expect(gamer.name).not_to be_empty
    end   
    
  end
end
