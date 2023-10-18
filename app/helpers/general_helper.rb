module GeneralHelper
  extend ActiveSupport::Concern

  def as_json(options: {})
    ("Api::V1::" + self.class.name + "Serializer").constantize.new(self, options).serializable_hash[:data][:attributes]
  end

  def valid_url?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end

  def set_address
    return if self.lat.nil? || self.long.nil?
    resp_en = Google::Places.new.reverse_geocode(lat: self.lat, lng: self.long, locale: :en)
    puts "RESULT IS #{resp_en}"
    self.full_address = resp_en[:formatted_address]
  end

  def set_email_case
    self.email = self.email.to_s.downcase
    self.unconfirmed_email = self.unconfirmed_email.to_s.downcase if self.has_attribute?("unconfirmed_email")
  end
end
