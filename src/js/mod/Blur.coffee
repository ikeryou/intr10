Param   = require('../core/Param')
Conf    = require('../core/Conf')
Func    = require('../core/Func')
Type    = require('../core/Type')
Util    = require('../libs/Util')
Delay   = require('../libs/Delay')
Capture = require('./Capture')

class Blur

  constructor: ->

    @_capture
    @_mesh

    @_num = 10



  # -----------------------------------
  # 初期化
  # -----------------------------------
  init: =>

    @_capture = new Capture({num:2})
    @_capture.init()

    @_mesh = new THREE.Mesh(
      new THREE.PlaneBufferGeometry(1, 1),
      new THREE.ShaderMaterial({
        vertexShader:require('../../shader/Base.vert')
        fragmentShader:require('../../shader/Gaussian.frag')
        transparent:true
        uniforms:{
          tDiffuse:{value:null}
          horizontal:{value:true}
          ratio:{value:1}
          weight:new THREE.Uniform(new Array(@_num))
          resolution:{value:new THREE.Vector2(0,0)}
        }
      })
    )
    @_capture.add(@_mesh)



  # -----------------------------------
  #
  # -----------------------------------
  getTexture: =>

    return @_capture.texture(1)



  # -----------------------------------
  #
  # -----------------------------------
  render: (opt) =>

    w = opt.w
    h = opt.h

    @_capture.size(w, h)
    @_mesh.scale.set(w, h, 1)

    u = @_mesh.material.uniforms
    u.resolution.value.set(w * Func.ratio(), h * Func.ratio())
    u.ratio.value = Func.ratio()

    weight = []
    num = u.weight.value.length
    i = 0
    t = 0
    d = opt.value
    while i < num
      r = 1 + 2 * i
      w2 = Math.exp(-0.5 * (r * r) / d)
      weight.push(w2)
      if i > 0
        w2 *= 2
      t += w2
      i++
    i = 0
    while i < num
      weight[i] /= t
      i++
    u.weight.value = weight

    # 横
    u.tDiffuse.value = opt.texture
    u.horizontal.value = true
    @_capture.render(opt.renderer, opt.camera, 0)

    # 縦
    u.tDiffuse.value = @_capture.texture(0)
    u.horizontal.value = false
    @_capture.render(opt.renderer, opt.camera, 1)




module.exports = Blur
