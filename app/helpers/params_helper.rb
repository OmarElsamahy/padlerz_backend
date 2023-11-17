module ParamsHelper
  def set_localized_params(base_params: {}, to_permit: [])
    result = {}
    return result if base_params.blank?
    AVAILABLE_LOCALES.each do |locale|
      next if base_params[locale].blank?
      base_params[locale].each do |attr, value|
        return unless to_permit.include?(attr.to_sym)
        result["#{attr}_#{locale.to_s}".to_sym] = value
      end
    end
    return result
  end

  def registration_params
    params.require(:user).permit()
  end
end
