module.exports = class Gridstort extends Lysertron.Layer
  uniformAttrs:
    time:      'f'
    baseColor: 'c'
    density:   'f'
    opacity:   'f'
    speed:     'f'
    spinSpeed: 'f'
    drift:     'v2'
    birth:     'f'
    death:     'f'

    ripplePositions: 'v2v'
    rippleData:      'v3v'


  initialize: ->
    @time         = THREE.Math.randFloat 0, 10
    @density      = THREE.Math.randFloat 10, 30
    @opacity      = 0.05
    @speed        = 20
    @spinSpeed    = THREE.Math.randFloatSpread(45).degToRad
    @birth        = 0
    @death        = 0
    @spawnPos     = new THREE.Vector2(
      THREE.Math.randFloatSpread(0.8)
      THREE.Math.randFloatSpread(0.8)
    )


    @ripplePositions =
      for i in [1..18]
        new THREE.Vector2

    @rippleData =
      for i in [1..18]
        new THREE.Vector3

    @drift        = new THREE.Vector2(
      THREE.Math.randFloatSpread 0.3
      THREE.Math.randFloatSpread 0.3
    )

    @baseColor  = new THREE.Color().setHSV(
      THREE.Math.randFloat 0, 1
      THREE.Math.randFloat 0.5, 1
      THREE.Math.randFloat 0.3, 0.7
    )

    @animateSpawnPoint()

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(1750, 1750)
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        depthTest:      no
        transparent:    yes
      )
    )
    @add @mesh


    @rotation.x = THREE.Math.randFloat(-160, -200).degToRad

  animateSpawnPoint: ->
    @futureSpawnPos = 
      x: (THREE.Math.randFloatSpread(0.8) for i in [0...15])
      y: (THREE.Math.randFloatSpread(0.8) for i in [0...15])

    @futureSpawnPos.x.push = @futureSpawnPos.x[@futureSpawnPos.x.length - 1]
    @futureSpawnPos.y.push = @futureSpawnPos.y[@futureSpawnPos.y.length - 1]

    new TWEEN.Tween(@spawnPos)
      .to(@futureSpawnPos, 10000)
      .interpolation(TWEEN.Interpolation.CatmullRom)
      .onComplete(=> @animateSpawnPoint() if @active)
      .start()


  onMusicEvent: (data) ->
    if data.bar
      @ripple {
        amplitude: 1.0
        frequency: 40
        x: 0
        y: 0
      }
    
    if data.segment
      @ripple {
        amplitude: 0.8
        frequency: 125
        x: @spawnPos.x
        y: @spawnPos.y
      }

  ripple: (options) ->
    start = performance.now() / 1000
    @lastRippleIndex ?= 0
    
    @rippleData[@lastRippleIndex].set(
      start
      options.amplitude
      options.frequency
    )

    @ripplePositions[@lastRippleIndex].set(
      options.x
      options.y
    )

    @lastRippleIndex++
    @lastRippleIndex = 0 if @lastRippleIndex >= @ripplePositions.length

  update: (elapsed) ->
    @birth += elapsed

    @time = performance.now() / 1000

    unless @active
      @death += elapsed
    
    @rotation.z += elapsed / 4.0

  alive: ->
    @death < 1