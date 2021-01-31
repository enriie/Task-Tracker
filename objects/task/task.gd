extends Control

var type : int

var task_name : String

func _ready():
	pass

func init(t_name : String, t_type : int):
	task_name = t_name
	type = t_type
	
	$margin_container/hbox/label_task.text = t_name
	pass

func load_task(t_name : String, t_type : int):
	task_name = t_name
	type = t_type
	pass
