require 'spec_helper'


describe User do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }

  it 'should set a uuid on creation' do
    user = User.new(email: 'marceline-the-vampire-queen@the-land-of.ooo')
    user.uuid = nil
    user.save
    user.uuid.should_not be_nil
    user.uuid.length.should == 36
  end
end
