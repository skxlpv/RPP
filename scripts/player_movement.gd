extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var jump_pressed := Input.is_action_just_pressed("jump")

	velocity = MovementLogic.apply_gravity(velocity, get_gravity(), is_on_floor(), delta)
	velocity = MovementLogic.apply_jump(velocity, jump_pressed, is_on_floor())
	velocity = MovementLogic.apply_movement(velocity, direction)
	move_and_slide()
