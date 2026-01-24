extends Control

@onready var setting = get_parent().get_node("settings-gui")
@onready var transitions = get_parent().get_node("transition/transitions")
@onready var intro_scene = preload("res://scenes/intro.tscn")

func _on_settings_toggled(toggled_on:bool) -> void:
	if toggled_on:
		setting.visible = true
	else:
		setting.visible = false

func _on_play_pressed() -> void:
	transitions.play("slide_out")

func _on_transitions_animation_finished(anim_name:StringName) -> void:
	if anim_name == "slide_out":
		get_tree().change_scene_to_packed(intro_scene)
