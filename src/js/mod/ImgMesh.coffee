Param     = require('../core/Param')
Conf      = require('../core/Conf')
Tween     = require('../core/Tween')
Util      = require('../libs/Util')
TexLoader = require('../data/TexLoader')


class ImgMesh extends THREE.Mesh


  constructor: (opt) ->

    super(
      new THREE.PlaneBufferGeometry(1, 1),
      new THREE.ShaderMaterial({
        vertexShader:require('../../shader/Base.vert')
        fragmentShader:require('../../shader/Image.frag')
        transparent:true
        side:THREE.DoubleSide
        uniforms:{
          tDiffuse:{value:null}
          alpha:{value:1}
        }
      })
    )

    @_opt = opt || {}
    @_tex



  # -----------------------------------------------
  #
  # -----------------------------------------------
  init: =>

    if @_opt.src?
      @setSrc(@_opt.src)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  setSrc: (src) =>

    if @_tex?
      @_tex.dispose()
      @_tex = null

    @_tex = TexLoader.get(src)
    # @_tex = new THREE.TextureLoader().load(src)
    # @_tex.magFilter = THREE.NearestFilter
    # @_tex.minFilter = THREE.NearestFilter

    @material.uniforms.tDiffuse.value = @_tex




  # -----------------------------------------------
  #
  # -----------------------------------------------
  alpha: (val) =>

    @material.uniforms.alpha.value = val



  # -----------------------------------------------
  #
  # -----------------------------------------------
  size: (size) =>

    if size?
      @scale.set(size, size, 1)
    else
      return @scale.x



  # -----------------------------------------------
  #
  # -----------------------------------------------
  width: =>

    return @scale.x



  # -----------------------------------------------
  #
  # -----------------------------------------------
  height: =>

    return @scale.y






module.exports = ImgMesh
