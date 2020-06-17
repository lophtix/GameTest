extends Node2D

export (float) var offset = 50
export (String) var bulletLocation

var sprite
var bulletContainer
var bulletScene

# Called when the node enters the scene tree for the first time.
func _ready():
	self.sprite = self.get_children()[0]
	self.bulletContainer = get_tree().get_nodes_in_group("containers")[0]
	self.bulletScene = load(bulletLocation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	positioning()
	if (Input.is_action_just_pressed("ui_fire")):
		shoot()

func positioning():
	self.position = (get_viewport().get_mouse_position() - get_viewport().size/2).normalized()*offset
	self.rotation = self.position.angle()
	if (self.position.x < 0):
		sprite.flip_v = true
	else:
		sprite.flip_v = false

func shoot():
	var bullet = self.bulletScene.instance()
	bullet.direction = self.position.normalized()
	bullet.rotation = self.position.angle()
	bullet.position = self.global_position + self.position
	self.bulletContainer.add_child(bullet)
