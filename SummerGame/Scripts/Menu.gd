extends Node

export (String) var scene

var player_location = "res://Prefabs/Player.tscn" 
var connection
var lobby

var check
var players
var player_name
var locations

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connection = get_node("Connection")
	self.lobby = get_node("Lobby")
	self.players = {}
	self.locations = [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)]

	get_tree().connect("network_peer_disconnected", self, "deregister_player")
	get_tree().connect("network_peer_connected", self, "register_to_server")
	get_tree().connect("connection_failed", self, "back_to_lobby")
	get_tree().connect("server_disconnected", self, "back_to_lobby")

func start_client():
	self.check = true
	var peer = NetworkedMultiplayerENet.new()
	var ip = get_node("Connection").get_node("Address").get_node("IPAddress").text as String
	var port = get_node("Connection").get_node("Address").get_node("Port").text as int
	self.player_name = get_node("Connection").get_node("Name").text
	peer.create_client(ip, port)
	get_tree().set_network_peer(peer)
	self.players[get_tree().get_network_unique_id()]= self.player_name
	update_lobby()

	self.connection.hide()
	self.lobby.show()

func start_server():
	self.check = false
	var peer = NetworkedMultiplayerENet.new()
	var port = get_node("Connection").get_node("Address").get_node("Port").text as int
	self.player_name = get_node("Connection").get_node("Name").text
	peer.create_server(port, 12)
	get_tree().set_network_peer(peer)
	self.players[get_tree().get_network_unique_id()] = self.player_name
	update_lobby()

	self.connection.hide()
	self.lobby.show()

func register_to_server(id):
	print(id)
	rpc_id(id, "register_player", self.player_name)

remote func register_player(register_name):
	var id = get_tree().get_rpc_sender_id()	
	self.players[id] = register_name
	update_lobby()

remote func deregister_player(id):
	self.players.erase(id)
	update_lobby()

func update_lobby():
	for child in self.lobby.get_node("players").get_children():
		child.queue_free()

	for player in self.players:
		var listed_player = Label.new()
		listed_player.text = self.players[player]
		self.lobby.get_node("players").add_child(listed_player)

func start_game():
	print("trying to start game")
	if (get_tree().is_network_server()):
		rpc("map_preperation")

remotesync func map_preperation():
	var map = load(scene).instance()
	add_child(map)
	var location = 0
	for player in self.players:
		var new_player = load(player_location).instance()
		new_player.position = self.locations[location]
		new_player.name = self.players[player]
		new_player.set_network_master(player)
		get_node("Main").get_node("PlayerContainer").add_child(new_player) 
		print(get_node("Main").get_node("PlayerContainer").get_node(self.players[player]).is_network_master())

		location+=1


func back_to_lobby():
	get_node("Lobby").hide()
	get_node("Connection").show()