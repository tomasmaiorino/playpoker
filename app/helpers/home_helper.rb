require 'cards_util'
module HomeHelper

	
	def get_card_url(card)
		CardsUtil.new.get_card_url(card)
	end

	def sort(card)
		model = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		return sort_cards(model, card)
	end

	def sort_cards(model, to_order)
		n = []
		if to_order != nil && !to_order.empty?
			model.each_with_index do |item, index|
		  		to_order.each_with_index do |val, ind|
		  			if model[index.to_i] == to_order[ind][0, to_order[ind].length - 1]
			  				n << to_order[ind]
		  			end
		  		end
		  	end
		  end
	  	return n
	end
end
