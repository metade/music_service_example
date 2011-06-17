class UsersController < ApplicationController
  respond_to :html, :xml, :json
  
  def index
    @users = User.all(:include => :collections)
    respond_with({ :users => @users }, :include => :collections)
  end
  
  def show
    @user = User.find_by_username(params[:id], :include => :collections)
    respond_with({ :user => @user }, :include => :collections)
  end
  
  def create
    @user = User.new(params[:user])
    @user.save
    respond_with({:user => @user}, :location => user_url(@user))
  end
  
  def update
    @user = User.find_by_username(params[:id])
    @user.update_attributes(params[:user])
    respond_with(:user => @user)
  end
  
  def destroy
    @user = User.find_by_username(params[:id])
    @user.destroy
    respond_with(:user => @user)
  end
end
