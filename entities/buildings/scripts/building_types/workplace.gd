extends Building

class_name Workplace

export var max_workers:int=10
var workers:int=0

func _ready():
	City.register_workplace(self)

func _exit_tree():
	City.remove_workplace(self)

func get_workers()->int:
	return workers

func get_max_workers()->int:
	return max_workers

func get_remaining_workers()->int:
	return get_max_workers()-get_workers()

func set_workers(new_workers:int)->void:
	assert(new_workers<=max_workers, "More workers than possible set in workplace")
	workers=new_workers
