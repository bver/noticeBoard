class ContextsController < ApplicationController

  # GET /contexts
  def index
    @contexts = @my_contexts + current_user.contexts.where( :active => false ).order( :name )
  end

  # GET /contexts/1
  def show
    @parent = Context.find(params[:id])

    unless @parent.active && (current_user.id == @parent.user_id )
      head :forbidden
      return
    end

    @notes = @parent.notes.find_all {|n| n.board.active and n.outcome.nil? and current_user.privilege?( :view_board, n.board.id ) }
    @notes.sort! { |b,a| a.priority <=> b.priority }
    dry_options

    respond_to do |format|
      format.html { render :template => 'notes/index' } # show.html.erb
      format.xml  { render :xml => @parent }
    end
  end

  # GET /contexts/1/overview
  def overview
    @context = Context.find(params[:id])

    unless  current_user.id == @context.user_id
      head :forbidden
      return
    end

    respond_to do |format|
      format.html { render :template => 'shared/show', :locals =>{:res=>:context} }
    end
  end

  # GET /contexts/new
  def new
    @context = Context.new
    @title = t :new_context
    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
      format.xml  { render :xml => @context }
    end
  end

  # GET /contexts/1/edit
  def edit
    @context = Context.find(params[:id])
    @title = t :edit_context
    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
      format.xml  { render :xml => @context }
    end
  end

  # POST /contexts
  def create
    @context = Context.new(params[:context])
    @context.user_id = current_user.id

    respond_to do |format|
      if @context.save
        format.js { render :template => 'shared/create', :locals =>{:templ=>'context'} }
        format.xml  { render :xml => @context, :status => :created, :location => @context }
      else
        @title = t :new_context
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'form'} }
        format.xml  { render :xml => @context.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  def destroy
    @context = Context.find(params[:id])
    @context.destroy

    respond_to do |format|
      format.html { redirect_to(contexts_url) }
      format.xml  { head :ok }
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @context = Context.find(params[:id])

    unless current_user.id == @context.user_id
      head :forbidden
      return
    end

    respond_to do |format|
      if @context.update_attributes(params[:context])
        format.js { render :template => 'shared/update', :locals =>{:templ=>'context', :item=>@context} }
        format.xml  { head :ok }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'edit'} }
        format.xml  { render :xml => @context.errors, :status => :unprocessable_entity }
      end
    end
  end


end
