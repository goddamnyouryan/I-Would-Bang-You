class ApplicationController < ActionController::Base
  config.relative_url_root = ""
  protect_from_forgery
  before_filter { |c| User.current_user = c.current_user }
end
