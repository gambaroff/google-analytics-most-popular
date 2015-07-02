module MostPopular
  module Trending
    class ViewedStory
      attr_reader :uri,:views

      def initialize(uri,views)
        @uri = uri
        @views = views
      end

    end
  end
end