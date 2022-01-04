require 'pry'
require './player'
require './diceset'

class Game
  attr_accessor :players

  def initialize(no_of_players)
    @players =[]
    no_of_players.times do |i|
      @players << Player.new(i)
    end

  end

  def calculate_score(dice)
    triple_scores = [1000, 200, 300, 400, 500, 600]
    single_scores = [100, 0, 0, 0, 50, 0]
    score=0
    non_scoring_count = dice.length
    (1..6).each do |number|
      count = dice.count(number)
      score += triple_scores[number - 1] * (count / 3)
      if (count / 3) >= 1
        non_scoring_count -= 3
      end
      score += single_scores[number - 1] * (count % 3)
      if number == 1 || number == 5 && count % 3 != 0
        non_scoring_count -= count % 3
      end

    end
    return [score , non_scoring_count]
  end 

  def turn(player)
    puts "Player #{player.id+1} turn -----"
    dice = DiceSet.new()
    dice.roll(5)
    roll = dice.values

    puts "The roll is: #{roll.inspect}"

    temp = calculate_score(roll)
    score = temp[0]
    current_score = temp[0]
    puts "score #{score}"
    non_scoring_count = temp[1]

    while non_scoring_count != 0 && current_score !=0
      puts "Do you want to re-roll? the non scoring dice #{non_scoring_count} (y/n)?"
      choice = gets.chomp
      if choice == "y"

        roll = DiceSet.new()
        dice = roll.roll(non_scoring_count)
        temp = calculate_score(dice)
        non_scoring_count = temp[1]
        score += temp[0]
        current_score = temp[0]
        p "dice of re-roll #{dice}"
        p "score after re-roll #{score}"

      else 
        puts "Not re-rolling"
        break
      end
    end
    puts "Score of player#{player.id+1} in this round : #{score}"

    if player.in_the_game == false
      if score >= 300
        player.in_the_game = true
      end 
    end

    if player.in_the_game == true
      player.score += score
    end
  end

  def did_anyone_win(players)

    players.each do |player|
      if player.score >= 3000
        return true

      end

    end
    return false
  end

  def start()

    round = 1

    while !did_anyone_win(players)

      puts "Round #{round}"
      players.each do |player|
        turn(player)
      end
      puts "Total Scores:"
      players.each do |player|
        puts player.score
      end

      round += 1
      puts ""
    end

    player_who_reach3000= []
    players.each do |player|
      if player.score >= 3000
        player_who_reach3000.push(player.id)
      end
    end

    puts "--------entering the final round--------"

    players.each do |player|
      if !player_who_reach3000.include?player.id
        turn(player)
      end
    end
    puts "Final Scores:"
    players.each do |player|
      puts player.score
    end

    playerid_havingMax_score= []
    def max_score(players)
      max_number = players[0].score
      players.each do |player|
        if player.score > max_number
          max_number = player.score
        end
      end
      max_number
    end

    players.each do |player|
      if player.score == max_score(players)
        playerid_havingMax_score.push(player.id)
      end
    end


    playerid_havingMax_score.each do |player|
      puts " the player who won is #{player+1}"
    end

  end



end

puts "enter the number of players"
no_of_players = gets.chomp.to_i
Game.new(no_of_players).start()


