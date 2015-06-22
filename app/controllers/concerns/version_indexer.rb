module VersionIndexer
  extend ActiveSupport::Concern

  #[major -> [mid -> [minor]]]
  def generate_displaylist(project)
    major_list = Array.new

    current_version = nil
    project.versions.sort!.each do |version|
      if current_version.nil?
        current_version = version
      else

      end
    end

    major_list
  end

  private

    def changed_level(current_version, next_version)
      return :major if current_version.major != next_version.major
      return :mid if current_version.mid != next_version.mid
      return :minor if current_version.minor != next_version.minor
      return :none
    end

    def generate_hash(parent)
      { version: parent, children: Array.new }
    end

end
