extends CharacterBody2D

@export var speed = 400
var can_move: bool = true

func set_can_move(value: bool) -> void:
	can_move = value
	if not can_move:
		velocity = Vector2.ZERO

func _physics_process(delta):
	if not can_move:
		return
	
	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	velocity.x = direction * speed
	move_and_slide()
