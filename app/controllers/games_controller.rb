require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    vowels = ["a", "e", "i", "o", "u", "y"]
    letters_without_vowel = ("a".."z").to_a - vowels
    @letters = (letters_without_vowel.sample(5) + vowels.sample(5)).shuffle
    @new_time = Time.now
  end

  def score
    url = "https://dictionary.lewagon.com/#{params[:word]}"
    word_serialized = URI.parse(url).read
    word_api_check = JSON.parse(word_serialized)
    word = params[:word].dup
    time_score = Time.now - Time.new(params[:new_time])
    params[:letters].chars.each { |letter| word.sub!(letter, '') }
    if word.length.positive?
      @answer = "Sorry but #{params[:word]} can't be built out of #{params[:letters]}"
    elsif word_api_check["found"] == false
      @answer = "Sorry but #{params[:word]} does not seem to be an english word."
    else
      @answer = "Congrations #{params[:word]} is a valid english word! Your score is #{params[:word].length * 10 - time_score}"
    end
  end
end
