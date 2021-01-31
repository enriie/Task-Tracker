extends Control

var type : int
var id : int

var task_name : String

var checked : bool
var checked_date : Dictionary

func _ready():
	pass

func init(t_name : String, t_type : int, t_id :int, t_checked : bool, t_checked_date : Dictionary):
	task_name = t_name
	type = t_type
	id = t_id
	
	checked = t_checked
	checked_date = t_checked_date
	
	$margin_container/hbox/check_box.pressed = checked
	if checked:
		$utils/animator.queue("finished")
	else:
		$utils/animator.queue("uncheck")
	
	$margin_container/hbox/label_task.text = t_name
	pass

func _on_check_box_pressed():
	if $margin_container/hbox/check_box.pressed:
		$utils/animator.queue("finished")
		checked_date = OS.get_datetime()
		checked = true
	else:
		$utils/animator.queue("uncheck")
		checked_date.clear()
		checked = false

func get_data():
	var data = {
		"task_name" : task_name,
		"checked" : checked,
		"checked_date" : checked_date
	}
	print(data)
	return data
