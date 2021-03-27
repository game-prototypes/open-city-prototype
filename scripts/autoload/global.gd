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
	"PRODUCER": "b_role_producer",
	"CONSUMER": "b_role_consumer",
	"STORAGE": "b_role_storage",
	"FACTORY": "b_role_factory"
}
