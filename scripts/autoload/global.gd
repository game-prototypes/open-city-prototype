extends Node


enum RESOURCES {
	Bread,
	Wheat
}

var resource_names:= {
	RESOURCES.Bread: "Bread",
	RESOURCES.Wheat: "Wheat"
}

var BUILDING_GROUP="building"


var BUILDING_ROLES:={
	"PRODUCER": "b_role_producer",
	"CONSUMER": "b_role_consumer",
	"STORAGE": "b_role_storage",
	"FACTORY": "b_role_factory",
	"MARKET": "b_role_market",
	"HOUSE": "b_role_house"
}
