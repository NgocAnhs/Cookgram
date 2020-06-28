module Recommendation
  def recommend_recipes # recommend recipes to user
    # find all other users, equivalent to .where('id != ?', self.id)
    other_users = self.class.all.where.not(id: self.id)

    # instantiate a new hash, set default value for any keys to 0
    recommended = Hash.new(0)

    my_recipes = self.viewed_recipes.select(:recipe_id)
    # for each user of all other users
    other_users.each do |other_user|
      
      # find the recipes this user and another user both viewed
      common_recipes = other_user.viewed_recipes.select(:recipe_id).where(recipe_id: my_recipes)

      different_of_other_user_recipes = other_user.viewed_recipes.select(:recipe_id).where.not(recipe_id: my_recipes)

      # calculate the weight (recommendation rating) 
      # jaccard index: intersection/union
      weight = common_recipes.size.to_f / (self.viewed_recipes.size + other_user.viewed_recipes.size - common_recipes.size)

      # add the extra recipes the other user viewed
      different_of_other_user_recipes.each do |recipe|
        # put the recipe along with the cumulative weight into hash
        recommended[recipe] += weight
      end
    end
    # sort by weight in descending order
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
  end
end