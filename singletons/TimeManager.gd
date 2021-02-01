extends Node

var datetime : Dictionary
var timer_update : Timer

func _ready():
	datetime = OS.get_datetime()
	timer_update = Timer.new()
	print(datetime)
	timer_update.wait_time = Ref.WAIT_TIME
	timer_update.autostart = true
	
	timer_update.connect("timeout", self, "update_datetime")

func update_datetime():
	datetime = OS.get_datetime()
	
	var nodes = []
	for c in get_tree().get_nodes_in_group("datetime"):
		if c.is_checked():
			nodes.append(c)
	
	var node_week = 0
	
	var days_passed = ceil(datetime["month"] - 1 * 30.41) + datetime["day"]
	var week = ceil(days_passed/7)
	
	var node_datetime : Dictionary
	for n in nodes:
		node_datetime = n.get_datetime()
		
		days_passed = ceil(node_datetime["month"] - 1 * 30.41) + node_datetime["day"]
		node_week = ceil(days_passed/7)
		
		if datetime["year"] == node_datetime["year"]:
			if week > node_week:
				# Update Weekly Tasks
				if n.type == Ref.TASK_TYPE.WEEKLY:
					n.uncheck()
					break
			
			if datetime["month"] > node_datetime["month"]:
				# Update Monthly Tasks
				# Update Daily Tasks
				if n.type == Ref.TASK_TYPE.MONTHLY or n.type == Ref.TASK_TYPE.DAILY:
					n.uncheck()
			else:
				if datetime["day"] > node_datetime["day"]:
					# Update Daily Tasks
					if n.type == Ref.TASK_TYPE.DAILY:
						n.uncheck()
		else:
			# Update All Tasks
			n.uncheck()
	
	nodes.clear()
	nodes = null
	pass


