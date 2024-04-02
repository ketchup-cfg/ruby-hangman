# frozen_string_literal: true

require 'json'

# Module to allow for call to become serializable as JSON
module Serializable
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
