Geocoder.configure(ip_lookup: :geoip2, geoip2: {
  file: File.expand_path('../../data/GeoLite2-City.mmdb', __FILE__)
})
