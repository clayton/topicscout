class SimilarUrlsController < ApplicationController
  def index
    @url = Url.find_by(id: params[:url_id])
    @similar = Url.includes(:influencers)
                  .relevant.unedited
                  .where.not(id: @url.id)
                  .where(Url.arel_table[:impression_count].gt(@url.impression_count))
                  .search_by_title(query(@url.title))
                  .order(impression_count: :desc)
                  .limit(5)

    render template: 'similar_urls/index', layout: false
  end

  private

  def query(title)
    title = title.gsub(/[^a-zA-Z0-9\s]/, '')

    adjectives = %w[New Best Top Great Free Easy Important Amazing Incredible
                    Simple Fun Awesome Popular Effective Valuable Powerful Exclusive Innovative Essential Smart Strong Practical Beautiful Brilliant Fantastic Exciting Proven Expert Useful Helpful Affordable Reliable Quick Creative Trustworthy High-quality Versatile Interesting Engaging Memorable Dynamic Rewarding Authentic Refreshing Guaranteed Trusted Bold Remarkable Unforgettable Revolutionary Inspiring Remarkable Unbeatable Exceptional Vibrant Fascinating Genuine Unbelievable Incredible Compelling Unmatched Superior Astonishing Unsurpassed Ultimate Proven Cutting-edge Well-designed Uncomplicated Convenient Unique Tailored Profound Delightful Stronger Thoughtful Simplified Guaranteed Unrivaled Promising Mind-blowing Unmatched Unparalleled Practical Creative Beautifully Well-rounded Upgraded Dazzling Indispensable Streamlined Phenomenal Revolutionary Simplistic Staggering Superiority Unbeatable Winning World-class]
    stop_words = %w[
      a
      an
      and
      are
      as
      at
      be
      by
      for
      from
      has
      he
      in
      is
      it
      its
      of
      on
      that
      the
      to
      was
      were
      will
      with
      how
      why
      you
      your
      we
      our
      they
      their
      he
      she
      it
      his
      her
      its
      me
      us
      them
      my
    ]

    stop_words_pattern = /\b(#{stop_words.map(&:downcase).uniq.compact.join('|')})\b/i
    adjectives_pattern = /\b(#{adjectives.map(&:downcase).uniq.compact.join('|')})\b/i

    title = title.downcase
    title = title.gsub(/[0-9+]/, '')
    title = title.gsub(stop_words_pattern, '')
    title = title.gsub(adjectives_pattern, '')
    title = title.gsub(/\s+/, ' ')
    title = title.split(' ').uniq.join(' ')

    Rails.logger.debug("SimilarUrlsController#query: #{title}")

    title.strip
  end
end
