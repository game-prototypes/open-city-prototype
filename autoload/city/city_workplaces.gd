extends Node

var workplace_list:=[]

var workforce:int=0
var jobs:int=0

func update_workforce(value: int)->void:
	workforce=value
	_assign_jobs_to_workers()

func register_workplace(workplace: Workplace)->void:
	workplace_list.append(workplace)
	jobs+=workplace.get_max_workers()
	_assign_jobs_to_workers()


func remove_workplace(workplace: Workplace)->void:
	var element_positon=workplace_list.find(workplace)
	if element_positon != -1:
		jobs-=workplace.get_max_workers()
		workplace_list.remove(element_positon)
	_assign_jobs_to_workers()

func _assign_jobs_to_workers()->void:
	if jobs==0 or workforce==0:
		return 
	var available_workers=workforce
	var job_fullfill_rate:float=min(float(workforce)/jobs, 1)

	for workplace in workplace_list:
		var max_workers=workplace.get_max_workers()
		var workers_to_assign=round(max_workers*job_fullfill_rate)
		var workers_assigned=min(workers_to_assign, available_workers)
		
		workplace.set_workers(workers_assigned)
		available_workers-=workers_assigned
	
	if available_workers>0 and workforce<jobs:
		# Edge case for rounding errors
		for workplace in workplace_list:
			var remaining_workers=workplace.get_remaining_workers()
			var current_workers=workplace.get_workers()
			var workers_to_assign=min(available_workers, remaining_workers)
			workplace.set_workers(current_workers+workers_to_assign)
			available_workers-=workers_to_assign
	
	assert(available_workers>=0, "assigned more workers than available")
