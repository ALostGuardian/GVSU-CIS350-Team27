## Represents and manages the game board. Stores references to entities that are in each cell and
## tells whether cells are occupied or not.
## Units can only move around the grid one at a time.
class_name GameBoard
extends Node2D


const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
var rng = RandomNumberGenerator.new()

## Resource of type Grid.
export var grid: Resource
var unit: Unit = load("res://src/Scripts/Unit.gd").new()
var newUnit = preload("res://src/Scenes/EnemyOne.tscn")


## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}
var _active_unit: Unit
var _walkable_cells := []

onready var _unit_overlay: UnitOverlay = $UnitOverlay
onready var _unit_path: UnitPath = $UnitPath


func _ready() -> void:
	_reinitialize()


func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()


func _get_configuration_warning() -> String:
	var warning := ""
	if not grid:
		warning = "You need a Grid resource for this node to work."
	return warning


## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return _units.has(cell)


## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(myUnit: Unit) -> Array:
	return _flood_fill(myUnit.cell, myUnit.move_range)


## Clears, and refills the `_units` dictionary with game objects that are on the board.
func _reinitialize() -> void:
	_units.clear()

	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit


## Returns an array with all the coordinates of walkable cells based on the `max_distance`.
func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var array := []
	var stack := [cell]
	while not stack.empty():
		var current = stack.pop_back()
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue

		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue

		array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			#if is_occupied(coordinates):
			#	continue
			if coordinates in array:
				continue

			stack.append(coordinates)
	return array


## Updates the _units dictionary with the target position for the unit and asks the _active_unit to walk to it.
func _move_active_unit(new_cell: Vector2) -> void:
	# warning-ignore:return_value_discarded
	if new_cell in _walkable_cells and new_cell != _active_unit.get_cell():
		if _checkValidAttack(new_cell):
			return
		_units.erase(_active_unit.cell)
		_units[new_cell] = _active_unit
		_deselect_active_unit()
		_active_unit.walk_along(_unit_path.current_path)
		yield(_active_unit, "walk_finished")
		_clear_active_unit()
	_reinitialize()

func _checkValidAttack(new_cell: Vector2):
	if is_occupied(new_cell): 
		if _active_unit.getRangeStatus():
			print(_active_unit.getRangeStatus())
			if new_cell != _active_unit.cell:
				print("Ranged")
				_attack(new_cell)
				_clear_active_unit()
				return true
			else:
				return false
		else: #Unit is Melee
			if is_occupied(_active_unit.get_cell() + Vector2.RIGHT):
				print("Right")
				_attack(_active_unit.get_cell() + Vector2.RIGHT)
				return true
			elif is_occupied(_active_unit.get_cell() + Vector2.UP):
				print("up")
				_attack(_active_unit.get_cell() + Vector2.UP)
				return true
			elif is_occupied(_active_unit.get_cell() + Vector2.LEFT):
				print("Let")
				_attack(_active_unit.get_cell() + Vector2.LEFT)
				return true
			elif is_occupied(_active_unit.get_cell() + Vector2.DOWN):
				print("Down")
				_attack(_active_unit.get_cell() + Vector2.DOWN)
				return true
	return false
	

func _attack(cell: Vector2) -> void:
	var unitToAttack = _units[cell]
	print($unitToAttack)
	unitToAttack._attack_unit($unitToAttack, _active_unit.attackPower)
	if unitToAttack.getHealth() <= 0:
		_units.erase(unitToAttack.cell)
		if remove_child(unitToAttack):
			queue_free()
		_spawnUnitRandom()


func _spawnUnitRandom() -> void:
	var counter = 0
	for x in self.get_children():
		if "Enemy" in x.name:
			counter += 1
	
	if counter == 0:
		var myUnit = newUnit.instance()
		add_child(newUnit.instance(), true)
		
		var newUnitCell = Vector2(rng.randi_range(0,500),rng.randi_range(0,500))
		while(not is_occupied(newUnitCell)):
					newUnitCell = Vector2(rng.randi_range(0,500),rng.randi_range(0,500))
					grid.clamp(newUnitCell)
					
		print("New Cell: " + str(newUnitCell))
		myUnit.cell = newUnitCell
		print("Added new unit")
		_reinitialize()
		
		


## Selects the unit in the `cell` if there's one there.
## Sets it as the `_active_unit` and draws its walkable cells and interactive move path. 
func _select_unit(cell: Vector2) -> void:
	if not _units.has(cell):
		return

	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)


## Deselects the active unit, clearing the cells overlay and interactive path drawing.
func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()


## Clears the reference to the _active_unit and the corresponding walkable cells.
func _clear_active_unit() -> void:
	_deselect_active_unit()
	_active_unit = null
	_walkable_cells.clear()


## Selects or moves a unit based on where the cursor is.
func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)
	# for friendly units -> _move_active_unit(find_closest_walkable_cell(cell))


## Updates the interactive path's drawing if there's an active and selected unit.
func _on_Cursor_moved(new_cell: Vector2) -> void:
	if _active_unit and _active_unit.is_selected:
		# We process the new cell by calling `find_closest_walkable_cell()`
		var target_cell = find_closest_walkable_cell(new_cell)
		_unit_path.draw(_active_unit.cell, target_cell)


##find closest unoccupied cell
func find_closest_walkable_cell(cell: Vector2) -> Vector2:
	if not _units.has(cell):
		return cell

	var closest_cell := cell
	var min_distance := INF

	for direction in DIRECTIONS:
		var target: Vector2 = cell + direction
		if _units.has(target) and not _units[target] == _active_unit:
			continue

		var distance := target.distance_squared_to(_active_unit.cell)
		if distance < min_distance:
			min_distance = distance
			closest_cell = target

	return closest_cell


func _on_escapeButton_pressed():
	get_tree().change_scene("res://src/Scenes/outOfBattleMenu.tscn")
	pass # Replace with function body.
