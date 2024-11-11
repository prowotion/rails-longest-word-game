require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def generate_grid(grid_size)
    grid = []
    grid_size.times do
      grid << ("A".."Z").to_a.sample
    end
    grid
  end

  def mot_dans_grid?(mot, grid)
    mot.upcase.chars.all? do |lettre|
      mot.upcase.count(lettre) <= grid.count(lettre)
    end
  end

  def mot_valide?(mot)

    url = "https://dictionary.lewagon.com/#{mot}"
    word_serialized = URI.parse(url).read
    word = JSON.parse(word_serialized)

    if word["found"]
      return true
    else
      return false
    end
  end

  def new
    @letters = generate_grid(10)
  end

  def score
    if mot_valide?(params[:word]) && mot_dans_grid?(params[:word], params[:grid])
      @score = "Congratulations! #{params[:word]} is a valide English word!"
    elsif !mot_valide?(params[:word])
      @score = "Sorry but #{params[:word]} does not seem to be a valid English word..."
    elsif !mot_dans_grid?(params[:word], params[:grid])
      @score = "Sorry but #{params[:word]} can't be built ouf of #{params[:grid]}"
    end
    @score
  end
end
