extends Control

@onready var transition = get_node("transition/transitions")
@onready var game = preload("res://scenes/map.tscn")

func _ready() -> void:
	AudioPlayer.stop_music()

func _on_playfr_pressed() -> void:
	transition.play("slide_out")

func _on_transitions_animation_finished(anim_name:StringName) -> void:
	if anim_name == "slide_out":
		get_tree().change_scene_to_packed(game)

func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.queue_free()
