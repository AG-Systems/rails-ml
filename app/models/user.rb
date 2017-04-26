class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  def admin?
    has_role?(:admin)
  end
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
