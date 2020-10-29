local serializers = {
    ['none'] = require('Scripts/lib/colyseus/serialization.none'),
    ['fossil-delta'] = require('Scripts/lib/colyseus.serialization.fossil_delta'),
    ['schema'] = require('Scripts/lib/colyseus.serialization.schema')
}

local exports = {}

exports.register_serializer = function(id, handler)
    serializers[id] = handler
end

exports.get_serializer = function(id)
    return serializers[id]
end

return exports
