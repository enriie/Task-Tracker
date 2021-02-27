extends Node

const task = preload("res://objects/task/task.res")
const managment_task = preload("res://objects/task/managment_task.res")

var all_tasks
var daily_tasks
var weekly_tasks
var monthly_tasks
var one_time_tasks

var task_box
var task_manager

var tasks = []
var task_instances = []

var id_counter = 0

signal task_created
signal task_edited
signal task_deleted

var wrappable_labels : Array = []

func _process(delta):
	update_group()
	for l in wrappable_labels:
		l.rect_size[0] = 0
		if l.rect_size[0] > l.get_parent().rect_size[0]:
			l.rect_position[0] -= 0.5
			if l.rect_position[0] <  -l.rect_size[0] - 4:
				l.rect_position[0] = l.get_parent().rect_size[0] * 1.25
		else:
			l.rect_position[0] = 0

func update_group():
	wrappable_labels.clear()
	wrappable_labels = get_tree().get_nodes_in_group("wrapping_text")

func create_task(t_name : String, t_type : int, t_checked : bool, t_checked_date : Dictionary, forced_id = -1, force_id = false):
	var i_mtask = managment_task.instance()
	var i_task = task.instance()
	var a_task = task.instance()
	
	if force_id:
		i_mtask.init(t_name, t_type, int(forced_id))
		i_task.init(t_name, t_type, int(forced_id), t_checked, t_checked_date)
		a_task.init(t_name, t_type, int(forced_id), t_checked, t_checked_date)
	else:
		i_mtask.init(t_name, t_type, id_counter)
		i_task.init(t_name, t_type, id_counter, t_checked, t_checked_date)
		a_task.init(t_name, t_type, id_counter, t_checked, t_checked_date)
	
	task_box.add_child(i_mtask)
	i_mtask.get_node("margin_container/hbox/button_edit").connect("pressed", task_manager, "select_task", [i_mtask])
	i_mtask.get_node("margin_container/hbox/button_delete").connect("pressed", self, "delete_task", [i_mtask])
	
	all_tasks.add_child(a_task)
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
	tasks.append(a_task)
	task_instances.append(i_task)
	
	id_counter += 1
	update_group()
	emit_signal("task_created")

func edit_task(t_mtask, new_t_name : String, new_t_type : int):
	var t_task = null
	for t in tasks:
		if t.id == t_mtask.id:
			t_task = t
	
	t_mtask.update_task(new_t_name, new_t_type)
	t_task.update_task(new_t_name, new_t_type)
	
	var parent = t_task.get_parent()
	parent.remove_child(t_task)
	match new_t_type:
		Ref.TASK_TYPE.DAILY:
			daily_tasks.add_child(t_task)
		Ref.TASK_TYPE.WEEKLY:
			weekly_tasks.add_child(t_task)
		Ref.TASK_TYPE.MONTHLY:
			monthly_tasks.add_child(t_task)
		Ref.TASK_TYPE.ONE_TIME:
			one_time_tasks.add_child(t_task)
		_:
			printerr("Invalid Task Type was passed in [%s]" % new_t_type)
	emit_signal("task_edited")

func delete_task(mt):
	for t in tasks:
		if t.id == mt.id:
			tasks.erase(t)
			t.queue_free()
			mt.queue_free()
	update_group()
	emit_signal("task_deleted")

func get_tasks_from_id(task_id : int):
	var ts = []
	for t in tasks:
		if t.id == task_id:
			ts.append(t)
	
	for t in task_instances:
		if t.id == task_id:
			ts.append(t)
	return ts
