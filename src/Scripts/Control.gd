extends Control

onready var text = get_parent().get_node("Dialogue").dialouge_1

var dialogue_index = 0
var finished
var active

var position

func _ready():
	load_dialogue()

func _physics_process(delta):
	if active:
		
		if Input.is_action_just_pressed("ui_accept"):
			if finished == true:
				load_dialogue()
			else:
				$TextBox/Tween.stop()
				$TextBox/RichTextLabel.percent_visible = 1
				finished = true
		if $Button1.text == "":
			$Button1.visible = false
		else:
			$Button1.visible = true
			
		if $Button2.text == "":
			$Button2.visible = false
		else:
			$Button2.visible = true
		

func load_dialogue():
	if dialogue_index < text.size():
		active = true
		finished = false
		
		$TextBox.visible = true
		$TextBox/RichTextLabel.bbcode_text = text[dialogue_index]["Text"]
		$TextBox/Label.text = text[dialogue_index]["Name"]
		$Button1.text = text[dialogue_index]["Choices"][0]
		$Button2.text = text[dialogue_index]["Choices"][1]
		
		position = text[dialogue_index]["Position"]
		
		$TextBox/RichTextLabel.percent_visible = 0
		$TextBox/Tween.interpolate_property(
			$TextBox/RichTextLabel, "percent_visible", 0,1,2, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$TextBox/Tween.start()
	else:
		$TextBox.visible = false
		active = false
		finished = true
	dialogue_index += 1
		

func _on_Tween_tween_completed(object, key):
	finished = true


func _on_Button1_pressed():
	if $Button1.text == "Okay, Ill leave":
		$Button1.text = ""
		$Button2.text= ""
		text = get_parent().get_node("Dialogue").after_choice_1
		dialogue_index = 0
		load_dialogue()


func _on_Button2_pressed():
	if $Button2.text == "What if I walk looking for YOU?":
		$Button1.text = ""
		$Button2.text= ""
		text = get_parent().get_node("Dialogue").after_choice_2
		dialogue_index = 0
		load_dialogue()
