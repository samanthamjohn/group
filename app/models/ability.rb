class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :create, :all
      can [:update, :destroy], Post do |post|
        post.nil? ? false : post.user == user
      end
    end
  end
end
