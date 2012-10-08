require 'spec_helper'


describe 'api/v1/posts/show.rabl' do
  before do
    @now = Time.zone.now
    @post_mock = double('post mock', {
      'uuid' => 'tree-trunks',
      'title' => 'Rhombus!',
      'body' => 'Slamacow! That was tops!',
      'created_at' => @now,
      'updated_at' => @now
    })
    assign(:post, @post_mock)
  end

  it 'should assign the fields in the API contract' do
    stub_ability
    render
    JSON.parse(rendered).values.first.should == {
      'id' => @post_mock.uuid,
      'title' => @post_mock.title,
      'body' => @post_mock.body,
      'created_at' => @now.as_json,
      'updated_at' => @now.as_json,
      'permissions' => { 'update' => false, 'destroy' => false }
    }
  end

  it 'should not assign fields outside of the API contract' do
    stub_ability
    render
    JSON.parse(rendered).values.each do |post_json|
      post_json.should_not have_key 'uuid'
    end
  end

  it 'should display the appropriate permissions associated with each post'
end
