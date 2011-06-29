class ClipsController < ApplicationController
  respond_to :html, :json, :xml
  
  def index
    @collection = Collection.find_by_url_key!(params[:collection_id])
    @clips = @collection.clips
    respond_with(:clips => @collection.clips)
  end
end
