extends Node2D


export(Array, Resource) var buildings
#export(Array, Resource) var roads

onready var GUI=$GUI

func _ready():
	GUI.set_buildings(buildings)

