# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Pl8es::Application.config.session_store :cookie_store, key: "_pl8es_session", domain: ".pl8.cc"#, :expire_after => 1.month
elsif Rails.env.development?
  Pl8es::Application.config.session_store :cookie_store, key: "_pl8es_session", domain: ".lvh.me"#, :expire_after => 1.month
end