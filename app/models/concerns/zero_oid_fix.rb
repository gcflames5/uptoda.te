module ZeroOidFix
  extend ActiveSupport::Concern

  module ClassMethods
    def self.serialize_into_session(record)
      [record.id.to_s, record.authenticatable_salt]
    end
  end
end
