require 'net/http'

class Dialect
  attr_reader :name, :slug, :endpoint

  def initialize(hash)
    hash.each do |key, value|
      self.instance_variable_set("@#{key}", value)
    end
  end

  def translate(message)
    res = Net::HTTP.get_response(uri(message))
    return message unless res.is_a?(Net::HTTPSuccess)
    if slug == 'pirate'
      JSON.parse(res.body)['translation']['pirate']
    else
      Nokogiri::HTML(res.body).css('blockquote p').text.strip
    end
  end

  def self.all
    file = File.expand_path('../../../config/dialects.yml', __FILE__)
    all ||= YAML.load_file(file).collect do |item|
      Dialect.new(name: item['name'], slug: item['slug'], endpoint: item['endpoint'])
    end
  end

  def self.find(slug)
    all.select{|x| x.slug == slug}.first
  end

  def self.select_options
    all.collect{|x| [x.name, x.slug]}
  end

  private

  def uri(message)
    uri = URI(endpoint)
    uri.query = URI.encode_www_form(request_params(message))
    uri
  end

  def request_params(message)
    slug == 'pirate' ? {:text => message, :format => 'json'} : {:d => slug, :w => message}
  end
end
