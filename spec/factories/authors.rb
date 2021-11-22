FactoryBot.define do
  factory :author do
    sequence :name do |n|
      "Author #{n}"
    end
  end
end
