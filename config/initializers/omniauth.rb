OmniAuth.config.logger = Rails.logger


Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, '405024793015142', "79f9dd7e6629c1c4879ba68e49102164"
end 
