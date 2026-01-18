extends Node2D

@onready var overlay_anim = get_node("player/night_overlay/AnimationPlayer")
@onready var light_parent = get_node("lights")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_daycycle_timeout() -> void:
	if Utils.crnt_day == "day":
		Utils.crnt_day = "night"
		overlay_anim.play("to_night")
		turn_lights_on()
	else:
		Utils.crnt_day = "day"
		overlay_anim.play("to_day")
		turn_lights_off()

func turn_lights_on() -> void:
	for light in light_parent.get_children():
		light.get_node("AnimationPlayer").play("turn_on")

func turn_lights_off() -> void:
	for light in light_parent.get_children():
		light.get_node("AnimationPlayer").play("turn_off")
