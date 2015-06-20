class Version
  include Mongoid::Document

  belongs_to :project

  field :major, type: Integer
  field :mid, type: Integer
  field :minor, type: Integer
  
end
