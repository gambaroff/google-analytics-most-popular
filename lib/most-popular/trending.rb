module MostPopular
  module Trending
    class TrendingStory

      def initialize(analytics)
        @analytics = analytics
      end

      def trending_stories(date: :last_day, num_results: 10)
        start_date, end_date = dates_for(date)
        rows = @analytics.summarize({start_date: start_date, end_date: end_date, num_results: num_results})
        rows.collect do |r|
          ViewedStory.new(r.first, r.last)
        end
      end

      private

      def dates_for(date)
        #TODO consider moving logic to Analytics subclasses
        case date
        when :last_day
          return 'yesterday', 'today'
        when :last_week
          return '7daysAgo', 'today'
        else
          raise "I don't know what to do with #{date}"
        end
      end
    end
  end
end