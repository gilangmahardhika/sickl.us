class User
	include Mongoid::Document
	include Mongoid::Timestamps
	# attr_accessible :name, :username, :email, :password, :password_salt, :password_confirmation
	attr_accessor :password_confirmation

	has_many :snippets

	field :name, :type => String
	field :username, :type => String
	field :email, :type => String
	field :password, :type => String
	field :password_salt, :type => String

	key :username

	before_save :prepare_password, :password_salt

	validates_presence_of :name, :username, :email, :password, :password_confirmation
	validates_uniqueness_of :username, :email
	validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => false, :message => "should only contain letters, numbers, or .-_@"
	validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
	validate :check_password

	def check_password
		if self.new_record?
		  errors.add(:base, "Password can't be blank") if self.password.blank?
		  errors.add(:base, "Password and confirmation does not match") unless self.password == self.password_confirmation
		  errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size.to_i < 4
		else
		  if self.password.blank?
		    errors.add(:base, "Password can't be blank") if self.password.blank?
		  else
		    errors.add(:base, "Password and confirmation does not match") unless self.password == self.password_confirmation
		    errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size.to_i < 4
		  end
		end
	end

  # login can be either username or email address
	def self.authenticate(login, pass)
		user = first(:conditions => {:username => login}) || first(:conditions => {:email => login})
		return user if user && user.matching_password?(pass)
	end

	def matching_password?(pass)
		self.password == encrypt_password(pass)
	end

	private


	def prepare_password
		unless password.blank?
			self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
			self.password = encrypt_password(password)
		end
	end

	def encrypt_password(pass)
	  Digest::SHA1.hexdigest([pass, password_salt].join)
	end

end
