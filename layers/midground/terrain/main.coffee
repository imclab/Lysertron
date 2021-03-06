module.exports = class Terrains extends Lysertron.LayerStack
  initialize: ->
    @bottom = new Terrain
    @top    = new Terrain
    @top.rotation.z = 180.degToRad

    @push @bottom
    @push @top

class Terrain extends Lysertron.Layer
  uniformAttrs:
    smoothness: 'f'
    travel: 'v2'
    maxHeight: 'f'
    beatValue: 'f'
    baseColor: 'c'

  geom: new THREE.PlaneGeometry 1500, 1000, 150, 100

  constructor: ->
    super

    @undulation    = THREE.Math.randFloat 0.5, 1.5
    @smoothness    = THREE.Math.randFloat 125, 300
    @realMaxHeight = THREE.Math.randFloat 75, 160
    @maxHeight     = @realMaxHeight * 0.5
    @baseColor     = new THREE.Color().setHSV(
      Math.random()
      THREE.Math.randFloat 0.5, 1
      1
    )
    @travelSpeed = new THREE.Vector2(
      [0, THREE.Math.randFloat(0, 0.2)]
    )

    @travel = new THREE.Vector2(
      Math.random() * 100
      Math.random() * 100
    )
    @beatValue = 1

    @terrain = new THREE.Mesh(
      @geom
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        vertexShader: assets['vert.glsl']
        fragmentShader: assets['frag.glsl']
        transparent: yes
      )
    )

    @terrain.rotation.x = -90.degToRad
    @terrain.position.y = -200
    @terrain.position.z = 500

    @add @terrain

  update: (elapsed) ->
    @beatValue -= elapsed * 2
    @beatValue = 0 if @beatValue < 0
    
    @travel.y -= @undulation * elapsed

  onBeat: (beat) ->
    new TWEEN.Tween(this)
      .to({maxHeight: beat.volume * @realMaxHeight}, beat.duration * 1000)
      .easing(TWEEN.Easing.Cubic.InOut)
      .start()
    
    @beatValue = 1

  kill: ->
    super
    new TWEEN.Tween(@terrain.position)
      .to({y: -1010}, 3.ms)
      .easing(TWEEN.Easing.Quadratic.In)
      .start()

  alive: ->
    @terrain.position.y > -1000