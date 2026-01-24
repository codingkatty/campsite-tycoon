extends Control

@onready var bg_switch = get_node("bg-container/bg-switch")

func _ready() -> void:
	AudioPlayer.play_music_bg()

func _on_bgswitch_toggled(toggled_on:bool) -> void:
	if toggled_on:
		AudioPlayer.stop_music()
		bg_switch.text = "off"
		Utils.bg_sound = false
	else:
		AudioPlayer.play_music_bg()
		bg_switch.text = "on"
		Utils.bg_sound = true
