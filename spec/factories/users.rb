# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Szymon Kowalski"
    provider "Google"
    uid "dadf79alewe0adbvbhygrqfkvnsd093fnsklfmasdgvhaf0g"
  end
end
