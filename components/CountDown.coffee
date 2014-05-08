noflo = require("noflo")

class CountDown extends noflo.Component

  description: "count down from particular number, by default 1, and
    send an empty IP when it hits 0"

  constructor: ->
    @default = @count = 1
    @repeat = true

    @inPorts =
      in: new noflo.Port 'bang'
      count: new noflo.Port 'int'
      repeat: new noflo.Port 'boolean'
    @outPorts =
      out: new noflo.Port 'bang'
      count: new noflo.Port 'int'

    @inPorts.count.on "data", (@count) =>
      @default = @count

    @inPorts.repeat.on "data", (@repeat) =>
      @default = null unless @repeat

    @inPorts.in.on "disconnect", =>
      if --@count is 0
        @outPorts.out.send(null)
        @outPorts.out.disconnect()

        @count = @default if @repeat

exports.getComponent = -> new CountDown
