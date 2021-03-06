class BoardsController < ApplicationController
  before_filter :dry_users

  # GET /boards
  # GET /boards.xml
  def index

    case params[:show].to_s
    when 'all'
      unless current_user.privilege?( :manage_boards )
        head :forbidden
        return
      end
      @boards = Board.includes(:user).where( "visibility = ? or visibility = ?", Board::Active, Board::Hidden ).order( "visibility DESC, title ASC" )

    when 'all_archived'
      unless current_user.privilege?( :manage_boards )
        head :forbidden
        return
      end
      @boards = Board.includes(:user).where( :visibility => Board::Archived ).order( "title ASC" )

    when 'archived'
      @boards = Board.includes(:user).where( :visibility => Board::Archived ).order( "title ASC" ).find_all { |b| current_user.privilege?( :view_board, b.id ) }

    else
      @boards = Board.includes(:user).where( "visibility = ? or visibility = ?", Board::Active, Board::Hidden )
                                   .order( "visibility DESC,title ASC" ).find_all { |b| current_user.privilege?( :view_board, b.id ) }

    end
    
    respond_to do |format|
      format.html { render :action => 'index' } # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @parent = Board.find(params[:id])

    unless current_user.privilege?( :view_board, @parent.id )
      head :forbidden
      return
    end

    conditions, order = dry_filter params

    @by_user_sel = {}
    if params.key?(:users)
      @by_user_sel.default = false
      conditions[ :user_id ] = []
      params[:users].split('_').each do |part|
        id = part.to_i
        @by_user_sel[id] = true
        conditions[ :user_id ] << id
      end
    else
      @by_user_sel.default = true
    end
    
    #@notes = @parent.notes
    conditions[:board_id] = @parent.id
    @notes = Note.includes(:user).includes(:board).includes(:contexts).all( :conditions => conditions, :order => order )
    dry_options
    
    respond_to do |format|
      format.html { render :template => 'notes/index' } # show.html.erb
      format.xml  { render :xml => @parent }
    end
  end

  # GET /boards/1/overview
  def overview
    @board = Board.find(params[:id])

    unless current_user.privilege?( :view_board, @board.id )
      head :forbidden
      return
    end

    respond_to do |format|
      format.html { render :template => 'shared/show', :locals =>{:res=>:board} }
    end
  end

  # GET /boards/new
  # GET /boards/new.xml
  def new
    @board = Board.new
    @title = t :new_board
    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
    @title = t :edit_board
    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
    end
  end

  # POST /boards
  # POST /boards.xml
  def create
    unless current_user.privilege?(:add_boards)
      head :forbidden
      return
    end

    @board = Board.new(params[:board])
    @board.user_id = current_user.id

    respond_to do |format|
      if @board.save
        dry_update_privs params
        format.js { render :text => "window.location.href = '#{board_path(@board)}';" }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    unless current_user.id == @board.user_id or current_user.privilege?( :manage_users )
      head :forbidden
      return
    end

    respond_to do |format|
      if @board.update_attributes(params[:board])
        dry_update_privs params
        format.js { render :template => 'shared/update', :locals =>{:templ=>'board', :item=>@board} }
        format.xml  { head :ok }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(boards_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def dry_users
      @users = User.includes(:permissions)
  end

  def dry_update_privs params
    @users.each do |u|
       #next if u.id == current_user.id
       Permission.privs_board.each do |p|
         if params.key?  "priv_#{p}_#{u.id}"
           u.grant( p, @board.id )
         else
           u.revoke( p, @board.id )
         end
       end
    end
 end

end
