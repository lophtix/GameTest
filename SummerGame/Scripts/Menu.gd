extends Node

export (String) var scene

var player_location = "res://Prefabs/Player.tscn" 
var connection
var lobby

var check
var players
var player_name

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connection = get_node("Connection")
	self.lobby = get_node("Lobby")
	self.players = {}

func start_client():
	self.check = true
	var peer = NetworkedMultiplayerENet.new()
	var ip = get_node("Connection").get_node("Address").get_node("IPAddress").text as String
	var port = get_node("Connection").get_node("Address").get_node("Port").text as int
	self.player_name = get_node("Connection").get_node("Name").text
	peer.create_client(ip, port)
	get_tree().set_network_peer(peer)
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

remote func register_player(register_name):
	var id = get_tree().get_rpc_sender_id()
	print(register_name)
	self.players[id] = register_name as String
	for player in self.players:
		rpc("update_players",self.players[player], player)
	update_lobby()

remote func update_players(register_name, id):
	self.players[id] = register_name
	update_lobby()

func update_lobby():
	for child in self.lobby.get_node("players").get_children():
		child.queue_free()

	for player in self.players:
		var listed_player = Label.new()
		listed_player.text = self.players[player]
		self.lobby.get_node("players").add_child(listed_player)

func _process(delta):
	if (self.check):
		if (get_tree().network_peer.get_connection_status() == 2):
			self.check = false
			rpc("register_player", self.player_name)
