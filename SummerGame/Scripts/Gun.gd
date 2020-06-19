extends Node2D

export (float) var offset = 50
export (String) var bulletLocation

var sprite
var bulletContainer
var bulletScene

remote var puppet_pos
remote var puppet_rot
remote var sprite_flip

# Called when the node enters the scene tree for the first time.
func _ready():
	puppet_pos = position
	puppet_rot = rotation
	self.sprite = self.get_children()[0]
	self.bulletContainer = get_tree().get_root().get_node("/root/Menu/Main/BulletContainer")
	self.bulletScene = load(bulletLocation)
	sprite_flip = sprite.flip_v


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_network_master():
		positioning()
		if (Input.is_action_just_pressed("ui_fire")):
			rpc("shoot", get_tree().get_network_unique_id())
		puppet_pos = position
		puppet_rot = rotation
		rset("sprite_flip", sprite_flip)
		rset("puppet_pos", puppet_pos)
		rset("puppet_rot", puppet_rot)
	else:
		position = puppet_pos
		rotation = puppet_rot
		sprite.flip_v = sprite_flip

func positioning():
	self.position = (get_viewport().get_mouse_position() - get_viewport().size/2).normalized()*offset
	self.rotation = self.position.angle()
	if (self.position.x < 0):
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	sprite_flip = sprite.flip_v

remotesync func shoot(id):
	var bullet = self.bulletScene.instance()
	var gun = get_tree().get_root().get_node("/root/Menu/Main/PlayerContainer/" + id as String +"/Gun")
	bullet.direction = gun.position.normalized()
	bullet.rotation = gun.position.angle()
	bullet.position = gun.global_position + gun.position
	self.bulletContainer.add_child(bullet)
