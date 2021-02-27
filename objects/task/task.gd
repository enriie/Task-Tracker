extends Control

var type : int
var id : int

var task_name : String

var checked : bool
var checked_date : Dictionary

var label : Label
var check_box : CheckBox

var container

func init(t_name : String, t_type : int, t_id :int, t_checked : bool, t_checked_date : Dictionary):
	task_name = t_name
	type = t_type
	id = t_id
	
	label = $margin_container/hbox/label_wrapper/label_task
	check_box = $margin_container/hbox/check_box
	container = $margin_container/hbox/label_wrapper
	
	checked = t_checked
	checked_date = t_checked_date
	
	check_box.pressed = checked
	if checked:
		$utils/animator.queue("check")
	else:
		$utils/animator.queue("uncheck")
	
	label.text = t_name
	container.mouse_filter = MOUSE_FILTER_PASS
	container.hint_tooltip = t_name

func update_task(new_name : String, new_type : int):
	task_name = new_name
	type = new_type
	
	label.text = new_name
	container.hint_tooltip = new_name

func get_datetime():
	return checked_date

func is_checked():
	return checked

func check():
	checked = true
	checked_date = OS.get_datetime()
	
	check_box.pressed = true
	$utils/animator.queue("check")

func uncheck():
	checked = false
	checked_date.clear()
	
	check_box.pressed = checked
	$utils/animator.queue("uncheck")

func _on_check_box_pressed():
	var tasks = []
	tasks = TaskManager.get_tasks_from_id(id)
	if tasks.empty():
		printerr("Task with ID:[%s] was not found.")
		return
	
	if check_box.pressed:
		for t in tasks:
			t.check()
	else:
		for t in tasks:
			t.uncheck()

func get_data():
	var data = {
		"task_name" : task_name,
		"checked" : checked,
		"checked_date" : checked_date
	}
	
	return data
