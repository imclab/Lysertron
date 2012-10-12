// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Layers.Cube = (function(_super) {

    __extends(Cube, _super);

    function Cube(scene) {
      var material, size;
      this.scene = scene;
      material = {};
      this.uniforms = {
        beatScale: {
          type: 'f',
          value: 1
        }
      };
      size = THREE.Math.randFloat(100, 200);
      this.mesh = new THREE.Mesh(new THREE.CubeGeometry(size, size, size, 1, 1, 1), new THREE.ShaderMaterial(_.extend(this.getMatProperties('cube'), {
        uniforms: this.uniforms
      })));
      this.scene.add(this.mesh);
      this.shrinkTime = THREE.Math.randFloat(3, 5);
      this.rotSpeed = THREE.Math.randFloatSpread(180 * (Math.PI / 180));
      this.mesh.position.set(THREE.Math.randFloatSpread(600), THREE.Math.randFloatSpread(400), THREE.Math.randFloatSpread(600));
    }

    Cube.prototype.beat = function() {
      return this.uniforms.beatScale.value = 1;
    };

    Cube.prototype.update = function(elapsed) {
      this.uniforms.beatScale.value -= elapsed / this.shrinkTime;
      this.mesh.rotation.y += this.rotSpeed * elapsed;
      if (this.uniforms.beatScale.value <= 0) {
        return this.expired = true;
      }
    };

    return Cube;

  })(Layers.Base);

}).call(this);
