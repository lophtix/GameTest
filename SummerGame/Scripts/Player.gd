extends KinematicBody2D

export (int) var velocity = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = Vector2()
	if Input.is_action_pressed('ui_right'):
		movement.x += 1
	if Input.is_action_pressed('ui_left'):
		movement.x -= 1
	if Input.is_action_pressed('ui_down'):
		movement.y += 1
	if Input.is_action_pressed('ui_up'):
		movement.y -= 1
	
	movement = movement.normalized()
	
	move_and_slide(movement*velocity)
