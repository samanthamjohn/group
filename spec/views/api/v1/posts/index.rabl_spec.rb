require 'spec_helper'


describe 'api/v1/posts/index.rabl' do
  before { stub_ability }

  it 'should have a root node of "posts"' do
    assign :posts, []
    result = JSON.parse(render)
    result.should have_key 'posts'
  end

  it 'should not have an object root' do
    post_stub = stub_model(Post)
    assign :posts, [post_stub]
    result = JSON.parse(render)
    result['posts'].each { |p| p.should_not have_key 'post' }
  end
end
