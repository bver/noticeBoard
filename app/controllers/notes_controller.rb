class NotesController < ApplicationController
  # GET /notes
  # GET /notes.xml
  def index
    @notes = Note.all
    @parent = nil

    respond_to do |format|
      format.html { render :action => 'index' } # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new
    if params.key? :parent
      @note.board = Board.find(params[:parent])
    else
      @board_options = Board.all( :order => :title ).map { |t| [t.title, t.id] }
    end

    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])

    respond_to do |format|
      format.js do
        @title = t :add_comment
        @label = t :label_comment
        @button = t :create_comment
        render :template => 'shared/dialog', :locals =>{:dialog=>'comment'}
      end
    end
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])

    respond_to do |format|
      if @note.save
        change = Change.new( :created=>Time.now )
        change.comment =params['comment'] if params.key? 'comment'
        change.sense = :created
        change.user_id = current_user.id
        change.note = @note
        change.save

        format.js { render :template => 'shared/create', :locals =>{:templ=>'note'} }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(@note, :notice => 'Note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml  { head :ok }
    end
  end
end
