class ApplicationController < ActionController::Base
  before_filter :authenticate_user! unless Rails.env.test?

  protect_from_forgery
end
