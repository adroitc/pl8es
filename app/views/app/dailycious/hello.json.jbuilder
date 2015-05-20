
json.token @token

json.tags (@tags) do |tag|
	json.(tag, :title)
end