Conf   = require('./Conf')
Tween  = require('./Tween')
Param  = require('./Param')
Type   = require('./Type')
Util   = require('../libs/Util')
Update = require('../libs/Update')
Resize = require('../libs/Resize')
Size   = require('../libs/obj/Size')


class Scroller

  constructor: ->

    @_elWin = $(window)

    @normal = 0
    @val = $(window).scrollTop()
    @docSize = new Size()

    @power = 0
    @powerNormal = 0
    @powerAbs = 0

    @_bufferNormal = 0

    @_powerTg = 0

    @sw = 0
    @sh = 0

    @_cnt = 0

    @_isUse = true

    @isLoop = false

    @isAutoScroll = true

    @onLoop = []

    @_wait = 0

    @_init()



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init: =>

    Update.add(@_update)
    Resize.add(@_resize, true)

    @setNormal(0.1)

    @_update()



  # -----------------------------------
  #
  # -----------------------------------
  setUse: (bool) =>

    @_isUse = bool
    if @_isUse
      $('.js-height').removeClass('is-none')
    else
      $('.js-height').addClass('is-none')



  # -----------------------------------
  # 更新
  # -----------------------------------
  _update: =>

    param = Param.scroll



  # -----------------------------------
  #
  # -----------------------------------
  _eScrollLoop: =>

    for val,i in @onLoop
      if val? then val()



  # -----------------------------------
  #
  # -----------------------------------
  _resetPower: =>

    @val = @_elWin.scrollTop()



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    #@docSize.height = $(document).height()

    @sw = window.innerWidth
    @sh = window.innerHeight



  # -----------------------------------
  #
  # -----------------------------------
  set: (val) =>

    @_elWin.scrollTop(val)
    # window.scrollTo(0, val)
    @val = val



  # -----------------------------------
  #
  # -----------------------------------
  setNormal: (val) =>

    s = ($(document).height() + window.innerHeight) * val
    @_elWin.scrollTop(s)



  # -----------------------------------
  #
  # -----------------------------------
  move: (opt) =>

    dura = opt.duration || 1
    delay = opt.delay || 0

    Tween.a($('html,body'), {
      scrollTop:opt.tg
    }, dura, delay, Power2.easeInOut)





module.exports = new Scroller()
