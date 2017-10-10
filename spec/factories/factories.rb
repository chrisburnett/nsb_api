# spec/factories/factories.rb
FactoryGirl.define do

  factory :tenant do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    contact_number_1 { Faker::PhoneNumber.phone_number }
    contact_number_2 { Faker::PhoneNumber.phone_number }
    contact_number_3 { Faker::PhoneNumber.phone_number }
    notes { Faker::Lorem.sentence(10) }
  end
  factory :client do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    notes { Faker::Lorem.sentence(10) }
  end
  
  factory :user do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    is_admin false
    username { Faker::Internet.unique.user_name }
    password "test"
    email { Faker::Internet.safe_email }
    phone_number { Faker::PhoneNumber.cell_phone }

    factory :admin do
      is_admin true
    end
    
  end

  factory :job do
    transient do
      assignment_count 0
      item_count 2
    end
    job_number { Faker::Code.unique.asin }
    reported_date { Faker::Time.backward(30) }
    completed_date { Faker::Time.backward(15) }
    due_date { Faker::Time.backward(10) }
    reported_fault { Faker::Lorem.sentence(10) }
    notes { Faker::Lorem.sentence(5) }
    association :priority
    association :user
    association :tenant
    association :client

    after(:create) do |job, evaluator|
      create_list(:assignment, evaluator.assignment_count, job: job, user: job.user)
      create_list(:item, evaluator.item_count, job: job)
    end
  end

  factory :assignment do
    association :user
    association :contractor, factory: :user
    job do
      create(:job)
    end
    assignment_date { Faker::Time.backward(30) }
    scheduled_date { Faker::Time.backward(10) }
    actual_date { Faker::Time.backward(15) }
    notes { Faker::Lorem.sentence(10) }
    resolution { Faker::Lorem.sentence(10) }
    am_pm_visit "AM"
    status "pending"
  end

  factory :job_comment do
    association :user
    association :job
    comment_text { Faker::Lorem.sentence(20) }
  end

  factory :item do
    association :job
    sor_code { Faker::Code.asin }
    description { Faker::Lorem.sentence(10) }
    quantity { Faker::Number.between(1.00, 5.00) }
  end

  factory :priority do
    priority { ["High", "Medium", "Low"].sample }
    level { { "High":3, "Medium":2, "Low":1 }[priority.to_sym] }
  end
  
end
