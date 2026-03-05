# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    # OmniAuth strategy for Box OAuth2.
    class Box < OmniAuth::Strategies::OAuth2
      option :name, 'box'

      option :client_options,
             site: 'https://api.box.com/2.0',
             authorize_url: 'https://account.box.com/api/oauth2/authorize',
             token_url: 'https://api.box.com/oauth2/token',
             connection_opts: {
               headers: {
                 user_agent: 'icoretech-omniauth-box2 gem',
                 accept: 'application/json',
                 content_type: 'application/json'
               }
             }

      uid { raw_info['id'].to_s }

      info do
        {
          name: raw_info['name'],
          email: raw_info['login']
        }.compact
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('users/me').parsed
      end

      # Ensure token exchange uses a stable callback URI that matches provider config.
      def callback_url
        options[:callback_url] || super
      end

      # Prevent authorization response params from being appended to redirect_uri.
      def query_string
        return '' if request.params['code']

        super
      end
    end

    Box2 = Box
  end
end
