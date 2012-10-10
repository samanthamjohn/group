require 'spec_helper'


describe 'api/v1/users/index.rabl' do
  before { stub_ability }

  it 'should have a root node of "users"' do
    assign :users, []
    result = JSON.parse(render)
    result.should have_key 'users'
  end

  it 'should not have an object root' do
    user_stub = stub_model(User)
    assign :users, [user_stub]
    result = JSON.parse(render)
    result['users'].each { |p| p.should_not have_key 'user' }
  end
end
