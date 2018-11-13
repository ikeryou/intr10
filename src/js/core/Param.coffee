dat    = require('dat-gui')
Conf   = require('./Conf')
Type   = require('./Type')
Update = require('../libs/Update')
Resize = require('../libs/Resize')
Size   = require('../libs/obj/Size')


# ---------------------------------------------------
# パラメータ
# ---------------------------------------------------
class Param

  constructor: ->

    @fps = Type.FPS.HIGH

    @_gui

    @text = {
      guide:{value:false}
      wire:{value:false}
      allWire:{value:false}
      wave:{value:120, min:0, max:500}
      alpha:{value:170, min:0, max:200}
      r:{value:117, min:0, max:200}
      g:{value:35, min:0, max:200}
      b:{value:200, min:0, max:200}
      blending:{value:'additive', list:[
        'normal',
        'screen',
        'additive'
      ]}
    }



    @_init()



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init: =>

    Update.add(@_update)
    Resize.add(@_resize, true)
    @_update()

    if !Conf.FLG.PARAM
      return

    @_gui = new dat.GUI()
    @_addGui(@text, 'text')



    $('.dg').css('zIndex', 99999999)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _addGui: (obj, folderName) =>

    folder = @_gui.addFolder(folderName)

    for key,val of obj
      if !val.use?
        if key.indexOf('color') > 0
          folder.addColor(val, 'value').name(key)
        else
          if val.list?
            folder.add(val, 'value', val.list).name(key)
          else
            folder.add(val, 'value', val.min, val.max).name(key)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _listen: (param, name) =>

    if !name? then name = param
    @_gui.add(@, param).name(name).listen()



  # -----------------------------------
  # 更新
  # -----------------------------------
  _update: =>




  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>










module.exports = new Param()
