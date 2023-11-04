# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :update, to: :cru
    alias_action :read, :update, to: :ru
    alias_action :accept, :approve, :complete, :reject, :cancel, :decline, to: :admin_actions
    puts "INSIDE ABILITY"
    puts "CONTROLLER NAMESPACE: #{controller_namespace}"
    user_class = user.class.name
    case controller_namespace
    when "Api::V1"
      can :manage, [:reviews, :follows]
      can :read, [:delivery_times]
      case user_class
      when "Customer"

      end
    when "Api::V1::Auth"
      can :manage, :sessions
      can [:change_password, :is_valid], :passwords
    when "Api::V1::Driver"
      case user_class
      when "Driver", "Shopper"
        can [:read, :admin_actions], :order_requests
      end
    end
    # case when admin
    return unless user_class == "AdminUser" || user_class == "Store"
    case user_class
    when "Store"
      can :ru, :stores
      can [:visit, :crud, :send_message, :clear], :chat_rooms
      return
    end
    user_privilege = user.privilege
    case user_privilege
    when "super_admin"
      can :manage, :all
      cannot :destroy, AdminUser
    when "admin"
      user_permissions = user&.role&.permissions&.where("can_read = true OR can_create = true OR can_update = true or can_delete = true")
      return unless user_permissions
      user_permissions.each do |permission|
        can :read, ActiveAdmin::Page, name: "Dashboard"
        resource_name = permission.resource_name.to_sym
        can [:read, :show_order_routes, :show_route_employees,
             :index_applied_freelancer, :index_followers, :index_followings], resource_name if permission.can_read?
        can [:create, :reorder], resource_name if permission.can_create?
        can [:update, :cancel_order, :accept_freelancer, :assign_order_routes,
             :mark_ready_for_delivery, :unassign_order_routes, :visit, :send_message, :clear], resource_name if permission.can_update?
        can :destroy, resource_name if permission.can_delete?
      end
    end
  end
end
