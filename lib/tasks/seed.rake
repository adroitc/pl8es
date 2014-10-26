#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

namespace :seed do
  require 'yajl'
  desc 'import overpass-json file to database'
  task :byfile, [:filepath] => :environment do |t, args|

    PASS = '3fk!dF(pp'

    begin
      jsonfile = File.open(args.filepath, 'r')
    rescue
      abort "'#{args.filepath}' not found"
    end

    puts "starting import via '#{args.filepath}'"

    parser = Yajl::Parser.new
    hash = parser.parse(jsonfile)

    success_counter = 0
    fail_counter = 0

    hash['elements'].each do |restaurantObj|

      probably_next_user_id = User.maximum(:id).next

      user_model = User.new({
        :email => probably_next_user_id.to_s + '@dailycious.co',
        :password => PASS,
        :password_confirmation => PASS,
        :last_login => DateTime.now,
        :product_referer => 'g'
      })

      restaurant_model = Restaurant.new({
        :user => user_model,
        :name => restaurantObj['tags']['name'],
        :website => web_from(restaurantObj['tags']),
        :telephone => phone_from(restaurantObj['tags']),
        :default_language => Language.first,
        :menuColorTemplate => MenuColorTemplate.first,
        :supportedFont => SupportedFont.first
      })

      address = Location.validate_address({
        :address => address_from(restaurantObj['tags']),
        :zip => restaurantObj['tags']['addr:postcode'],
        :city => 'Vienna',
        :country => 'Austria'
      })

      if address.nil? && restaurantObj['type'].eql?('node')
        address = {
          :address => address_from(restaurantObj['tags']),
          :zip => restaurantObj['tags']['addr:postcode'],
          :city => 'Vienna',
          :country => 'Austria',
          :latitude => restaurantObj['lat'],
          :longitude => restaurantObj['lon']
        }
      end

      if user_model.valid? && user_model.errors.count == 0 && restaurant_model.valid? && restaurant_model.errors.count == 0 && address != nil

        user_model.save

        restaurant_model.save
        restaurant_model.update_attributes({
          :location => Location.create(address)
        })

        success_counter += 1
        puts 'saved: ' + restaurantObj['tags']['name']

      else
        puts 'could not save: ' + restaurantObj['tags']['name']
        puts '  user errors: ' + user_model.errors.messages.to_s
        puts '  restaurant errors: ' + restaurant_model.errors.messages.to_s

        if address.nil?
          puts '  could not locate ' + address_from(restaurantObj['tags'])
        end

        fail_counter += 1

      end

    end

    jsonfile.close

  end

  def remove_old_import_data
    User.destroy(:product_referer => 'g')
  end

  def address_from(tags)

    s = StringIO.new
    s << tags['addr:street']
    s << ' '
    s << tags['addr:housenumber']

    return s.string

  end

  def phone_from(tags)

    if tags.key?('phone')
      return tags['phone']
    end

    if tags.key?('contact:phone')
      return tags['contact:phone']
    end

    return nil

  end

  def web_from(tags)

    if tags.key?('website')
      return tags['website']
    end

    if tags.key?('contact:website')
      return tags['contact:website']
    end

    if tags.key?('url')
      return tags['url']
    end

    return nil

  end

end