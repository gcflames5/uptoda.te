module Uploader
  extend ActiveSupport::Concern

  def connect_to_mega
    @@storage = Rmega.login(ENV['MEGA_USERNAME'], ENV['MEGA_PASSWORD'])
  end

  def upload_file(version, file)
    create_root? if root.nil?
    project_folder = create_folder("#{version.project.id}", root)
    version_folder = create_folder("#{version.to_s}", project_folder)
    clear_folder(version_folder);
    version_folder.upload(file.path)
    File.delete(file.path) if File.exist?(file.path)
  end

  def get_file(version)
    project_folder = get_folder("#{version.project.id}", root)
    version_folder = get_folder("#{version.to_s}", project_folder)
    version_folder.files.first.download(Rails.root.join('tmp'))
    return Rails.root.join('tmp', version_folder.files.first.name)
  end


  private
    def root
      root = @@storage.nodes.find do |node|
        node.type == :folder and node.name == "uptodate"
      end
      return root
    end

    def create_root?
      @@storage.root.create_folder("uptodate")
    end

    def folder_exists?(name, folder)
      result = folder.children.find do |node|
        node.type == :folder and node.name == name
      end
      return !result.nil?
    end

    def create_folder(name, folder)
      unless folder_exists?(name, folder)
        return folder.create_folder(name)
      end
      return get_folder(name, folder)
    end

    def clear_folder(folder)
      folder.children.each do |node|
        node.delete
      end
    end

    def get_folder(name, folder)
      return folder.children.find do |node|
        node.type == :folder and node.name == name
      end
    end

end
