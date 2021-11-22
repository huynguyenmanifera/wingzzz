FactoryBot.define do
  factory :book_session do
    profile
    book
    current_page { 4 }
  end
end
