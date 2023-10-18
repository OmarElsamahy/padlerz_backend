class BaseApiController < ApplicationController
  include ResponseHelper
  include ParamsHelper
  include ExceptionHandler
  include Authorization
  include JsonWebToken
  include Api::V1::Lookups::LookupsSetters
  include Api::V1::PhoneHandler

  before_action :set_time_zone
  before_action :set_current_city
  around_action :use_time_zone
  before_action :authorize_request
  before_action :authorize_action!
  before_action :check_verified
  before_action :set_paging_parameters
  before_action :set_email_params

  def set_time_zone
    if request.headers["Timezone"].present? && ActiveSupport::TimeZone[request.headers["Timezone"].to_s].present?
      @time_zone = request.headers["Timezone"].to_s
    else
      @time_zone = "UTC"
    end
    puts "TIME ZONE IS #{@time_zone}"
  end

  def set_current_city
    if request.headers["City"].present?
      @current_city = request.headers["City"].to_i
      @current_fulfillment_center_city = GoogleCity.find(@current_city).fulfillment_center
      puts "Current City is #{@current_city} , Fulfilled By #{@current_fulfillment_center_city.key}"
    end
  end

  def use_time_zone
    Time.use_zone(@time_zone) { yield }
  end

  def set_paging_parameters
    @page = 1
    @per_page = 10
    @per_page = params[:page_size].to_i if params[:page_size].present?
    @page = params[:page_number].to_i if params[:page_number].present?
  end

  def paginate_collection(collection)
    @pagination_info = { total_count: collection.reorder(nil).size, page_number: @page, page_size: @per_page }
    return (collection.loaded? rescue true) ?
             Kaminari.paginate_array(collection).page(@page).per(@per_page) : collection.page(@page).per(@per_page)
  end

  def is_number?(string)
    true if Float(string) rescue false
  end

  def set_email_params
    if params[:user].present? && !params[:user][:email].blank?
      params[:user][:email] = params[:user][:email].downcase
    end
  end

  def current_user
    @current_user
  end

  def current_ability
    controller_name_segments = params[:controller].split("/")
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join("/").camelize
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end
end
