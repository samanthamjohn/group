require 'spec_helper'


describe Post do
  it { should validate_presence_of :user }
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of(:title), scope: :user_id }
  it { should validate_presence_of :body }
  it { should_not validate_presence_of :created_at }
  it { should_not validate_presence_of :updated_at }

  it 'should set a uuid on creation' do
    post = Post.new(title: 'Werewolves: much worse than ogres.',
                    body: 'That sounds bombastic!')
    post.uuid = nil
    post.save
    post.uuid.should_not be_nil
  end
end
