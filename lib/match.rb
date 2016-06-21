require 'player'
require 'poker'

class Match

	attr_accessor :players

	def initialize(players_number = 0, players = [])
		@poker = Poker.new
		load_game(players_number, players)
  	end

	def get_players_cards
		cards = []
		@players.each{|key, value|
			cards.concat(value.cards)
		}
		return cards
	end

	def play
		@players = @poker.play(@players)
		#puts "players #{@players}"
		#puts "Hash[@players.sort_by #{Hash[@players.sort_by{|k, v| v.points}.reverse]}"
		return Hash[@players.sort_by{|k, v| v.points}.reverse]
	end

	def load_game(players_number, players)
		#if the players number was informed, treat like a new game
		#create the players
		if players_number > 0
			for i in 0..players_number - 1
					players << Player.new([], i + 1)
			end
			#set the players cards
			players = @poker.create_game_using_players(players)
		end
		#configure Match object players
		if !players.nil? && players.length > 0
			@players = {}
			players.each{|v|
				@players[v.id] = v
			}
		else
			@players = {}
		end
		#print "\nPlayers: #{players.size}\n"
		return players
	end

	def is_a_tie(players)
		points = {}
		players.each {|key, value|
			if points.has_key?(value.points)
				v = points[value.points]
				points[value.points] = v + 1
			elsif
				points[value.points] = 1
			end
		}
		return false if points.size == players.size
		#	puts "points #{points}"
		# get higher point and check if there is more than one player with this point
		points = Hash[points.sort.reverse]
		if points[points.keys.first].to_i == 1
			return false
		end
		return true
	end

	def get_players_by_point(point)
		players = []
		@players.each{|key, value|
			players << value if value.points == point
		}
		return players
	end

	def get_higher_player(players)
		player = nil
		points = players[0].points
		if points == ConstClass::A_PAIR
			player = get_higher_pair(players)
		elsif points == ConstClass::STRAIGHT_FLUSH
			player = get_higher_is_straight_flush(players)
		elsif points == ConstClass::QUADRA
			player = get_higher_four(players)
		elsif points == ConstClass::FULL_HOUSE
			player = get_higher_full_house(players)
		elsif points == ConstClass::FLUSH
		elsif points == ConstClass::STRAIGHT
		elsif points == ConstClass::TRINCA
			player = get_higher_three(players)
		elsif points == ConstClass::TWO_PAIRS
		elsif points == ConstClass::HIGHER_CARD
			player = get_higher_is_straight_flush(players)
		end
	end

	def print_players
 		@players.each{|key, value| puts value.to_s}
	end
	def get_higher_pair(players)
		return get_higher_group(players){|v| @poker.check_pair(v.cards)}
	end

	def get_higher_three(players)
		return get_higher_group(players){|v| @poker.check_three(v.cards)}
	end

	def get_higher_four(players)
		return get_higher_group(players){|v| @poker.check_four(v.cards)}
	end

	def get_higher_full_house(players)
		return get_higher_group(players){|v| @poker.check_three(v.cards)}
	end

	def get_higher_group(players)
		#configure players pairs data
		cards_fits = []
		players.each{|player|
			player.points_cards = yield(player)#@play_poker.p.check_pair(player.cards)
			cards_fits.concat(player.get_cards_fit(player.points_cards))
		}
#		puts "cards_fits #{cards_fits}"
		player_temp = []
		h = @poker.get_higher_card(cards_fits)
		return [get_player_by_card(players, h)]
	end

	def get_higher_is_straight_flush(players)
		cards = []
		players.each{|v|
			cards.concat(v.cards)
		}
		higher = @poker.get_higher_card(cards)
		return [get_player_by_card(players, higher)]
	end

	def get_player_by_card(players, card)
		if players.kind_of?(Array)
			players.each{|value|
				return value if value.cards.include?(card)
			}
		else
			players.each{|key, value|
				return value if value.cards.include?(card)
			}
		end
	end
end
