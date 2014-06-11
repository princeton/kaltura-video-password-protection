class VideopasswordsController < ApplicationController

  def index
  end

  def insert
#    render plain: params[:video].inspect
    @video = Video.new(video_params)

    # Encrypt the password before saving in DB
    salt = BCrypt::Engine.generate_salt
    encrypted_password = BCrypt::Engine.hash_secret(@video.password_hash, salt)

    @video.password_hash = encrypted_password

    @video.password_salt = salt

    @video.save

    redirect_to "/videopasswords/confirm"
  end

  def showvideo

    # If password in post data is correct, then show video


    # Else, presnet form

  end

  def confirm
  end

  private
    def video_params
      params.require(:video).permit(:entry_id, :uiconf_id, :password_hash)
    end

end
