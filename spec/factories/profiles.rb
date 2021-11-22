FactoryBot.define do
  factory :profile do
    user
    content_language { 'en' }
  end
end
