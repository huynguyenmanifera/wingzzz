After do
  root = Pathname(CarrierWave::Uploader::Base.root.call)
  sleep 0.5
  root.exist? && root.rmtree # Needed because of using 2 ebooks for testing. This prevents deleting them too early which caused errors by looking for files of the deleted book
end
