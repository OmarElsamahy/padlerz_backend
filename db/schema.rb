# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_11_02_092306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "name"
    t.string "lookup_key"
    t.string "lat"
    t.string "long"
    t.text "full_address"
    t.string "district"
    t.string "street_information"
    t.string "landmark"
    t.boolean "is_hidden"
    t.boolean "is_default"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
  end

  create_table "admin_priviliges", force: :cascade do |t|
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "privilege"
    t.bigint "role_id"
    t.string "name"
    t.string "phone_number", default: ""
    t.string "country_code", default: ""
    t.string "firebase_uid"
    t.string "avatar"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_admin_users_on_role_id"
  end

  create_table "between_zones_fees", force: :cascade do |t|
    t.bigint "origin_zone_id"
    t.bigint "destination_zone_id"
    t.string "delivery_fees", default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destination_zone_id"], name: "index_between_zones_fees_on_destination_zone_id"
    t.index ["origin_zone_id"], name: "index_between_zones_fees_on_origin_zone_id"
  end

  create_table "cart_gift_cards", force: :cascade do |t|
    t.integer "card_type"
    t.string "title"
    t.text "message"
    t.string "attachment_link"
    t.string "voice_message_link"
    t.bigint "gift_card_id"
    t.bigint "cart_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_cart_gift_cards_on_cart_id"
    t.index ["gift_card_id"], name: "index_cart_gift_cards_on_gift_card_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "variant_id", null: false
    t.integer "quantity", default: 1
    t.float "original_amount"
    t.float "amount"
    t.integer "status", default: 0
    t.datetime "checked_out_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "wishlist_id"
    t.integer "current_city_id"
    t.integer "current_city_fulfillment_center_id"
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["variant_id"], name: "index_cart_items_on_variant_id"
    t.index ["wishlist_id"], name: "index_cart_items_on_wishlist_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.float "original_amount"
    t.float "amount"
    t.integer "state", default: 0
    t.datetime "checked_out_at"
    t.text "special_instructions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_address_id"
    t.float "redeemed_from_wallet", default: 0.0
    t.float "weight", default: 0.0
    t.float "route_one_delivery_fees", default: 0.0
    t.float "route_two_delivery_fees", default: 0.0
    t.float "delivery_fees", default: 0.0
    t.index ["customer_id"], name: "index_carts_on_customer_id"
    t.index ["delivery_address_id"], name: "index_carts_on_delivery_address_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chat_members", force: :cascade do |t|
    t.bigint "chat_room_id", null: false
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "first_join"
    t.datetime "last_seen"
    t.boolean "is_muted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_chat_members_on_chat_room_id"
    t.index ["user_type", "user_id"], name: "index_chat_members_on_user"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "chat_room_url"
    t.string "messages_url"
    t.string "name"
    t.string "image"
    t.string "user_type"
    t.bigint "user_id"
    t.boolean "is_deleted", default: false
    t.boolean "is_direct_chat", default: false
    t.string "last_message"
    t.datetime "last_message_date"
    t.integer "status", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "extra_options_url"
    t.index ["user_type", "user_id"], name: "index_chat_rooms_on_user"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "lookup_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id"
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "lookup_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "country_code", default: ""
    t.string "phone_number", default: ""
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "unconfirmed_email"
    t.string "unconfirmed_country_code"
    t.string "unconfirmed_phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "verification_code"
    t.datetime "verification_code_sent_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "avatar"
    t.string "firebase_uid"
    t.text "provider_account_id"
    t.date "birthdate"
    t.integer "provider", default: 0
    t.integer "source", default: 0
    t.integer "status", default: 0
    t.integer "gender", default: 0
    t.boolean "enable_push", default: true
    t.boolean "enable_orders_push", default: true
    t.boolean "enable_offers_push", default: true
    t.string "invitation_code"
    t.boolean "is_verified", default: false
    t.boolean "is_email_verified", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "verification_email_token"
    t.string "lat"
    t.string "long"
    t.index ["country_code", "phone_number", "status"], name: "index_customers_on_country_code_and_phone_number_and_status", unique: true, where: "(status = 0)"
    t.index ["email", "status"], name: "index_customers_on_email_and_status", unique: true, where: "((status = 0) AND (is_email_verified = true))"
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "declined_orders", force: :cascade do |t|
    t.string "comment"
    t.bigint "driver_id"
    t.bigint "order_declination_reason_id"
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["driver_id"], name: "index_declined_orders_on_driver_id"
    t.index ["order_declination_reason_id"], name: "index_declined_orders_on_order_declination_reason_id"
    t.index ["order_id"], name: "index_declined_orders_on_order_id"
  end

  create_table "delivery_times", force: :cascade do |t|
    t.string "description"
  end

  create_table "devices", force: :cascade do |t|
    t.string "authenticable_type"
    t.bigint "authenticable_id"
    t.text "fcm_token"
    t.integer "device_type", default: 0
    t.boolean "logged_out", default: true
    t.string "locale", default: "en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authenticable_type", "authenticable_id"], name: "index_devices_on_authenticable"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "country_code", default: ""
    t.string "phone_number", default: ""
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "unconfirmed_email"
    t.string "unconfirmed_country_code"
    t.string "unconfirmed_phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "verification_code"
    t.datetime "verification_code_sent_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "avatar"
    t.string "firebase_uid"
    t.text "provider_account_id"
    t.date "birthdate"
    t.integer "provider", default: 0
    t.integer "licences_info", default: 0
    t.integer "source", default: 0
    t.integer "status", default: 0
    t.integer "gender"
    t.string "national_id"
    t.boolean "enable_push", default: true
    t.boolean "enable_orders_push", default: true
    t.boolean "enable_offers_push", default: true
    t.string "invitation_code"
    t.boolean "is_verified", default: false
    t.boolean "is_email_verified", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id"
    t.bigint "city_id"
    t.integer "profile_status", default: 0
    t.integer "state", default: 0
    t.float "lat"
    t.float "long"
    t.string "type"
    t.integer "driver_type"
    t.float "balance", default: 0.0
    t.string "rejection_reason"
    t.index ["city_id"], name: "index_drivers_on_city_id"
    t.index ["country_code", "phone_number", "status"], name: "index_drivers_on_country_code_and_phone_number_and_status", unique: true, where: "(status = 0)"
    t.index ["country_id"], name: "index_drivers_on_country_id"
    t.index ["email", "status"], name: "index_drivers_on_email_and_status", unique: true, where: "((status = 0) AND (is_email_verified = true))"
    t.index ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true
  end

  create_table "favourites", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.string "favourite_type"
    t.bigint "favourite_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["favourite_type", "favourite_id"], name: "index_favourites_on_favourite"
    t.index ["user_id", "user_type", "favourite_id", "favourite_type"], name: "index_favourites_on_user_favourite", unique: true
    t.index ["user_type", "user_id"], name: "index_favourites_on_user"
  end

  create_table "featured_banners", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "banner"
    t.boolean "is_visible", default: true
    t.boolean "need_action"
    t.string "data"
    t.string "data_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "countdown_to"
  end

  create_table "follows", force: :cascade do |t|
    t.string "follower_type"
    t.bigint "follower_id"
    t.string "followee_type"
    t.bigint "followee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followee_type", "followee_id"], name: "index_follows_on_followee"
    t.index ["follower_id", "follower_type", "followee_id", "followee_type"], name: "index_follower_on_followee", unique: true
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower"
  end

  create_table "gift_cards", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.float "price"
    t.float "price_after_discount"
    t.float "discount_percentage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_available", default: true
    t.integer "status"
  end

  create_table "gift_histories", force: :cascade do |t|
    t.bigint "wishlist_id"
    t.bigint "variant_id"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_gift_histories_on_customer_id"
    t.index ["variant_id"], name: "index_gift_histories_on_variant_id"
    t.index ["wishlist_id"], name: "index_gift_histories_on_wishlist_id"
  end

  create_table "gift_history_variants", force: :cascade do |t|
    t.bigint "variant_id"
    t.bigint "gift_history_id"
    t.index ["gift_history_id", "variant_id"], name: "index_gift_history_variants_on_gift_history_id_and_variant_id", unique: true
    t.index ["gift_history_id"], name: "index_gift_history_variants_on_gift_history_id"
    t.index ["variant_id", "gift_history_id"], name: "index_gift_history_variants_on_variant_id_and_gift_history_id", unique: true
    t.index ["variant_id"], name: "index_gift_history_variants_on_variant_id"
  end

  create_table "google_cities", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.string "lat"
    t.string "long"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "delivery_fees", default: "0.0"
    t.boolean "is_fulfillment_center", default: false
    t.bigint "fulfillment_center_id"
    t.index ["fulfillment_center_id"], name: "index_google_cities_on_fulfillment_center_id"
  end

  create_table "google_cities_stores", force: :cascade do |t|
    t.bigint "google_city_id", null: false
    t.bigint "store_id", null: false
    t.string "lat"
    t.string "long"
    t.boolean "is_default_city", default: false
    t.string "location"
    t.index ["google_city_id", "store_id"], name: "index_google_cities_stores_on_google_city_id_and_store_id"
    t.index ["google_city_id"], name: "index_google_cities_stores_on_google_city_id"
    t.index ["store_id", "google_city_id"], name: "index_google_cities_stores_on_store_id_and_google_city_id"
    t.index ["store_id"], name: "index_google_cities_stores_on_store_id"
  end

  create_table "google_cities_variants", force: :cascade do |t|
    t.bigint "google_city_id"
    t.bigint "variant_id"
    t.boolean "purchasable", default: true
    t.boolean "track_inventory", default: true
    t.integer "count_on_hand", default: 0
    t.index ["google_city_id"], name: "index_google_cities_variants_on_google_city_id"
    t.index ["variant_id"], name: "index_google_cities_variants_on_variant_id"
  end

  create_table "job_schedules", force: :cascade do |t|
    t.string "schedulable_type"
    t.bigint "schedulable_id"
    t.datetime "time"
    t.string "worker_jid"
    t.integer "job_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["schedulable_type", "schedulable_id"], name: "index_job_schedules_on_schedulable"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "lookup_key"
    t.string "lat"
    t.string "long"
    t.text "full_address"
    t.string "district"
    t.string "street_information"
    t.boolean "is_hidden"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_locations_on_city_id"
    t.index ["country_id"], name: "index_locations_on_country_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "mediable_type"
    t.bigint "mediable_id"
    t.integer "media_type", default: 0
    t.string "file_name"
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "media_option", default: 0
    t.index ["mediable_type", "mediable_id"], name: "index_media_on_mediable"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "notification_users", force: :cascade do |t|
    t.bigint "notification_id"
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.boolean "is_seen", default: false
    t.datetime "seen_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notification_users_on_notifiable"
    t.index ["notification_id"], name: "index_notification_users_on_notification_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "notification_type"
    t.text "title"
    t.text "message"
    t.string "data"
    t.string "data_id"
    t.boolean "need_action", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "occasion_types", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.string "banner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
  end

  create_table "occasion_types_products", id: false, force: :cascade do |t|
    t.bigint "occasion_type_id", null: false
    t.bigint "product_id", null: false
    t.index ["occasion_type_id", "product_id"], name: "index_occasion_type_id_on_product_id"
    t.index ["product_id", "occasion_type_id"], name: "index_product_id_on_occasion_type_id"
  end

  create_table "occasions", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.bigint "occasion_type_id"
    t.bigint "customer_id"
    t.datetime "datetime"
    t.string "icon"
    t.string "banner"
    t.text "description"
    t.integer "repetition_type", default: 0
    t.boolean "send_reminder", default: false
    t.integer "reminder_days", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_occasions_on_customer_id"
    t.index ["occasion_type_id"], name: "index_occasions_on_occasion_type_id"
  end

  create_table "option_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "option_value_variants", force: :cascade do |t|
    t.bigint "variant_id", null: false
    t.bigint "option_value_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["option_value_id", "variant_id"], name: "index_option_value_variants_on_option_value_id_and_variant_id", unique: true
    t.index ["option_value_id"], name: "index_option_value_variants_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_option_value_variants_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_option_value_variants_on_variant_id"
  end

  create_table "option_values", force: :cascade do |t|
    t.bigint "option_type_id", null: false
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
  end

  create_table "order_complaint_reasons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_complaints", force: :cascade do |t|
    t.text "feedback"
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.string "complaint_email"
    t.index ["order_id"], name: "index_order_complaints_on_order_id"
  end

  create_table "order_declination_reasons", force: :cascade do |t|
    t.string "name"
    t.boolean "is_visible", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_reasons", force: :cascade do |t|
    t.bigint "order_complaint_id"
    t.bigint "order_complaint_reason_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_complaint_id"], name: "index_order_reasons_on_order_complaint_id"
    t.index ["order_complaint_reason_id"], name: "index_order_reasons_on_order_complaint_reason_id"
  end

  create_table "order_request_nodes", force: :cascade do |t|
    t.string "request_status"
    t.string "route_status"
    t.string "order_request_node_url"
    t.bigint "route_applied_driver_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["route_applied_driver_id"], name: "index_order_request_nodes_on_route_applied_driver_id"
  end

  create_table "order_states", force: :cascade do |t|
    t.integer "step"
    t.string "title"
    t.string "description"
    t.integer "status", default: 0
    t.bigint "order_id"
    t.bigint "location_id"
    t.datetime "fulfilled_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["location_id"], name: "index_order_states_on_location_id"
    t.index ["order_id"], name: "index_order_states_on_order_id"
  end

  create_table "order_status_changes", force: :cascade do |t|
    t.string "name"
    t.string "prev_state"
    t.string "next_state"
    t.string "stateful_type"
    t.bigint "stateful_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stateful_type", "stateful_id"], name: "index_order_status_changes_on_stateful"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "customer_id"
    t.bigint "payment_transaction_id"
    t.integer "status", default: 0
    t.datetime "completed_at"
    t.datetime "canceled_at"
    t.datetime "delivery_date"
    t.bigint "recipient_id"
    t.bigint "recipient_information_id"
    t.bigint "driver_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_address_id"
    t.boolean "need_more_info", default: true
    t.string "delivery_time"
    t.string "order_number"
    t.integer "fulfillment_center_id"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["delivery_address_id"], name: "index_orders_on_delivery_address_id"
    t.index ["driver_id"], name: "index_orders_on_driver_id"
    t.index ["payment_transaction_id"], name: "index_orders_on_payment_transaction_id"
    t.index ["recipient_id"], name: "index_orders_on_recipient_id"
    t.index ["recipient_information_id"], name: "index_orders_on_recipient_information_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.boolean "is_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lookup_key"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "payment_method_id", null: false
    t.bigint "cart_id", null: false
    t.integer "status"
    t.string "transaction_ref"
    t.float "amount"
    t.float "original_amount"
    t.string "currency"
    t.float "vat_percentage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_payment_transactions_on_cart_id"
    t.index ["payment_method_id"], name: "index_payment_transactions_on_payment_method_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "product_option_types", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "option_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["option_type_id", "product_id"], name: "index_product_option_types_on_option_type_id_and_product_id", unique: true
    t.index ["option_type_id"], name: "index_product_option_types_on_option_type_id"
    t.index ["product_id", "option_type_id"], name: "index_product_option_types_on_product_id_and_option_type_id", unique: true
    t.index ["product_id"], name: "index_product_option_types_on_product_id"
  end

  create_table "product_sub_categories", force: :cascade do |t|
    t.bigint "sub_category_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_sub_categories_on_product_id"
    t.index ["sub_category_id"], name: "index_product_sub_categories_on_sub_category_id"
  end

  create_table "product_views", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.datetime "view_date"
    t.index ["customer_id", "product_id"], name: "index_product_views_on_customer_id_and_product_id", unique: true
    t.index ["customer_id"], name: "index_product_views_on_customer_id"
    t.index ["product_id", "customer_id"], name: "index_product_views_on_product_id_and_customer_id", unique: true
    t.index ["product_id"], name: "index_product_views_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "store_id"
    t.integer "status", default: 0
    t.boolean "is_visible", default: true
    t.boolean "is_wrappable", default: false
    t.text "description"
    t.float "avg_rate", default: 0.0
    t.integer "reviews_count", default: 0
    t.string "dynamic_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thumbnail"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "recipient_informations", force: :cascade do |t|
    t.string "country_code"
    t.string "phone_number"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "reviewer_type"
    t.bigint "reviewer_id"
    t.string "reviewee_type"
    t.bigint "reviewee_id"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.float "rating", default: 0.0
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "reviewee_key", default: 0
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
    t.index ["reviewee_type", "reviewee_id"], name: "index_reviews_on_reviewee"
    t.index ["reviewer_id", "reviewer_type", "reviewee_id", "reviewee_type", "reviewable_id", "reviewable_type", "reviewee_key"], name: "entities_associated_with_review", unique: true
    t.index ["reviewer_type", "reviewer_id"], name: "index_reviews_on_reviewer"
  end

  create_table "ribbon_colors", force: :cascade do |t|
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "price"
    t.float "price_after_discount"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "resource_id"
    t.string "resource_name"
    t.bigint "role_id"
    t.boolean "can_create", default: false
    t.boolean "can_read", default: false
    t.boolean "can_update", default: false
    t.boolean "can_delete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resource_id"], name: "index_role_permissions_on_resource_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "route_applied_drivers", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "route_id"
    t.float "delivery_fees"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["driver_id"], name: "index_route_applied_drivers_on_driver_id"
    t.index ["route_id"], name: "index_route_applied_drivers_on_route_id"
  end

  create_table "route_complaint_reasons", force: :cascade do |t|
    t.string "name"
    t.boolean "is_visible"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "route_complaints", force: :cascade do |t|
    t.string "complaint_email"
    t.text "feedback"
    t.integer "status"
    t.bigint "route_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["route_id"], name: "index_route_complaints_on_route_id"
  end

  create_table "route_reasons", force: :cascade do |t|
    t.bigint "route_complaint_id"
    t.bigint "route_complaint_reason_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["route_complaint_id", "route_complaint_reason_id"], name: "index_route_reasons_on_complaint_and_reason"
    t.index ["route_complaint_id"], name: "index_route_reasons_on_route_complaint_id"
    t.index ["route_complaint_reason_id"], name: "index_route_reasons_on_route_complaint_reason_id"
  end

  create_table "route_steps", force: :cascade do |t|
    t.bigint "route_id"
    t.string "destination_type"
    t.bigint "destination_id"
    t.integer "status", default: 0
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destination_type", "destination_id"], name: "index_route_steps_on_destination"
    t.index ["route_id"], name: "index_route_steps_on_route_id"
  end

  create_table "routes", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "driver_id"
    t.string "name"
    t.integer "leg_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.bigint "order_declination_reasons_id"
    t.integer "current_step", default: 0
    t.integer "route_assigned_to"
    t.integer "range_assigned_to"
    t.integer "num_of_drivers_assigned"
    t.integer "num_of_drivers_assigned_range_2"
    t.index ["driver_id"], name: "index_routes_on_driver_id"
    t.index ["order_declination_reasons_id"], name: "index_routes_on_order_declination_reasons_id"
    t.index ["order_id"], name: "index_routes_on_order_id"
  end

  create_table "shapes", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.float "price"
    t.float "price_after_discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "weight"
    t.float "width"
    t.float "height"
    t.float "length"
    t.float "volume"
    t.bigint "wrap_id"
    t.index ["wrap_id"], name: "index_shapes_on_wrap_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.integer "no_of_views", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country_code", default: ""
    t.string "phone_number", default: ""
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "unconfirmed_email"
    t.string "unconfirmed_country_code"
    t.string "unconfirmed_phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "verification_code"
    t.datetime "verification_code_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "enable_push", default: true
    t.boolean "is_verified", default: false
    t.boolean "is_email_verified", default: false
    t.string "avatar"
    t.string "firebase_uid"
    t.integer "provider"
    t.float "lat"
    t.float "long"
    t.string "verification_email_token"
    t.text "rejection_reason"
    t.integer "profile_status"
    t.index ["country_code", "phone_number", "status"], name: "index_stores_on_country_code_and_phone_number_and_status", unique: true, where: "(status = 0)"
    t.index ["email"], name: "index_stores_on_email", unique: true
    t.index ["reset_password_token"], name: "index_stores_on_reset_password_token", unique: true
  end

  create_table "stores_tags", id: false, force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "tag_id", null: false
    t.index ["store_id", "tag_id"], name: "index_stores_tags_on_store_id_and_tag_id"
    t.index ["tag_id", "store_id"], name: "index_stores_tags_on_tag_id_and_store_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "suggested_wrappers", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "wrappable_type"
    t.float "cost"
    t.float "cost_after_discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "wrap_variant_id"
    t.bigint "ribbon_color_id"
    t.string "image"
    t.index ["ribbon_color_id"], name: "index_suggested_wrappers_on_ribbon_color_id"
    t.index ["wrap_variant_id"], name: "index_suggested_wrappers_on_wrap_variant_id"
  end

  create_table "suggested_wrappers_wrap_extras", id: false, force: :cascade do |t|
    t.bigint "suggested_wrapper_id", null: false
    t.bigint "wrap_extra_id", null: false
    t.index ["suggested_wrapper_id", "wrap_extra_id"], name: "suggested_wrapper_wrap_extra_index", unique: true
    t.index ["wrap_extra_id", "suggested_wrapper_id"], name: "wrap_extra_suggested_wrapper_index", unique: true
  end

  create_table "suggested_wrappings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "wrappable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "system_configurations", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "variant_wishlists", force: :cascade do |t|
    t.bigint "variant_id", null: false
    t.bigint "wishlist_id", null: false
    t.index ["variant_id", "wishlist_id"], name: "index_variant_wishlists_on_variant_id_and_wishlist_id", unique: true
    t.index ["variant_id"], name: "index_variant_wishlists_on_variant_id"
    t.index ["wishlist_id", "variant_id"], name: "index_variant_wishlists_on_wishlist_id_and_variant_id", unique: true
    t.index ["wishlist_id"], name: "index_variant_wishlists_on_wishlist_id"
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.boolean "is_master"
    t.integer "status", default: 0
    t.string "name"
    t.string "sku"
    t.float "price"
    t.float "price_after_discount"
    t.integer "target_gender", default: 0
    t.integer "target_age", default: 0
    t.integer "position", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "discount_percentage"
    t.float "weight"
    t.float "width"
    t.float "height"
    t.float "length"
    t.float "volume"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.bigint "wallet_id"
    t.bigint "order_id"
    t.float "amount"
    t.string "currency"
    t.integer "action_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "wallet_amount_before_transaction", default: 0.0
    t.string "wallet_amount_currency_before_transaction"
    t.float "wallet_amount_after_transaction", default: 0.0
    t.index ["order_id"], name: "index_wallet_transactions_on_order_id"
    t.index ["wallet_id"], name: "index_wallet_transactions_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.float "balance", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_type", "user_id"], name: "index_wallets_on_user"
  end

  create_table "wishlists", force: :cascade do |t|
    t.integer "list_type", default: 0
    t.bigint "customer_id", null: false
    t.bigint "occasion_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_wishlists_on_customer_id"
    t.index ["occasion_id"], name: "index_wishlists_on_occasion_id"
  end

  create_table "wrap_extras", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.float "price"
    t.float "price_after_discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "count_on_hand", default: 0
    t.boolean "purchasable", default: false
    t.boolean "track_inventory", default: false
    t.float "weight"
    t.float "width"
    t.float "height"
    t.float "length"
    t.float "volume"
  end

  create_table "wrap_extras_wrappers", id: false, force: :cascade do |t|
    t.bigint "wrapper_id", null: false
    t.bigint "wrap_extra_id", null: false
    t.index ["wrap_extra_id", "wrapper_id"], name: "index_wrap_extras_wrappers_on_wrap_extra_id_and_wrapper_id"
    t.index ["wrapper_id", "wrap_extra_id"], name: "index_wrap_extras_wrappers_on_wrapper_id_and_wrap_extra_id"
  end

  create_table "wrap_option_values", force: :cascade do |t|
    t.bigint "wrap_id"
    t.bigint "wrap_option_id"
    t.float "addition_cost"
    t.float "addition_cost_after_discount"
    t.string "image"
    t.string "presentation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["wrap_id"], name: "index_wrap_option_values_on_wrap_id"
    t.index ["wrap_option_id"], name: "index_wrap_option_values_on_wrap_option_id"
  end

  create_table "wrap_variants", force: :cascade do |t|
    t.boolean "purchasable"
    t.integer "count_on_hand"
    t.bigint "shape_id"
    t.bigint "color_id"
    t.bigint "wrap_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.boolean "track_inventory", default: false
    t.index ["color_id"], name: "index_wrap_variants_on_color_id"
    t.index ["shape_id"], name: "index_wrap_variants_on_shape_id"
    t.index ["wrap_id"], name: "index_wrap_variants_on_wrap_id"
  end

  create_table "wrappers", force: :cascade do |t|
    t.string "wrappable_type"
    t.bigint "wrappable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "cost", default: 0.0
    t.float "cost_after_discount", default: 0.0
    t.bigint "wrap_variant_id"
    t.bigint "ribbon_color_id"
    t.index ["ribbon_color_id"], name: "index_wrappers_on_ribbon_color_id"
    t.index ["wrap_variant_id"], name: "index_wrappers_on_wrap_variant_id"
    t.index ["wrappable_type", "wrappable_id"], name: "index_wrappers_on_wrappable"
  end

  create_table "wraps", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "dimensions"
  end

  create_table "zones", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.string "lat"
    t.string "long"
    t.string "radius"
    t.string "delivery_fees", default: "0.0"
    t.bigint "google_city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_fulfillment_center", default: false
    t.index ["google_city_id"], name: "index_zones_on_google_city_id"
  end

  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "customers"
  add_foreign_key "addresses", "google_cities", column: "city_id"
  add_foreign_key "admin_users", "roles"
  add_foreign_key "between_zones_fees", "zones", column: "destination_zone_id"
  add_foreign_key "between_zones_fees", "zones", column: "origin_zone_id"
  add_foreign_key "cart_gift_cards", "carts"
  add_foreign_key "cart_gift_cards", "gift_cards"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "variants"
  add_foreign_key "cart_items", "wishlists"
  add_foreign_key "carts", "addresses", column: "delivery_address_id"
  add_foreign_key "carts", "customers"
  add_foreign_key "chat_members", "chat_rooms"
  add_foreign_key "cities", "countries"
  add_foreign_key "declined_orders", "drivers"
  add_foreign_key "declined_orders", "order_declination_reasons"
  add_foreign_key "declined_orders", "orders"
  add_foreign_key "drivers", "countries"
  add_foreign_key "drivers", "google_cities", column: "city_id"
  add_foreign_key "gift_histories", "wishlists"
  add_foreign_key "gift_history_variants", "gift_histories"
  add_foreign_key "gift_history_variants", "variants"
  add_foreign_key "google_cities", "google_cities", column: "fulfillment_center_id"
  add_foreign_key "google_cities_stores", "google_cities"
  add_foreign_key "google_cities_stores", "stores"
  add_foreign_key "google_cities_variants", "google_cities"
  add_foreign_key "google_cities_variants", "variants"
  add_foreign_key "locations", "cities"
  add_foreign_key "locations", "countries"
  add_foreign_key "notification_users", "notifications"
  add_foreign_key "occasions", "customers"
  add_foreign_key "occasions", "occasion_types"
  add_foreign_key "option_value_variants", "option_values"
  add_foreign_key "option_value_variants", "variants"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "order_complaints", "orders"
  add_foreign_key "order_reasons", "order_complaint_reasons"
  add_foreign_key "order_reasons", "order_complaints"
  add_foreign_key "order_request_nodes", "route_applied_drivers"
  add_foreign_key "order_states", "locations"
  add_foreign_key "order_states", "orders"
  add_foreign_key "orders", "addresses", column: "delivery_address_id"
  add_foreign_key "orders", "carts"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "customers", column: "recipient_id"
  add_foreign_key "orders", "drivers"
  add_foreign_key "orders", "payment_transactions"
  add_foreign_key "orders", "recipient_informations"
  add_foreign_key "payment_transactions", "carts"
  add_foreign_key "payment_transactions", "payment_methods"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "product_option_types", "option_types"
  add_foreign_key "product_option_types", "products"
  add_foreign_key "product_sub_categories", "sub_categories"
  add_foreign_key "product_views", "customers"
  add_foreign_key "product_views", "products"
  add_foreign_key "products", "stores"
  add_foreign_key "role_permissions", "resources"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "route_applied_drivers", "drivers"
  add_foreign_key "route_applied_drivers", "routes"
  add_foreign_key "route_complaints", "routes"
  add_foreign_key "route_reasons", "route_complaint_reasons"
  add_foreign_key "route_reasons", "route_complaints"
  add_foreign_key "route_steps", "routes"
  add_foreign_key "routes", "drivers"
  add_foreign_key "routes", "order_declination_reasons", column: "order_declination_reasons_id"
  add_foreign_key "routes", "orders"
  add_foreign_key "suggested_wrappers", "ribbon_colors"
  add_foreign_key "suggested_wrappers", "wrap_variants"
  add_foreign_key "variant_wishlists", "variants"
  add_foreign_key "variant_wishlists", "wishlists"
  add_foreign_key "variants", "products"
  add_foreign_key "wallet_transactions", "orders"
  add_foreign_key "wallet_transactions", "wallets"
  add_foreign_key "wishlists", "customers"
  add_foreign_key "wishlists", "occasions"
  add_foreign_key "wrap_option_values", "wraps"
  add_foreign_key "wrap_variants", "colors"
  add_foreign_key "wrap_variants", "shapes"
  add_foreign_key "wrap_variants", "wraps"
  add_foreign_key "wrappers", "ribbon_colors"
  add_foreign_key "wrappers", "wrap_variants"
  add_foreign_key "zones", "google_cities"
end
