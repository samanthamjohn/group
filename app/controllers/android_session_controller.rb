 class AndroidSessionController < ApplicationController
  # POST /auth/google_apps/android
  def android_login
    token = params['token']
    uri = URI.parse("https://www.googleapis.com")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    path = "/oauth2/v1/tokeninfo?access_token=#{token}"
    resp = http.get(path)
    binding.pry
    data = JSON.parse(resp.body)
    binding.pry
    if resp.code == "200"
      # Find a user
      @user = User.where(:email => data["email"]).first
      else
        #Create a user with the data we just got back
    end
  end
end

