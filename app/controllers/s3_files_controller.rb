require 'presigned_url_creator'

class S3FilesController < ApplicationController
  def show
    expires_in PresignedUrlCreator::EXPIRES_IN
    redirect_to PresignedUrlCreator.presigned_url(params)
  end
end
