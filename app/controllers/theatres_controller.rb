class TheatresController < ApplicationController

  before_filter :require_admin

  # GET /theatres
  # GET /theatres.json
  def index
    @theatres = Theatre.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @theatres }
    end
  end

  # GET /theatres/1
  # GET /theatres/1.json
  def show
    @theatre = Theatre.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @theatre }
    end
  end

  # GET /theatres/new
  # GET /theatres/new.json
  def new
    @theatre = Theatre.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @theatre }
    end
  end

  # GET /theatres/1/edit
  def edit
    @theatre = Theatre.find(params[:id])
  end

  # POST /theatres
  # POST /theatres.json
  def create
    @theatre = Theatre.new(params[:theatre])

    respond_to do |format|
      if @theatre.save
        format.html { redirect_to @theatre, notice: 'Theatre was successfully created.' }
        format.json { render json: @theatre, status: :created, location: @theatre }
      else
        format.html { render action: "new" }
        format.json { render json: @theatre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /theatres/1
  # PUT /theatres/1.json
  def update
    @theatre = Theatre.find(params[:id])

    respond_to do |format|
      if @theatre.update_attributes(params[:theatre])
        format.html { redirect_to @theatre, notice: 'Theatre was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @theatre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /theatres/1
  # DELETE /theatres/1.json
  def destroy
    @theatre = Theatre.find(params[:id])
    @theatre.destroy

    respond_to do |format|
      format.html { redirect_to theatres_url }
      format.json { head :no_content }
    end
  end
end
