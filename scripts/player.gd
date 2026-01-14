extends CharacterBody2D

@export var speed = 20
@onready var tilemap = get_parent().get_node("TileMap")
@onready var sprite = get_node("AnimatedSprite2D")

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("up"):
		input_vector.y -= 1
		play_anim("back_walk")
		sprite.flip_h = false
	elif Input.is_action_pressed("down"):
		input_vector.y += 1
		play_anim("front_walk")
		sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		input_vector.x -= 1
		play_anim("side_walk")
		sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		input_vector.x += 1
		play_anim("side_walk")
		sprite.flip_h = false

	velocity = input_vector.normalized() * speed

	if velocity == Vector2.ZERO:
		play_anim("idle")
		sprite.flip_h = false
	
	move_and_slide()

func play_anim(anim):
	if sprite.animation != anim:
		sprite.play(anim)

func _on_bridge_entered(body:Node2D) -> void:
	if body == self:
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(8, true)

func _on_bridge_exited(body:Node2D) -> void:
	if body == self:
		self.set_collision_mask_value(1, true)
		self.set_collision_mask_value(8, false)
