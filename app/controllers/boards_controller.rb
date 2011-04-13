class BoardsController < ApplicationController
  # GET /boards
  # GET /boards.xml
  def index
    @boards = Board.all( :order => :title)

    respond_to do |format|
      format.html { render :action => 'index' } # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @parent = Board.find(params[:id])
    @notes = @parent.notes

    @by_user_sel = {}
    if params.key?(:users)
      @by_user_sel.default = false
      params[:users].split('_').each { |id| @by_user_sel[id.to_i] = true }
    else
      @by_user_sel.default = true
    end

    @by_prio_sel = params.key?(:prio) ? params[:prio] : '0_1_2_3'
    @by_proc_sel = params.key?(:proc) ? params[:proc] : '0_1'
    @by_prob_sel = (params.key?(:prob) && params[:prob] == 'P')
    
    dry_options
    
    respond_to do |format|
      format.html { render :template => 'notes/index' } # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.xml
  def new
    @board = Board.new

    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])

    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'edit'} }
    end
  end

  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        format.js { render :template => 'shared/create', :locals =>{:templ=>'board'} }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.js { render :template => 'shared/update', :locals =>{:templ=>'board', :item=>@board} }
        format.xml  { head :ok }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'edit'} }
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
end
