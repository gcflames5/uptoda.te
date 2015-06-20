class Project
  include Mongoid::Document

  belongs_to :user
  has_many :versions

  field :name, type: String
  field :desc, type: String

end
