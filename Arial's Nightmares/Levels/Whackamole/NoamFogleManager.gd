extends Node

var noam_fogle_scene = preload("res://Nodes/Enemys/NoamFogle.tscn")
var noam_fogles = []
var count
var noam_mutex

# Called when the node enters the scene tree for the first time.
func _ready():
	var holes = get_tree().get_nodes_in_group("Holes")
	
	for i in range(3):
		var noam_fogle = noam_fogle_scene.instantiate()
		noam_fogles.append(noam_fogle)
		add_child(noam_fogles[i])
		noam_fogles[i].body_entered.connect(won_game)
		noam_fogles[i].start(holes)
		
	count = 0

func won_game(body):
	count += 1
	print("Killed ", count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
