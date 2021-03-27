extends Node


enum RESOURCES {
	Bread,
	Wheat
}

var resource_names:= {
	RESOURCES.Bread: "Bread",
	RESOURCES.Wheat: "Wheat"
}

const BUILDING_GROUP="building"
const STORAGE_GROUP="storage"
const PRODUCER_GROUP="producer"
const CONSUMER_GROUP="consumer"


var BUILDING_ROLES:={
	"PRODUCER": "brole_producer",
	"CONSUMER": "brole_consumer",
	"STORAGE": "brole_storage"
}