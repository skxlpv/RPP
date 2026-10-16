extends CharacterBody2D

@onready var animation_tree: AnimationTree = $SubViewport/Player/AnimationPlayer/AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var model: Node3D = $SubViewport/Player

const TURN_SPEED := 15.0
var target_yaw := 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var jump_pressed := Input.is_action_just_pressed("jump")
	var was_on_floor := is_on_floor()

	velocity = MovementLogic.apply_gravity(velocity, get_gravity(), was_on_floor, delta)
	velocity = MovementLogic.check_jump(velocity, jump_pressed, was_on_floor)

	if direction:
		velocity.x = direction * MovementConfig.SPEED
		target_yaw = deg_to_rad(90.0 * signf(direction))
	else:
		velocity.x = move_toward(velocity.x, 0, MovementConfig.SPEED)

	model.rotation.y = lerp_angle(model.rotation.y, target_yaw, TURN_SPEED * delta)

	move_and_slide()

	# Hard-cut into jump on the exact frame it starts, no blending, no idle frames
	if jump_pressed and was_on_floor:
		playback.start("jump", true)
	else:
		_update_animation(direction)

func _update_animation(direction: float) -> void:
	var target := "idle"
	if not is_on_floor():
		target = "jump"
	elif direction != 0:
		target = "walk"

	if playback.get_current_node() != target:
		playback.travel(target)
