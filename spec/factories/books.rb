def sentence
  Faker::Lorem.paragraph(
    sentence_count: 5, supplemental: true, random_sentences_to_add: 2
  )
end

FactoryBot.define do
  factory :book do
    transient { random_min_age_in_months { rand(37) } }

    title { Faker::Book.unique.title }
    summary { Array.new(rand(4)) { sentence }.join("\n") }
    language { I18n.available_locales.sample }
    min_age_in_months { random_min_age_in_months }
    max_age_in_months { random_min_age_in_months + rand(144) }

    trait :has_cover do
      before(:create) do |book|
        book.cover =
          File.open(Dir[Rails.root.join('test/fixtures/covers/*.jpg')].sample)
      end
    end

    trait :has_audio do
      before(:create) do |book|
        book.book_type = :audio_only
        book.audio =
          File.open(Dir[Rails.root.join('test/fixtures/audio/*.mp3')].sample)
      end
    end

    trait :has_epub do
      after(:create) do |book|
        epub = Rails.root.join('spec/fixtures/epub/epub_test.zip')
        EpubExtractor.extract_epub(book.storage, epub)
      end
    end

    trait :epub_with_page_images do
      after(:create) do |book|
        epub =
          Rails.root.join(
            'spec/fixtures/epub/epub_test_with_whole_page_images.zip'
          )
        EpubExtractor.extract_epub(book.storage, epub)
      end
    end
  end
end
