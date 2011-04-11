module NotesHelper

  def note_icon note
     case note.status
     when :active
       note.user.nil? ? 'star' : (note.working ? 'play' : 'pause')
     when :finished
       'check'
     when :cancelled
       'trash'
     else
       'alert'
     end
  end

  @@priority_class = [ 'nbpriolow', 'nbprionormal', 'nbpriohigh', 'nbpriosuper' ]
  def note_prio note
     @@priority_class[ note.priority ]
  end

  def note_user note
     note.user.nil? ? '' : " [#{note.user.name}]"
  end

  def note_title note
     return '' if note.board.nil?
     note.board.title + ' : ' + note.title
  end

  def nsp icon
    raw %Q'<span class="ui-icon ui-icon-#{icon}"></span>'
  end

  def note_problem note
    raw note.problem ? '<span class="nbpriosuper">?</span>' : ''
  end

  def change_comment change
     case change.sense
     when :created, :commented
       change.comment
     when :finished
       t( :c_finished )
     when :cancelled
       "#{ t :c_cancelled } : #{change.comment}"
     when :accepted
       t( :c_accepted )
     when :rejected
       "#{ t :c_rejected } : #{change.comment}"
     when :assigned
       "#{ t :c_assigned } #{User.guess_name_by_id(change.argument)}"
     when :raise_priority
       "#{ t :c_raised } #{change_priority change.argument}"
     when :lower_priority
       "#{ t :c_lowered } #{change_priority change.argument}"
     when :start_work
       t( :c_started )
     when :stop_work
       "#{ t :c_paused } : #{change.comment}"
     when :set_problem
       "#{ t :c_problem } : #{change.comment}"
     when :reset_problem
       t( :c_noproblem )
     else
       '!!!'
     end
  end

  @@change_priorities = [ :prio_low, :prio_normal, :prio_high, :prio_super ]
  def change_priority prio
     t @@change_priorities[ prio ]
  end

  @@change_icons = {
    :created => 'star',
    :finished => 'check',
    :cancelled => 'circle-close',
    :accepted => 'person',
    :rejected => 'close',
    :assigned => 'arrowreturnthick-1-e',
    :commented => 'comment',
    :raise_priority => 'arrowthick-1-n',
    :lower_priority => 'arrowthick-1-s',
    :start_work => 'play',
    :stop_work => 'pause',
    :set_problem => 'help',
    :reset_problem => 'help'
  }
  @@change_icons.default ='alert'
  def change_icon change
     @@change_icons[ change.sense ]
  end

end
