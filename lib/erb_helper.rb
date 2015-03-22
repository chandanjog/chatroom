class ErbHelper
  def self.load_erb(filename, variable, value)
    binding_object = binding
    binding_object.local_variable_set(variable, value)
    ERB.new(File.new(filename).read).result(binding_object)
  end
end
