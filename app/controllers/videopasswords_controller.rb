class VideopasswordsController < ApplicationController

  # Force CAS authentication for all pages except the showvideo page
  before_filter CASClient::Frameworks::Rails::Filter, :except => :showvideo

  #  Form for creating a new video entry
  def index
    @video = Video.new()
  end

  #  Insert new video information into the database
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
      # Pass the hostname and port so that the confirmation page can build the URL to the video
      @host_and_port = request.host_with_port

      render "confirm"
    else
      render "index"
    end

  end

  #  Show a video if, and only if, the appropriate password is submitted
  def showvideo

    @entry_id = params[:entry_id]
    @submitted_password = params[:password]

    # Retrieve all videos that match the given entry_id
    @videos = Video.where(:entry_id => @entry_id)

    # If we received results then step through them and compare the submitted password with the saved password
    if ! @videos.empty?

      @videos.each do |v|

        @video = v

        if ! @submitted_password.blank?

            @submitted_password_hash = BCrypt::Engine.hash_secret(@submitted_password, @video.password_salt)


            if @submitted_password_hash == @video.password_hash

              # Load the Kaltura client library
              require_dependency "kaltura_client.rb"

              # Define Kaltura integration settings that are stored in environment variable on the host system
              @kaltura_partner_id = ENV['KALTURA_PARTNER_ID']
              kaltura_admin_secret = ENV['KALTURA_ADMIN_SECRET']
              kaltura_user = ENV['KALTURA_USER']
              user_secret = ""
              service_url = 'http://www.kaltura.com/'

              # Obtain a Kaltura Session token
              config = Kaltura::KalturaConfiguration.new(@partner_id, service_url)

              client = Kaltura::KalturaClient.new( config )

              @session = client.session_service.start( kaltura_admin_secret, kaltura_user, Kaltura::KalturaSessionType::ADMIN, @kaltura_partner_id, 36000)

              break # break out of the each loop

            end # end of password match check 

        end # end of password.blank check

      end # end of each loop

    end # end of  ideos.empty check

  end

  #  Show confirmation page after successfully saving a new video entry
  def confirm
  end


  private
    def video_params
      params.require(:video).permit(:entry_id, :uiconf_id, :password_hash)
    end

end
