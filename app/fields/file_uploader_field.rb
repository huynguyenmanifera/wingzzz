require 'administrate/field/base'

class FileUploaderField < Administrate::Field::Base
  delegate :url, to: :data

  def exists?
    !data.file.nil?
  end
end
