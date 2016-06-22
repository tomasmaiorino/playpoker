class Player 
	include ActiveModel::Validations


	attr_accessor :cards, :id, :points, :points_cards, :game_name, :players_qt, :player_chosen

	validates :players_qt,  :presence => { :message => "Come on dude !! You need to choose at least one player." }
	validates :player_chosen,  :presence => { :message => "Do you realy don't want to play ? Choose one for player for you." }
	validates_numericality_of :players_qt, :player_chosen, :greater_than => 0, :less_than => 5,  :message => ""
	validate :check_player_chosen

	def initialize(cards, id, points = 0)
		@cards = cards
		@id = id
		@points = points
		@points_cards = {}
		@game_name = ''
		@players_qt = nil
		@player_chosen = nil
	end

	def to_s
		puts "Player #{@id} cards: #{@cards} points: #{@points}"
	end

	def get_cards_fit(points_cards)
		cards_fit = []
		points_cards.each{|key, value|
			value.each{|i|
				cards_fit << @cards[i]
			}
		}
		return cards_fit
	end
	
	def check_player_chosen
	    Rails.logger.info "check_player_chosen"
		if (!@player_chosen.nil? && @player_chosen.to_i > 0 && !@players_qt.nil? && @players_qt.to_i > 0)
			if @player_chosen > @players_qt
				Rails.logger.info "Player chose higher than players qt"
				append_message = @players_qt.to_i == 1 ? "player" : "players"
	  			errors.add(:player_chosen, "Man, how can you be the player #{@player_chosen} if we have only #{@players_qt} #{append_message}. Let's choose another one, rigth?")
			elsif @player_chosen.to_i == 1 and @players_qt.to_i == 1
				Rails.logger.info "Both player_chosen and players_qt equal 1"
				errors.add(:player_chosen, "Man, how can you play with only your self ? Let's choose another one, rigth!?")
	  		end
	  	end
	end

end
