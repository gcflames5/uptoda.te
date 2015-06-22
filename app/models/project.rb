class Project
  include Mongoid::Document

  belongs_to :user
  has_many :versions

  field :name, type: String
  field :desc, type: String

  def get_matches(major, mid, minor)
    possibilities = Array.new
    versions.each do |version|
      possibilities << version if version.matches?(major, mid, minor)
    end
    return possibilities
  end

  def grab_version(major, mid, minor, search_type)
    possibilities = get_matches(major, mid, minor)
    case search_type
    when :rec
      version = get_rec(possibilities)
      return version.nil? ? latest(possibilities) : version
    when :stable
      version = get_stable(possibilities)
      return version.nil? ? latest(possibilities) : version
    else
      return latest(possibilities)
    end
    return nil #could not find suitable version
  end

  private
    def get_rec(versions)
      rec_possibilities = Array.new
      versions.each do |version|
        rec_possibilities << version if version.rec == true
      end
      return latest(rec_possibilities)
    end

    def get_stable(versions)
      rec_possibilities = Array.new
      versions.each do |version|
        rec_possibilities << version if version.stable == true
      end
      return latest(rec_possibilities)
    end

    def latest(versions)
      highest = -1
      high_version = nil
      versions.each do |version|
        if version.sum > highest
          highest = version.sum
          high_version = version
        end
      end
      return high_version
    end

end
