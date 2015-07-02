require 'spec_helper'
require 'dotenv'
Dotenv.load

describe MostPopular::Analytics::GoogleAnalytics do
  it_behaves_like 'google_analytics' do

    let(:analytics) {
      builder = MostPopular::Analytics::GoogleAnalyticsBuilder.new
      builder.service_account({
        service_account_email: ENV["SERVICE_ACCOUNT_EMAIL2"],
        profile_id: ENV["PROFILE_ID2"]
        })
      builder.key_file({
        filename: ENV["FILENAME2"],
        secret: ENV["SECRET2"]
        })
      builder.application({
        application_name: ENV["APPLICATION_NAME2"],
        application_version: ENV["APPLICATION_VERSION2"]
      })
      builder.api(:api_v3)
      builder.filter({filter: 'story'})
      builder.build
    }
      describe '#client' do
        it 'privately contains YourClassical user agent' do
          VCR.use_cassette('google_analytics_additional_app', :record => :all) do
            expect(analytics.instance_eval("@client").user_agent).to include "YourClassical/1.0.0 google-api-ruby-client/0.8.6"
        end
      end

      describe '#summarize' do
        it 'summarizes the service with options' do
          VCR.use_cassette('with_options_additional_app', :record => :all) do
            expect(analytics.summarize({num_results: 15}).class).to eq Array
            expect(analytics.summarize({num_results: 15}).size).to eq 15
          end
        end

        it 'summarizes the service without options' do
          VCR.use_cassette('without_options_additional_app', :record => :all) do
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
end
