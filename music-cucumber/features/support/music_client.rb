require 'ostruct'
require 'rest-client'
require 'pp'

module Music
  def self.destroy_all_users
    users = Music::User.all.inject({}){ |h,u| h[u.username] ||= u; h }.values
    users.each do |user|
      user.collections.each do |collection|
      #   collection.clips.each do |clip|
      #     RestClient.delete "#{Music::HOST}/collections/#{collection.to_param}/clips/#{clip.pid}", :content_type => :json, :accept => :json
      #   end
        collection.destroy
      end
      # user.playlists.each do |playlist|
      #   playlist.playlists_tracks.each do |track|
      #     RestClient.delete "#{Music::HOST}/playlists/#{playlist.to_param}/tracks/#{track['id']}", :content_type => :json, :accept => :json
      #   end
      #   playlist.destroy
      # end
      user.destroy
    end
  end
  
  class Base < OpenStruct
    def self.all
      response = RestClient.get "#{Music::HOST}/#{collection_name}", :content_type => :json, :accept => :json
      data = JSON.parse(response.body)
      return [] unless (data.kind_of? Hash and data[collection_name])
      data[collection_name].map { |u| self.new(u) }
    end
    
    def self.find(what, params={})
      path = params[:from] || "/#{collection_name}/#{what}"
      response = RestClient.get "#{Music::HOST}#{path}", :content_type => :json, :accept => :json
      if (what == :all)
        JSON.parse(response.body)[collection_name].map { |h| self.new(h) }
      else
        self.new JSON.parse(response.body)[element_name]
      end
    end
    
    def self.create(params)
      response = RestClient.post "#{Music::HOST}/users", { :user => params }.to_json, :content_type => :json, :accept => :json
      self.new(JSON.parse(response)['user'])
    end
    
    def destroy
      RestClient.delete "#{Music::HOST}/#{self.class.collection_name}/#{to_param}", :content_type => :json, :accept => :json
    end
    
    protected
    
    def self.collection_name
      # TODO: use Rails Inflectors
      self.element_name + 's'
    end
    
    def self.element_name
      self.to_s.sub('Music::', '').downcase
    end
  end
  
  class User < Base
    def self.find_by_name(name)
      self.find(name.gsub(/\W/,'').downcase)
    end
    
    def to_param
      username
    end
    
    def collections
      Collection.find(:all, :from => "/users/#{to_param}/collections")
    end
    
    def playlists
      Playlist.find(:all, :from => "/users/#{to_param}/playlists")
    end
  end
  
  class Collection < Base
    def self.create(params)
      user = params.delete(:user) || User.new(:username => 'testuser')
      response = RestClient.post "#{Music::HOST}/users/#{user.to_param}/collections", { :collection => params }.to_json, :content_type => :json, :accept => :json
      Collection.new(JSON.parse(response)['collection'])
    end
    
    def to_param
      url_key
    end
	
	def clips
      Clip.find(:all, :from => "/collections/#{to_param}/clips")
    end
  end
  
  class Clip < Base
    def self.create(params)
      collection = params.delete(:collection)
      response = RestClient.post "#{Music::HOST}/collections/#{collection.to_param}/clips", { :clip => params }.to_json, :content_type => :json, :accept => :json
      Clip.new(JSON.parse(response)['clip'])
    end
    
    def to_param
      url_key
    end
  end

  class Playlist < Base
    def self.create(params)
      user = params.delete(:user) || User.new(:username => 'testuser')
      response = RestClient.post "#{Music::HOST}/users/#{user.to_param}/playlists", { :playlist => params }.to_json, :content_type => :json, :accept => :json
      Playlist.new(JSON.parse(response)['playlist'])
    end
    
    def to_param
      url_key
    end
  end
  
  class Track < Base
    def self.create(params)
      playlist = params.delete(:playlist)
      response = RestClient.post "#{Music::HOST}/playlists/#{playlist.to_param}/tracks", { :playlists_track => params }.to_json, :content_type => :json, :accept => :json
      Track.new(JSON.parse(response)['playlists_track'])
    end
  end
end
