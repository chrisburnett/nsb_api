# spec/factories/factories.rb
FactoryGirl.define do

  factory :tenant do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    notes { Faker::Lorem.sentence(10) }
  end
  
  factory :user do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    is_admin false
    password "test"

    factory :admin do
      is_admin true
    end
    
  end

  factory :job do
    short_title { Faker::Lorem.sentence(3) }
    reported_date { Faker::Date.backward(30) }
    completed_date { Faker::Date.backward(15) }
    reported_fault { Faker::Lorem.sentence(10) }
    sor_code { Faker::Code.asin }
    description { Faker::Lorem.sentence(10) }
    notes { Faker::Lorem.sentence(5) }
    association :user, factory: :admin
    association :tenant
  end

  factory :assignment do
    association :user
    association :job
    assignment_date { Faker::Date.backward(30) }
    scheduled_date { Faker::Date.backward(10) }
    actual_date { Faker::Date.backward(15) }
    notes { Faker::Lorem.sentence(10) }
    resolution { Faker::Lorem.sentence(10) }
    am_pm_visit "am"
  end

  factory :job_comment do
    user
    job
    comment_text { Faker::Lorem.sentence(20) }
  end
  
end
