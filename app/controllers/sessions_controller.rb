class SessionsController < Devise::SessionsController

  # POST /auth/google_apps/callback 
  def create
    if user = User.find_or_create_by_auth_hash(request.env['omniauth.auth'])
      sign_in(:user, user)
      session[:user_id] = user.id
    end
    redirect_to :root
  end

  # POST /auth/google_apps/android
  def create_android
    token = params['token']
    uri = URI.parse("https://www.googleapis.com")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    path = "/oauth2/v1/tokeninfo?access_token=#{token}"
    resp = http.get(path)
    data = JSON.parse(resp.body)
    if resp.code == "200" && user = User.find_or_create_by_email(data['email'])
      sign_in(:user, user)
      session[:user_id] = user.id
    end
    redirect_to :root
  end

  def test_create
    raise unless Rails.env.test?
    user = User.find_by_email(params[:email])
    sign_in :user, user
    redirect_to :root
  end
end
