require 'spec_helper'


describe 'api/v1/users' do
  describe 'index' do
    it 'should have an index route' do
      { get: '/api/v1/users.json' }.should route_to controller: 'api/v1/users',
                                                        action: 'index',
                                                        format: 'json'
    end
    it 'should have the correct path when using the index route helper' do
      api_v1_users_path(format: :json).should == '/api/v1/users.json'
    end
  end

  describe 'show' do
    it 'should have a show route' do
      { get: 'api/v1/users/this-is-the-user-uuid.json' }.
        should route_to controller: 'api/v1/users',
                        action: 'show',
                        id: 'this-is-the-user-uuid',
                        format: 'json'
    end
    it 'should have the correct path when using the show route helper' do
      api_v1_user_path(id: 'user-uuid', format: :json).
        should == '/api/v1/users/user-uuid.json'
    end
  end

  describe 'unrouted' do
    it 'should not have a create route' do
      { post: 'api/v1/users.json' }.should_not be_routable
    end
    it 'should not have an edit route' do
      { get: 'api/v1/users/the-user-uuid/edit.json' }.should_not be_routable
    end
    it 'should not have a destroy route' do
      { delete: 'api/v1/users.json' }.should_not be_routable
    end
  end
end
