# pl8.cc

Official pl8.cc repository

## Configuration

We follow the [12 Factor App principles](http://12factor.net). Anything that is likely to change between deployment environments is pulled out into the environment. Check the [sample file](.env.sample) for configuration specific variables, required by the application.

### During development and testing

During development and testing the application is configured using [dotenv](https://github.com/bkeepers/dotenv).


### Production

In production all required environment variables are **securely** stored in `/etc/profile.d/pl8es.sh` or `/etc/environment` for Debian/Ubuntu. The operation system itself makes sure they're available when needed.


## Deployment

For deployment, we use [Capistrano](http://capistranorb.com/). To install it, please follow the instructions on it's website.

We also have some `gem` dependencies which can be installed with

```
gem install capistrano-rails
gem install capistrano-rvm
gem install capistrano-passenger
```

To deploy a new release, run the following in a terminal from within the project's root directory

```
cap production deploy
```




## General Coding Guidelines

### Commenting

Remove not used code with a descriptive commit, don't leave code blocks as unused comments:

**Preferred:**
```
```
`git commit -m "removed check if user is signed in"`

**Not Preferred:**
```ruby
#if User.loggedIn(session)
#	@user = User.find(session[:user_id])
#end
```


## CSS Styleguides

### Formating

Format your CSS to make it consistent and more readable throughout the project:

**Preferred:**
```scss
.gallery {
	//rules here
}
```
**Not Preferred:**
```scss
.gallery
{
	//rules here
}
//OR
.gallery {
	//rules here }
```

### Nesting

Nest where possible and indent accordingly. Remember not to nest to deep!

**Preferred:**
```scss
.gallery {
	//rules here
	
	img {
		//rules here
	}
}
```
**Not Preferred:**
```scss
.gallery {
	//rules here
}
.gallery img {
	//rules here
}
```

### Specifying

Where possible use single classes or HTML-attributes, and don't ever use `!important` ;) (if possible)

**Preferred:**
```scss
.draggable-portlets .panel-primary article {
	//rules here	
}
```
**Not Preferred:**
```scss
.gallery-env.draggable-portlets div.panel.panel-primary.panel-add article.album {
	//rules here
}
```

### Naming

Don't repeat parent element names in child elements, that is what correct nesting is for.

**Preferred:**
```scss
.pl8es-c-dish {
	
	.title {
		// code here
	}
	
	.price {
		// code here
	}
}
```
**Not Preferred:**
```scss
.pl8es-c-dish {
	
	.pl8es-c-dish-title {
		// code here
	}
	
	.pl8es-c-dish-price {
		// code here
	}
}