class VideopasswordsController < ApplicationController

  def index
    @video = Video.new()
  end

  def insert

#    Show params values when debugging
#    render plain: params[:video].inspect
    @video = Video.new(video_params)

    # Encrypt the password before saving in DB
    salt = BCrypt::Engine.generate_salt
    @video.password_salt = salt

    # If no password was submitted, then leave blank
    if !@video.password_hash.blank?
      encrypted_password = BCrypt::Engine.hash_secret(@video.password_hash, salt)

      @video.password_hash = encrypted_password
    end 

    #  Attempt to save the video.  If save fails, return to index page
    if @video.save
      redirect_to "/videopasswords/confirm"
    else
      render "index"
    end

  end

  def showvideo

    # If password in post data is correct, then show video

  end

  def confirm
  end

  private
    def video_params
      params.require(:video).permit(:entry_id, :uiconf_id, :password_hash)
    end

end
