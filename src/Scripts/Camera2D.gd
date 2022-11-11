extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false


func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
	elif event.is_action_pressed("scroll_up"):
		zoom -= Vector2(0.25,0.25)
	elif event.is_action_pressed("scroll_down"):
		zoom += Vector2(0.25,0.25) 
