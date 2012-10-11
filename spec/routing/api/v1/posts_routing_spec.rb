require 'spec_helper'


describe 'api/v1 posts' do
  describe 'index' do
    it 'should have an index route' do
      { get: '/api/v1/posts.json' }.should route_to controller: 'api/v1/posts',
                                                    action: 'index',
                                                    format: 'json'
    end
    it 'should have the correct path when using the index route helper' do
      api_v1_posts_path(format: :json).should == '/api/v1/posts.json'
    end
  end

  describe 'show' do
    it 'should have a show route' do
      { get: 'api/v1/posts/this-is-the-post-uuid.json' }.
        should route_to controller: 'api/v1/posts',
                        action: 'show',
                        id: 'this-is-the-post-uuid',
                        format: 'json'
    end
    it 'should have the correct path when using the show route helper' do
      api_v1_post_path(id: 'post-uuid', format: :json).should == '/api/v1/posts/post-uuid.json'
    end
  end

  describe 'update' do
    it 'should have an update route' do
      { put: 'api/v1/posts/post-uuid.json' }.
        should route_to controller: 'api/v1/posts',
                        action: 'update',
                        id: 'post-uuid',
                        format: 'json'
    end
  end

  describe 'destroy' do
    it 'should have a destroy route' do
      { delete: 'api/v1/posts/post-uuid.json' }.
        should route_to controller: 'api/v1/posts',
                        action: 'destroy',
                        id: 'post-uuid',
                        format: 'json'
    end
  end

  describe 'unrouted' do
    it 'should not have a create route' do
      { post: 'api/v1/posts.json' }.should_not be_routable
    end
    it 'should not have an edit route' do
      { get: 'api/v1/posts/the-post-uuid/edit.json' }.should_not be_routable
    end
  end
end
