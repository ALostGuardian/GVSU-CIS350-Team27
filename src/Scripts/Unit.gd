
class_name Unit
extends Path2D

signal walk_finished()
signal moving(cell)

export var grid: Resource = preload("res://src/Resources/Grid.tres")
export var move_range := 6
export var move_speed := 350.0


#combat variables
export var health := 3
var isRanged: bool = true
var attackPower = 1

var cell := Vector2.ZERO setget set_cell
var is_selected := false setget set_is_selected

var _is_walking := false setget _set_is_walking

onready var _sprite: Sprite = $PathFollow2D/Sprite
onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _path_follow: PathFollow2D = $PathFollow2D
onready var _animated_sprite = $AnimatedSprite


func _ready() -> void:
	set_process(false)
	print("Position: " + str(self.cell))
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)

	if not Engine.editor_hint:
		curve = Curve2D.new()
		
		
func _process(delta: float) -> void:
	_path_follow.offset += move_speed * delta
	get_node("PathFollow2D/AnimatedSprite").play("run")

	if _path_follow.unit_offset >= 1.0:
		self._is_walking = false
		_path_follow.offset = 0.0
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		print("Position: " + str(self.cell))
		emit_signal("walk_finished")
		get_node("PathFollow2D/AnimatedSprite").stop()
		


func getRangeStatus():
	return false

func walk_along(path: PoolVector2Array) -> void:
	if path.empty():
		return

	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	cell = path[-1]
	self._is_walking = true
	

func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)
	position = grid.calculate_map_position(value)
	

func get_cell() -> Vector2:
	return cell


func set_is_selected(value: bool) -> void:
	is_selected = value
	

func _set_is_walking(value: bool) -> void:
	emit_signal("moving", cell)
	_is_walking = value
	set_process(_is_walking)
	
	
	
func _attack_unit(unit: Unit, attackPower: int) -> void:
	health -= attackPower
	print("Object health: " + str(health))


func getHealth() -> int:
	return health

# Syntactically it doesn't look like it should work, but it does
func setHealth(health: int) -> void:
	health = health
	
