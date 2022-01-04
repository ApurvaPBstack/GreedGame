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
  