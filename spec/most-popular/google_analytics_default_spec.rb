require 'spec_helper'

describe MostPopular::Analytics::GoogleAnalytics do
  it_behaves_like 'google_analytics' do

    describe '#client' do
      it 'privately employs the expected user agent' do
        VCR.use_cassette('google_analytics_default') do
          expect(analytics.instance_eval("@client").user_agent).to include "google-api-ruby-client/0.8.6"
        end
      end
    end

    describe '#summarize' do
      it 'summarizes the service with options' do
        VCR.use_cassette('with options erb') do
          expect(analytics.summarize({num_results: 15}).class).to eq Array
          expect(analytics.summarize({num_results: 15}).size).to eq 15
        end
      end

      it 'summarizes the service without options' do
        VCR.use_cassette('without options erb' ) do
          expect(analytics.summarize.class).to eq Array
          expect(analytics.summarize.size).to eq 10
          expect(analytics.summarize.first.class).to eq Array
          # should be some kind of duck typable thing
          expect(analytics.summarize.first[0].class).to eq String
          expect(analytics.summarize.first[1].class).to eq String
        end
      end
    end
  end
end
