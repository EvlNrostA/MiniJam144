extends Player_library

var killed_count
var noam_fogle_manager

func _ready():
	self.speed = 3
	killed_count = 0
	noam_fogle_manager = $"../NoamFogleManager"

func _process(delta):
	Move2D(delta)

func killed_noam_fogle():
	killed_count += 1
	print("Killed ", killed_count)
	
	if (killed_count == noam_fogle_manager.noam_fogle_count):
		won_game()

func game_over():
	pass

func won_game():
	print("Won Game")
