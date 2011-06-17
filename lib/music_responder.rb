class MusicResponder < ActionController::Responder
  # This is the common behavior for "API" requests, like :xml and :json.
  def api_behavior(error)
    raise error unless resourceful?

    if get?
      display resource
    elsif has_errors?
      display resource.errors, :status => :unprocessable_entity
    elsif post?
      display resource, :status => :created, :location => api_location
    elsif put?
      display resource
    elsif delete?
      display '', :status => :ok
    elsif has_empty_resource_definition?
      display empty_resource, :status => :ok
    else
      head :ok
    end
  end
end