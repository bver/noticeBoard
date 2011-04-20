class NoteMailer < ActionMailer::Base
  default :from => "no@reply"
  helper :notes # adds helpers/notes_helper.rb

  def note_email note
    @note = note
    recipients = []
    User.includes(:permissions).where( :active=>true, :send_mails=>true ).each do |user|
      next unless user.privilege?( :view_board, @note.board.id>0 ? @note.board.id : nil )
      recipients << user.email
    end
    logger.debug "sending to #{recipients.inspect} subject: #{t :notice_board} : #{@note.title}"
    mail(:to => recipients, :subject => "#{t :notice_board} : #{@note.title}") unless recipients.empty?
  end
end
