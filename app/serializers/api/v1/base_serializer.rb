class Api::V1::BaseSerializer
  include JSONAPI::Serializer
  attribute :id
  def self.firebase_auth_token
    attribute :firebase_auth_token, if: proc { |record, params| params[:is_owner] } do |record, params|
      record.get_firebase_token
    end
  end

  def self.show_localized_data?(user)
    return false unless user.present?
    ["AdminUser", "Store"].include?(user&.class&.name.to_s) ? true : false
  end

  def self.localized_data
    attribute :localized_data, if: proc { |record, params| show_localized_data?(params[:current_user]) } do |record|
      record.get_localized_attributes
    end
  end
end
