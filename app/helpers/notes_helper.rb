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

  def note_problem note
    note.problem ? '<span class="nbpriosuper">?</span>' : ''
  end
  
end
