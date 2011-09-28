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
     (note.user_id==-1) ? '' : " [#{note.user.name}]"
  end

  def note_title( note, parent )
     return '' if note.board.nil?
     if parent.nil?
       note.board.title + ' : ' + note.title
     else
       note.title
     end
  end

  def note_instant note
    return '' if note.date.nil? and note.time.nil?
    raw %Q'<span class="nbnoteinstant">#{note.date} #{note.time}</span>'
  end

  def nsp icon
    raw %Q'<span class="ui-icon ui-icon-#{icon}"></span>'
  end

  def note_problem note
    raw note.problem ? '<span class="nbpriosuper">?</span>' : ''
  end

  def change_comment change
     case change.sense
     when :created
       #raw('<b>')  + ": #{change.comment}" + raw('</b>')
       t( :c_created )
     when :commented
       ": #{change.comment}"
     when :finished
       t( :c_finished )
     when :cancelled
       "#{ t :c_cancelled } : #{change.comment}"
     when :accepted
       t( :c_accepted )
     when :rejected
       "#{ t :c_rejected } : #{change.comment}"
     when :assigned
       "#{ t :c_assigned } #{User.find(change.argument).name}"
     when :unassigned
       "#{ t :c_unassigned } #{User.find(change.argument).name}"
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
     when :edited_title
       t( :c_edited_title )
     when :edited_content
       t( :c_edited_content )
     when :attachement
       raw(  "#{ t :c_attachement } : " + link_to( change.comment, "/attachements/#{change.note_id}/#{change.comment}", :target => '_blank' ) )
     when :set_time
       "#{t( :c_set_time )} : #{DateTime.parse('00:00').since(change.argument).to_s.gsub(/^.*T/,'').gsub(/\+.*$/,'').gsub(/\:\d\d$/,'')}"
     when :reset_time
       t( :c_reset_time )
     when :set_date
       "#{t( :c_set_date )} : #{Date.parse('1.1.1970').since(change.argument).to_s(:db).split(' ').first.split('-').reverse.join('.')}"
     when :reset_date
       t( :c_reset_date )
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
    :unassigned => 'arrowreturnthick-1-n',
    :commented => 'comment',
    :raise_priority => 'arrowthick-1-n',
    :lower_priority => 'arrowthick-1-s',
    :start_work => 'play',
    :stop_work => 'pause',
    :set_problem => 'help',
    :reset_problem => 'help',
    :edited_title => 'pencil',
    :edited_content => 'pencil',
    :attachement => 'document',
    :set_time => 'clock',
    :reset_time => 'clock',
    :set_date => 'calendar',
    :reset_date => 'calendar'
  }
  @@change_icons.default ='alert'
  def change_icon change
     @@change_icons[ change.sense ]
  end

end
