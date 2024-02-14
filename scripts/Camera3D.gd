extends Camera3D

@onready var snap_left = $panning/snapLeft
@onready var snap_right = $panning/snapRight
@onready var generator = $panning/generator
@onready var cameras = $panning/cameras
@onready var lightBlocker = get_tree().get_nodes_in_group("lightBlocker")
@onready var cam_system = $panning/cameras/canvas
@onready var exit_ready = $panning/cameras/canvas/camSystem/mainExitReady

var left_clamp : float = 20
var right_clamp : float = -20

var left_dist : float
var right_dist : float
var sensitivity : float
var initial_turning_speed : float

func _ready() -> void:
	left_dist = 260
	right_dist = 360
	sensitivity = 768 / 360
	initial_turning_speed = 360 / 15360
	return

func _process(delta : float) -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	if mouse_position.x < left_dist:
		rotate_y(deg_to_rad((left_dist - mouse_position.x) * delta * sensitivity + initial_turning_speed))
	elif mouse_position.x > right_dist:
		rotate_y(deg_to_rad(-(mouse_position.x - right_dist) * delta * sensitivity - initial_turning_speed))
	rotation.y = clamp(rotation.y, deg_to_rad(right_clamp), deg_to_rad(left_clamp))
	return

func _on_snap_left_mouse_entered():
	if left_clamp == 20:
		rotate_y(90)
		left_clamp = 90
		right_clamp = 90
		snap_left.visible = false
		generator.visible = true
		return
	if left_clamp == -90:
		rotate_y(0)
		left_clamp = 20
		right_clamp = -20
		snap_right.visible = true
		cameras.visible = false
		for i in lightBlocker:
			i.get_parent().visible = true
			return

func _on_snap_right_mouse_entered():
	if right_clamp == -20:
		rotate_y(-90)
		left_clamp = -90
		right_clamp = -90
		snap_right.visible = false
		cameras.visible = true
		return
	if right_clamp == 90:
		rotate_y(0)
		left_clamp = 20
		right_clamp = -20
		snap_left.visible = true
		generator.visible = false
		return

var gen_view = false

func _on_generator_mouse_entered():
	if gen_view == false:
		rotate_z(-12)
		self.position = Vector3(0, 1, 0.1)
		snap_right.visible = false
		gen_view = true
		return
	rotate_z(12)
	self.position = Vector3(0, 1.3, 0)
	snap_right.visible = true
	gen_view = false
	return

func _on_cameras_mouse_entered():
	if exit_ready.is_one_shot():
		exit_ready.set_one_shot(false)
		snap_left.visible = true
		return
	cameras.visible = false
	snap_left.visible = false
	cam_system.visible = true
	return
