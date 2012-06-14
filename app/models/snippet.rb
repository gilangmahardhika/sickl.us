class Snippet
  include Mongoid::Document
  field :title, :type => String
  field :code, :type => String

  belongs_to :user
  belongs_to :language

  # before_save :create_highlight

  # def create_highlight
  # 	self.code = Pygment.highlight(self.code, lexer: self.language.downcase!)
  # end
end
