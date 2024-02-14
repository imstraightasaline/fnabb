extends Control

@onready var exit_ready = $mainExitReady
var local_exit_ready = false

func _on_subcameras_mouse_entered():
	if local_exit_ready == false:
		return
	self.get_parent().visible = false
	self.get_parent().get_parent().visible = true
	local_exit_ready = false
	return

func _on_subcameras_mouse_exited():
	if self.get_parent().get_parent().visible:
		exit_ready.set_one_shot(true)
		return
	local_exit_ready = true
	exit_ready.set_one_shot(true)
	return
