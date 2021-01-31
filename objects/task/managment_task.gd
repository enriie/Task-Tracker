extends Control

var type : int

var task_name : String

func _ready():
	pass

func init(t_name : String, t_type : int):
	task_name = t_name
	type = t_type
	
	var type_letter = ""
	match t_type:
		Ref.TASK_TYPE.DAILY: type_letter = "D"
		Ref.TASK_TYPE.WEEKLY: type_letter = "W"
		Ref.TASK_TYPE.MONTHLY: type_letter = "M"
		Ref.TASK_TYPE.ONE_TIME: type_letter = "O"
		_: type_letter = "N"
	
	type_letter.capitalize()
	
	$margin_container/hbox/label_task.text = t_name
	$margin_container/hbox/label_type.text = type_letter
	
	pass

func load_task(t_name : String, t_type : int):
	task_name = t_name
	type = t_type
	pass
