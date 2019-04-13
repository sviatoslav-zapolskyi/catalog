require 'csv'
require 'scraper'

class BulkInsertListsController < ApplicationController
  before_action :set_bulk_insert_list, only: [:show, :edit, :update, :destroy]

  def initialize
    super # this calls ActionController::Base initialize
    @scrap = Scraper.new
  end

  # GET /bulk_insert_lists
  # GET /bulk_insert_lists.json
  def index
    @bulk_insert_lists = BulkInsertList.all
    new
  end

  # GET /bulk_insert_lists/1
  # GET /bulk_insert_lists/1.json
  def show
    @bulk_inserted_books = @bulk_insert_list.EAN13.split('; ').map do |ean13|
      Book.find_by EAN13: ean13
    end
  end

  # GET /bulk_insert_lists/new
  def new
    @bulk_insert_list = BulkInsertList.new
  end

  # GET /bulk_insert_lists/1/edit
  def edit
  end

  # POST /bulk_insert_lists
  # POST /bulk_insert_lists.json
  def create
    index
    @bulk_insert_list = BulkInsertList.new(bulk_insert_list_params)

    respond_to do |format|
      if @bulk_insert_list.save

        @bulk_insert_list.EAN13.split('; ').each do |ean13|
          @scrap.from_fantlab ean13 unless Book.find_by EAN13: ean13
        end

        format.html { redirect_to @bulk_insert_list, notice: 'Bulk insert list was successfully created.' }
        format.json { render :show, status: :created, location: @bulk_insert_list }
      else
        format.html { render :index }
        format.json { render json: @bulk_insert_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_insert_lists/1
  # PATCH/PUT /bulk_insert_lists/1.json
  def update
    respond_to do |format|
      if @bulk_insert_list.update(bulk_insert_list_params)
        format.html { redirect_to @bulk_insert_list, notice: 'Bulk insert list was successfully updated.' }
        format.json { render :show, status: :ok, location: @bulk_insert_list }
      else
        format.html { render :edit }
        format.json { render json: @bulk_insert_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_insert_lists/1
  # DELETE /bulk_insert_lists/1.json
  def destroy
    @bulk_insert_list.destroy
    respond_to do |format|
      format.html { redirect_to bulk_insert_lists_url, notice: 'Bulk insert list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_insert_list
      @bulk_insert_list = BulkInsertList.find_by hash_id: params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_insert_list_params
      params.require(:bulk_insert_list).permit(:hash_id, :EAN13)
    end
end
