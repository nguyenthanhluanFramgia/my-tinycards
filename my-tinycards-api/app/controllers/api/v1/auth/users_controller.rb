class Api::V1::Auth::UsersController < Api::V1::BaseController
  # include Document::Auth::SignUpDoc
  # include Document::Auth::ActiveUserDoc
  validate_params on: :create, require: [user: User::SIGN_UP_REQUIRE_PARAMS]

  def create
    user = Authenticates::SignUpService.new(user_params: user_params).perform
    render_success
  end

  def update
    user = User.find_by! email: params[:email]
    invalid_confirmation_token! user
    user_activated! user
    user.confirm
    render_success data: Authenticates::LoginService.new(user: user).perform
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def invalid_confirmation_token! user
    raise APIError::Authorize::InvalidConfirmationToken if user.confirmation_token != params[:confirmation_token]
  end

  def user_activated! user
    raise APIError::Authorize::UserActivated if user.confirmed?
  end
end
