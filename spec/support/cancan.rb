module CanCanSupport
  def stub_ability
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
    @view.stub(:current_ability).and_return(@ability)
  end
end

