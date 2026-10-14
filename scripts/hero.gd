extends Sprite2D

const movement_speed: int = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector('left', 'right', 'jump', 'crouch')
	
	if Input.is_action_pressed("left"):
		position.x -= movement_speed * delta
	if Input.is_action_pressed("right"):
		position.x += movement_speed * delta
