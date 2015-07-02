require 'google/api_client'

module MostPopular
  module Analytics
    class GoogleAnalytics
      # Don't call GoogleAnalytics.new directly.  Use GoogleAnalyticsBuilder instead.  See unit tests
      def initialize(client, api_method, profile_id, filter)
        @client = client
        @api_method = api_method
        @profile_id = profile_id
        @filter = filter
      end

      def summarize(args={})
        args = defaults.merge(args)
        results = @client.execute(
          :api_method => @api_method,
          :parameters => query_hash(args))
        results.data.rows
      end

      private

      def defaults
        {start_date: 'yesterday', end_date: 'today', num_results: 10 }
      end

      def query_hash(args)
        {
            'ids' => "ga:" + @profile_id,
            'start-date' => args[:start_date],
            'end-date' => args[:end_date],
            'dimensions' => 'ga:pagePath',
            'metrics' => 'ga:pageviews',
            'sort' => '-ga:pageviews',
            'filters' => 'ga:pagePath=~^/' + @filter.to_s + '/.*',
            'max-results' => args[:num_results]
        }
      end

    end

    class GoogleAnalyticsBuilder
      def service_account(args)
        @service_account_email = args[:service_account_email]
        @profile_id = args[:profile_id]
      end

      def key_file(args)
        @key_file = args[:filename]
        @key_secret = args[:secret]
      end

      def application(args)
        @application_name = args[:application_name]
        @application_version = args[:application_version]
      end

      def api(api)
        raise 'API not yet supported' unless api == :api_v3
        @api_name = 'analytics'
        @api_version = 'v3'
      end

      def filter(args)
        @filter = args[:filter]
      end

      def build
        #TODO check if account is set up or else raise exception
        client = Google::APIClient.new(
          :application_name => @application_name,
          :application_version => @application_version
        )
        key = Google::APIClient::KeyUtils.load_from_pkcs12(@key_file, @key_secret)
        client.authorization =  Signet::OAuth2::Client.new(
          :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          :audience => 'https://accounts.google.com/o/oauth2/token',
          :scope => 'https://www.googleapis.com/auth/analytics.readonly',
          :issuer => @service_account_email,
          :signing_key => key)
        client.authorization.fetch_access_token!
        api_method = client.discovered_api(@api_name, @api_version).data.ga.get
        GoogleAnalytics.new(client, api_method, @profile_id, @filter)
      end
    end
  end
end