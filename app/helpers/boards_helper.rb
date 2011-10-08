module BoardsHelper

  VisibilityIcons = ['folder-open', 'note', 'clipboard']
  VisibilityTexts = [:board_archived, :board_hidden, :board_active]

  def board_icon board
    %Q[<span class="ui-icon ui-icon-#{VisibilityIcons[board.visibility+1] }"></span>]
  end

  def board_state board
    t VisibilityTexts[board.visibility+1]
  end

  def board_title board
    %Q[#{board_icon board}#{board.user.name} : #{board.title}]
  end

end
