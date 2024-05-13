class InquiresController < ApplicationController
  before_action :set_inquire, only: [:show, :edit, :update, :destroy]
  def index
    @profile = Profile.find(params[:profile_id])
    @inquires = @profile.inquires.page(params[:page]).per(3)

  end

  def new
    @profile = Profile.find(params[:profile_id])
    @inquire = Inquire.new
  end

  def create
    @profile = Profile.find(params[:profile_id])
    @inquire = @profile.inquires.new(inquire_params)
    @inquire.user = current_user

    if @inquire.save
      similarity = fetch_similarity(@profile.images, @inquire.images)
      if @inquire.update(similarity: similarity)
        redirect_to [:admin, @profile], notice: 'Your inquiry has been sent successfully and similarity updated.'
      else
        flash.now[:alert] = 'Failed to update similarity: ' + @inquire.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @inquire.update(inquire_params)
      redirect_to profile_inquire_path(@inquire.profile, @inquire), notice: 'Inquiry was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inquire.destroy
    redirect_to profile_inquires_path(@inquire.profile), notice: 'Inquiry was successfully deleted.'
  end

  private

  require 'net/http/post/multipart'

  def fetch_similarity(profile_images, inquiry_images)
    uri = URI('http://127.0.0.1:5000/batch_images_similarity')
    request = Net::HTTP::Post::Multipart.new uri.path,
                                             "imageList1" => convert_to_uploads(profile_images),
                                             "imageList2" => convert_to_uploads(inquiry_images)

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    result = JSON.parse(response.body)
    logger.info result['similarity']
    result['similarity']
  rescue => e
    logger.error "Failed to call MPAIFR API: #{e.message}"
    0.0
  end

  def convert_to_uploads(attachments)
    attachments.map do |attachment|
      file_path = ActiveStorage::Blob.service.path_for(attachment.key)
      logger.info "Accessing file at: #{file_path}"
      if File.exist?(file_path)
        UploadIO.new(file_path, "image/jpeg", File.basename(file_path))
      else
        logger.error "File does not exist at path: #{file_path}"
      end
    end
  end

  def set_inquire
    @inquire = Inquire.find(params[:id])
  end

  def inquire_params
    params.require(:inquire).permit(:date_taken, :city_taken, :country_taken, :status, :similarity, images: [])
  end
end
