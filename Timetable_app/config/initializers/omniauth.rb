OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 851870488230120, "495190d07ea7c87736e5592126bcd98f"
end