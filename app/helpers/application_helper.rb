module ApplicationHelper
	
	def get_correct_logo
		sector = case params[:controller]
			when "menus", "categories", "dishes" then "menumalist"
			when "dailycious" then "dailycious"
			else "pl8"
		end
		
		return image_tag("logo-#{sector}.png")
	end
	
	def get_aspect_ratio_of_image(instance)
		options = instance.validators.find{|v| v.class.to_s == "DimensionsValidator"}.options
		return options[:width].to_f/options[:height].to_f
	end
	
	def white_data_image
		"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAMAAAACCAYAAACddGYaAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoTWFjaW50b3NoKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoxNEZGQUQ3OUZGNkYxMUUzQkYxQUI5QjY3NkQ5NTIyRCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoxNEZGQUQ3QUZGNkYxMUUzQkYxQUI5QjY3NkQ5NTIyRCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjE0RkZBRDc3RkY2RjExRTNCRjFBQjlCNjc2RDk1MjJEIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjE0RkZBRDc4RkY2RjExRTNCRjFBQjlCNjc2RDk1MjJEIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+WZssTAAAABVJREFUeNpi/P//PwMMMDEgAYAAAwBIBgMBqEIoJAAAAABJRU5ErkJggg=="
	end

	def image_url_for_host(image_url)
		if Rails.env.development?
			image_url.prepend(URI.join(request.url, "/").to_s)
		else
			image_url
		end
	end

end