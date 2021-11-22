require 'book_storage/local'
require 'book_storage/s3'

class ProfileDecorator < ApplicationDecorator
  delegate_all
end
