extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var item
var looted
# Called when the node enters the scene tree for the first time.
func _ready():
	looted = false
	item = "Item"
	get_node("Area2D").connect("body_entered", self, "_on_body_enter")
	get_node("Area2D").connect("body_exited", self, "_on_body_exit")

func _on_body_enter(player):
	if player.name == get_tree().get_network_unique_id() as String && !looted:
		get_node("Label").show()
		player.add_box(self)

func _on_body_exit(player):
	if player.name == get_tree().get_network_unique_id() as String && !looted:
		get_node("Label").hide()
		player.remove_box(self)

func loot_box(player):
	if !looted:
		rpc("_box_looted")
		player.inventory.append(item)

remotesync func _box_looted():
		looted = true
		get_node("Label").text = "LOOTED"
		get_node("Label").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
