Param   = require('../core/Param')
Conf    = require('../core/Conf')
Func    = require('../core/Func')
Type    = require('../core/Type')
Util    = require('../libs/Util')
Delay   = require('../libs/Delay')
Capture = require('./Capture')

class Bright

  constructor: ->

    @_capture
    @_mesh



  # -----------------------------------
  # 初期化
  # -----------------------------------
  init: =>

    @_capture = new Capture()
    @_capture.init()

    @_mesh = new THREE.Mesh(
      new THREE.PlaneBufferGeometry(1, 1),
      new THREE.ShaderMaterial({
        vertexShader:require('../../shader/Base.vert')
        fragmentShader:require('../../shader/Bright.frag')
        transparent:true
        uniforms:{
          tDiffuse:{value:null}
          minBright:{value:0}
        }
      })
    )
    @_capture.add(@_mesh)



  # -----------------------------------
  #
  # -----------------------------------
  getTexture: =>

    return @_capture.texture(0)



  # -----------------------------------
  #
  # -----------------------------------
  render: (opt) =>

    w = opt.w
    h = opt.h

    @_capture.size(w, h)
    @_mesh.scale.set(w, h, 1)

    u = @_mesh.material.uniforms
    u.tDiffuse.value = opt.texture
    u.minBright.value = opt.value

    @_capture.render(opt.renderer, opt.camera)




module.exports = Bright
