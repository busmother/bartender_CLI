class Recipe
    attr_reader :name, :link, :ingredients
    attr_accessor :instructions, :stocked, :site

    require_relative 'scraper.rb'
    require_relative 'ingredient.rb'
    require_relative 'CLI.rb'

    @@all = []

    def initialize(name, link)
        @name = name
        @link = link
        @ingredients = []
        @stocked = false
        @@all << self
        @instructions = "This is how you make a #{@name}: https://makemeacocktail.com/#{@link}"
        @site = "https://makemeacocktail.com/"+@link
        create_ingredients(@link)
    end

    def self.all
        @@all
    end
    
    def create_ingredients #used to be class method, now instance method
        ingredient_array = Scraper.create_ingredients_array(@link)
        ingredient_array.each do |ingredient_name|
            new_ingredient = Ingredient.find_or_create_by_name(ingredient_name)
            @ingredients << new_ingredient
        end
    end

    def create_ingredients(site)
        #site = "https://makemeacocktail.com/"+@link
        array = Scraper.create_ingredients_array(site)
        array.each do |ingredient_name|
            new_ingredient = Ingredient.find_or_create_by_name(ingredient_name)
            @ingredients << new_ingredient #test whether this line is needed
        end
    end

    def self.ingredients
        @ingredients
    end

    def self.recipe_ingredients= #test this
        ingredient_array = Scraper.create_ingredients_array(@link)
        create_ingredients(ingredient_array)
    end

    def self.stocked_recipes #pulls stocked
        stocked_recipes = []
        all_recipes = Recipe.all
        all_recipes.each do |recipe|
            if recipe.stocked == true
                stocked_recipes << recipe
            end
        end
        stocked_recipes
    end

    def self.match_recipes
        all_recipes = Recipe.all
        all_recipes.map do |recipe| 
            ingredients = recipe.ingredients
            if ingredients.all? {|ingredient_obj| ingredient_obj.cart == true}
                recipe.stocked = true 
            end
        end
    end

    def self.instructions #test which is printing
        ">> Here's how to make a #{@name}:"
        #should be @instructions
        #this means more scraping
    end

end