class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_authenticity_token

  private

  def invalid_authenticity_token
    flash[:alert] = 'Your session expired. Please sign in again to continue.'
    redirect_to(new_user_session_path)
  end

  def user_not_authorized
    if user_signed_in?
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to(request.referrer || root_path)
    else
      flash[:alert] = 'You need to sign in or sign up before continuing.'
      redirect_to(new_user_session_path)
    end
  end
end
