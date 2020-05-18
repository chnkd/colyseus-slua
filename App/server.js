const app = new (require('colyseus').Server)({
  server: require('http').createServer()
})
class Battle extends require('colyseus').Room {
  onCreate (options) {
    this.autoDispose = false
    this.maxClients = options.maxClients
    this.reservedTime = options.reservedTime
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
    this.setState(new Sync())
  }
  async onLeave (client, consented) {
    console.info('leaved')
    var isRemoval
    if (consented) {
      isRemoval = !this.autoDispose
    } else {
      console.info('reserved')
      isRemoval = await this.allowReconnection(client, this.reservedTime).then(function () {
        console.info('rejoined')
        return false
      }.bind(this)).catch(function () {
        if (this.autoDispose) {
          return false
        } else {
          return true
        }
      }.bind(this))
    }
    if (isRemoval) {
      this.disconnect()
    }
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
