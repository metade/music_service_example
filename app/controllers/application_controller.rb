require 'music_responder'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  self.responder = MusicResponder
end
