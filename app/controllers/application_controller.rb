
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

    @user_options = User.all.map { |u| [ u.name, u.id ] }
    @user_options.unshift [ "[#{ t :unassigned }]", -1 ]

    @by_prio_options = [
      [ t( :by_prio_all ), '0_1_2_3'],
      [ t( :by_prio_important_normal ), '1_2_3'],
      [ t( :by_prio_only_important ), '2_3']
    ]

    @by_proc_options = [
      [ t( :by_proc_all_uncompleted ), '0_1'],
      [ t( :by_proc_in_process ), '1'],
      [ t( :by_proc_paused ), '0'],
      [ t( :by_proc_archived_done ), 'D'],
      [ t( :by_proc_archived_cancelled ), 'C']
    ]

  end

end
