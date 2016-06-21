
require 'match'
class HomeController < ApplicationController

  def index
  	@player = Player.new([], 0, 0)
    render "home/index"
  end

  def play  	
  	@player = Player.new([], 0, 0)

  	@player.player_chosen = params[:player_chosen]
  	@player.players_qt = params[:players_qt]

  	if @player.valid? == false
   		render "home/index" 
   		return
  	end

	  m = Match.new(@player.players_qt.to_i, [])

  	result = m.play
  	m.print_players
  	player = [result[result.keys.first]]
  	if m.is_a_tie(result)
  		players = []
  		result.each{|key, value|
  			players << value
  		}
  		player = m.get_higher_player(players)
  	end
	
    Rails.logger.info "The winner is player:"
    Rails.logger.info "Player #{player[0].id} with a #{player[0].game_name} and this cards #{player[0].cards}"

    @winner_player = player[0]
    if @player.players_qt.to_i > 1
      others = []
      result.each{|key, value|
        if value.id != player[0].id
          others << value
        end
      }
      @others_players = others
      @you_win = @player.player_chosen.to_i == @winner_player.id
    end
	  render "home/index"
  end

end
