require 'spec_helper'


describe Api::V1::PostsController do
  describe 'index' do
    context 'with authenticated client' do
      before { authenticate_client }
      it 'should fetch a collection of posts' do
        post_mock = double('post mock')
        Post.stub(:all).and_return [post_mock]
        get :index, format: :json
        assigns(:posts).should == [post_mock]
      end
    end
  end

  describe 'show' do
    context 'with authenticated client' do
      before { authenticate_client }
      it 'should fetch a post with the specified UUID' do
        post_mock = double('post mock')
        Post.stub(:find_by_uuid).
          with('not-righteous-wrong-teous').
          and_return(post_mock)
        get :show, id: 'not-righteous-wrong-teous'
        assigns(:post).should == post_mock
      end
      it 'should return 404 when a post with the specified UUID could not be found' do
        Post.stub(:find_by_uuid).with('ill-never-kidnap-again').and_return nil
        get :show, id: 'ill-never-kidnap-again'
        response.status.should == 404
      end
    end
  end
end
