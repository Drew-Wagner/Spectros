@tool
extends Platform

signal opened()

func on_all_bones_collected():
	next_waypoint()
	opened.emit()
