# scrumptious

A simple webhook for [Scrumy](http://apidoc.scrumy.com/wiki/show/Webhooks "Scrumy web hooks api") that will listen for task changes and fire notifications to the configured [Campfire](http://campfirenow.com/) room.

## Usage

Use the env.sample as an example of the 5 environment variables that need to be set.

```EXPORT CAMPFIRE_DOMAIN="domain"```  
```EXPORT CAMPFIRE_TOKEN="api_token"```  
```EXPORT CAMPFIRE_ROOM="id"```  
```EXPORT SCRUMY_PROJECT="project"```  
```EXPORT SCRUMY_PASSWORD="password"```  

You can use [foreman](https://github.com/ddollar/foreman) to run this locally:  

```foreman start```

Or manually run thin:

```bundle exec thin start```

### Thanks

This project was only possible because of the exuberance of @jeffremer, thanks.

### License

Copyright (c) 2011 cacoco and released under an MIT license.

