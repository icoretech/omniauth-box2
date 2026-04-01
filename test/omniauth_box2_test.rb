# frozen_string_literal: true

require_relative "test_helper"

class OmniauthBox2Test < Minitest::Test
  def build_strategy
    OmniAuth::Strategies::Box.new(nil, "client-id", "client-secret")
  end

  def test_uses_current_box_endpoints
    client_options = build_strategy.options.client_options

    assert_equal "https://api.box.com/2.0", client_options.site
    assert_equal "https://account.box.com/api/oauth2/authorize", client_options.authorize_url
    assert_equal "https://api.box.com/oauth2/token", client_options.token_url
  end

  def test_uid_info_and_extra_are_derived_from_raw_info
    strategy = build_strategy
    payload = {
      "id" => "123456",
      "name" => "Test User",
      "login" => "test@example.com"
    }

    strategy.instance_variable_set(:@raw_info, payload)

    assert_equal "123456", strategy.uid
    assert_equal({name: "Test User", email: "test@example.com"}, strategy.info)
    assert_equal({"raw_info" => payload}, strategy.extra)
  end

  def test_raw_info_calls_users_me_endpoint_and_memoizes
    strategy = build_strategy
    token = FakeAccessToken.new({"id" => "123456"})

    strategy.define_singleton_method(:access_token) { token }

    first_call = strategy.raw_info
    second_call = strategy.raw_info

    assert_equal({"id" => "123456"}, first_call)
    assert_same first_call, second_call
    assert_equal 1, token.calls.length
    assert_equal "users/me", token.calls.first[:path]
  end

  def test_credentials_include_refresh_token_even_when_token_does_not_expire
    strategy = build_strategy
    token = FakeCredentialAccessToken.new(
      token: "access-token",
      refresh_token: "refresh-token",
      expires_at: nil,
      expires: false,
      params: {"scope" => "root_readonly"}
    )

    strategy.define_singleton_method(:access_token) { token }

    assert_equal(
      {
        "token" => "access-token",
        "refresh_token" => "refresh-token",
        "expires" => false,
        "scope" => "root_readonly"
      },
      strategy.credentials
    )
  end

  def test_does_not_expose_wrong_omniauth_namespace
    assert_raises(NameError) { Omniauth::Box2::VERSION }
  end

  def test_callback_url_prefers_configured_value
    strategy = build_strategy
    callback = "https://example.test/auth/box/callback"
    strategy.options[:callback_url] = callback

    assert_equal callback, strategy.callback_url
  end

  def test_query_string_is_ignored_during_callback_request
    strategy = build_strategy
    request = Rack::Request.new(Rack::MockRequest.env_for("/auth/box/callback?code=abc&state=xyz"))
    strategy.define_singleton_method(:request) { request }

    assert_equal "", strategy.query_string
  end

  def test_query_string_is_kept_for_non_callback_requests
    strategy = build_strategy
    request = Rack::Request.new(Rack::MockRequest.env_for("/auth/box?prompt=consent"))
    strategy.define_singleton_method(:request) { request }

    assert_equal "?prompt=consent", strategy.query_string
  end

  class FakeAccessToken
    attr_reader :calls

    def initialize(parsed_payload)
      @parsed_payload = parsed_payload
      @calls = []
    end

    def get(path)
      @calls << {path: path}
      Struct.new(:parsed).new(@parsed_payload)
    end
  end

  class FakeCredentialAccessToken
    attr_reader :token, :refresh_token, :expires_at, :params

    def initialize(token:, refresh_token:, expires_at:, expires:, params:)
      @token = token
      @refresh_token = refresh_token
      @expires_at = expires_at
      @expires = expires
      @params = params
    end

    def expires?
      @expires
    end

    def [](key)
      {"scope" => @params["scope"]}[key]
    end
  end
end
