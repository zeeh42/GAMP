extends Node

#--------------------
@onready var audio_player: AudioStreamPlayer = $AudioPlayer
@onready var prev_button: Button = $UI/PanelContainer/VBoxContainer/PlaybackControls/HBoxContainer/Prev
@onready var play_pause_button: Button = $UI/PanelContainer/VBoxContainer/PlaybackControls/HBoxContainer/PlayPause
@onready var next_button: Button = $UI/PanelContainer/VBoxContainer/PlaybackControls/HBoxContainer/Next
@onready var current_time: Label = $UI/PanelContainer/VBoxContainer/CurrentTime
@onready var album_art: TextureRect = $UI/PanelContainer/VBoxContainer/AlbumArt/CenterContainer/AlbumArt
@onready var currently_playing: Label = $UI/PanelContainer/VBoxContainer/CurrentlyPlaying/Label
#--------------------

#--------------------
var song_meta_data
var current_song_index : int:
	set(_song_index):
		audio_player.stream = queue[_song_index]
		current_song_index = _song_index
var playlist : Array[AudioStream]
var queue : Array[AudioStream] = [
preload("uid://dt3m04v2moipb"),
preload("uid://dqn61ehcxinty"),
preload("uid://8xp7052cmx0e"),
preload("uid://c221hgofq2n8i")
]
#--------------------

#--------Assets--------
const NO_MUSIC_ICON = preload("uid://dl1sa2jtunvrm")
#----------------------

func load_song(song:AudioStream) ->void:
	# If song too short don't load
	if song.get_length() < 30.0:
		push_error("The song will not be loaded it is too small")

	song_meta_data = MusicMeta.get_mp3_metadata(song)
	
	currently_playing.text = "%s - %s" % [song_meta_data.title, song_meta_data.artist]
	song_meta_data.print_info()
	if song_meta_data.cover == null:
		push_warning("The song has no cover image or cannot be loaded")
		album_art.texture = NO_MUSIC_ICON
	else:
		album_art.texture = song_meta_data.cover
		print(song_meta_data.cover)
	audio_player.stream = song

func _ready() -> void:
	load_song(queue[0])

func _on_play_pause_pressed() -> void:
	audio_player.play()

func _on_next_pressed() -> void:
	current_song_index += 1
	load_song(queue[current_song_index])
	audio_player.play()

func _on_prev_pressed() -> void:
	current_song_index -= 1
	load_song(queue[current_song_index])
	audio_player.play()
