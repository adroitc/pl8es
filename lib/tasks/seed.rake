#!/usr/bin/env rake

# import geojson-data from overpass api as users/restaurants to database

# json files can be retrieved by
# curl -g -o import.json 'http://overpass.osm.rambler.ru/cgi/interpreter?data=[out:json][timeout:25];area%283600109166%29-%3E.area;%28node[%22amenity%22=%22restaurant%22][%22name%22][%22addr:street%22][%22addr:housenumber%22][%22addr:postcode%22]%28area.area%29;%29;out%20body;%3E;out%20skel%20qt;'

# call like
# rake seed:byfile[test/import/example.json]
# or in production
# rake seed:byfile[tmp/import.json] RAILS_ENV=production

namespace :seed do
  require 'yajl'
  desc 'import overpass-geojson file to database'
  task :byfile, [:filepath] => :environment do |t, args|

    # hardcode pwd for all imported users
    PASS = '3fk!dF(pp'
    DEFAULT_CITY = 'Vienna'
    DEFAULT_COUNTRY = 'Austria'

    begin
      jsonfile = File.open(args.filepath, 'r')
    rescue
      abort "'#{args.filepath}' not found"
    end

    remove_old_import_data

    puts 'removed old import data, starting import via '#{args.filepath}'"

    parser = Yajl::Parser.new
    hash = parser.parse(jsonfile)

    success_counter = 0
    fail_counter = 0

    hash['elements'].each do |restaurantObj|

      # thats just the max-id + 1, may not be the next autoincrement id (should work in any case nevertheless)
      probably_next_user_id = User.maximum(:id).next

      user_model = User.new({
        :email => probably_next_user_id.to_s + '@dailycious.co', # %USERID%@dailycius.co <- suffix ensures that newsletters or similar things wont be sent to imported restaurants
        :password => PASS,
        :password_confirmation => PASS,
        :last_login => DateTime.now,
        :product_referer => 'g' # g => 'generated'
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

      begin

        address = Location.validate_address({
          :address => address_from(restaurantObj['tags']),
          :zip => restaurantObj['tags']['addr:postcode'],
          :city => DEFAULT_CITY,
          :country => DEFAULT_COUNTRY
        })

      rescue Exception => e
        puts 'could not google-validate: ' + e.message + ' taking osm-data'
      end

      # if google could not locate the address, and the restaurant is available als node (point)
      # then pick the lat/lon values from the geojson

      if address.nil? && restaurantObj['type'].eql?('node')
        address = {
            :address => address_from(restaurantObj['tags']),
            :zip => restaurantObj['tags']['addr:postcode'],
            :city => DEFAULT_CITY,
            :country => DEFAULT_COUNTRY,
            :latitude => restaurantObj['lat'],
            :longitude => restaurantObj['lon']
        }
      end

      if user_model.valid? && user_model.errors.count == 0 && restaurant_model.valid? && restaurant_model.errors.count == 0 && address != nil

        user_model.save
        user_model.update_attributes({
          :email => user_model.id.to_s + '@dailycious.co'
        })

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

    puts 'import finished. imported ' + success_counter.to_s + ' restaurants; ' + fail_counter.to_s + ' fails.'

  end

  # removes als users/restaurants/locations which were imported.
  def remove_old_import_data

    Location.connection.execute("
      delete from locations
      where locations.id in (
      select id from locations
      join (
        select restaurants.id as 'restid' from restaurants
        join users on (restaurants.user_id = users.id AND users.product_referer = 'g')
      ) as 'genrest' on (genrest.restid = locations.restaurant_id)
      );
    ", :skip_logging)

    Restaurant.connection.execute("
      delete from restaurants
      where restaurants.user_id in (
        select users.id from users where users.product_referer = 'g'
      );
    ", :skip_logging)

    User.connection.execute("
      delete from users
      where users.product_referer = 'g'
    ", :skip_logging)

  end

  # concat address-tags and return as string
  def address_from(tags)

    s = StringIO.new
    s << tags['addr:street']
    s << ' '
    s << tags['addr:housenumber']

    return s.string

  end

  # return phone number as string or nil if not available
  # tag priority 'phone' > 'contact:phone'
  def phone_from(tags)

    if tags.key?('phone')
      return tags['phone']
    end

    if tags.key?('contact:phone')
      return tags['contact:phone']
    end

    return nil

  end

  # return website as string, or nil if not available
  # tag priority 'website' > 'contact:website' > 'url'
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