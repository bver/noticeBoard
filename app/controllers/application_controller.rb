class ApplicationController < ActionController::Base
  before_filter :authenticate_user! unless Rails.env.test?
  before_filter :boards

  protect_from_forgery

  protected

  def boards
     @menu_boards = Board.all( :order => :title)
  end
end
