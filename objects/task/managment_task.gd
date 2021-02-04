extends Control

var type : int
var id : int

var task_name : String

var label_name : Label
var label_type : Label

func init(t_name : String, t_type : int, t_id : int):
	label_name = $margin_container/hbox/label_wrapper/label_task
	label_type = $margin_container/hbox/label_type
	
	task_name = t_name
	type = t_type
	id = t_id
	
	var type_letter = ""
	match t_type:
		Ref.TASK_TYPE.DAILY: type_letter = "D"
		Ref.TASK_TYPE.WEEKLY: type_letter = "W"
		Ref.TASK_TYPE.MONTHLY: type_letter = "M"
		Ref.TASK_TYPE.ONE_TIME: type_letter = "O"
		_: type_letter = "N"
	
	type_letter.capitalize()
	
	label_name.text = t_name
	label_type.text = type_letter

func update_task(t_name : String, t_type : int):
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
	
	label_name.text = t_name
	label_type.text = type_letter
