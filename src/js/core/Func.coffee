Util     = require('../libs/Util')
Resize   = require('../libs/Resize')
Size     = require('../libs/obj/Size')
Type     = require('./Type')
Conf     = require('./Conf')
Profiler = require('./Profiler')
Scroller = require('./Scroller')
Param    = require('./Param')
Tween    = require('./Tween')

# 共通関数
class Func

  constructor: ->




  # ------------------------------------
  # レティナ値
  # ------------------------------------
  ratio: =>

    return Math.min(2, window.devicePixelRatio || 1)



  # ------------------------------------
  # スクリーンタイプ取得
  # ------------------------------------
  screen: =>

    if window.innerWidth <= Conf.BREAKPOINT
      return Type.SCREEN.XS
    else
      return Type.SCREEN.LG



  # ------------------------------------
  # スクリーンタイプ XS
  # ------------------------------------
  isXS: =>

    return (@screen() == Type.SCREEN.XS)



  # ------------------------------------
  # スクリーンタイプ LG
  # ------------------------------------
  isLG: =>

    return (@screen() == Type.SCREEN.LG)



  # ------------------------------------
  # スクリーンタイプで分岐
  # ------------------------------------
  val: (xs, lg) =>

    if @isXS()
      return xs
    else
      return lg



  # ------------------------------------
  # コクのあるサイン 1
  # ------------------------------------
  sin1: (radian) =>

    return Math.sin(radian) + Math.sin(2 * radian)



  # ------------------------------------
  # コクのあるサイン 2
  # ------------------------------------
  sin2: (radian) =>

    return (
      Math.sin(radian) +
      Math.sin(2.2 * radian + 5.52) +
      Math.sin(2.9 * radian + 0.93) +
      Math.sin(4.6 * radian + 8.94)
    ) / 4



  # ------------------------------------
  #
  # ------------------------------------
  inUrl: (str) =>

    return location.href.indexOf(str) > 0



  # ------------------------------------
  #
  # ------------------------------------
  xsVal: (val) =>

    return (val / 750) * @sw()



  # ------------------------------------
  #
  # ------------------------------------
  sw: =>

    return window.innerWidth



  # ------------------------------------
  #
  # ------------------------------------
  sh: =>

    return window.innerHeight



  # ------------------------------------
  # 画面全体の操作ON/OFF
  # ------------------------------------
  clickable: (bool) =>

    c = 'is-noPointer'

    if bool
      $('body').removeClass(c)
    else
      $('body').addClass(c)


  # ------------------------------------
  #
  # ------------------------------------
  cursorPointer: (bool) =>

    if bool
      if @_isCursorPointer != bool
        $('body,html').addClass('is-clickable')
        @_isCursorPointer = bool
    else
      if @_isCursorPointer != bool
        $('body,html').removeClass('is-clickable')
        @_isCursorPointer = bool








module.exports = new Func()
