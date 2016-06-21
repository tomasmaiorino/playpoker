require "const_class"

class Poker

	def initialize
		@cards = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		@deck = ['D','H','S','C']
		@all_cards = initialize_all_cards(@cards, @deck)
	end

	def create_cards(type_card, cards)
		c = []
		return nil if type_card == nil || type_card.empty? || cards == nil || cards.empty?
		cards.each {|x|
			r = "#{x}#{type_card}"
			c.push(r)
		}
		return c
	end

	def create_game_using_players(players)
		#players = {}
		if !players.nil? && players.length > 0
			car = []
			players.each_with_index {|item, index|
				car = create_game(@all_cards, car)
				players[index].cards = car
			}
		end
		return players
	end

	def create_game(all_cards, c = [])
		g = []
		rand = Random.new
		if all_cards != nil && !all_cards.empty?
			while g.length < 5
				x = all_cards[rand.rand(0..all_cards.length - 1)]
				if !g.include?(x)
					if c.length == 0 || c.length > 0 && !c.include?(x)
						g << x
					end
				end
			end
		end
		return g
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

	def check_pair(cards)
		return get_sets(cards, 2)
	end

	def get_sets(cards, numbers_to_match)
		n = {}
		if cards != nil && !cards.empty?
			cards_without_n = remove_n(cards)
			cards_without_n.each_with_index { |val, ind|
				if cards_without_n.count(val) == numbers_to_match
					indexes = cards_without_n.size.times.select {|i| cards_without_n[i] == cards_without_n[ind.to_i]}
					n[val] = indexes
				end
			}
		end
		return n
	end

	def remove_n(cards)
		n = []
		if cards != nil && !cards.empty?
			cards.each {|v|
				n << v[0, v.length - 1]
			}
		end
		return n
	end

	def check_three(cards)
		return get_sets(cards, 3)
	end

	def check_four(cards)
		return get_sets(cards, 4)
	end

	def is_full_house(cards)
		check_three(cards).length == 1 && check_pair(cards).length == 1
	end

	def is_flush(cards)
		v = true
		cards.each_with_index{|val, ind|
			cards.each_with_index{|ival, iind|
				if cards[ind][val.length - 1] != cards[iind][ival.length - 1]
					v = false
					break
				end
			}
		}
		return v
	end

	def check_all_cards_in_sequence(cards)
		cards_without_n = remove_n(sort_cards(@cards, cards))
		s = true
		cards_without_n.each_with_index{|val, ind|
			# check if the card is a number
			if val.match(/\d/) != nil
				# check if this is the last one
				if ind < cards_without_n.length - 1
					# check if the actual card is a 10
					if val.to_i == 10
						if cards_without_n[ind + 1] != "J"
							s = false
						end
					elsif (val.to_i + 1 != cards_without_n[ind  + 1].to_i)
						s = false
					end
				end
			else
				if ind < cards_without_n.length - 1
					if val == 'J' && cards_without_n[ind + 1]  != 'Q' || val == 'Q' && cards_without_n[ind + 1] != 'K' ||  val == 'K' && cards_without_n[ind + 1] != 'A'
						s = false
					end
				end
			end
		}
		return s
	end

	def if_full_house(cards)
		t = check_three(cards)
		p = check_pair(cards)
		!t.empty? && t.length == 1 and !p.empty? && p.length == 1
	end

	def is_straight(cards)
		check_all_cards_in_sequence(cards)
	end

	def is_straight_flush(cards)
		check_all_cards_in_sequence(cards) && is_flush(cards)
	end

	def is_royal_flush(cards)
		sorted_cards = sort_cards(@cards, cards)
		is_straight_flush(cards) && !sorted_cards.empty? && sorted_cards[0][0,2] == '10'
	end

	def is_four(cards)
		return !get_sets(cards, 4).empty?
	end

	def initialize_all_cards(cards, deck)
		all_cards = []
		if !cards.nil? && !cards.empty? && !deck.nil?  && !deck.empty?
			deck.each{ |val|
				all_cards.concat create_cards(val, cards)
			}
		end
		return all_cards
	end

	def get_higher_card(cards)
		sorted_cards = sort_cards(@cards, cards)
		sorted_cards[sorted_cards.length - 1]
	end

	def check_only_letters(cards)
		check_only(cards){ |v|
 				v.match(/\d/) != nil ? false : true
 			}
	end

	def check_only_numbers(cards)
		check_only(cards){ |v|
 				v.match(/\d/) == nil ? false : true
 		}
	end

	def get_points(player)
		#puts "cards #{player.cards}"
		if is_straight_flush(player.cards)
			player.points = ConstClass::STRAIGHT_FLUSH
			player.game_name = "STRAIGHT_FLUSH"
		elsif is_four(player.cards)
			player.points = ConstClass::QUADRA
			player.game_name = "QUADRA"
		elsif is_full_house(player.cards)
			player.points = ConstClass::FULL_HOUSE
			player.game_name = "FULL_HOUSE"
		elsif is_flush(player.cards)
			player.points = ConstClass::FLUSH
			player.game_name = "FLUSH"
		elsif is_straight(player.cards)
			player.points = ConstClass::STRAIGHT
			player.game_name = "STRAIGHT"
		elsif check_three(player.cards).length == 1
			player.points = ConstClass::TRINCA
			player.game_name = "TRINCA"
		elsif check_pair(player.cards).length == 2
			player.points = ConstClass::TWO_PAIRS
			player.game_name = "TWO_PAIRS"
		elsif check_pair(player.cards).length == 1
			player.points = ConstClass::A_PAIR
			player.game_name = "A_PAIR"
		else
			player.points = ConstClass::HIGHER_CARD
			player.game_name = "HIGHER_CARD"
		end
		return player
	end


	def play(players)
		players.each {|key, value|
  			value = get_points(value)
		}		
		return players
	end

	private
	def check_only(cards)
		v = nil
		if !cards.nil? && !cards.empty?
			v = true
			cards.each{|h|
				v = yield(h)
				break unless v == true
			}
		end
		return v
	end
end
=begin
10 - Straight Flush: Cinco cartas em seqüência, do mesmo naipe.
Obs: O melhor straight flush possível é conhecido como Royal Flush, que consiste
 em ás, rei, dama, valete e dez de um único naipe.

09 - Quadra: Quatro cartas de valor idêntico e uma carta lateral.
Obs: Na eventualidade de um empate: A quadra mais alta ganha. Nos jogos com cartas comunitárias,
em que os jogadores têm a mesma quadra, a quinta carta lateral mais alta (a "kicker") ganha.

08 - Full House: Três cartas de valor idêntico (trinca) e duas cartas de valor diferente e compatível.
Obs: Na eventualidade de um empate: A trinca mais alta ganha o pote. Nos jogos de cartas de comunidade
 em que os jogadores têm a mesma trinca, o valor mais alto de um par ganha.

07 - Flush (Cor): Cinco cartas do mesmo naipe.
Obs: Na eventualidade de um empate: Ganha o jogador com a carta com maior valor.
Se necessário, a segunda, terceira, quarta e quinta cartas mais altas podem ser utilizadas para resolver o empate.

06 - Straight (Seqüencia): Cinco cartas em seqüência.
Obs: Na eventualidade de um empate: A carta com valor mais alto no topo da seqüência ganha.
Nota: O Ás pode ser utilizado na parte superior ou inferior da seqüência e é a única carta que pode agir desta forma

05 - Trinca: Três cartas de valor idêntico e duas cartas laterais não relacionadas.
Obs: Na eventualidade de um empate: A trinca mais alta ganha. Nos jogos com cartas comunitárias,
 em que os jogadores têm a mesma trinca, a carta lateral mais alta ou, se necessário, a segunda carta mais alta ganha.

04 - Dois pares: Duas cartas de valor idêntico, outras duas cartas de outro valor idêntico
entre si (mas diferente do valor das duas primeiras cartas) e uma carta lateral
Obs: Na eventualidade de um empate: O par mais alto ganha. Se os jogadores tiverem um par de idêntico valor,
o segundo par mais alto ganha. Se ambos os jogadores tiverem pares idênticos, a carta lateral mais alta ganha.

03 - Um par: Duas cartas de valor idêntico e três cartas laterais não relacionadas.
Obs: Na eventualidade de um empate: O par mais alto ganha. Se os jogadores possuírem o mesmo par, a carta lateral mais alta ganha e,
se necessário, a segunda e terceira cartas mais altas podem ser utilizadas para resolver o empate.

02 - Carta alta: Qualquer mão que não se qualifique numa categoria listada acima.
Obs: Na eventualidade de um empate: A carta mais alta ganha e, se necessário, a segunda,
terceira e quarta mais altas e a carta mais baixa podem ser utilizadas para resolver o empate.
=end
