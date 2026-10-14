extends CharacterBody2D

@export_group("Movement")
@export var walk_speed: float = 200.0
@export var sprint_speed: float = 350.0
@export var jump_velocity: float = -400.0

@export_group("3D References")
## Drag the 3D raccoon model from inside your SubViewport here
@export var model_3d: Node3D
## Drag your AnimationTree node here
@export var anim_tree: AnimationTree

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var anim_state: AnimationNodeStateMachinePlayback

func _ready() -> void:
	if anim_tree == null:
		push_error("ERROR: anim_tree is not assigned in the Inspector!")
		return

	# 1. Activate the tree first so Godot initializes parameters
	anim_tree.active = true
	
	# 2. Grab the playback parameter
	anim_state = anim_tree.get("parameters/playback")
	
	if anim_state == null:
		push_error("ERROR: parameters/playback is null. Check Tree Root in AnimationTree!")
	else:
		print("Animation state machine connected successfully!")
func _physics_process(delta: float) -> void:
	# 1. Apply 2D gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Horizontal input (Left / Right)
	var direction := Input.get_axis("left", "right")
	var is_sprinting := Input.is_key_pressed(KEY_SHIFT)
	var current_speed := sprint_speed if is_sprinting else walk_speed

	if direction != 0.0:
		velocity.x = direction * current_speed
		
		# Turn the 3D model to face left or right
		if model_3d:
			var target_angle := deg_to_rad(90.0) if direction > 0 else deg_to_rad(-90.0)
			model_3d.rotation.y = lerp_angle(model_3d.rotation.y, target_angle, 15.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()

	# 4. Drive the 3D Animation State Machine
	update_animations(direction, is_sprinting)

func update_animations(direction: float, is_sprinting: bool) -> void:
	if anim_state == null:
		return

	if not is_on_floor():
		anim_state.travel("jump")
	elif direction != 0.0:
		if is_sprinting:
			anim_state.travel("sprint")
		else:
			anim_state.travel("walk")
	else:
		anim_state.travel("idle")
