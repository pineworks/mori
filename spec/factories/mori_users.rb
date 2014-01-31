# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mori_minimal_user, :class => 'Mori::User' do
    email "email@example.com"
    password "123456789sdf"
  end
  factory :mori_invited_user, :class => 'Mori::User' do
    email "email@example.com"
    invitation_token "sdflkjadfsd24rec2"
  end
end
