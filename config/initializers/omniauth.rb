Rails.application.config.middleware.use OmniAuth::Builder do
  provider :steam, Rails.application.credentials.dig(:steam_api_key)
end
