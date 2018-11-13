window.$                     = require('jquery')
window.requestAnimationFrame = require('raf')
window.TweenMax              = require('gsap').TweenMax
window.CustomEase            = require('gsap').CustomEase
window.TimelineMax           = require('gsap').TimelineMax
window.isMobile              = require('ismobilejs')

Param    = require('./Param')
Profiler = require('./Profiler')
Func     = require('./Func')
Delay    = require('../libs/Delay')
Util     = require('../libs/Util')
Resize   = require('../libs/Resize')
Update   = require('../libs/Update')


# エントリーポイント
class Entry

  constructor: ->

    @isJp = (window.navigator.userLanguage || window.navigator.language || window.navigator.browserLanguage).substr(0,2) == 'ja'



  # ------------------------------------
  # 初期化
  # ------------------------------------
  init: =>

    window.main = @

    console.warn = =>
      return

    # console.log = =>
    #   return

    Number.isNaN = Number.isNaN || (any) ->
      return typeof any == 'number' && isNaN(any)

    # $('a:not([href])').attr('href', 'javascript:void(0)')
    $('a:not([href])').addClass('l-btn')

    # SVGのあと読み
    $('.js-svgload').each((i,e) =>
      el = $(e)
      svg = el.attr('data-svg')
      el.load(svg + ' svg')
    )

    # 背景画像セット
    $('.js-bgImg').each((i,e) =>
      el = $(e)
      el.css({
        backgroundImage:'url("' + el.attr('data-bg') + '")'
      })
    )

    if isMobile.any
      $('body').addClass('is-sp')
      $('.is-hover').removeClass('is-hover')
      if isMobile.android.device
        $('body').addClass('is-android')
    else
      $('body').addClass('is-pc')

    if Util.isIE()
      $('body').addClass('is-ie')

    if Util.isFF()
      $('body').addClass('is-ff')


    Resize.add(@_resize, true)
    Update.add(@_update)



  # ------------------------------------
  #
  # ------------------------------------
  _update: =>




  # ------------------------------------
  # リサイズ
  # ------------------------------------
  _resize: =>

    sw = window.innerWidth

    if isMobile.any
      sh = screen.height
    else
      sh = window.innerHeight

    $('.js-fix').css({
      width:sw
      height:sh
    })

    $('.js-resImg').each((i,e) =>
      el = $(e)
      if Func.isXS()
        el.attr('src', el.attr('data-xs'))
      else
        el.attr('src', el.attr('data-lg'))
    )








module.exports = Entry
