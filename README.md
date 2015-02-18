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
~~if User.loggedIn(session)~~
	~~@user = User.find(session[:user_id])~~
~~end~~

**Not Preferred:**
```
#if User.loggedIn(session)
#	@user = User.find(session[:user_id])
#end
```


## CSS Styleguides

### Formating

Format your CSS to make it consistent and more readable throughout the project:

**Preferred:**
```
.gallery {
	background: white;
}
```
**Not Preferred:**
```
.gallery
{
	background: white;
}
//OR
.gallery {
	background: white; }
```

### Nesting

Nest where possible and indent accordingly. Remember not to nest to deep, and don't over specify!

**Preferred:**
```
.gallery {
	background: white;
	
	img {
		border: none;
	}
}
```
**Not Preferred:**
```
.gallery {
	background: white;
}
.gallery img.my-image {
	border: none;
}
```

