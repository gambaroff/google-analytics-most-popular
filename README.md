[![Build Status](https://travis-ci.org/gambaroff/google-analytics-most-popular.svg?branch=master)](https://travis-ci.org/gambaroff/google-analytics-most-popular)
# most_popular

Add this line to your application's Gemfile:

```ruby
gem 'most-popular'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install most-popular

## Usage
You will need a service account credentials from google.

## Service Account with Google for Server-to-Server Applications
Google API uses OAuth 2.0 with service accounts. Learn more about Google APIs and OAuth 2.0 here:https://developers.google.com/accounts/docs/OAuth2

Or, follow these steps.

1. From the "Project Home" screen, activate access to "Google+ API”.
2. From google developer console, APIs -> Enabled APIs - Must enable analytics API
3. Click on "APIs&Auth" in the left column
4. Click  Credentials in the left column
5. Under OAuth click Create New ClientID button
6. Give your application a name and click "Next"
7. Select "Service Account" as the "Application type"
8. Select "other" under "Installed application type"
9. Click "Create client ID"
10. Click 'Download private key' to save the generate private key file


### Managing Credentials

* ###Using Bash or Zsh Profile

This is the “bare minimum” solution. You can store the environment variable key/value pairs with the operating system directly and globally, so they are going to be available to the Rails app. In your .bashrc file or .zshrc file, set environment variables with lines like:
```
export KEY=value
```

With this, you can fire up rails console or irb and access your environment var by doing:

```
ENV["KEY"]
=> "value"
```
This is also not very ideal for creating app-specific environment variables or using different environment variables for different environments such as development and testing
http://www.gotealeaf.com/blog/managing-environment-configuration-variables-in-rails

* ###Using a gem, like Dotenv

[Dotenv](https://github.com/bkeepers/dotenv) solves the problems of setting project-specific environment vars and is super easy to get started on. Start by including the ```gem 'dotenv-rails', :groups => [:development, :test]``` in the appropriate groups, in this case development and test. You can then put your sensitive information inside a .env file at the root of your project directory:

 ```
SERVICE_ACCOUNT_EMAIL=072731723843-htv966ia965hk61mii9hqr98edtt2lad@developer.gserviceaccount.com
PROFILE_ID=77777
FILENAME=config/environments/production/YourApp-5eee1f52d9cf.p12
SECRET=notasecret
```

You can call these variables anywhere in your Rails application by using: ```ENV["SERVICE_ACCOUNT_EMAIL"], ENV["PROFILE_ID"], ENV["FILENAME"] and ENV["SECRET"]```

Support for export (for accessing these variables in the terminal) and yaml-like configs come baked in. Make sure to git-ignore your ```.env``` files if you’re working alone or you’ll be back to square one. While working on a team, you can maintain a default ```.env.example``` file that is checked into source control with further instructions to other developers. check out  [dotenv](https://github.com/bkeepers/dotenv)

More info on [Managing Environment Configuration Variables in Rails](http://www.gotealeaf.com/blog/managing-environment-configuration-variables-in-rails)


### Example Rails App

```ruby
#app/models/concerns/most_popupar_story.rb

class MostPopularStory
  def initialize
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
      application_name: 'Your Application',
      application_version: '1.0.0'
      })
    builder.api(:api_v3)
    builder.filter({filter: 'topics'})
    analytics = builder.build
    @trending = MostPopular::Trending::TrendingStory.new(analytics)
  end

  def trending
    @trending.trending_stories
  end
end
```

### Optional Arguments

trending_stories method can take a Hash of  any of these *date: :today*, *date: :last_day*, *date: :last_week*, *num_results: 10*, filter: 'my_filter'

for example

```ruby
@trending.trending_stories(date: :last_week, num_results: 3)
```

## Testing Example,  using VCR gem
```ruby
require 'rails_helper'

RSpec.describe MostPopularStory do
  let(:trending) { MostPopularStory.new}

  VCR.use_cassette('treding_story', :record => :new_episodes) do
    describe '#initialize' do
      it 'can be instantiated',:vcr do
        expect(trending).not_to be_nil
        expect(trending.class).to eq MostPopularStory
      end
    end

    describe '#now_trending' do
      it 'contains an array of trending stories', :vcr do
        expect(trending.now_trending.class).to eq Array
        expect(trending.now_trending.size).to eq  10
      end

      it 'contains expected Object', :vcr do
        expect(trending.now_trending.first.class).to eq  MostPopular::Trending::ViewedStory
      end
    end
  end
end
```
## Contributing

Pull requests are welcome.

To contribute to Google Analytics Most Popular:

1. Fork the repo.
2. Make your changes in a topic branch.
3. Send a PR.

Notes:

* Contributions without tests won't be accepted.
* Please don't update the Gem version.
