extends Control


func _ready() -> void:
	%HTTPRequest.request_completed.connect(_on_http_request_completed)

	var domain: String = CfgFile.settings.get("url-api")
	var route: String = "/meetings/by-date"
	var params: String = "/%s" % Time.get_date_string_from_system()

	var url: String = domain + route + params

	%HTTPRequest.request(url)


func _on_http_request_completed(
	_result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response_data: Variant = json.get_data()

	if response_data == null:
		%Spinner.status = %Spinner.Status.ERROR
		printerr(response_code)
		return

	for user: Dictionary in response_data.get("attendanceList"):
		%MembersList.add_item(user.get("id"))
