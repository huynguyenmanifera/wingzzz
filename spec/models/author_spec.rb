require 'rails_helper'

RSpec.describe Author, type: :model do
  it { should have_and_belong_to_many(:books).dependent(:nullify) }

  describe '#name' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
