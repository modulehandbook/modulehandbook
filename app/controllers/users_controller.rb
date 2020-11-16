# frozen_string_literal: true

class UsersController < ApplicationController
  authorize_resource
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = if params[:approved] == 'false'
               User.where(approved: false)
             else
               User.all
             end
   end

  def show

  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :approved, :role)
  end

end
