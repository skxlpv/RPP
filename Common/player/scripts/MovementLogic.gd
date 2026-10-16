class_name MovementLogic
extends RefCounted



static func apply_gravity(vel: Vector2, gravity: Vector2, on_floor: bool, delta: float) -> Vector2:
	if not on_floor:
		vel += gravity * delta
	return vel

static func check_jump(vel: Vector2, jump_pressed: bool, on_floor: bool) -> Vector2:
	if jump_pressed and on_floor:
		vel.y = MovementConfig.JUMP_VELOCITY
	return vel
