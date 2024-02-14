extends Sprite3D

@onready var ray2 = $/root/gameplay/Camera3D/flashlight/ray2

func _process(delta):
	if ray2.is_colliding():
		var object = ray2.get_collider()
		if object.is_in_group("hank"):
			if !$away.is_stopped():
				$away.set_paused(true)
				return
			elif !$peeking.is_stopped():
				var time = $peeking.get_time_left()
				if time <= 4:
					return
				$peeking.start(time - 0.1)
				return
			return

func _input(event):
	if Input.is_action_just_released("flashlight"):
		$away.set_paused(false)

func _on_away_timeout():
	self.visible = true
	$peeking.start()
	return

func _on_peeking_timeout():
	self.texture = load("res://media/you just shat my pants.png")
	$enraged.start()
	return

func _on_enraged_timeout():
	get_tree().quit()
	return
