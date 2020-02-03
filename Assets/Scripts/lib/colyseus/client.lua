local Connection = require('Scripts/lib/colyseus.connection')
-- local Auth = require('Scripts/lib/colyseus.auth')
local Room = require('Scripts/lib/colyseus.room')
-- local Push = require('Scripts/lib/colyseus.push')
local protocol = require('Scripts/lib/colyseus.protocol')
local EventEmitter = require('Scripts/lib/colyseus.eventemitter')
-- local storage = require('Scripts/lib/colyseus.storage')

local utils = require('Scripts/lib/colyseus.utils')
local decode = require('Scripts/lib/colyseus.serialization.schema.schema')
local json = require('Scripts/lib/colyseus.serialization.json')
local msgpack = require('Scripts/lib/colyseus.messagepack.MessagePack')

local client = {}
client.__index = client

function client.new (endpoint)
  local instance = EventEmitter:new()
  setmetatable(instance, client)
  instance:init(endpoint)
  return instance
end

function client:init(endpoint)
  self.hostname = endpoint

  -- ensure the ends with "/", to concat with path during create_connection.
  if string.sub(self.hostname, -1) ~= "/" then
    self.hostname = self.hostname .. "/"
  end

  -- self.auth = Auth.new(endpoint)
  -- self.push = Push.new(endpoint)

  self.rooms = {}
end

function client:get_available_rooms(room_name, callback)
  local requestId = self.requestId + 1
  self.connection:send({ protocol.ROOM_LIST, requestId, room_name })

  -- TODO: add timeout to cancel request.

  self.rooms_available_request[requestId] = function(rooms)
    self.rooms_available_request[requestId] = nil
    callback(rooms)
  end

  self.requestId = requestId
end

function client:join_or_create(room_name, options, callback)
  return self:create_matchmake_request('joinOrCreate', room_name, options or {}, callback)
end

function client:create(room_name, options, callback)
  return self:create_matchmake_request('create', room_name, options or {}, callback)
end

function client:join(room_name, options, callback)
  return self:create_matchmake_request('join', room_name, options or {}, callback)
end

function client:join(room_id, options, callback)
  return self:create_matchmake_request('joinById', room_id, options or {}, callback)
end

function client:reconnect(room_id, session_id, callback)
  return self:create_matchmake_request('joinById', room_id, { sessionId = session_id }, callback)
end

function client:create_matchmake_request(method, room_name, options, callback)
  if type(options) == "function" then
    callback = options
    options = {}
  end

  -- if self.auth:has_token() then
  --   options.token = self.auth.token
  -- end

  local url = "http" .. self.hostname:sub(3) .. "matchmake/" .. method .. "/" .. room_name
  self:_request(url, json.encode(options), function(err, response)
    if (err) then return callback(err) end

    local room = Room.new(room_name)
    room.id = response.room.roomId
    room.sessionId = response.sessionId

    local on_error = function(err)
      callback(err)
      room:off()
    end

    local on_join = function()
      room:off('error', on_error)
      callback(nil, room)
    end

    room:on('error', on_error)
    room:on('join', on_join)
    room:on('leave', function()
      self.rooms[room.id] = nil
    end)
    self.rooms[room.id] = room

    room:connect(self:_build_endpoint(response.room.processId .. "/" .. room.id, {sessionId = room.sessionId}))
  end)
end

function client:_build_endpoint(path, options)
  path = path or ""
  options = options or {}

  local params = {}
  for k, v in pairs(options) do
    table.insert(params, k .. "=" .. tostring(v))
  end

  return self.hostname .. path .. "?" .. table.concat(params, "&")
end

function client:_request(url, options, callback)
  coroutine.resume(coroutine.create(function()
    local post = UnityWebRequest(url, 'POST')
    post.uploadHandler = UploadHandlerRaw(Util.UTF8Bytes(options))
    post.downloadHandler = DownloadHandlerBuffer()
    post:SetRequestHeader('Content-Type', 'application/json')
    Yield(post:SendWebRequest())
    local response = post.downloadHandler.text
    local data = response ~= '' and json.decode(response)
    if not data and post.responseCode == 0 then
      return callback('offline')
    end
    local has_error = post.responseCode >= 400
    local err = nil
    if has_error or data.error then
      err = (not data or next(data) == nil) and response or data.error
    end
    callback(err, data)
  end))
end

return client
