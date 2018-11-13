Util = require('../libs/Util')


class Conf

  constructor: ->

    # 本番フラグ
    @RELEASE = false

    # フラグ関連
    @FLG = {
      PARAM:true
      STATS:true
      TEST_NO_PRELOAD:isMobile.any
    };

    # 本番フラグがtrueの場合、フラグ関連は全てfalseに
    if @RELEASE
      for key,val of @FLG
        @FLG[key] = false

    # ブレイクポイント
    @BREAKPOINT = 768







module.exports = new Conf()
