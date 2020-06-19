extends KinematicBody2D

export (int) var velocity = 100

remote var puppet_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	puppet_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_network_master():
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

		puppet_pos = position
	else:
		position = puppet_pos
	rset("puppet_pos", puppet_pos)