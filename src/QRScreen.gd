extends Control


func _ready() -> void:
	%QRHTTPRequest.request_completed.connect(_on_http_request_request_completed)
	%OpenLoginButton.toggled.connect(_on_open_login_toggled)
	%WebQRCode.data = CfgFile.settings.get("url-web")

	var url: String = CfgFile.settings["url-api"] + "meetings"

	var datetime : Dictionary = Time.get_date_dict_from_system()
	var body: String = JSON.stringify(
		{"date": Time.get_datetime_string_from_system()}
		)
	print(str(body))

	var error: Error = %QRHTTPRequest.request(
		url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body
	)
	if error != OK:
		var msg: String = (
			"Erro ao fazer requisição para %s (%s)" % [url, error_string(error)]
		)

		%QRSpinner.status = %QRSpinner.Status.ERROR
		%ErrorLabel.show()
		%ErrorLabel.text = msg
		printerr(msg)


func _on_http_request_request_completed(
	_result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response_data: Variant = json.get_data()
	# TODO atualizar documentação na parte de getMeetingById
	print_debug(response_data)

	var meeting_id: int
	if response_code == HTTPClient.RESPONSE_CREATED:
		meeting_id = response_data.get("meetingCode") as int 
		if not meeting_id: return
	elif response_code == HTTPClient.RESPONSE_CONFLICT:
		meeting_id = response_data.get("meeting").get("meetingCode") as int
		if not meeting_id: return
	else:
		var err: String = "Erro na requisição, código: %s" % response_code
		printerr(err)

		%ErrorLabel.text = err
		%ErrorLabel.show()
		return

	var link: int = meeting_id
	%QRCodeRect.data = str(link)
	print(%QRCodeRect.data)
	%QRCodeRect.show()


func _on_open_login_toggled(value: bool) -> void:
	if value == true:
		%LoginAnimPlayer.play("transition_in")
		%OpenLoginButton.text = " < "
		return

	%LoginAnimPlayer.play("transition_out")
	%OpenLoginButton.text = " > "
