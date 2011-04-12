
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

  def dry_options
    @prio_options = [
      [ t(:prio_super), 3 ],
      [ t(:prio_high), 2 ],
      [ t(:prio_normal), 1 ],
      [ t(:prio_low), 0 ]
    ]
  end

end
