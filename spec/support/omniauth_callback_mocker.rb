# frozen_string_literal: true

# A class for mocking the OmniAuth data like 'omniauth.auth' and 'omniauth.params'
class OmniAuthCallbackMocker
  def initialize(provider:)
    @provider = provider
  end

  def call(auth:, params: {})
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(auth.update(provider:))
    OmniAuth.config.before_callback_phase do |env|
      env["omniauth.params"] = params
    end
  end

  private

  attr_reader :provider
end
