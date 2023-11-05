class User < ApplicationRecord

  devise :database_authenticatable, :recoverable, :rememberable, :trackable
  enum status: { active: 0, deactivated: 1, deleted: 2, suspended: 3 }, _suffix: :status,_default: :active

end
