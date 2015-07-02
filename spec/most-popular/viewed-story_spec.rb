require 'spec_helper'

describe MostPopular::Trending::ViewedStory do

  let(:viewed) { MostPopular::Trending::ViewedStory.new('story/2015/06/02/the-sights-and-sounds-of-charleston-part-2', 115) }

  describe '#initialize' do
    it 'can be instantiated' do
      expect(viewed.class).to eq  MostPopular::Trending::ViewedStory
      expect(viewed.class).not_to be nil
      expect(viewed.uri).to eq 'story/2015/06/02/the-sights-and-sounds-of-charleston-part-2'
      expect(viewed.views).to eql 115
    end
  end
end