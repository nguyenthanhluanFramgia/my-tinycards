class DecksController < ApplicationController
  def show
    @deck = Deck.find_by id: params[:id]
  end

  def new
  end
end