require 'pry'
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
    #binding.pry
    
  end
  return [score , non_scoring_count]
end   
# p calculate_score([1,1,1,1,5])

class DiceSet
  attr_accessor :values
  def roll(number_of_rolls)
    @values=[]
    i=0
    while i < number_of_rolls
      @values << rand(1..6)
      i += 1
    end
    @values
    
  end
end


def turn(scores, player,eligibility)
  puts "Player #{player+1} turn -----"
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
      
      #binding.pry
    else 
      puts "Not re-rolling"
      break
    end
  end
  puts "Score of player#{player+1} in this round : #{score}"
  #scores[player]+= score
  if eligibility[player] == false
    if score >= 300
      eligibility[player] = true
    end 
  end

  if eligibility[player] == true
    scores[player]+= score
  end
    
    #scores[player] += score
  #elsif  score >= 300
    #eligibility[player] = true
    #scores[player]+= score
  #end
  scores
end

# turn()

puts "enter the number of players"
n = gets.chomp.to_i

scores = []
eligibility =[]
(0...n).each do |i|
  scores.push(0)
  eligibility.push(false)
end


# scores=[0,0]
# binding.pry
# current_player = 0

round = 1

def did_anyone_win(scores)
  #binding.pry
  scores.each do |score|
    if score >= 3000
      return true
      #final_score = final_round(scores)
    end
    #final_score
  end
  return false
end


while !did_anyone_win(scores)
  #binding.pry
  puts "Round #{round}"
  (0...n).each do |player|
    scores = turn(scores, player,eligibility)
  end
  puts "Total Scores: #{scores}"
  
  round += 1
  puts ""
end


player_who_reach3000= []
scores.each_index do |index|
  if scores[index] >= 3000
    player_who_reach3000.push(index)
  end
end



puts "--------entering the final round--------"
  
(0...n).each do |player|
  if !player_who_reach3000.include?player
    scores = turn(scores, player,eligibility)
  end
end
puts "Final Scores: #{scores}"

playerid_havingMax_score= []
def max_score(scores)
  max_number = scores[0]
  scores.each_index do |index|
    if scores[index] > max_number
      max_number = scores[index]
    end
  end
  max_number
end

scores.each_index do |index|
  if scores[index] == max_score(scores)
    playerid_havingMax_score.push(index)
  end
end

#puts playerid_havingMax_score
playerid_havingMax_score.each do |player|
  puts " the player who won is #{player+1}"
end

  



