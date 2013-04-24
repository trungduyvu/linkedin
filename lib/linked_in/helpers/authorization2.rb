module LinkedIn
  module Helpers
    module Authorization2

      DEFAULT_OAUTH2_OPTIONS = {
          :access_token_path  => "/uas/oauth2/accessToken",
          :authorize_path     => "/uas/oauth2/authorization",
          :api_host           => "https://api.linkedin.com",
          :auth_host          => "https://www.linkedin.com",
      }

      DEFAULT_ACCESS_TOKEN_OPTIONS = {
          :mode => :query,
          :param_name => 'oauth2_access_token'
      }

      def consumer
        @consumer ||=  ::OAuth2::Client.new(@consumer_token, @consumer_secret, parse_oauth_options)
      end

      def authorize_url(options={})
        @authorize_url ||= consumer.auth_code.authorize_url(options)
      end

      # Note: If using oauth with a web app, be sure to provide :oauth_callback.
      # Options:
      #   :oauth_callback => String, url that LinkedIn should redirect to
      def request_token(options={})
        @request_token ||= consumer.get_request_token(options)
      end

      def authorize_from_code(code, redirect_uri)
        @access_token = consumer.auth_code.get_token(code, {:redirect_uri => redirect_uri},
                                                     DEFAULT_ACCESS_TOKEN_OPTIONS.clone)
        # because
      end

      def access_token
        @access_token
      end

      def authorize_from_access(atoken)
        @access_token ||= ::OAuth2::AccessToken.new(consumer, atoken, DEFAULT_ACCESS_TOKEN_OPTIONS.clone)
      end

      private

      # since LinkedIn uses api.linkedin.com for request and access token exchanges,
      # but www.linkedin.com for authorize/authenticate, we have to take care
      # of the url creation ourselves.
      def parse_oauth_options
        {
            :token_url  => full_oauth_url_for(:access_token,  :auth_host),
            :authorize_url     => full_oauth_url_for(:authorize,     :auth_host),
            :site              => @consumer_options[:site] || @consumer_options[:api_host] || DEFAULT_OAUTH2_OPTIONS[:api_host],
            :raise_errors       => false
        }
      end

      def full_oauth_url_for(url_type, host_type)
        if @consumer_options["#{url_type}_url".to_sym]
          @consumer_options["#{url_type}_url".to_sym]
        else
          host = @consumer_options[:site] || @consumer_options[host_type] || DEFAULT_OAUTH2_OPTIONS[host_type]
          path = @consumer_options[:"#{url_type}_path".to_sym] || DEFAULT_OAUTH2_OPTIONS["#{url_type}_path".to_sym]
          "#{host}#{path}"
        end
      end

    end

  end
end
