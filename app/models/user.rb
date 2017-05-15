class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :limit
  def limit
     self.admin ||= 5
  end
  def admin?
    has_role?(:admin)
  end
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
