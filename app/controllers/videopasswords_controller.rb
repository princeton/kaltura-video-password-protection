class VideopasswordsController < ApplicationController

  before_filter CASClient::Frameworks::Rails::Filter, :except => :showvideo

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

    @entry_id = params[:entry_id]

    @video = Video.find_by_entry_id(@entry_id)

    @submitted_password = params[:password]

    if ! @submitted_password.blank?

        @submitted_password_hash = BCrypt::Engine.hash_secret(@submitted_password, @video.password_salt)

        if @submitted_password_hash == @video.password_hash

          # Load the Kaltura client library
          require_dependency "kaltura_client.rb"

          # Define Kaltura integration settings
          @partner_id = ENV['KALTURA_PARTNER_ID']
          admin_secret = ENV['KALTURA_ADMIN_SECRET']
          user_secret = ""
          service_url = 'http://www.kaltura.com/'

          # Obtain a Kaltura Session token
          config = Kaltura::KalturaConfiguration.new(@partner_id, service_url)

          client = Kaltura::KalturaClient.new( config )

          @session = client.session_service.start( admin_secret, 'bcstaff@princeton.edu', Kaltura::KalturaSessionType::ADMIN, @partner_id, 36000)

        end  
    end

  end

  def confirm
  end

  private
    def video_params
      params.require(:video).permit(:entry_id, :uiconf_id, :password_hash)
    end

end
