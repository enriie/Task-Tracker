extends Control

enum STATES { MAIN, MANAGEMENT }

var state : int
var previous_state : int

var task_manager_ready : bool = false
var task_manager_box_ready : bool = false
var core_ready : bool = false

func _ready():
	
	pass

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		DataManager.save_data()

func _on_button_manage_tasks_pressed():
	$utils/animator.queue("to_managment")
	pass


func _on_Button_button_down():
	$utils/animator.queue("to_tasks")
	pass
