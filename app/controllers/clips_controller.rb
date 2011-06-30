class ClipsController < ApplicationController
  respond_to :html, :json, :xml
  
  def index
    @collection = Collection.find_by_url_key!(params[:collection_id])
    @clips = @collection.clips
    respond_with(:clips => @collection.clips)
  end
  
  def create
    @clip = Clip.new(params[:clip])
    @clip.collection = Collection.find_by_url_key!(params[:collection_id]) if params[:collection_id]
    @clip.save
    respond_with({ :clip => @clip }, :location => collection_clip_url(@clip.collection, @clip))
  end
  
  def update
    @collection = Collection.find_by_url_key!(params[:collection_id])
    @clip = Clip.find_by_collection_id_and_pid!(@collection.id, params[:id])
    @clip.update_attributes(params[:clip])
    @clip.save
    respond_with({ :clip => @clip })
  end
  
  def destroy
    @clip = Clip.find_by_pid(params[:id])
    @clip.destroy
    respond_with({ :clip => @clip })
  end
  
end
