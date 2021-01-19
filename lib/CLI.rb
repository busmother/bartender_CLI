require 'pry'
class Bartender::CLI
    require_relative 'recipe.rb'
    require_relative 'scraper.rb'
    require_relative 'ingredient.rb'

    def call
        greeting
        find_recipes
        menu
        goodbye
    end

    def greeting
        puts ">> Hi there! I'm going to ask which ingredients you have in your own barcart so we can see what drinks you can make.".colorize(:yellow)
        puts ">> I'm checking out all of the possible recipes and ingredients, so just give me a sec.".colorize(:yellow)
    end

    def find_recipes
        recipe_scraper = Scraper.new("https://makemeacocktail.com/recipes/IBA+Official+Drink-cocktails/")
        recipe_hash = recipe_scraper.create_recipes_hash
        Scraper.create_recipes(recipe_hash)
    end

    def random_question
        question_array = [" What about", " Any", " Do you have", "", " How about"]
        question_array[(rand()*4).floor]
    end

    def menu
        check_ingredient
        list_ingredients_in_cart
        Recipe.match_recipes
        share_recipes_greeting
        share_recipes
        #different_recipe
    end

    def all_ingredients_sorted
        all_ingredients = Ingredient.all
        all_ingredients = all_ingredients.sort_by {|ingredient| ingredient.name}
    end

    def invalid_input
        puts ">> Sorry, my responses are limited. You must enter an input that matches one of your options.".colorize(:red)
    end

    def check_ingredient
        all_ingredients_sorted.each do |ingredient|
            puts ">>#{random_question} #{ingredient.name}? enter 'y' if yes or 'n' if no."
            while true
                input = nil
                input = gets.strip.downcase
                if input == "y" || input == "n"
                    if input == "y"
                        ingredient.add_to_cart
                        puts ">> adding #{ingredient.name} to the virtual barcart".colorize(:green)
                    elsif input == "n"
                        puts ">> No #{ingredient.name}, no worries."
                    end
                    break
                else
                    invalid_input
                end
            end
        end
    end

    def ingredients_in_cart
        cart = []
        Ingredient.all.each do|ingredient| 
            if ingredient.cart == true
                cart << ingredient
            end
        end
        cart
    end

    def list_ingredients_in_cart
        puts ">> Here's what's in your cart:"
        ingredients_in_cart.each_with_index {|ingredient, i| puts ">>#{i+1}. #{ingredient.name}".colorize(:green)}
    end

    def share_recipes_greeting
        if recipe_counter == 20
            puts ">> You have all the ingredients, so here's all the recipes:".colorize(:green)
        elsif recipe_counter.between?(15, 19)
            puts ">> You have a well-stocked bar cart, you can make anything on this list:".colorize(:green)
        elsif recipe_counter.between?(10, 14)
            puts ">> Looks like like there are some good drinks you can try:".colorize(:green)
        elsif recipe_counter.between?(2, 9)
            puts ">> There's a couple of drinks you can make with the ingredients in your cart:".colorize(:yellow)
        elsif recipe_counter == 1
            puts ">> With the ingredients in your cart, you can make this drink:".colorize(:yellow)
        else
            puts ">> Sorry, not much to make with that. Go shopping for some more ingredients!".colorize(:red)
        end
    end

    def share_recipes
        if recipe_counter > 1
            print_recipes
            choose_recipe
            different_recipe
        elsif recipe_counter == 1
            stocked_recipes = Recipe.stocked_recipes
            recipe = stocked_recipes[0]
            puts "#{recipe.instructions}"
        end
    end

    def recipe_counter
        stocked_recipes = Recipe.stocked_recipes
        stocked_recipes.length
    end

    def print_recipes
        Recipe.stocked_recipes.each_with_index do |recipe, i|
            puts ">> >> #{i +1}. #{recipe.name}".colorize(:black).on_green
        end
    end

    def choose_recipe
        puts ">> Which number drink would you like to try?" 
        stocked_recipes = Recipe.stocked_recipes
        while true
            input = nil
            input = gets.chomp.to_i
            upper_limit = stocked_recipes.length 
            if input.between?(1,upper_limit)
                recipe = stocked_recipes[input-1]
                puts "#{recipe.instructions}"
                break
            else
                invalid_input
            end
        end
    end

    def different_recipe
        puts ">> Do you want to check out a different recipe? Enter 'y' for yes and 'n' for no"
        while true
            input = nil
            input = gets.strip.downcase 
            if input == "y" || input == "n"
                if input == "y"
                    share_recipes
                elsif input == "n"
                    goodbye
                end
                break
            else
                invalid_input
            end
        end
    end

    def goodbye
        puts ">> See you later!"
        exit
    end

end