extends Node

const POINTS_LABEL_TEXT = "Points: %s D / %s W / %s M / %s OT | All Time: %s"

var points : Array
var points_label : Label

var at_total : int
var history : Dictionary

func _ready():
	points = []
	for n in Ref.TASK_TYPE.size():
		points.append(0)
	print(points)

func increase_points(type : int):
	points[type] = points[type] + 1
	at_total += 1
	update_points()

func decrease_points(type : int):
	points[type] = points[type] - 1
	at_total -= 1
	update_points()

func update_points():
	points_label.text = POINTS_LABEL_TEXT % [points[0], points[1], points[2], points[3], at_total]
	print("Points: %s D / %s W / %s M / %s One Time" % [points[0], points[1], points[2], points[3]])
	
	var test = 0
	for val in points:
		test += val
	print(test)


func get_data():
	var date = OS.get_date()
	
	var data = {
		"daily": points[0],
		"weekly": points[1],
		"monthly": points[2],
		"special": points[3]
	}
	
	return data

func load_data(data):
	points[0] = int(data["daily"])
	points[1] = int(data["weekly"])
	points[2] = int(data["monthly"])
	points[3] = int(data["special"])
	
	for val in points:
		at_total += val
	
	update_points()
