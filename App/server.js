const app = new (require('colyseus').Server)({
  server: require('http').createServer()
})
const { Schema, defineTypes } = require('@colyseus/schema')
class Sync extends Schema {
  constructor () {
    super()
    this.name = 'tourn'
  }
}
defineTypes(Sync, {
  name: 'string'
})
class Battle extends require('colyseus').Room {
  onCreate (options) {
    this.autoDispose = false
    this.maxClients = options.maxClients
    this.reservedTime = options.reservedTime
    this.setState(new Sync())
  }

  async allowReconnection (client) {
    console.info('reserve')
    return await super.allowReconnection(client, this.reservedTime).then(() => {
      console.info('rejoin')
      return true
    }).catch(() => {
      if (this.autoDispose) {
        return true
      } else {
        console.log('available')
        return false
      }
    })
  }

  async isReserved (client, consented) {
    return consented ? this.autoDispose : await this.allowReconnection(client)
  }

  async onLeave (client, consented) {
    console.info('leave')
    if (await this.isReserved(client, consented)) {
      return
    }
    this.disconnect()
  }

  async onDispose () {
    console.info('dispose')
  }
}
app.define('Battle', Battle, {
  maxClients: 1,
  reservedTime: 15
})
app.onShutdown(async () => {
  console.info('close')
})
app.listen(41003, '::', 511, () => {
  console.info('open')
})
