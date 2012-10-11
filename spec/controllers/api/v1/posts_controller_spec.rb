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
        get :show, id: 'not-righteous-wrong-teous', format: :json
        assigns(:post).should == post_mock
      end
      it 'should return 404 when a post with the specified UUID could not be found' do
        Post.stub(:find_by_uuid).with('ill-never-kidnap-again').and_return nil
        get :show, id: 'ill-never-kidnap-again', format: :json
        response.status.should == 404
      end
    end
  end

  describe 'update' do
    context 'with authenticated client' do
      before { authenticate_client }
      context 'the PUT params do not contain necessary data' do
        before { put :update, id: 'vampire-fighting-time' }
        it 'should return a status code of 422 (unprocessable entity)' do
          response.status.should == 422
        end
      end
      context 'the PUT params contain all necessary data' do
        before do
          @factory_post = FactoryGirl.build :post,
                                            user: nil,
                                            uuid: 'how-did-you-almost-know-my-name'
          @params = {
            post: {
              id: @factory_post.uuid,
              title: @factory_post.title,
              body: @factory_post.body
            }
          }
          @update_params = {
            'title' => @params[:post][:title],
            'body' => @params[:post][:body]
          }
        end
        context 'a post with the specified UUID does not exist' do
          before do
            @user.stub_chain(:posts, :find_or_initialize_by_uuid).
              with(@params[:id]).
              and_return(@factory_post)
            @factory_post.stub(:new_record?).and_return(true)
          end
          context 'model validations pass' do
            before do
              @factory_post.should_receive(:update_attributes).
                with(@update_params).
                and_return(true)
            end
            it 'should return a status code of 201 (created)' do
              put :update, @params
              response.status.should == 201
            end
            it('should create a new post') do
              put :update, @params
            end
            it 'should return the post data as JSON in the response' do
              put :update, @params
              assigns(:post).should == @factory_post
              response.should render_template 'api/v1/posts/show'
            end
          end
          context 'model validations fail' do
            before do
              @factory_post.should_receive(:update_attributes).
                with(@update_params).
                and_return(false)
              @factory_post.stub(:errors).and_return(
                title: ['was kicking my buns', 'might\'ve finished my buns']
              )
            end
            it 'should return a status code of 422 (unprocessable entity)' do
              put :update, @params
              response.status.should == 422
            end
            it 'should return a list of errors' do
              put :update, @params
              body = JSON.parse(response.body)
              body.should have_key 'errors'
              body['errors'].keys.length.should == 1
              body['errors'].should have_key 'post'
              body['errors']['post'].keys.length.should == 1
              body['errors']['post'].should have_key 'title'
              body['errors']['post']['title'].should include 'was kicking my buns'
              body['errors']['post']['title'].should include 'might\'ve finished my buns'
            end
          end
        end
        context 'a post with the specified UUID does exist' do
          before do
            @user.stub_chain(:posts, :find_or_initialize_by_uuid).
              with(@params[:id]).
              and_return(@factory_post)
            @factory_post.stub(:new_record?).and_return(false)
          end
          context 'model validations pass' do
            before do
              @factory_post.should_receive(:update_attributes).
                with(@update_params).
                and_return(true)
            end
            it 'should return a status code of 200 (ok)' do
              put :update, @params
              response.status.should == 200
            end
            it 'should update the existing post' do
              put :update, @params
            end
            it 'should return the post data as JSON in the response' do
              put :update, @params
              assigns(:post).should == @factory_post
              response.should render_template 'api/v1/posts/show'
            end
          end
          context 'model validations fail' do
            before do
              @factory_post.should_receive(:update_attributes).
                with(@update_params).
                and_return(false)
              @factory_post.stub(:errors).
                and_return(
                  title: ['was kicking my buns', 'might\'ve finished my buns'])
            end
            it 'should return a status code of 422 (unprocessable entity)' do
              put :update, @params
              response.status.should == 422
            end
            it 'should return a list of errors' do
              put :update, @params
              body = JSON.parse(response.body)
              body.should have_key 'errors'
              body['errors'].keys.length.should == 1
              body['errors'].should have_key 'post'
              body['errors']['post'].keys.length.should == 1
              body['errors']['post'].should have_key 'title'
              body['errors']['post']['title'].should include 'was kicking my buns'
              body['errors']['post']['title'].should include 'might\'ve finished my buns'
            end
          end
        end
      end
    end
  end

  describe 'delete' do
    before { @params = { id: 'what-the-huh' } }
    context 'with authenticated client' do
      before { authenticate_client }
      context 'the post with the specified UUID does not exist' do
        before do
          @user.stub_chain(:posts, :find_by_uuid).with(@params[:id])
          delete :destroy, @params
        end
        it 'should return a status code of 404 (not found)' do
          response.status.should == 404
        end
      end
      context 'the post with the specified UUID exists' do
        before do
          mock_post = double('mock post')
          mock_post.should_receive(:destroy)
          @user.stub_chain(:posts, :find_by_uuid).
            with(@params[:id]).
            and_return(mock_post)
          delete :destroy, @params
        end
        it 'should return a status code of 200 (ok)' do
          response.status.should == 200
        end
        it('should delete the post') {} # tested in before
      end
    end
  end
end
