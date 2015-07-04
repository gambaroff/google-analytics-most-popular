require 'dotenv'
Dotenv.load

shared_examples 'google_analytics' do
  let(:analytics) {
    builder = MostPopular::Analytics::GoogleAnalyticsBuilder.new
    builder.service_account({
      service_account_email: ENV["SERVICE_ACCOUNT_EMAIL"],
      profile_id: ENV["PROFILE_ID"]
      })
    builder.key_file({
      filename: ENV["FILENAME"],
      secret: ENV["SECRET"]
      })
    builder.application({
      application_name: ENV["APPLICATION_NAME"],
      application_version: ENV["APPLICATION_VERSION"]
      })
    builder.api(:api_v3)
    builder.filter({filter: 'topics'}) # matches site url path like http://marketplace.org/topics/business/ive-always-wondered/how-do-actors-make-money-residuals
    builder.build
  }

  it 'is built with the correct methods and appropriately hides variables' do
    VCR.use_cassette('shared_1_erb') do
      expect(analytics.methods).to include :summarize
    end
  end

  it 'returns an array of stories when date argument is passed' do
    VCR.use_cassette('shared erb') do
      expect(analytics.summarize(start_date: '2014-12-13', end_date: '2015-01-01' ).class).to eq Array
    end
  end
end