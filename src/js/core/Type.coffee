
class Type

  constructor: ->

    # スクリーンタイプ
    # XS : スマホ系
    # LG : PC系
    @SCREEN = {
      XS : 0
      LG : 1
    }

    @FPS = {
      HIGH:0
      LOW:1
      NONE:2
    }





module.exports = new Type()
