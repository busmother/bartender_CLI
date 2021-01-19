class Ingredient
    attr_reader :name
    attr_accessor :cart

    require_relative 'scraper.rb'
    require_relative 'CLI.rb'
    require_relative 'recipe.rb'

    @@all = []

    def initialize(name)
        @name = name
        @cart = false
        @@all << self
    end

    def self.all
        @@all
    end

    def add_to_cart
        @cart = true
    end

    def self.find_by_name(input)
        name = input.downcase
        @@all.find{|i| i.name.downcase == name}
    end

    def self.find_or_create_by_name(name)
        if self.find_by_name(name) == nil
            ingredient = Ingredient.new(name)
        else
            ingredient = self.find_by_name(name)
        end
    end

    def self.cart
        @cart
    end

end