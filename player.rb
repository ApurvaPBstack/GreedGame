class Player
    attr_accessor :id, :score, :in_the_game

    def initialize(id)
        @id = id
        @score = 0
        @in_the_game =false

    end

    def print_player
        "Player " + @id.to_s + " with current score " + @score.to_s
    end

end
