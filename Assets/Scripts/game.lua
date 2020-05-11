local Colyseus = require('Scripts/lib/colyseus.client')
Game = {}
function Game:Start()
  local client = Colyseus.new('ws://localhost:41003')
  self.rooms = {}
  client:join_or_create('Battle', function(err, room)
    if err then
      return
    end
    room:on('statechange', function(state)
      print('new state:', require('Scripts/lib/inspect')(state))
    end)
    room:on('leave', function()
      self.rooms[room] = nil
    end)
    self.rooms[room] = {}
  end)
end
function Game:Finish()
  for room, info in self.rooms do
    room:leave(false)
  end
end
