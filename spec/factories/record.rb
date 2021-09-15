# ddefine Record factory
FactoryBot.define do
  factory :record do
    duration { rand(0.1..1440).floor(1) }
    satisfaction { rand(1..10) }
    date { Date.today }

    user
    activity
  end
end
