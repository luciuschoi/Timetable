OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '396915460492742', "4aa6d4e4fd62e8fd924cc2bd6966ae3d"
end