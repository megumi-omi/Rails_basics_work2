class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show update destroy ]

  def index
    @pictures = Picture.all
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def new
    @picture = Picture.new
  end

  def edit
    @picture = Picture.find(params[:id])
    if @picture.user_id == current_user.id
      render :edit
    else
      flash.now[:danger] = '編集権限がありません'
      render :show
    end
  end

  def create
    @picture = current_user.pictures.build(picture_params)
    if params[:back]
      render :new
      else
        if @picture.save
          PictureMailer.picture_mail(@picture).deliver
          redirect_to pictures_path, notice: '写真を投稿しました'
        else
          render :new
        end
      end
  end

  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to picture_url(@picture), notice: "Picture was successfully updated." }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @picture.user_id == current_user.id
        @picture.destroy
        redirect_to pictures_path, notice: '削除しました'
    else
      flash.now[:danger] = '削除権限がありません'
      render :show
    end
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.require(:picture).permit(:image, :image_cache, :content)
  end
end