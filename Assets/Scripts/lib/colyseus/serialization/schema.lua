local Schema = require('Scripts/lib/colyseus.serialization.schema.schema')
local ReferenceTracker = require('Scripts/lib/colyseus.serialization.schema.reference_tracker')

local schema_serializer = {}
schema_serializer.__index = schema_serializer

function schema_serializer.new ()
  local instance = {
    state = nil,
    refs = ReferenceTracker:new()
  }
  setmetatable(instance, schema_serializer)
  return instance
end

function schema_serializer:get_state()
  return self.state
end

function schema_serializer:set_state(encoded_state, it)
  self.state:decode(encoded_state, it, self.refs)
end

function schema_serializer:patch(binary_patch, it)
  self.state:decode(binary_patch, it, self.refs)
end

function schema_serializer:teardown()
  self.refs:clear()
end

function schema_serializer:handshake(bytes, it)
  self.state = Schema.reflection_decode(bytes, it)
end

return schema_serializer

