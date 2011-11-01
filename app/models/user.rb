class User < ActiveRecord::Base
  
  serialize :user_info
  serialize :extra
  attr_accessor :password_confirmation
  has_many :authorizations, :dependent => :destroy
  has_many :statuses, :dependent => :destroy
  has_many :checkins, :dependent => :destroy
  has_many :locations, :through => :checkins

  acts_as_authentic do |c|
    c.ignore_blank_passwords = true #ignoring passwords
    c.validate_password_field = false #ignoring validations for password fields
  end

  #here we add required validations for a new record and pre-existing record
  validate do |user|
    if user.new_record? #adds validation if it is a new record
      user.errors.add(:password, "is required") if user.password.blank?
      user.errors.add(:password_confirmation, "is required") if user.password_confirmation.blank?
      user.errors.add(:password, "Password and confirmation must match") if user.password != user.password_confirmation
    elsif !(!user.new_record? && user.password.blank? && user.password_confirmation.blank?) #adds validation only if password or password_confirmation are modified
      user.errors.add(:password, "is required") if user.password.blank?
      user.errors.add(:password_confirmation, "is required") if user.password_confirmation.blank?
      user.errors.add(:password, " and confirmation must match.") if user.password != user.password_confirmation
      user.errors.add(:password, " and confirmation should be atleast 4 characters long.") if user.password.length < 4 || user.password_confirmation.length < 4
    end
  end

  def self.create_from_hash(hash, provider)
    user = User.new(:username =>  hash['user_info']['name'].scan(/[a-zA-Z0-9_]/).to_s.downcase)
    
    user.user_info = hash['user_info']
    user.extra = hash['extra']
    begin
      if provider == "facebook"
        user.first_name = hash['user_info']['first_name'].to_s
        user.last_name = hash['user_info']['last_name'].to_s
        user.gender = hash['user_info']['gender'].to_s
        user.email = hash['user_info']['email'].to_s
        user.location = hash['user_info']['location'].to_s
        user.bio = hash['user_info']['bio'].to_s
        user.work = hash['user_info']['work'].to_s
      end
    
      if provider == "twitter"
        user.location = hash['user_info']['location'].to_s
        user.website = hash['user_info']['url'].to_s
      end
    
      if provider == "linked_in"
        user.first_name = hash['user_info']['first-name'].to_s
        user.last_name = hash['user_info']['last-name'].to_s
        user.location = hash['user_info']['location']['name'].to_s
      end
    
      if provider == "open_id"
        user.first_name = hash['user_info']['firstName'].to_s
        user.last_name = hash['user_info']['lastnName'].to_s
        user.location = hash['user_info']['location'].to_s
        user.gender = hash['user_info']['gender'].to_s
        user.bio = hash['user_info']['aboutMe'].to_s
      end
    rescue Exception=>e
      # JUST IN CASE
    end

    user.save(false) #create the user without performing validations. This is because most of the fields are not set.
    user.reset_persistence_token! #set persistence_token else sessions will not be created
    user
  end
end

