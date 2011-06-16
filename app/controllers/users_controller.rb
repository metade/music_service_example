class UsersController < ApplicationController
  respond_to :html, :xml, :json
  
  def index
    @users = User.all
    respond_with(:users => @users)
  end
  
  def show
    @user = User.find_by_username(params[:id])
    respond_with(:user => @user)
  end
  
  def create
    @user = User.new(params[:user])
    @user.save
    respond_with({:user => @user}, :location => user_url(@user))
  end
  
  def update
    @user = User.find_by_username(params[:id])
    @user.update_attributes(params[:user])
    respond_with(:user => @user) do |format|
      format.json { render(:json => {:user => @user}.to_json) }
    end
  end
  
  def destroy
    @user = User.find_by_username(params[:id])
    @user.destroy
    respond_with(:user => @user) do |format|
      format.json { render(:json => '') }
    end
  end
end
