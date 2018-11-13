# window.THREE = require('three')

Entry       = require('./core/Entry')
Param       = require('./core/Param')
Conf        = require('./core/Conf')
Func        = require('./core/Func')
Tween       = require('./core/Tween')
Type        = require('./core/Type')
Scroller    = require('./core/Scroller')
Update      = require('./libs/Update')
Util        = require('./libs/Util')
Delay       = require('./libs/Delay')


Contents  = require('./top/Contents')


class Main extends Entry

  constructor: ->

    super()



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    super()

    c = new Contents({
      el:$('.l-mv')
    })
    c.init()



  # ------------------------------------
  #
  # ------------------------------------
  _update: =>

    super()



  # ------------------------------------
  # リサイズ
  # ------------------------------------
  _resize: =>

    super()






module.exports = Main

main = new Main()
main.init()
