module DeviseRequestSupport
  include Devise::TestHelpers

  def authenticate_client
    @user = FactoryGirl.create :user
    post_via_redirect test_users_sign_in_path, email: @user.email
  end
end


module DeviseControllerSupport
  include Devise::TestHelpers

  def authenticate_client
    @user = FactoryGirl.create :user
    sign_in @user
    @controller.stub(:current_user).and_return(@user)
  end
end
