require_relative '../../spec_helper'
require_relative '../../lib/studio_game/player'
require_relative '../../lib/studio_game/treasure_trove'

module StudioGame
  describe Player do

    before do
      @initial_health = 150
      @player = Player.new("larry", @initial_health)

      $stdout = StringIO.new
    end

    it 'has a capitalized name' do
      # player.name.should == "Larry"
      expect(@player.name).to eq("Larry")
    end

    it "has an initial health" do

      expect(@player.health).to eq(150)
    end

    it "has a string representation" do
      @player.found_treasure(Treasure.new(:hammer, 50))
      @player.found_treasure(Treasure.new(:hammer, 50))

      expect(@player.to_s).to eq("I'm Larry with health = 150, points = 100, and score = 250.")
    end

    it "computes a score as the sum of its health and points" do
      @player.found_treasure(Treasure.new(:hammer, 50))
      @player.found_treasure(Treasure.new(:hammer, 50))

      expect(@player.score).to eq(250)
    end

    it "increases health by 15 when w00ted" do
      @player.w00t

      expect(@player.health).to eq(@initial_health + 15)
    end

    it "decreases health by 10 when blammed" do
      @player.blam

      expect(@player.health).to eq(@initial_health - 10)
    end

    context "with a health greater than 100" do
      before do
        @player = Player.new("larry", 150)
      end

      it 'gives the player a strong rating' do
        expect(@player).to be_strong
      end
    end

    context "with a health of 100 or less" do
      before do
        @player = Player.new("larry", 100)
      end

      it "gives the player a wimpy rating" do
        expect(@player.strong?).not_to be_truthy
      end
    end

    context "in a collection of players" do
      before do
        @player1 = Player.new("moe", 100)
        @player2 = Player.new("larry", 200)
        @player3 = Player.new("curly", 300)

        @players = [@player1, @player2, @player3]
      end

      it "is sorted by decreasing score" do
        expect(@players.sort).to eq([@player3, @player2, @player1])
      end
    end

    it "computes points as the sum of all treasure points" do
      @player.points.should == 0

      @player.found_treasure(Treasure.new(:hammer, 50))

      @player.points.should == 50

      @player.found_treasure(Treasure.new(:crowbar, 400))

      @player.points.should == 450

      @player.found_treasure(Treasure.new(:hammer, 50))

      @player.points.should == 500
    end

    it "yields each found treasure and its total points" do
      @player.found_treasure(Treasure.new(:skillet, 100))
      @player.found_treasure(Treasure.new(:skillet, 100))
      @player.found_treasure(Treasure.new(:hammer, 50))
      @player.found_treasure(Treasure.new(:bottle, 5))
      @player.found_treasure(Treasure.new(:bottle, 5))
      @player.found_treasure(Treasure.new(:bottle, 5))
      @player.found_treasure(Treasure.new(:bottle, 5))
      @player.found_treasure(Treasure.new(:bottle, 5))

      yielded = []
      @player.each_found_treasure do |treasure|
        yielded << treasure
      end

      yielded.should == [
        Treasure.new(:skillet, 200),
        Treasure.new(:hammer, 50),
        Treasure.new(:bottle, 25)
      ]
    end

    it 'can be created from a CSV string' do
      csv_string = "Tester,100"
      player = Player.from_csv(csv_string)
      expect(player.name).to eq("Tester")
      expect(player.health).to eq(100)
    end

  end
end

