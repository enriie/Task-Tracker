extends Control

func _ready():
	
	TaskManager.all_tasks = $main_body/tab_container/All/scroll_container/task_box
	TaskManager.daily_tasks = $main_body/tab_container/Daily/scroll_container/task_box
	TaskManager.weekly_tasks = $main_body/tab_container/Weekly/scroll_container/task_box
	TaskManager.monthly_tasks = $main_body/tab_container/Monthly/scroll_container/task_box
	TaskManager.one_time_tasks = $"main_body/tab_container/One Time/scroll_container/task_box"
	
	PointsManager.points_label = $main_body/hbox_points/label_points
	PointsManager.update_points()
	
	var err
	err = TaskManager.connect("task_created", self, "update_tabs")
	if err == 0:
		printerr("Successfully connected [Task Created] Signal from Task Manager to Main Screen")
	else:
		printerr("Unsuccessfully connected [Task Created] Signal from Task Manager to Main Screen")
	
	err = null
	err = TaskManager.connect("task_edited", self, "update_tabs")
	if err == 0:
		printerr("Successfully connected [Task Edited] Signal from Task Manager to Main Screen")
	else:
		printerr("Unsuccessfully connected [Task Edited] Signal from Task Manager to Main Screen")
	
	err = null
	err = TaskManager.connect("task_deleted", self, "update_tabs")
	if err == 0:
		printerr("Successfully connected [Task Deleted] Signal from Task Manager to Main Screen")
	else:
		printerr("Unsuccessfully connected [Task Deleted] Signal from Task Manager to Main Screen")

func update_tabs():
	for c in get_node("main_body/tab_container").get_children():
		if c.get_node("scroll_container/task_box").get_children().size() > 1:
			c.get_node("scroll_container/task_box/label_no_tasks").visible = false
