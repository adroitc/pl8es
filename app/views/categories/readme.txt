––––––––––––––––––––––––––––––
  category files description  
––––––––––––––––––––––––––––––

	––––––––––––
	  partials  
	––––––––––––
		
		_category.html
			
			- basic partial, sneak peek where one can open, edit & move the category
			- rendered from menus/show & various JS files to add, update & remove categories
		
		_cropper_form.html
			
			- form only used for cropping the category, using the Jcrop plugin
			- rendered by crop.js
			- called by crop, create & update action
			
		_form.html
			
			- form used to create, update & delete a category
			- rendered by new.js, edit.js
			- called by new & edit action
			
		_new_category_tile.html
			
			- a tile to add a category
			- called from menus/show
			
	––––––––––––––––––
	  AJAX responses  
	––––––––––––––––––
		
		create.js
				
			- adds a category partial
			
		crop.js
			
			- adds a category partial when cropping a newly created one
			- updates a category partial when adding an image to an existing one
			- renderes the crop form
			
		destroy.js
			
			- removes the category partial
			
		edit.js
			
			- renders the form
			
		new.js
			
			- renders the form
			
		update.js.erb
			
			- updates an existing category partial
			
	––––––––
	  view  
	––––––––
	
		show.html.erb
			
			- 