extends AudioStreamPlayer

const bg_music = preload("res://assets/bleep.mp3")

func _play_music(music: AudioStream, volume = 0.2):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()

func play_music_bg():
	_play_music(bg_music)

func stop_music():
	stream = null
	stop()