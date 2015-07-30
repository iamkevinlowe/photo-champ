class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.active_challenges.includes(:challenger, :challenged).paginate(page: params[:page], per_page: 12)
  end

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
    if @challenge.save
      ChallengeMailer.new_challenge(@challenge).deliver_later
      flash[:notice] = "A challenge invitation email has been sent to the user!"
      redirect_to @challenge
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to :back
    end
  end

  def vote
    @challenge = Challenge.find(params[:id])
    someone = challenge_params[:vote]
    authorize @challenge
    if @challenge.vote_for(someone)
      flash[:notice] = "Thanks for your vote!"
      redirect_to @challenge.challenger if someone == 'challenger'
      redirect_to @challenge.challenged if someone == 'challenged'
    else
      flash[:error] = "The vote didn't go through."
      redirect_to :back
    end
  end

  def accept
    # user = User.where(email: params[:sender]).first
    # in policy check that the user is the owner of the challenged photo

    @challenge = Challenge.find(params[:id])
    if @challenge.start!
      flash[:notice] = "The challenge has begun!"
      redirect_to @challenge
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to :root
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:challenger_id, :challenged_id, :length, :vote)
  end
end