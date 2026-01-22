extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Utils.crnt_day == "night":
		play("turn_on")
