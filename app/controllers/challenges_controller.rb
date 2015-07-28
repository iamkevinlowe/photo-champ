class ChallengesController < ApplicationController

  def show
    Challenge.send_results
    @challenge = Challenge.find(params[:id])
  end

  def new
    @challenge = Challenge.new
    @challenged_photo = Photo.find(params[:photo_id])
    @challenger_photos = Photo.new_challenge_photos(current_user, @challenged_photo)
    @challenge_length_options = [["6 hours", 6],["12 hours", 12],["18 hours", 18],["24 hours", 24]]
  end

  def create
    @challenge = Challenge.new(challenge_params)
    authorize @challenge
    # I want to refactor this so and email gets sent and the challenged user must accept the invitation
    if @challenge.save
      flash[:notice] = "A new challenge has been created successfully!"
      redirect_to @challenge
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to :new
    end
  end

  def update

  end

  def vote
    @challenge = Challenge.find(params[:id])
    challenger = challenge_params[:votes_challenger]
    challenged = challenge_params[:votes_challenged]
    @challenge.votes_challenger += 1 if challenger
    @challenge.votes_challenged += 1 if challenged
    authorize @challenge
    if @challenge.save
      flash[:notice] = "Thanks for your vote!"
      redirect_to @challenge.challenger if challenger
      redirect_to @challenge.challenged if challenged
    else
      flash[:error] = "The vote didn't go through."
      redirect_to :back
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:challenger_id, :challenged_id, :length, :votes_challenger, :votes_challenged)
  end
end