require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do

  erb(:homepage)
end


post("/result") do
  key = ENV.fetch("FOOD_KEY")
  random_recipe_url = "https://api.spoonacular.com/recipes/random?number=1&apiKey=#{key}"

  raw_response = HTTP.get(random_recipe_url).to_s
  parsed_response = JSON.parse(raw_response)
  recipe = parsed_response.fetch("recipes")
  data = recipe[0]

  #data
  @title = data.fetch("title")
  @prep_time = data.fetch("readyInMinutes").to_s
  @servings = data.fetch("servings").to_s
  @image = data.fetch("image")
  @summary = data.fetch("summary")
  @instructions = data.fetch("instructions")

  #instructions
  deep_instructions = data.fetch("analyzedInstructions")[0]
  @steps = deep_instructions.fetch("steps")

  #ingredients
  @ingredients = data.fetch("extendedIngredients")

  erb(:result)
end
