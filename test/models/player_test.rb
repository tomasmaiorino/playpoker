require 'test_helper'
require 'player'

class PlayerTest < ActiveSupport::TestCase

	def setup
			@cards = ["JD", "AA", "AF", "4D", "QA"]
	end

	def test_playes_initialize
		player = Player.new(@cards, 1)
		assert_equal(player.id, 1)
		assert_equal(player.cards, @cards)
  end

	def test_playes_initialize_2
		player = Player.new([], 1)
		assert_equal(player.id, 1)
		assert_equal(player.cards.length, 0)
	end


	def test_get_cards_fit
		player = Player.new(@cards, 1)
		player.points_cards = {'A'=>[1,2]}
		cards = player.get_cards_fit(player.points_cards)
		assert_equal([player.cards[1], player.cards[2]], cards)
	end

	def test_get_cards_fit_three
		player = Player.new(["AD", "2F", "AF", "4D", "AA"], 1)
		player.points_cards = {'A'=>[0,2,4]}
		cards = player.get_cards_fit(player.points_cards)
		assert_equal([player.cards[0], player.cards[2], player.cards[4]], cards)
	end
end
