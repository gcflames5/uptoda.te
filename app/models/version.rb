class Version
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :project
  has_many :downloads

  validate :ensure_unique

  has_mongoid_attached_file :file
    do_not_validate_attachment_file_type :file
    validates_attachment_size :file, :less_than => 5.megabytes

  validates_presence_of :major
  validates_inclusion_of :mid, :in => 0..99
  validates_inclusion_of :minor, :in => 0..99

  field :major, type: Integer
  field :mid, type: Integer
  field :minor, type: Integer

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
      break if self == version
      errors.add(:minor, "Version must be unique!") if major == version.major && mid == version.mid && minor == version.minor
      break
    end
  end

end
