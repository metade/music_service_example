class CollectionsController < ApplicationController
  respond_to :html, :json, :xml
  
  def index
    @user = User.find_by_username(params[:user_id])
    @collections = @user ? @user.collections : Collection.all
    respond_with(:collections => @collections)
  end
  
  def featured
    @collections = Collection.all(:conditions => ['featured_position >= 0'], :order => 'featured_position')
    respond_with({:collections => @collections})
  end
  
  def show
    @collection = Collection.find_by_url_key(params[:id])
    respond_with({ :collection => @collection })
  end
  
  def create
    @collection = Collection.new(params[:collection])
    @collection.user = User.find_by_username(params[:user_id]) if params[:user_id]
    @collection.save
    respond_with({ :collection => @collection }, :location => collection_url(@collection))
  end
  
  def update
    @collection = Collection.find_by_url_key(params[:id])
    @collection.update_attributes(params[:collection])
    @collection.save
    respond_with({ :collection => @collection })
  end
  
  def destroy
    @collection = Collection.find_by_url_key(params[:id])
    @collection.destroy
    respond_with({ :collection => @collection })
  end
end
