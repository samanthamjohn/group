require 'spec_helper'


describe 'GET api/v1/posts.json' do
  context 'client is not authenticated' do
    it 'should return a status code of 401 (unauthorized)' do
      get '/api/v1/posts.json'
      response.status.should == 401
    end
  end

  context 'client is authenticated' do
    before { authenticate_client }
    it 'should return a status code of 200' do
      get '/api/v1/posts.json'
      response.status.should == 200
    end
    it 'should return a list of posts in JSON as specified in the API contract' do
      test_post = FactoryGirl.create :post

      get '/api/v1/posts.json'
      body = JSON.parse(response.body)
      body.should have_key 'posts'
      body['posts'].length.should == 1
      body['posts'].first['id'].should == test_post.uuid
      body['posts'].first['title'].should == test_post.title
      body['posts'].first['body'].should == test_post.body
      body['posts'].first['permissions']['update'].should be_false
      body['posts'].first['permissions']['destroy'].should be_false
    end
  end
end


describe 'GET api/v1/posts/:uuid.json' do
  context 'client is not authenticated' do
    it 'should return a status code of 401 (unauthorized)' do
      get '/api/v1/posts/this-is-the-post-uuid.json'
      response.status.should == 401
    end
  end

  context 'client is authenticated' do
    before { authenticate_client }
    context 'the post with the specified UUID exists' do
      before { @test_post = FactoryGirl.create :post }
      it 'should return a status code of 200' do
        get "api/v1/posts/#{@test_post.uuid}.json"
        response.status.should == 200
      end
      it 'should return the post in JSON as specified in the API contract' do
        get "api/v1/posts/#{@test_post.uuid}.json"
        body = JSON.parse(response.body)
        body.should have_key 'post'
        body['post']['id'].should == @test_post.uuid
        body['post']['title'].should == @test_post.title
        body['post']['body'].should == @test_post.body
        body['post']['permissions']['update'].should be_false
        body['post']['permissions']['destroy'].should be_false
      end
      context 'and the post belongs to the authenticated client' do
        it 'should indicate in the response data that the post is modifiable'
      end
      context 'and the post does not belong to the authenticated client' do
        it 'should indicate in the response data that the post is not modifiable'
      end
    end
    context 'the post with the specified UUID does not exist' do
      it 'should return a status code of 404 (not found)' do
        get 'api/v1/posts/shmow-zow.json'
        response.status.should == 404
      end
    end
  end
end
