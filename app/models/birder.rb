module Birder
  module Twitter
    class List
      attr_reader :id, :name

      def initialize(id, name)
        @id = id
        @name = name
      end
    end
  end

  class Search
    attr_accessor :debug

    def initialize(client: Birder::Client.new)
      @client = client
      @debug = ''
    end

    def tweets(query, options = {})
      body = { 'expansions' => 'author_id,edit_history_tweet_ids', 'tweet.fields' => 'created_at,entities,lang,public_metrics',
               'user.fields' => 'username,profile_image_url,public_metrics,verified,verified_type', 'max_results' => 100 }
      body.merge!('since_id' => options.fetch(:since_id, nil)) if options.fetch(:since_id, nil)
      body.merge!('start_time' => options.fetch(:start_time, nil)) if options.fetch(:start_time, nil)
      body.merge!({ 'query' => query })

      path = '/2/tweets/search/recent'

      @debug = "Birder::Search.tweets: #{path} #{body}"

      Birder::Results.new(@client.get(path, body), @client,
                          request: { path: path, body: body, page: 'next_token' }, debug: @debug)
    end
  end

  class List
    attr_accessor :debug
    def initialize(client: Birder::Client.new)
      @client = client
      @debug = ''
    end

    def create(name, options = {})
      body = { 'name' => name }
      body.merge!('description' => options.fetch(:description, nil)) if options.fetch(:description, nil)
      body.merge!('private' => options.fetch(:private, nil)) if options.fetch(:private, nil)

      path = '/2/lists'

      @debug = "Birder::List.create: #{path} #{body}"

      response = @client.post(path, body.to_json, {})
      Birder::Twitter::List.new(response['data']['id'], response['data']['name'])
    end

    def promote(list_id, user_id)
      body = { 'user_id' => user_id }

      path = "/2/lists/#{list_id}/members"

      @client.post(path, body.to_json, {})
    end

    def tweets(list_id)
      body = { 'tweet.fields' => 'created_at,entities,lang,public_metrics,referenced_tweets', 'expansions' => 'author_id,edit_history_tweet_ids',
               'user.fields' => 'username,profile_image_url,public_metrics,verified,verified_type' }

      path = "/2/lists/#{list_id}/tweets"

      @debug = "Birder::List.tweets: #{path} #{body}"
      Rails.logger.info "Birder::List.tweets: #{path} #{body}"

      Birder::Results.new(@client.get(path, body), @client,
                          request: { path: path, body: body, page: 'pagination_token' }, debug: @debug)
    end
  end

  class Results
    attr_reader :request, :data, :meta, :includes, :debug

    def initialize(response, client, request: {}, debug: nil)
      @response = response
      @client = client
      @request = request
      @meta = response.fetch('meta', {})
      @data = response.fetch('data', [])
      @includes = response.fetch('includes', {})
      @debug = debug
    end

    def to_h
      { 'data' => @data, 'meta' => @meta, 'includes' => @includes, 'debug' => @debug }
    end

    def next
      next_token = meta.fetch('next_token', nil)
      return nil unless next_token

      page = @request.fetch(:page, nil)
      path = @request.fetch(:path, nil)
      body = @request.fetch(:body, {})
      headers = @request.fetch(:headers, {})

      body.merge!(pagination_token: next_token) if page == 'pagination_token'
      body.merge!(next_token: next_token) if page == 'next_token'

      Birder::Results.new(@client.get(path, body, headers), @client,
                          request: { path: path, body: body, headers: headers, page: page }, debug: @debug)
    end
  end

  class Client
    def initialize(token = nil)
      @token = token

      raise MissingTokenError, 'Missing token' unless @token

      @client = Faraday.new(url: 'https://api.twitter.com') do |f|
        f.adapter Faraday.default_adapter
        f.request :json
        f.response :json
        f.request :authorization, 'Bearer', token
      end

      @body = {}
      @path = ''
      @headers = {}
    end

    def post(path, body = {}, headers = {})
      @path = path
      @body = body
      @headers = headers

      response = @client.post(path, body, headers)

      handle_response(response)
    end

    def get(path, body = {}, headers = {})
      @path = path
      @body = body
      @headers = headers

      response = @client.get(path, body, headers)

      handle_response(response)
    end

    def handle_response(response)
      case response.status
      when 200..399
        response.body
      when 401
        raise Birder::Unauthorized, response.body
      when 404
        raise Birder::NotFound, response.body
      when 400
        raise Birder::BadRequest, response.body
      when 500
        raise Birder::InternalServerError, response.body
      when 503
        raise Birder::ServiceUnavailable, response.body
      when 429
        raise Birder::TooManyRequests, response.body
      else
        raise Birder::Error, response.body
      end
    end

    def previous_path
      @path
    end

    def previous_body
      @body
    end

    def previous_headers
      @headers
    end

    def list
      @list = Birder::List.new(client: self)
    end

    def search
      @search = Birder::Search.new(client: self)
    end
  end

  class Error < StandardError; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class BadRequest < Error; end
  class InternalServerError < Error; end
  class ServiceUnavailable < Error; end
  class TooManyRequests < Error; end
  class MissingTokenError < Error; end
end
