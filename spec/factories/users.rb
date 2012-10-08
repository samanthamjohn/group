FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "finn-the-human-#{n}@land-of-ooo.ooo" }
    password 'boomboom'
  end
end
