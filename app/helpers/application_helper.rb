module ApplicationHelper

  def board_name ( board, name=nil )
    name = board.title if name.nil?
    raw '<span class="' + (board.visibility == Board::Active ? 'nbmenuactive' : 'nbmenuhidden') + '">' + name + '</span>'
  end

end
