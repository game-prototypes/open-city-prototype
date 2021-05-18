extends Node2D

class_name Character

const BuildingInteraction=preload("./building_interaction.gd")

const RESOURCE_CAPACITY=10
const ARRIVAL_WAIT=0.5

export(float) var movement_speed=25

onready var animation: AnimatedSprite = $Animation
onready var tween: Tween = $Tween

var origin_building: BuildingInteraction
var target_building: BuildingInteraction

var map

var map_position:Vector2

enum CharacterState {
	moving,
	waiting,
	returning
}

var current_state: int

func _ready():
	map=City.map
	assert(map_position and origin_building, "Character not set")
	position=map.tile2pos(map_position)
	animation.play()

func _process(delta:float):
	match current_state:
		CharacterState.waiting:
			_on_waiting(delta)

func setup(_map_position:Vector2, _origin_building: Building):# Triggered before ready
	map_position=_map_position
	_set_origin(_origin_building)
	current_state=CharacterState.waiting

func _arrived_to_destination(building:BuildingInteraction) -> void:
	building.arrived_to_destination(self)
	if building.is_origin:
		_despawn()

func _on_waiting(_delta: float):
	pass


func _set_origin(_origin: Building):
	origin_building=BuildingInteraction.new(_origin,true)

func _despawn():
	queue_free()

# Actions
func _go_to(_position:Vector2):
	 # TODO: Implement go_to action
	pass

func _go_to_building(target:BuildingInteraction):
	target_building=target
	var new_path=map.navigation.get_road_path_to_building(map_position, target_building.get_position())
	if new_path.size()>0:
		_move(new_path)

func _return_to_origin():
	_go_to_building(origin_building)
	current_state=CharacterState.returning


func _move(path: Array):
	current_state=CharacterState.moving
	assert(tween.is_active()==false, "Move with already active tween")
	var first_point=path.pop_front()
	position=map.tile2pos(first_point)
	for point in path:
		var new_pos=map.tile2pos(point)
		var distance=position.distance_to(new_pos)
		var interpolation_time=distance/(movement_speed*10)
		
		tween.interpolate_property(self, "position",
			position, new_pos, interpolation_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		map_position=point
	tween.stop_all()
	
	if target_building:
		yield(get_tree().create_timer(ARRIVAL_WAIT), "timeout")
		_arrived_to_destination(target_building)
	current_state=CharacterState.waiting
