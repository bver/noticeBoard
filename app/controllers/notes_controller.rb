class NotesController < ApplicationController
  # GET /notes
  # GET /notes.xml
  def index
    @notes = Note.all
    @parent = nil
    dry_options

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
    dry_edit_create params[:add].to_s

    respond_to do |format|
      format.js do
          render :template => 'shared/dialog', :locals =>{:dialog=>'comment'}
      end
    end
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    dry_options

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
    dry_edit_create params[:add]
    dry_options

    change = Change.new( :created=>Time.now )
    change.user_id = current_user.id
    change.note = @note
    change.comment =params['comment']
    case params[:add].to_s
    when 'accept'
       change.sense = :accepted
       @note.user_id = current_user.id
       @note.working = false
    when 'done'
       change.sense = :finished
       @note.status = :finished
    when 'cancel'
       change.sense = :cancelled
       @note.status = :cancelled
    when 'start'
       change.sense = :start_work
       @note.user_id = current_user.id
       @note.working = true
    when 'stop'
       change.sense = :stop_work
       @note.working = false
    when 'priority'
       prio = params[:value].to_i
       if prio > @note.priority
         change.sense = :raise_priority
       elsif prio < @note.priority
         change.sense = :lower_priority
       else
         change = nil
       end
       change.argument = prio
       @note.priority = prio
    when 'user'
      user_id = params[:value].to_i
      if user_id == -1
        @note.user_id = nil
        change.sense = :unassigned
        change.argument = @note.user_id
      else
        @note.user_id = user_id
        change.sense = :assigned
        change.argument = user_id
      end
    when 'reject'
       change.sense = :rejected
       @note.user_id = nil
       @note.working = false
    when 'prob'
       change.sense = :set_problem
       @note.problem = true
    when 'noprob'
       change.sense = :reset_problem
       @note.problem = false
    else #when 'comment'
       change.sense = :commented
    end
    change.save unless change.nil?

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.js { render :template => 'shared/update', :locals =>{:templ=>'note', :item=>@note} }
        format.xml  { head :ok }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'comment'} }
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

  protected

  def dry_edit_create add
    @hidden = add.to_s
    @title, @label, @button = case @hidden
    when 'cancel'
       [t(:add_cancel), t(:label_cancel), t(:create_cancel)]
    when 'stop'
       [t(:add_stop), t(:label_stop), t(:create_stop)]
    when 'reject'
       [t(:add_reject), t(:label_reject), t(:create_reject)]
    when 'prob'
       [t(:add_problem), t(:label_problem), t(:create_problem)]
    else  # when 'comment'
       @hidden = 'comment'
       [t(:add_comment), t(:label_comment), t(:create_comment)]       
    end
  end

end
