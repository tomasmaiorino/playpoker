require 'test_helper'
require 'match'
require 'player'


class MatchTest < ActiveSupport::TestCase

	def setup
		@card_1 = ['AH', 'AD', 'KS', 'KQ', 'QS']
		@card_2 = ["2D", "2A", "AF", "KD", "QA"]

		@players = [Player.new(["2D", "2A", "AF", "KD", "QA"], 2), Player.new(['AH', 'AD', 'KS', 'KQ', 'QS'], 1)]
	end

	def test_initialize
		m = Match.new(0, @players)
		assert m.players.length == 2
		assert_equal(10, m.get_players_cards.length)
		assert_equal(@card_1, m.players[1].cards)
		assert_equal(@card_2, m.players[2].cards)
	end

	def test_initialize_load_passing_only_players_numbers
		m = Match.new(2, [])
		assert m.players.length == 2
		assert_equal(10, m.get_players_cards.length)
		assert_not_nil(1, m.players[1])
		assert_not_nil(2, m.players[2])
		assert_not_equal(m.players[1].cards, m.players[2].cards)
	end

	def test_get_players_cards_passing_only_players
		m = Match.new(0, @players)
		assert_equal(@card_1, m.players[1].cards)
		assert_equal(@card_2, m.players[2].cards)
		assert_equal(2, m.players.size)
	end

	def test_play
		m = Match.new(0, @players)
		players = m.play
		assert_equal(players[players.keys.first].points, ConstClass::TWO_PAIRS)
	end

	def test_is_a_tie_false
		m = Match.new(0, @players)
		players = m.play
		#m.print_players
		assert !m.is_a_tie(players)
	end

	def test_is_a_tie_false_2
		@players << Player.new(["4D", "4A", "JF", "5D", "QA"], 3)
		m = Match.new(0, @players)
		players = m.play
		#m.print_players
		assert !m.is_a_tie(players)
	end

	def test_get_players_by_point
		m = Match.new(0, @players)
		players = m.play
		#4
		temp_players = m.get_players_by_point(ConstClass::TWO_PAIRS)
		assert temp_players.length == 1
		assert_equal(temp_players[0].cards, @card_1)
		assert_equal(temp_players[0].points, ConstClass::TWO_PAIRS)

		temp_players = m.get_players_by_point(ConstClass::A_PAIR)
		assert_equal(temp_players[0].cards, @card_2)
		assert_equal(temp_players[0].points, ConstClass::A_PAIR)
	end

	def test_get_players_by_point_with_tie_cards
		@players << Player.new(["4D", "4A", "JF", "5D", "QA"], 3)
		m = Match.new(0, @players)
		players = m.play
		#4
		temp_players = m.get_players_by_point(ConstClass::A_PAIR)
		assert temp_players.length == 2
		assert_equal(temp_players[0].cards, @card_2)
		assert_equal(temp_players[0].points, ConstClass::A_PAIR)
	end

	def test_get_higher_five_pair
		players = [Player.new(["4D", "4A", "JF", "5D", "QA"], 2), Player.new(["5D", "5A", "JF", "6D", "QA"], 1)]
		m = Match.new(0, players)
		player = m.get_higher_pair(players)
		assert_equal(player[0].id, players[1].id)
	end

	def test_get_higher_queen_pair
		players = [Player.new(["QD", "QA", "JF", "5D", "2A"], 2), Player.new(["5D", "5A", "JF", "6D", "QF"], 1)]
		m = Match.new(0, players)
		player = m.get_higher_pair(players)
		assert_equal(player[0].id, players[0].id)
	end

	def test_get_higher_king_pair
		players = [Player.new(["QD", "QA", "JF", "5D", "2A"], 2), Player.new(["5D", "5A", "JF", "6D", "QF"], 1), Player.new(["2D", "3A", "JF", "AD", "AF"], 3)]
		m = Match.new(0, players)
		player = m.get_higher_pair(players)
		assert_equal(player[0].id, players[2].id)
	end


	def test_get_higher_three
		players = [Player.new(["QD", "QA", "QF", "5D", "2A"], 2), Player.new(["5D", "5B", "5F", "6D", "2F"], 1), Player.new(["2D", "3A", "JF", "4D", "2F"], 3), Player.new(["AD", "AA", "AF", "5D", "2A"], 4)]
		m = Match.new(0, players)
		player = m.get_higher_three(players)
		assert_equal(player[0].id, players[3].id)
	end

	def test_get_higher_four_queen
		players = [
			Player.new(["QD", "QA", "QF", "QB", "2A"], 2),
			Player.new(["5D", "5B", "5F", "5A", "2F"], 1),
			Player.new(["2D", "3A", "JF", "4D", "2F"], 3),
			Player.new(["AD", "AA", "AF", "2D", "2A"], 4)
		]
		m = Match.new(0, players)
		player = m.get_higher_four(players)
		assert_equal(player[0].id, players[0].id)
	end

	def test_get_higher_four_five
		players = [
			Player.new(["2D", "2A", "2F", "2B", "2A"], 2),
			Player.new(["5D", "5B", "5F", "5A", "JF"], 1),
			Player.new(["2D", "3A", "JF", "4D", "3F"], 3),
			Player.new(["AD", "AA", "AF", "2D", "2A"], 4)
		]
		m = Match.new(0, players)
		player = m.get_higher_four(players)
		assert_equal(player[0].id, players[1].id)
	end

	def test_get_higher_full_house
		players = [
			Player.new(["2D", "2A", "2F", "10B", "10A"], 2),
			Player.new(["5D", "5B", "5F", "JA", "JF"], 1),
			Player.new(["2S", "3A", "JD", "4D", "5S"], 3),
			Player.new(["AD", "AA", "AF", "3D", "3A"], 4)
		]
		m = Match.new(0, players)
		player = m.get_higher_full_house(players)
		assert_equal(player[0].id, players[3].id)
	end

	def test_get_higher_is_straight_flush
		players = [
			Player.new(["2D", "3D", "4D", "5D", "6D"], 2),
			Player.new(["10A", "JA", "QA", "KA", "AA"], 1)
		]
		m = Match.new(0, players)
		player = m.get_higher_is_straight_flush(players)
		assert_equal(players[1].id, player[0].id)
	end

	def test_get_higher_flush
		players = [
			Player.new(["2D", "7D", "JD", "9D", "3D"], 2),
			Player.new(["2A", "4A", "7A", "KA", "3A"], 1)
		]
		m = Match.new(0, players)
		player = m.get_higher_is_straight_flush(players)
		assert_equal(players[1].id, player[0].id)
	end

	def test_get_player_by_card
		players = [
			Player.new(["4D", "4A", "JF", "5D", "QA"], 2),
			Player.new(["5D", "5A", "JF", "6D", "QA"], 1)
		]
		m = Match.new(0, players)
		card = '4D'
		player = m.get_player_by_card(m.players, card)
		assert_equal(player.id, players[0].id)
		assert player.cards.include?(card)
		assert players[0].cards.include?(card)

		card = '6D'
		player = m.get_player_by_card(m.players, card)
		assert_equal(player.id, players[1].id)
		assert player.cards.include?(card)
		assert players[1].cards.include?(card)
	end

end
