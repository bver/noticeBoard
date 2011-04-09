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

end
