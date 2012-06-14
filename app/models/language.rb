class Language
  include Mongoid::Document
  field :name, :type => String
  field :alias, :type => String

  has_many :snippets
end
