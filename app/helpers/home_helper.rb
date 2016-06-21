require 'cards_util'
module HomeHelper

	
	def get_card_url(card)
		CardsUtil.new.get_card_url(card)
	end
end
