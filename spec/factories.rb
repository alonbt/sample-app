FactoryGirl.define do
  factory :user do
    name      "Alon Bartur"
    email     "alonbt@gmail.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end