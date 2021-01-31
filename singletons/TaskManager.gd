extends Node

const task = preload("res://objects/task/task.res")
const managment_task = preload("res://objects/task/managment_task.res")

var daily_tasks
var weekly_tasks
var monthly_tasks
var one_time_tasks

var task_manager

var managment_tasks = []

func _ready():
	pass

func create_task(t_name : String, t_type : int):
	var i_mtask = managment_task.instance()
	var i_task = task.instance()
	
	i_mtask.init(t_name, t_type)
	i_task.init(t_name, t_type)
	
	task_manager.add_child(i_mtask)
	
	
	
	match t_type:
		Ref.TASK_TYPE.DAILY:
			daily_tasks.add_child(i_task)
		Ref.TASK_TYPE.WEEKLY:
			weekly_tasks.add_child(i_task)
		Ref.TASK_TYPE.MONTHLY:
			monthly_tasks.add_child(i_task)
		Ref.TASK_TYPE.ONE_TIME:
			one_time_tasks.add_child(i_task)
		_:
			printerr("Invalid Task Type was passed in [%s]" % t_type)
	pass
