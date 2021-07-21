class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_playing_games
      redirect_to login_url
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
  end

  def create_playing_games
    return unless params[:games]

    params[:games].each do |key, _value|
      game = Game.find(key)
      playing_game = @user.playing_games.build(game: game)
      playing_game.save!
    end
  end
end
