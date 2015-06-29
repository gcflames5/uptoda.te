module DropboxUploader
  extend ActiveSupport::Concern

  def connect_to_dropbox
    @@client = Dropbox::API::Client.new(:token  => ENV['DROPBOX_APP_TOKEN'], :secret => ENV['DROPBOX_APP_TOKEN_SECRET'])
  end

  def upload(version, file)
    begin
      @@client.mkdir version.project.id.to_s
    rescue
      #do nothing, bad oauth request --> folder already exists
    end
    @@client.chunked_upload("#{version.project.id.to_s}/#{version.to_s}.zip", File.open(file.path))
  end

  def get_download_url(version)
    @@client.find("#{version.project.id.to_s}/#{version.to_s}.zip").direct_url.url
  end



end
