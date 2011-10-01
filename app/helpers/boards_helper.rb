module BoardsHelper
  def board_title board
    %Q[<span class="ui-icon ui-icon-#{ board.active ?  'clipboard' : 'note' }"></span>#{board.user.name} : #{board.title}]
  end
end
