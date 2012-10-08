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
end
