extends Node2D

class_name FireEffect

@onready var particle: GPUParticles2D = $GPUParticles2D

static var pool:Array[FireEffect]

static func fetch_effect(prefab: PackedScene, parent: Node2D) -> FireEffect:
	for vfx in pool:
		if vfx.is_ready:
			return vfx
			
	var vfx = prefab.instantiate()
	parent.add_child(vfx)
	pool.append(vfx)
	return pool.back()

var is_ready = true

func play_vfx(location: Vector2) -> void:
	is_ready = false
	position = location
	particle.restart()
	
func _on_vfx_finished():
	is_ready = true
