require "spec_helper"


describe Api::V1::UsersController do
  describe 'index'
    context 'with authenticated client' do
      before { authenticate_client }
      it 'should fetch a collection of users' do
        user = double('user mock')
        User.stub(:all).and_return [user]
        get :index, format: :json
        assigns(:users).should == [user]
      end
    end

  describe 'show' do
    context 'with authenticated client' do
      before { authenticate_client }
      it 'should fetch a user with the specified UUID' do
        user = double('user mock')
        User.stub(:find_by_uuid).with('henchman-for-life').and_return user
        get :show, id: 'henchman-for-life', format: :json
        assigns(:user).should == user
      end
      it 'should return 404 when the specified user does not exist' do
        User.stub(:find_by_uuid).with('sounds-like-dinner').and_return nil
        get :show, id: 'sounds-like-dinner', format: :json
        response.status.should == 404
      end
    end
  end
end
