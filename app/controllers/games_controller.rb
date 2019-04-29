require "byebug"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }.take(10).shuffle!
  end


  def score
    session[:score] = 0 if session[:score].nil?
    @letters = params[:letters].split
    @word = params[:word].upcase
    @included = @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
    json = JSON.parse(response.read)
    @english_word = json['found']
    if @english_word && @included
      session[:score] += @word.length
    end
  end
end

# # in the view - we want to display the letters, take the word input from the user and post the score back to the viewer
