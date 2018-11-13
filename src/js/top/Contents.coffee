Util      = require('../libs/Util')
Update    = require('../libs/Update')
Delay     = require('../libs/Delay')
Resize    = require('../libs/Resize')
Conf      = require('../core/Conf')
Param     = require('../core/Param')
Tween     = require('../core/Tween')
Func      = require('../core/Func')
Type      = require('../core/Type')
Scroller  = require('../core/Scroller')
Canvas    = require('../mod/Canvas')
Capture   = require('../mod/Capture')




class Contents extends Canvas

  constructor: (opt) ->

    super(opt)

    @_guide
    @_guidePoint = []
    @_plane = []

    @_stageColor = new THREE.Color(0x000000)



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    super()

    # カメラ
    @camera = @_makeCamera({isOrthographic:false})
    @updateCamera(@camera)

    @_resize()

    loader = new THREE.SVGLoader()
    loader.load('./assets/img/data.svg', (paths) =>

      group = new THREE.Group()
      for val,i in paths

        material = new THREE.MeshBasicMaterial( {
          color: 0xff0000,
          side: THREE.DoubleSide
        })

        waru = 100
        kake = 0.65

        shapes = val.toShapes(true)
        for val2,i2 in shapes
          geometry = new THREE.ShapeBufferGeometry(val2)
          i3 = 0
          arr = geometry.attributes.position.array
          while i3 < geometry.attributes.position.count
            @_guidePoint.push(new THREE.Vector3(
              (arr[i3 * 3 + 0] / waru - 0.5) * kake,
              (arr[i3 * 3 + 1] * -1 / waru + 0.25) * kake,
              (arr[i3 * 3 + 2] / waru) * kake
            ))
            i3++

          mesh = new THREE.Mesh(geometry, material)
          group.add(mesh)


      @mainScene.add(group)
      @_guide = group



      i = 0
      while i < 10
        # @_makeGeo([1, 3, 0.5][i])
        if i == 0
          @_makeGeo(3, 1)
        else
          @_makeGeo(Util.random(0.1, 0.5), Util.random(0.5, 1))
        i++

    )



  # -----------------------------------------------
  #
  # -----------------------------------------------
  hitGuidePoint: (p, kake) =>

    min = 0.005 * kake

    for val,i in @_guidePoint

      d = val.distanceTo(p)
      if d < min
        return true

    return false



  # -----------------------------------------------
  #
  # -----------------------------------------------
  getGuidePoint: (i) =>

    return @_guidePoint[i % (@_guidePoint.length - 1)];
    # return Util.randomArr(@_guidePoint)




  # -----------------------------------------------
  #
  # -----------------------------------------------
  _makeGeo: (segNum, kake) =>


    seg = 32 * segNum
    geometry = new THREE.PlaneBufferGeometry(1, 1, seg, seg)


    num = geometry.attributes.position.count
    arr = geometry.attributes.position.array

    #console.log(@_guidePoint.length, num)

    a_color = new Float32Array(num * 4)
    a_tg = new Float32Array(num * 3)
    a_noise = new Float32Array(num * 3)

    i = 0
    while i < num

      test = new THREE.Vector3(
        arr[i*3+0],
        arr[i*3+1],
        arr[i*3+2]
      )


      if @hitGuidePoint(test, kake)
        baseColor = new THREE.Color('hsl(' + Util.random(0, 360) + ', 80%, 50%)')
        # baseColor = new THREE.Color('hsl(' + (100) + ', 80%, 80%)')
        # p = @getGuidePoint(i);
        a = Util.random(0, 1);
      else
        baseColor = @_stageColor

        a = 0.1

      p = test

      a_color[i*4+0] = baseColor.r
      a_color[i*4+1] = baseColor.g
      a_color[i*4+2] = baseColor.b
      # a_color[i*4+3] = Util.map(i, 0, 0.8, 0, num)
      a_color[i*4+3] = a


      a_tg[i*3+0] = p.x
      a_tg[i*3+1] = p.y
      a_tg[i*3+2] = p.z

      a_noise[i*3+0] = Math.random()
      a_noise[i*3+1] = Math.random()
      a_noise[i*3+2] = Math.random()

      i++

    geometry.addAttribute('a_color', new THREE.BufferAttribute(a_color, 4))
    geometry.addAttribute('a_tg', new THREE.BufferAttribute(a_tg, 3))
    geometry.addAttribute('a_noise', new THREE.BufferAttribute(a_noise, 3))

    plane = new THREE.Mesh(
      geometry,
      new THREE.ShaderMaterial({
        transparent:true
        #blending:THREE.AdditiveBlending

        blending:THREE.CustomBlending
        blendEquation:THREE.AddEquation
        blendSrc:THREE.OneMinusDstColorFactor
        blendDst:THREE.DstAlphaFactor

        # vertexColors:THREE.VertexColors
        side:THREE.DoubleSide
        # depthTest:false
        wireframe:true
        vertexShader:require('../../shader/plane.vert')
        fragmentShader:require('../../shader/plane.frag')
        uniforms:{
          alpha:{value:0.5}
          white:{value:1}
          wire:{value:false}
          time:{value:0}
          rate:{value:0}
          wave:{value:0}
          rgb:{value:new THREE.Vector3()}
        }
      })
    )
    @mainScene.add(plane)

    @_plane.push(plane)




  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    @renderer.setClearColor(0x000000, 1)

    if @_plane.length > 0

      sw = Func.sw()
      sh = Func.sh()

      param = Param.text

      guideScale = 9
      @_guide.scale.set(guideScale, -guideScale, 1)
      @_guide.position.set(-guideScale * 100 * 0.5, guideScale * 100 * 0.25, 0)

      @_guide.visible = param.guide.value

      for val,i in @_plane

        size = Math.max(sw, sh)
        val.scale.set(size, size, 1)

        val.visible = !param.guide.value
        if param.allWire.value
          val.visible = (i == 0)

        uni = val.material.uniforms
        uni.time.value += 1
        uni.wire.value = param.allWire.value
        uni.wave.value = param.wave.value
        uni.alpha.value = param.alpha.value * 0.01

        uni.rgb.value.set(
          param.r.value * 0.01,
          param.g.value * 0.01,
          param.b.value * 0.01
        )

        mat = val.material
        mat.wireframe = param.wire.value

        switch param.blending.value
          when 'additive'
            mat.blending = THREE.AdditiveBlending
          when 'multiply'
            mat.blending = THREE.MultiplyBlending
          when 'screen'
            mat.blending      = THREE.CustomBlending
            mat.blendEquation = THREE.AddEquation
            mat.blendSrc      = THREE.OneMinusDstColorFactor
            mat.blendDst      = THREE.DstAlphaFactor
          else
            mat.blending = THREE.NormalBlending


      # @_updateGeo()

    if @isNowRenderFrame()
      @render()









  # -----------------------------------------------
  #
  # -----------------------------------------------
  render: =>

    @renderer.render(@mainScene, @camera)
    @renderCnt++



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    w = Func.sw()
    h = Func.sh()

    @updateCamera(@camera, w, h)

    @renderer.setPixelRatio(Func.ratio())
    @renderer.setSize(w, h)
    @renderer.clear()
    @render()





  # -----------------------------------------------
  # このフレームでレンダリングするかどうか
  # -----------------------------------------------
  isNowRenderFrame: =>

    return true

    #
    # if Func.isXS()
    #   return true
    # else
    #   switch Param.fps
    #     when Type.FPS.HIGH
    #       return true
    #     when Type.FPS.LOW
    #       return Update.cnt % 2 == 0
    #     else
    #       return false
    #










module.exports = Contents
