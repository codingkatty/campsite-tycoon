extends AnimationPlayer

func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == "fade_out":
		get_parent().get_parent().queue_free()
