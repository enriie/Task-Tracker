extends Control

enum STATES { MAIN, MANAGEMENT }

var state : int
var previous_state : int

func _ready():
	
	TaskManager.daily_tasks = get_node("main/main_body/tab_container/Daily/scroll_container/task_box")
	TaskManager.weekly_tasks = get_node("main/main_body/tab_container/Weekly/scroll_container/task_box")
	TaskManager.monthly_tasks = get_node("main/main_body/tab_container/Monthly/scroll_container/task_box")
	TaskManager.one_time_tasks = get_node("main/main_body/tab_container/One Time/scroll_container/task_box")
	
	pass


func _on_button_manage_tasks_pressed():
	$utils/animator.play("to_managment")
	pass


func _on_Button_button_down():
	$utils/animator.play("to_tasks")
	pass
