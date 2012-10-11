require 'spec_helper'


describe 'GET api/v1/users.json' do
  context 'client is not authenticated' do
    it 'should return a status code of 401 (unauthorized)' do
      get '/api/v1/users.json'
      response.status.should == 401
    end
  end
#  context 'client is authenticated' do
#    before { authenticate_client }
#    it 'should return a status code of 200' do
#      get 'api/v1/users.json'
#      response.should == 200
#    end
#    it 'should return a list of users in JSON as specified in the API contract' do
#      FactoryGirl.create :user, email: 'jake-the-dog@the-land-of.ooo'
#
#      get 'api/v1/users.json'
#      body = JSON.parse(response.body)
#      body.should have_key 'users'
#      body['users'].length.should == 1
#      body['users'].first['email'].should == 'jake-the-dog@the-land-of.ooo'
#    end
#  end
end


describe 'GET api/v1/users/:id.json' do
  context 'client is not authenticated' do
    it 'should return a status code of 401 (unauthorized)' do
      get '/api/v1/users.json'
      response.status.should == 401
    end
  end
end
