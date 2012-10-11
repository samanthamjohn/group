require 'spec_helper'


describe 'api/v1/users/show.rabl' do
  before do
    @now = Time.zone.now
    @user_mock = double('user mock', {
      'uuid' => 'tree-trunks',
      'email' => 'thats-bunk@easy-as-childbirth.com',
      'created_at' => @now,
      'updated_at' => @now
    })
    assign(:user, @user_mock)
  end

  it 'should assign the fields in the API contract' do
    stub_ability
    render
    JSON.parse(rendered).values.first.should == {
      'id' => @user_mock.uuid,
      'email' => @user_mock.email,
      'created_at' => @now.as_json,
      'updated_at' => @now.as_json,
    }
  end

  it 'should not assign fields outside of the API contract' do
    stub_ability
    render
    JSON.parse(rendered).values.each do |user_json|
      user_json.should_not have_key 'uuid'
    end
  end
end
