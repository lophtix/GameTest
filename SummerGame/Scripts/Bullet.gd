extends KinematicBody2D

class_name Bullet

export (int) var velocity = 100
var direction
var timeAlive = 0
export var maxLifetime = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	move_and_collide(direction*velocity)
	timeAlive += delta
	if timeAlive > maxLifetime:
		self.queue_free()

