# Be sure to restart your server when you modify this file.

Pl8es::Application.config.session_store :cookie_store, key: "_pl8es_session"#, :expire_after => 1.month
#if Rails.env.production?
#  Pl8es::Application.config.session_store :cookie_store, key: "_pl8es_session", domain: "pl8.cc"
#elsif Rails.env.development?
#  Pl8es::Application.config.session_store :cookie_store, key: "_pl8es_session", domain: "lvh.me"
#end