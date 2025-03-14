# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :select_fields_index, only: %i[index]
  before_action :select_fields_single, only: %i[show edit update]
  # before_action :select_fields_edit, only: %i[]

  def select_fields_single
    include_fields(UserAttrs::SHOW)
  end

  def select_fields_edit
    include_fields(UserAttrs::EDITABLE)
  end

  def select_fields_index
    include_fields(UserAttrs::INDEX)
  end

  def index
    if can? :see_admin_fields, User
      include_fields(UserAttrs::INDEX)
    else
      include_fields(UserAttrs::INDEX & UserAttrs::READABLE)
    end

    @users = if params[:approved] == 'false'
               User.accessible_by(current_ability).where(approved: false).order('email').select(@select_fields)
             else
               User.accessible_by(current_ability).order('approved', 'email').select(@select_fields)
             end
  end

  def show; end

  def edit; end

  def destroy
    return unless can? :destroy, @user

    if current_user == @user
      @user.errors.add(:base, I18n.t('controllers.users.error_destroy'))
      result = false
    else
      result = @user.destroy
    end
    messages = result ? { notice: I18n.t('controllers.users.destroyed') } : { alert: "User could not be destroyed: #{@user.errors.full_messages}" }
    respond_to do |format|
      format.html { redirect_to users_url, messages }
      format.json { head :no_content }
    end
  end

  def destroy
    return unless can? :destroy, @user

    if current_user == @user
      @user.errors.add(:base, "Logged in User can't be destroyed.")
      result = false
    else
      result = @user.destroy
    end
    messages = result ? { notice: 'User was successfully destroyed.' } : { alert: "User could not be destroyed: #{@user.errors.full_messages} " }
    respond_to do |format|
      format.html { redirect_to users_url, messages }
      format.json { head :no_content }
    end
  end

  def approve
    user = User.find(params[:id])
    user.approved = true
    if user.save
      redirect_to users_path, notice: I18n.t('controllers.users.approved')
    else
      redirect_to users_path, notice: I18n.t('controllers.users.error_approve')
    end
    UserMailer.user_approved_mail(user.email).deliver_later
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: I18n.t('controllers.users.updated') }
        format.json { render :show, status: :ok, location: @program }
      else
        flash.now[:alert] = I18n.t('controllers.users.error_update')
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
      #params.require(:user).permit(:full_name, :about, :readable, :faculty_id, :email, :approved)
    else
      params.require(:user).permit(:full_name, :about, :readable, :faculty_id, :email)
    end
  end

  private

  def include_fields(include_fields)
    @include_fields = if can? :see_admin_fields, User
                        include_fields
                      elsif @user && (current_user == @user)
                        include_fields & UserAttrs::OWN_READABLE_FIELDS
                      else
                        include_fields & UserAttrs::READABLE
                      end
    @select_fields = @include_fields - UserAttrs::COMPUTED + %i[faculty_id]
    @fields = @include_fields - [:id]
  end
end
