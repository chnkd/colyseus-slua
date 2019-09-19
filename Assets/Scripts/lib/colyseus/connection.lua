local protocol = require('Scripts/lib/colyseus.protocol')
local EventEmitter = require('Scripts/lib/colyseus.eventemitter')

local msgpack = require('Scripts/lib/colyseus.messagepack.MessagePack')

local connection = {}
connection.__index = connection

function connection.new()
  local instance = EventEmitter:new()
  setmetatable(instance, connection)
  instance:init()
  return instance
end

function connection:init()
  self._enqueuedCalls = {}
  self.state = "CONNECTING"
  -- self.is_html5 = sys.get_sys_info().system_name == "HTML5"
end

function connection:send(data)
  if self.ws and self.ws.state == "OPEN" then
    if self.is_html5 then
      -- binary frames are sent by default on HTML5
      self.ws:send(msgpack.pack(data))

    else
      -- force binary frame on native platforms
      self.ws:send(msgpack.pack(data), 0x2)
    end

  else
    -- WebSocket not connected.
    -- Enqueue data to be sent when readyState is OPEN
    table.insert(self._enqueuedCalls, { 'send', { data } })
  end
end

function connection:open(endpoint)
  -- skip if connection is already open
  if self.state == 'OPEN' then
    return
  end

  self.ws = WebSocket(endpoint)

  self.ws:RegOpenEvent(function()
    self.state = 'OPEN' -- self.ws.state
    if err then
      self:emit("error", err)
      self:emit("close", e)
      self:close()

    else
      for i,cmd in ipairs(self._enqueuedCalls) do
        local method = self[ cmd[1] ]
        local arguments = cmd[2]
        method(self, unpack(arguments))
      end

      self:emit("open")
    end
  end)

  self.ws:RegMessageEvent(function(message)
    self:emit("message", Slua.ToString(message))
  end)

  self.ws:RegCloseEvent(function(e)
    self.state = "CLOSED"
    self:emit("close", e)
  end)

  coroutine.resume(coroutine.create(function()
    Yield(self.ws:Connect())
  end))
end

function connection:close()
  self.state = "CLOSED"
  if self.ws then
    coroutine.resume(coroutine.create(function()
      self.ws:Close()
    end))
    self.ws = nil
  end
end

return connection
