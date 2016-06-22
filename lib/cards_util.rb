require 'const_class'
class CardsUtil

	def initialize
		@cards_type = {}
		@cards_type['C'] = ConstClass::CLUB_IMAGE_URL
		@cards_type['D'] = ConstClass::DIAMOND_IMAGE_URL
		@cards_type['S'] = ConstClass::SPADE_IMAGE_URL
		@cards_type['H'] = ConstClass::HEART_IMAGE_URL
	end
	
	def get_card_url(card)
		return nil if card.nil? || card.empty?

		url_temp = @cards_type[card[card.length - 1]]
		url_temp.sub(/@/, card)
	end

	def get_game_name_view(game_name)
		
	end
end