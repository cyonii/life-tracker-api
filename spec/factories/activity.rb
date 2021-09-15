# define Activity factory
FactoryBot.define do
  factory :activity do
    name { Faker::Lorem.word }
  end
end
