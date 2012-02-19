
class ApplicationController < ActionController::Base

  ### testing (UGLY)
  unless Rails.env.test?
    before_filter :authenticate_user!
    before_filter :deactivated_account
  else
    class CUser < Struct.new( 'CUser', :id, :name )
      def privilege?( name, board_id=nil )
        true
      end
    end
    @@cuser = CUser.new(  42, 'name' )
    def current_user
      @@cuser
    end
  end

  before_filter :boards
  before_filter :my_contexts

  protect_from_forgery

  protected

  def deactivated_account
    return if current_user.nil? or current_user.active
    sign_out current_user
    redirect_to new_user_session_path, :alert => t( :deactivated_account )
  end

  GroupSeparator = ' - '

  def boards
    @menu_boards = []
    return if current_user.nil?
    Board.all( :conditions => { :visibility => Board::Active },  :order => :title ).each do |b|
      @menu_boards << b if current_user.privilege?( :view_board, b.id )
    end

    @grouped_boards = {}
    @menu_boards.each do |b|
      parts = b.title.split GroupSeparator
      group = parts.shift
      chain = @grouped_boards.fetch( group, [] )
      chain << ( parts.empty? ? b : [b, parts.join(GroupSeparator)] )
      @grouped_boards[group] = chain
    end
  end

  def dry_options
    @prio_options = [
      [ t(:prio_high), 2 ],
      [ t(:prio_normal), 1 ],
      [ t(:prio_low), 0 ]
    ]
    @prio_options.unshift [ t(:prio_super), 3 ] if current_user.privilege?( :urgent_prio )

    @user_options = User.where( :active => true ).map { |u| [ u.name, u.id ] }
    @user_options.unshift [ "[#{ t :unassigned }]", -1 ]

    @ctx_options = @my_contexts.map { |c| [c.name, c.id] }

    #@board_options = @menu_boards.map { |b| [ b.title,  b.id ] }
    @board_options = []
    Board.where( "visibility = ? or visibility = ?", Board::Active, Board::Hidden ).order( "visibility DESC, title ASC" ).each do |b|
       @board_options << b if current_user.privilege?( :view_board, b.id )
    end
    @board_options.map! { |b| [ b.title,  b.id ] }

    @by_prio_options = [
      [ t( :by_prio_all ), '0_1_2_3'],
      [ t( :by_prio_important_normal ), '1_2_3'],
      [ t( :by_prio_only_important ), '2_3']
    ]

    @by_proc_options = [
      [ t( :by_proc_all ), '0_1_D_C'],
      [ t( :by_proc_all_uncompleted ), '0_1'],
      [ t( :by_proc_in_process ), '1'],
      [ t( :by_proc_paused ), '0'],
      [ t( :by_proc_archived ), 'D_C'],
      [ t( :by_proc_archived_done ), 'D'],
      [ t( :by_proc_archived_cancelled ), 'C']
    ]

    @by_instant_options = [
      [ t( :by_instant_all ), '0'],
      [ t( :by_instant_date ), 'D'],
      [ t( :by_instant_time ), 'T'],
      [ t( :by_instant_date_time ), 'D_T']
    ]

    @no_put_method = ( /Kindle/ =~ request.env["HTTP_USER_AGENT"] )

  end

  def dry_filter params
    conditions = {}

    if params.key? :prio
       @by_prio_sel =  params[:prio]
       conditions[ :priority ] = @by_prio_sel.split('_').map { |p| p.to_i }
    else
       @by_prio_sel =  '0_1_2_3'
    end

    @by_prob_sel = (params.key?(:prob) && params[:prob] == 'P')
    conditions[ :problem ] = true if @by_prob_sel

    @by_proc_sel = params.key?(:proc) ? params[:proc] : '0_1_D_C'
    case @by_proc_sel
    when '0_1'
      conditions[ :outcome ] = nil
    when '0'
      conditions[ :outcome ] = nil
      conditions[ :working ] = false
    when '1'
      conditions[ :outcome ] = nil
      conditions[ :working ] = true
    when 'D'
      conditions[ :outcome ] = true
    when 'C'
      conditions[ :outcome ] = false
    when 'D_C'
      conditions[ :outcome ] = [ true, false ]
    else # '0_1_D_C'
    end

    order = 'outcome ASC, priority DESC, problem DESC, boards.title, notes.title'
    
    if params.key? :inst
      @by_instant_sel = params[:inst]
      case @by_instant_sel
      when 'D'
        conditions[:instant_date] = Time.now.years_ago(30)..Time.now.years_since(50) # TODO better like "is not null" for hash options
        order = 'outcome ASC, instant_date ASC'
      when 'T'
        conditions[:instant_time] = Time.now.years_ago(30)..Time.now.years_since(50) # TODO better like "is not null" for hash options
        order = 'outcome ASC, instant_time ASC'
      when 'D_T'
        conditions[:instant_date] = Time.now.years_ago(30)..Time.now.years_since(50) # TODO better like "is not null" for hash options
        conditions[:instant_time] = Time.now.years_ago(30)..Time.now.years_since(50) # TODO better like "is not null" for hash options
        order = 'outcome ASC, instant_date ASC, instant_time ASC, boards.title, notes.title'
      else # 0
      end
    end

    logger.debug "conditions=#{conditions} order=#{order}"
    [conditions, order]
  end

  def my_contexts
    @my_contexts = current_user.nil? ? [] : current_user.contexts.where( :active => true ).order( :name )
  end

end
