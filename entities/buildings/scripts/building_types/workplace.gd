extends Building

class_name Workplace

export var max_workers:int=10
var workers:int=0

var city

func _ready():
	city=ServiceLocator.get_city()
	city.register_workplace(self)

func _exit_tree():
	city.remove_workplace(self)

func get_workers()->int:
	return workers

func get_max_workers()->int:
	return max_workers

func get_remaining_workers()->int:
	return get_max_workers()-get_workers()

func set_workers(new_workers:int)->void:
	assert(new_workers<=max_workers, "More workers than possible set in workplace")
	workers=new_workers

func get_workers_rate()->float:
	return float(workers)/max_workers

func get_info() -> Array:
	var info=.get_info()
	info.append("Workers:"+String(workers)+"/"+String(max_workers))
	return info

func serialize()->Dictionary:
	return Utils.merge_dict(.serialize(), {
		"workers": workers
	})
