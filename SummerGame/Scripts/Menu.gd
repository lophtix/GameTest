extends Node

export (String) var scene

var check
var network

var player_location = "res://Prefabs/Player.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_client():
	self.check = true
	self.network = NetworkedMultiplayerENet.new()
	var ip = get_child(0).get_child(0).get_child(0).text as String
	var port = get_child(0).get_child(0).get_child(1).text as int
	self.network.create_client(ip, port)
	get_tree().set_network_peer(self.network)

	self.get_child(0).hide()
	var gameScene = load(scene).instance()
	get_tree().get_root().add_child(gameScene)

	var player = load(player_location).instance()
	player.set_network_master(get_tree().get_network_unique_id())
	get_tree().get_root().get_node("Main").add_child(player)

func start_server():
	self.check = false
	self.network = NetworkedMultiplayerENet.new()
	var ip = get_child(0).get_child(0).get_child(0).text as String
	var port = get_child(0).get_child(0).get_child(1).text as int
	self.network.create_server(port, 12)
	get_tree().set_network_peer(self.network) 
	
	self.get_child(0).hide()
	var gameScene = load(scene).instance()
	get_tree().get_root().add_child(gameScene)

	var player = load(player_location).instance()
	player.set_network_master(get_tree().get_network_unique_id())
	get_tree().get_root().get_node("Main").add_child(player)

remote func player_server():
	var id = get_tree().get_rpc_sender_id()
	print("Server: " + id as String)
	var player = load(player_location).instance()
	player.set_network_master(id)
	get_tree().get_root().get_node("Main").add_child(player)
	rpc_id(id, "player")

remote func player():
	var id = get_tree().get_rpc_sender_id()
	print("client: " + id as String)
	var player = load(player_location).instance()
	player.set_network_master(id)
	get_tree().get_root().get_node("Main").add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (check):
		print(self.network.get_connection_status())
		if (self.network.get_connection_status() == 2):
			rpc("player_server")
			self.check = false
