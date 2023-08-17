class Public::HomesController < ApplicationController
  def top
    @playgrounds = Playground.all
  end

  def about
  end
end
