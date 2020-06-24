extends KinematicBody2D

export (int) var velocity = 100

var interactable_boxes
var inventory

remote var puppet_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable_boxes = []
	inventory = []
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

		if (interactable_boxes.size() > 0 && Input.is_action_just_pressed("ui_pick_up")):
			interactable_boxes[0].loot_box(self)
			print(inventory)

		move_and_slide(movement*velocity)

		puppet_pos = position
		rset("puppet_pos", puppet_pos)
	else:
		position = puppet_pos

func add_box(box):
	interactable_boxes.append(box)

func remove_box(box):
	interactable_boxes.erase(box)

