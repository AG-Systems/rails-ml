class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :set_default_limit, :set_default_ready
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  private
  def set_default_limit
    self.limit ||= 5
  end
  def set_default_ready
    self.ready ||= true
  end
end
