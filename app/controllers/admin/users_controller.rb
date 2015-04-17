class Admin::UsersController < ApplicationController



	def index
		@users = User.order("created_at desc").paginate(:page => params[:page], :per_page => 3)
	end

	def edit
		@user=User.new
	end

	def show
		@user = User.find(params[:user_id])
	end

	def create
		@user = User.new(user_params)
		if @user.valid?
			@user.save
			@success = true
			flash[:success] = "You have logged in successfullly!"
		else
			@success = false
		end
	end

	private

	def user_params
		params.require(:user).permit(:name)
	end


end












