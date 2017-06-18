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
    username { Faker::Internet.user_name }
    password "test"

    factory :admin do
      is_admin true
    end
    
  end

  factory :job do
    transient do
      assignment_count 0
    end
    short_title { Faker::Lorem.sentence(3) }
    reported_date { Faker::Time.backward(30) }
    completed_date { Faker::Time.backward(15) }
    reported_fault { Faker::Lorem.sentence(10) }
    sor_code { Faker::Code.asin }
    description { Faker::Lorem.sentence(10) }
    notes { Faker::Lorem.sentence(5) }
    association :user
    association :tenant
    assigned false
    completed false

    after(:create) do |job, evaluator|
      create_list(:assignment, evaluator.assignment_count, job: job)
    end
  end

  factory :assignment do
    transient do
      completed false
      assigned false
    end
    association :user
    job do
      create(:job, completed: completed, assigned: assigned)
    end
    assignment_date { Faker::Time.backward(30) }
    scheduled_date { Faker::Time.backward(10) }
    actual_date { Faker::Time.backward(15) }
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
