Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'lYa5SMp4Fy4WDs3n1Ljnbw', ENV['twitter_oauth_secret']
  provider :flickr, '52c9226e6d1e5c2452366c0f26e5ee11', ENV['flickr_oauth_secret']
end