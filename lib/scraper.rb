class Scraper
  require_relative 'recipe.rb'
  require_relative 'ingredient.rb'
  require_relative 'CLI.rb'

  attr_accessor :site

  def initialize(site)
    @site = site
  end

  def site
    @site
  end

  def create_recipes_hash
    page = Nokogiri::HTML(open(@site))
    results = page.css(".item_info").css("a") #this targets links
    recipe_keys_array = []
    recipe_values_array = []
    results.each {|recipe| recipe_keys_array << recipe.text}
    results.each {|recipe| recipe_values_array << recipe["href"]}
    recipe_hash = Hash[recipe_keys_array.zip(recipe_values_array)]
    recipe_hash
  end

  def self.create_recipes(hash) #should accept a hash #move to Recipe class?
    hash.each do |name, link|
       Recipe.new(name,link)
    end
  end

  def self.create_link(hash=create_recipes_hash,key) #works! 
    link = "https://makemeacocktail.com/#{hash.fetch(key)}"
    link
  end 

  def self.create_ingredients_array(href) #working
    ingredients_array = []
    site = "https://makemeacocktail.com/"+href
    page = Nokogiri::HTML(open(site))
    results = page.css(".ingredient_list").css("li")
    results.each {|result| ingredients_array << result.css("span")[-1].text}
    ingredients_array[0,ingredients_array.count / 3]
  end

end