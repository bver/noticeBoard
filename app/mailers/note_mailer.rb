
class NoteMailer < ActionMailer::Base
  default :from => "no@reply"
  helper :notes # adds helpers/notes_helper.rb

  def note_email( note, recipients )
    @note = note
    logger.debug "sending MAILs to #{recipients.inspect} subject: #{t :notice_board} : #{@note.title}"
    mail(:to => recipients, :subject => "#{t :notice_board} : #{@note.title}")
  end
end
