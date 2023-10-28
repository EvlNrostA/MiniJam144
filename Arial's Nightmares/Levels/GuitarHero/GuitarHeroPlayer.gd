extends Node



var arrows
var song_file_path = "res://Levels/GuitarHero/Ed-Sheeran-Perfect-Midi-File.mp3"

func _ready():
	arrows = [
		$Up,
		$Left,
		$Down,
		$Right
	]
	AudioStreamPlayer
	var song_file = FileAccess.open(song_file_path, FileAccess.READ)
	var sound = AudioStreamMP3.new() 
	sound.data = song_file.get_buffer(song_file.get_length())
	print(sound.data.slice(0, 100))

func _process(delta):
	pass
