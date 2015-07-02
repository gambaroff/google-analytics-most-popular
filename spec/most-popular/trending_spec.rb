require 'spec_helper'

describe MostPopular::Trending::TrendingStory do

  let(:analytics) {
    double()
  }
  let(:one_analytics_result){
    ['/slug/slugger/sluggly/sluggish/sluggerly', '99']
  }
  let(:ten_analytics_results){
    [one_analytics_result] * 10
  }
  let(:fifteen_analytics_results){
    [one_analytics_result] * 15
  }
  let(:trending) { MostPopular::Trending::TrendingStory.new(analytics) }

  describe '#trending_stories' do
    it 'returns an array of 10 stories by default' do
      allow(analytics).to receive(:summarize).with({start_date: "yesterday", end_date: "today", num_results: 10}) {ten_analytics_results}
      expect(trending.trending_stories.class).to eq Array
      expect(trending.trending_stories.size).to eq 10
    end

    it 'returns an array of 15 stories when num_results argument is passed' do
      allow(analytics).to receive(:summarize).with({start_date: "yesterday", end_date: "today", num_results: 15}) {fifteen_analytics_results}
      expect(trending.trending_stories(num_results: 15).class).to eq Array
      expect(trending.trending_stories(num_results: 15).size).to eq 15
    end

    it 'returns an array of stories when results for the last 24 hours are requested' do
      allow(analytics).to receive(:summarize).with({start_date: "yesterday", end_date: "today", num_results: 10}) {ten_analytics_results}
      expect(trending.trending_stories(date: :last_day).class).to eq Array
    end

    it 'returns an array of stories when results for the last week are requested' do
      allow(analytics).to receive(:summarize).with({start_date: "7daysAgo", end_date: "today", num_results: 10}) {ten_analytics_results}
      expect(trending.trending_stories(date: :last_week).class).to eq Array
    end

    xit 'will ultimately support additional date ranges' do
      pending("this functionality is not yet implemented")
      expect(trending.trending_stories(date: :day_before_last).class).to eq Array
      expect(trending.trending_stories(date: :last_3_days).class).to eq Array
      expect(trending.trending_stories(date: :last_month).class).to eq Array
      expect(trending.trending_stories(date: :custom, start_date: '2019-12-13', end_date: '2020-01-01' ).class).to eq Array
    end

    it 'retuns an array of ViewedStory objects' do
      allow(analytics).to receive(:summarize).with({start_date: "yesterday", end_date: "today", num_results: 10}) {ten_analytics_results}
      expect(trending.trending_stories.class).to eq Array
      expect(trending.trending_stories.first.class).to eq MostPopular::Trending::ViewedStory
    end
  end
end