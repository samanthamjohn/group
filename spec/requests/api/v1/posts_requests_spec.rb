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


describe 'PUT /api/v1/posts/:id.json' do
  context 'client is not authenticated' do
    it 'should return a status code of 401 (unauthorized)' do
      put '/api/v1/posts/youth-culture-forever.json'
      response.status.should == 401
    end
  end
  context 'client is authenticated' do
    before { authenticate_client }
    context 'the PUT params are malformed' do
      before { put 'api/v1/posts/all-about-feeding-hobos.json' }
      it 'should return a status code of 422 (unprocessable entity)' do
        response.status.should == 422
      end
    end
    context 'the PUT params are valid' do
      before do
        @params = {
          post: {
            title: 'Safety! Patrol!',
            body: 'Slam-bam-in-a-can!'
          }
        }
      end
      context 'the post with the specified UUID does not exist' do
        context 'model validation fails' do
          before do
            existing_post = FactoryGirl.create :post, user: @user
            @params[:post][:title] = existing_post.title
            put 'api/v1/posts/werewolves-much-worse-than-ogres.json', @params
          end
          it 'should return a status code of 422' do
            response.status.should == 422
          end
          it 'should return a list of errors in JSON' do
            body = JSON.parse(response.body)
            body.should have_key 'errors'
            body['errors'].keys.length.should == 1
            body['errors'].should have_key 'post'
            body['errors']['post'].keys.length.should == 1
            body['errors']['post'].should have_key 'title'
            body['errors']['post']['title'].length.should == 1
            body['errors']['post']['title'].should include 'has already been taken'
          end
        end
        context 'model validation succeeds' do
          before do
            put 'api/v1/posts/werewolves-much-worse-than-ogres.json', @params
          end
          it 'should return a status code of 201 (created)' do
            response.status.should == 201
          end
          it 'should return the post in JSON as specified in the API contract' do
            body = JSON.parse(response.body)
            body.should have_key 'post'
            body['post'].should have_key 'id'
            body['post']['id'].length.should == 32
            body['post']['title'].should == @params[:post][:title]
            body['post']['body'].should == @params[:post][:body]
            body['post']['permissions']['update'].should be_true
            body['post']['permissions']['destroy'].should be_true
          end
        end
      end
      context 'the post with the specified UUID exists' do
        before do
          FactoryGirl.create :post, uuid: 'that-riddle-sucks', user: @user
        end
        context 'model validation fails' do
          before do
            existing_post = FactoryGirl.create :post, user: @user
            @params[:post][:title] = existing_post.title
            put 'api/v1/posts/that-riddle-sucks.json', @params
          end
          it 'should return a status code of 422' do
            response.status.should == 422
          end
          it 'should return a list of errors in JSON' do
            body = JSON.parse(response.body)
            body.should have_key 'errors'
            body['errors'].keys.length.should == 1
            body['errors'].should have_key 'post'
            body['errors']['post'].keys.length.should == 1
            body['errors']['post'].should have_key 'title'
            body['errors']['post']['title'].length.should == 1
            body['errors']['post']['title'].should include 'has already been taken'
          end
        end
        context 'model validation succeeds' do
          before do
            put 'api/v1/posts/that-riddle-sucks.json', @params
          end
          it 'should return a status code of 200 (ok)' do
            response.status.should == 200
          end
          it 'should return the post in JSON as specified in the API contract' do
            body = JSON.parse(response.body)
            body.should have_key 'post'
            body['post']['id'].should == 'that-riddle-sucks'
            body['post']['title'].should == @params[:post][:title]
            body['post']['body'].should == @params[:post][:body]
            body['post']['permissions']['update'].should be_true
            body['post']['permissions']['destroy'].should be_true
          end
        end
      end
    end
  end
end


describe 'DELETE /api/v1/posts/:id.json' do
  context 'client is not authenticated' do
    it 'should return a status code of 401 (unauthorized)' do
      delete '/api/v1/posts/this-is-our-weird-secret.json'
      response.status.should == 401
    end
  end
  context 'client is authenticated' do
    before { authenticate_client }
    context 'the post with the specified UUID does not exist' do
      it 'should return a 404 (not found)' do
        delete 'api/v1/posts/you-really-smell-like-dog-buns.json'
        response.status.should == 404
      end
    end
    context 'the post with the specified UUID does exist' do
      before do
        FactoryGirl.create :post, user: @user, uuid: 'aint-a-crime'
        delete 'api/v1/posts/aint-a-crime.json'
      end
      it 'should return a status code of 200 (ok)' do
        response.status.should == 200
      end
      it 'should delete the post' do
        Post.find_by_uuid('aint-a-crime').should be_nil
      end
    end
  end
end
