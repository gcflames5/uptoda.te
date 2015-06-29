class Version
  include Mongoid::Document

  belongs_to :project
  has_many :downloads

  validate :ensure_unique

  validates_presence_of :major
  validates_inclusion_of :mid, :in => 0..99
  validates_inclusion_of :minor, :in => 0..99

  field :major, type: Integer, default: 1
  field :mid, type: Integer, default: 0
  field :minor, type: Integer, default: 0

  field :rec, type: Boolean
  field :stable, type: Boolean

  def matches?(major, mid, minor)
    return false if (major != -1 && self.major != major)
    return false if (mid != -1 && self.mid != mid)
    return false if (minor != -1 && self.minor != minor)
    return true
  end

  def sum
    major*10000 + mid*100 + minor
  end

  #Validation
  def ensure_unique
    project.versions.each do |version|
      next if self.id == version.id
      if major == version.major && mid == version.mid && minor == version.minor
        errors.add(:minor, "Version must be unique!")
        break
      end
    end
  end

  #Sorting
  def <=>(other)
    self.sum <=> other.sum
  end

  def to_s
    major.to_s + "." + mid.to_s + "." + minor.to_s
  end

  include Comparable

  before_destroy :clean_up

  private
    def clean_up
      downloads.destroy
    end

end
