class AddContentLanguageToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles,
               :content_language,
               :string,
               required: true, default: 'en-US'
  end
end
