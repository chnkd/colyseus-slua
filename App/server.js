const app = new (require('colyseus').Server)({
  server: require('http').createServer()
})
class Battle extends require('colyseus').Room {
  onCreate (options) {
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
}
app.define('Battle', Battle)
app.onShutdown(async () => {
  console.info('close')
})
app.listen(41003, '::', 511, () => {
  console.info('open')
})
