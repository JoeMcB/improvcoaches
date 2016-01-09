class TimeBlocksController < ApplicationController

  # GET /time_blocks
  # GET /time_blocks.json
  def index
    @time_blocks = TimeBlock.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @time_blocks }
    end
  end


  def search

  end

  def results
    @time_blocks = TimeBlock.where(
      day_of_week: params[:day_of_week]
      )

    respond_to do |format|
      format.html
      format.json { render json: @time_block }
    end
  end

  # GET /time_blocks/1
  # GET /time_blocks/1.json
  def show
    @time_block = TimeBlock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_block }
    end
  end

  # GET /time_blocks/new
  # GET /time_blocks/new.json
  def new
    @time_block = TimeBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_block }
    end
  end

  def edit

    TimeBlock.delete_by_user_id(current_user.id)
    new_blocks = []
    params['time_blocks'].each do |block|
      block = TimeBlock.new
      block.day = block['day'].to_i
      block.day = block['hour'].to_i
      block.day = block['minute'].to_i

      block.save
      new_blocks << block
    end

    #Get rid of of
    TimeBlock.destroy_all( 'id NOT IN (?)', new_blocks.collect(&:id))
    respond_to do |format|
      format.html { redirect_to :profile_edit_schedule, notice: 'Your schedule has been updated.' }
      format.json { head :no_content }
    end
  end

  # POST /time_blocks
  # POST /time_blocks.json
  def create
    @time_block = TimeBlock.new(params[:time_block])
    @time_block.user = current_user

    respond_to do |format|
      if @time_block.save
        format.html { redirect_to @time_block, notice: 'Time block was successfully created.' }
        format.json { render json: @time_block, status: :created, location: @time_block }
      else
        format.html { render action: "new" }
        format.json { render json: @time_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /time_blocks/1
  # PUT /time_blocks/1.json
  def update

    @time_block = TimeBlock.find(params[:id])

    respond_to do |format|
      if @time_block.update_attributes(params[:time_block])
        format.html { redirect_to @time_block, notice: 'Time block was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_blocks/1
  # DELETE /time_blocks/1.json
  def destroy
    @time_block = TimeBlock.find(params[:id])
    @time_block.destroy

    respond_to do |format|
      format.html { redirect_to time_blocks_url }
      format.json { head :no_content }
    end
  end
end
