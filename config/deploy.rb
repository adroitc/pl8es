# config valid only for Capistrano 3.1
lock '3.2.1'

set :rvm_ruby_version, 'ruby-2.1.1'

set :application, 'pl8es'
set :repo_url, 'git@github.com:adroitc/pl8es.git'

set :branch, 'production'
set :assets_roles, [:web, :app]

set :deploy_to, '/home/dume/pl8es'
