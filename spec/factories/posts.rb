FactoryGirl.define do
  factory :post do
    user
    sequence(:title) { |n| "mathematical * #{n}!" }
    body 'It\'s gonna be so flippin\' awesome.'
  end
end
