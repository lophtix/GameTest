extends KinematicBody2D

export (int) var velocity = 100
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	move_and_collide(direction*velocity)
