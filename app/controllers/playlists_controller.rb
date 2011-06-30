class PlaylistsController < ApplicationController
  respond_to :html, :json, :xml
  
  def index
    @user = User.find_by_username(params[:user_id])
    @playlists = @user ? @user.playlists : Playlist.all
    respond_with(:playlists => @playlists)
  end
  
  def draft
    @playlists = Playlist.all(:conditions => ['status =?', 0])
    respond_with({:playlists => @playlists, :count => @playlists.size})
  end
  
  def published
    @playlists = Playlist.all(:conditions => ['status =?', 1])
    respond_with({:playlists => @playlists, :count => @playlists.size})
  end
  
  def show
    @playlist = Playlist.find_by_url_key!(params[:id])
    respond_with({ :playlist => @playlist })
  end
  
  def create
    @playlist = Playlist.new(params[:playlist])
    @playlist.user = User.find_by_username!(params[:user_id]) if params[:user_id]
    @playlist.save
    respond_with({ :playlist => @playlist }, :location => playlist_url(@playlist))
  end
  
  def update
    @playlist = Playlist.find_by_url_key(params[:id])
    if params[:playlist][:user]
      params[:playlist][:user] = User.find_by_username!(params[:playlist][:user][:username])
    end
    @playlist.update_attributes(params[:playlist])
    @playlist.save
    respond_with({ :playlist => @playlist }, :include => :user)
  end
  
  def destroy
    @playlist = Playlist.find_by_url_key!(params[:id])
    @playlist.destroy
    respond_with({ :playlist => @playlist })
  end
end
