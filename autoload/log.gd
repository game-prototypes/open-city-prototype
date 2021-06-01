extends Node


var info_enabled=true
var warn_enabled=true
var error_enabled=true

func _ready():
	if ProjectSettings.has_setting("log/info"):
		info_enabled=ProjectSettings.get_setting("log/info")
	if ProjectSettings.has_setting("log/warn"):
		warn_enabled=ProjectSettings.get_setting("log/warn")
	if ProjectSettings.has_setting("log/error"):
		error_enabled=ProjectSettings.get_setting("log/error")


func info(a1="",a2="",a3="",a4="",a5="") ->void:
	if info_enabled:
		prints(a1,a2,a3,a4,a5)

func warn(a1="",a2="",a3="",a4="",a5="") -> void:
	if warn_enabled:
		prints("Warn: ", a1,a2,a3,a4,a5)

func error(a1="",a2="",a3="",a4="",a5="") -> void:
	if error_enabled:
		printerr("Error: ",a1,a2,a3,a4,a5)


func version() -> void:
	var version=ProjectSettings.get_setting("application/config/version")
	info("Open City Prototype", "v"+version)
