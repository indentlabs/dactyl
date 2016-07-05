FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end
  
  factory :user do
    email
    password "password"
    encrypted_password "a"
  end
end