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


		if movement.x < 0:
			var scale = find_node("Character").get("scale")
			if scale.x > 0:
				find_node("Character").set("scale", Vector2(-scale.x, scale.y) )
		elif movement.x > 0:
			var scale = find_node("Character").get("scale")
			if scale.x < 0:
				find_node("Character").set("scale", Vector2(-scale.x, scale.y) )
		
		find_node("AnimationTree").set("parameters/Moving/blend_amount", max( abs(movement.x), abs(movement.y) ))
		movement = movement.normalized()

		move_and_slide(movement*velocity)

		puppet_pos = position
		rset("puppet_pos", puppet_pos)
	else:
		position = puppet_pos
