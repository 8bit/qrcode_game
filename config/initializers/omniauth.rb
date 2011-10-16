require 'openid/store/filesystem'

ActionController::Dispatcher.middleware.use OmniAuth::Builder do
  # :scope parameter specifies the requested permissions for graph api. if you set it to empty, it will only pull the basic info. Default values for this is 'email, offline_access'
  # provide Site URL as http://localhost:3000/ in your facebook app. Now you will be able to access it from your development machine
  facebook_options = {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}, :scope => ''}

  provider :twitter, 'pywkRLwKIQr0n6iOzrWBpg', 'j4Qo9bBQMGkTEJse3SJY47nbbs6ySZIJoedKiYRyf4'
  provider :facebook, '241248755922188', 'f4d5e00b44bf78f186f7c464da4c47cc', facebook_options
  provider :linked_in, 'myf4f4slwur4', 'VBXtKITLso6RMmZU'

  provider :open_id,  OpenID::Store::Filesystem.new('/tmp')
end

# you will be able to access the above providers by the following url
# /auth/providername for example /auth/twitter /auth/facebook

ActionController::Dispatcher.middleware do
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
end

# you won't be able to access the openid urls like /auth/google
# you will be able to access them through
# /auth/open_id?openid_url=https://www.google.com/accounts/o8/id
# /auth/open_id?openid_url=https://me.yahoo.com
