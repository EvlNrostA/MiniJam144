extends Node2D

var difficulties = {
	"easy": {

	},
	"normal": {

	},
	"hard": {

	},
}

@onready var song_file_path = "res://Levels/GuitarHero/Ed-Sheeran-Perfect-Midi-File.mp3"
@onready var player = $"Player_Tamplate"
@onready var level_timer = $"LevelTimer"
@onready var arrows = [
		$"../UpArrow",
		$"../LeftArrow",
		$"../DownArrow",
		$"../RightArrow"
	]

func _ready():
	start("normal")
	
func start(selected_difficulty):
	var difficulty = difficulties[selected_difficulty]

	# Start code

	#level_timer.wait_time = difficulty.level_timer
	#level_timer.start()
	
	#AudioStreamPlayer
	#var song_file = FileAccess.open(song_file_path, FileAccess.READ)
	#var sound = AudioStreamMP3.new() 
	#sound.data = song_file.get_buffer(song_file.get_length())
	#print(sound.data.slice(0, 100))
