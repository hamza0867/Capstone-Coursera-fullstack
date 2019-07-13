# frozen_string_literal: true

class ThingImagesController < ApplicationController
  before_action :get_thing, only: %i[index update destroy]
  before_action :get_image, only: [:image_things]
  before_action :get_thing_image, only: %i[update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  def index
    @thing_images = @thing.thing_images.prioritized.with_caption
  end

  def image_things
    image = Image.find(params[:image_id])
    @thing_images = image.thing_images.prioritized.with_name
    render :index
  end

  def linkable_things
    image = Image.find(params[:image_id])
    # @things=policy_scope(Thing.not_linked(image))
    # need to exclude admins from seeing things they cannot link
    @things = Thing.not_linked(image)
    render 'things/index'
  end

  def create
    thing_image = ThingImage.new(thing_image_create_params.merge(
                                   image_id: params[:image_id],
                                   thing_id: params[:thing_id]
                                 ))
    thing = Thing.where(id: thing_image.thing_id).first
    if !thing
      full_message_error "cannot find thing[#{params[:thing_id]}]", :bad_request
    elsif !Image.where(id: thing_image.image_id).exists?
      full_message_error "cannot find image[#{params[:image_id]}]", :bad_request
    else
      thing_image.creator_id = current_user.id
      if thing_image.save
        head :no_content
      else
        render json: { errors: @thing_image.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    if @thing_image.update(thing_image_update_params)
      head :no_content
    else
      render json: { errors: @thing_image.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @thing_image.image.touch # image will be only thing left
    @thing_image.destroy
    head :no_content
  end

  private

  def get_thing
    @thing ||= Thing.find(params[:thing_id])
  end

  def get_image
    @image ||= Image.find(params[:image_id])
  end

  def get_thing_image
    @thing_image ||= ThingImage.find(params[:id])
  end

  def thing_image_create_params
    params.require(:thing_image).tap do |p|
      # _ids only required in payload when not part of URI
      p.require(:image_id) unless params[:image_id]
      p.require(:thing_id) unless params[:thing_id]
    end.permit(:priority, :image_id, :thing_id)
  end

  def thing_image_update_params
    params.require(:thing_image).permit(:priority)
  end
end
