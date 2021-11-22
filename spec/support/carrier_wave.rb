RSpec.configure do |config|
  config.after(:each) do
    root = Pathname(CarrierWave::Uploader::Base.root.call)
    root.exist? && root.rmtree
  end
end
