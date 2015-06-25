class Download
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :version

  field :ip, type: String
  field :key, type: String
  field :useragent, type: String 

end
