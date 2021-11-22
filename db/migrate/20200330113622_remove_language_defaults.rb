class RemoveLanguageDefaults < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:books, :language, from: 'en-US', to: nil)
    change_column_default(:profiles, :content_language, from: 'en-US', to: nil)

    Book.where(language: 'en-US').update_all(language: 'en')
    Book.where(language: 'nl-NL').update_all(language: 'nl')

    Profile.where(content_language: 'en-US').update_all(content_language: 'en')
    Profile.where(content_language: 'nl-NL').update_all(content_language: 'nl')
  end
end
