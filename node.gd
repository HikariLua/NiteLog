extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%HTTPRequest.request(
		"http://localhost:3000/meetings", ["Content-Type: application/json"], HTTPClient.METHOD_POST, '{"date": "2024-11-7"}'
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print(body.get_string_from_utf8())
	
