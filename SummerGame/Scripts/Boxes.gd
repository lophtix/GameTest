extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Area2D").connect("body_entered", self, "_on_body_enter")
	get_node("Area2D").connect("body_exited", self, "_on_body_exit")

func _on_body_enter(player):
	if player.name == get_tree().get_network_unique_id() as String:
		get_node("Label").show()

func _on_body_exit(player):
	if player.name == get_tree().get_network_unique_id() as String:
		get_node("Label").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
