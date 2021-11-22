require 'zip'

class EpubExtractor
  class << self
    def extract_epub(storage, zip_file)
      unzip_to_temp_dir(zip_file) do |dir, entries|
        storage.delete_epub_files!

        entries.filter(&:file?).each do |file|
          source_path = "#{dir}/#{file.name}"
          storage.add_epub_file! source_path, file.name
        end
      end
    end

    def unzip_to_temp_dir(zip_file)
      Dir.mktmpdir do |dir|
        entries = []

        Zip::File.open(zip_file) do |zip_file_contents|
          zip_file_contents.each do |entry|
            entries << entry

            temp_path = "#{dir}/#{entry.name}"

            path = Pathname.new(temp_path)

            path.dirname.mkpath

            zip_file_contents.extract(entry, temp_path)
          end
        end

        yield dir, entries
      end
    end
  end
end
