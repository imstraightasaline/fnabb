extends MeshInstance3D

var hovering = false

func _input(event):
	if Input.is_action_pressed("click"):
		if hovering == true:
			$audio.play()
			return

func _on_area_3d_mouse_entered():
	hovering = true
	return
