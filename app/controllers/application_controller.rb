
class ApplicationController < ActionController::Base

  ### testing (UGLY)
  unless Rails.env.test?
    before_filter :authenticate_user!
  else
    CUser = Struct.new( 'CUser', :id, :name )
    @@cuser = CUser.new(  42, 'name' )
    def current_user
      @@cuser
    end
  end

  before_filter :boards

  protect_from_forgery

  protected

  def boards
     @menu_boards = Board.all( :order => :title)
  end
end
