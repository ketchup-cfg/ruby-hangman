# frozen_string_literal: true

require 'msgpack'

# Module to allow for call to become serializable as JSON
module Serializable
  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    obj.to_msgpack
  end

  def unserialize(string)
    obj = MessagePack.unpack(string)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
