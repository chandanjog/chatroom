require 'ostruct'

class ErbHelper
  def self.load_erb(filename, hash)
    namespace = OpenStruct.new(hash)
    ERB.new(File.new(filename).read).result(namespace.instance_eval { binding })
  end
end
