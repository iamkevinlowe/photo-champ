class ChallengesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:id])
  end

  def update
    @challenge = Challenge.find(params[:id])
    if @challenge.update_attributes(challenge_params)
      redirect_to @challenge
    else
      flash[:error] = "There was an error updating the challenge."
      redirect_to @challenge
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:length, :votes_challenger, :votes_challenged, :complete)
  end
end