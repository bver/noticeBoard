require 'RedCloth'

class NotesController < ApplicationController
  # GET /notes
  # GET /notes.xml
  def index
    @parent = nil

    conditions = dry_filter params

    @by_board_sel = {}
    @by_board_sel.default = false
    conditions[ :board_id ] = []
    all_ids = if params.key?(:boards)
       params[:boards].split('_').map {|id| id.to_i } 
    else
       Board.where( :active=>true ).map {|b| b.id }
    end
    all_ids.each do |id|
        next unless current_user.privilege?( :view_board, id )
        @by_board_sel[id] = true
        conditions[ :board_id ] << id
    end

    conditions[:user_id] = [ current_user.id, -1 ]
    @notes = Note.all( :conditions => conditions, :order => 'priority DESC, problem DESC' )
    @all_size = Note.count( :conditions => {:user_id =>  [ current_user.id, -1 ] })
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

    unless current_user.privilege?( :view_board, @note.board_id )
      head :forbidden
      return
    end
    dry_options

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
      @board_options = []
      Board.all( :conditions => {:active=>true},  :order => :title ).each do |b|
         @board_options <<  [b.title, b.id]  if current_user.privilege?( :edit_notes, b.id )
      end

      if @board_options.empty?
        head :forbidden
        return
      end
    end

    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
    return if dry_modified_by_others

   add = params[:add].to_s
   dry_edit_create add
    
    dialog = case add
    when 'edit', 'upload'
      add
    else
      'comment'
    end

    respond_to do |format|
      format.js do
          render :template => 'shared/dialog', :locals =>{:dialog=>dialog}
      end
    end
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    @note.content = params['comment'] if params.key? 'comment'

    unless current_user.privilege?( :edit_notes, @note.board_id )
      head :forbidden
      return
    end

    if @menu_boards.empty?
      head :forbidden
      return
    end
    
    dry_options

    respond_to do |format|
      if @note.save
        change = Change.new( :created=>Time.now )
        #change.comment =params['comment'] if params.key? 'comment'
        change.sense = :created
        change.user_id = current_user.id
        change.note = @note
        change.save

        recipients = note_recipients(@note)
        NoteMailer.note_email( @note, recipients ).deliver unless recipients.empty?

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

    if params[:add].to_s != 'comment'
      return if dry_modified_by_others
    end
    dry_edit_create params[:add]
    dry_options

    change = Change.new( :created=>Time.now )
    change.user_id = current_user.id
    change.note = @note
    change.comment =params['comment']

    case params[:add].to_s
    when 'accept'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :accepted
       @note.user_id = current_user.id
       @note.working = false
    when 'done'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :finished
       @note.status = :finished
    when 'cancel'
       unless current_user.privilege?( :cancel_notes, @note.board_id )
          head :forbidden
          return
       end
       change.sense = :cancelled
       @note.status = :cancelled
    when 'start'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :start_work
       @note.user_id = current_user.id
       @note.working = true
    when 'stop'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :stop_work
       @note.working = false
    when 'priority'
       unless current_user.privilege?( :change_prio, @note.board_id )
          head :forbidden
          return
       end
       prio = params[:value].to_i
       if (prio == 3 or @note.priority == 3) and ! current_user.privilege?( :urgent_prio, @note.board_id )
          head :forbidden
          return
       end
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
      unless current_user.privilege?( :assign_notes, @note.board_id )
          head :forbidden
          return
      end
      user_id = params[:value].to_i
      if user_id == -1
        change.sense = :unassigned
        change.argument = @note.user_id
      else
        change.sense = :assigned
        change.argument = user_id
      end
      @note.user_id =user_id
    when 'reject'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :rejected
       @note.user_id = -1
       @note.working = false
    when 'prob'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :set_problem
       @note.problem = true
    when 'noprob'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :reset_problem
       @note.problem = false
    when 'edit'
      unless current_user.privilege?( :edit_notes, @note.board_id )
          head :forbidden
          return
      end
      unless @note.content == params[:note][:content]
        change.sense = :edited_content
        change.comment =@note.content
        unless @note.title == params[:note][:title]
          change.save
          change = Change.new( :created=>Time.now )
          change.user_id = current_user.id
          change.note = @note
          change.sense = :edited_title
          change.comment =@note.title
        end
      else
        unless @note.title == params[:note][:title]
          change.sense = :edited_title
          change.comment =@note.title
        else
          change = nil
        end        
      end
    when 'upload'
      unless current_user.privilege?( :file_upload, @note.board_id )
          head :forbidden
          return
      end
      change.comment = @note.save_attachement( params[:upload] )
      change.sense = :attachement

    else #when 'comment'
       unless current_user.privilege?( :process_notes, @note.board_id )
         head :forbidden
         return
       end
       change.sense = :commented
    end

    unless change.nil?
      change.save
      @note.updated_at = Time.now
    end

    respond_to do |format|
      if @note.update_attributes(params[:note])

        recipients = note_recipients(@note)
        NoteMailer.note_email( @note, recipients ).deliver unless recipients.empty?

        format.js { render :template => 'shared/update', :locals =>{:templ=>'note', :item=>@note} }
        format.html { redirect_to request.referrer }
        format.xml  { head :ok }
      else
        format.html { redirect_to request.referrer }
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

  def dry_modified_by_others
     @last = @note.updated_at.to_i
      return false if params.key?(:last) and params[:last].to_i == @last

      respond_to do |format|
          format.js { render 'alert' }
          format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
      
      true
  end

  def note_recipients note
      recipients = []
      User.includes(:permissions).where( :active=>true, :send_mails=>true ).each do |user|
        next unless user.privilege?( :view_board, note.board.id>0 ? note.board.id : nil )
        recipients << user.email
      end
      recipients
  end

end
