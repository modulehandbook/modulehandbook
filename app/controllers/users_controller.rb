# frozen_string_literal: true

class UsersController < ApplicationController

  load_and_authorize_resource
  #before_action :set_user, only: %i[show edit update]

  def index
    @users = if params[:approved] == 'false'
               User.accessible_by(current_ability).where(approved: false).order('email').select(UserAttrs::SHOW)
             else
               User.accessible_by(current_ability).order('approved', 'email').select(UserAttrs::SHOW)
             end
  end

  def public_index
    @users = User.accessible_by(current_ability).order('email').select(UserAttrs::READABLE)
  end

  def show; end

  def edit; end

  def destroy
    if can? :destroy, @user
        if current_user == @user
            @user.errors.add(:base, "Logged in User can't be destroyed.")
            result = false
        else
          result = @user.destroy
        end
      messages = result ? {notice: "User was successfully destroyed."} : {alert: "User could not be destroyed: #{@user.errors.full_messages} "}
      respond_to do |format|
        format.html { redirect_to users_url, messages }
        format.json { head :no_content }
      end

    end

  end

  def approve
    user = User.find(params[:id])
    user.approved = true
    if user.save
      redirect_to users_path, notice: 'User was successfully approved.'
    else
      redirect_to users_path, notice: 'Error approving user.'
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @program }
      else
        flash.now[:alert] = "User could not be updated"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
        end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    if can? :manage_access, User
        params.require(:user).permit(:full_name, :about, :readable, :faculty_id, :email, :approved, :role)
    else
        params.require(:user).permit(:full_name, :about, :readable, :faculty_id, :email)
    end
  end
end
