[![Build Status](https://semaphoreci.com/api/v1/projects/9c32c634-c898-4c9f-bd5b-dc8f4aada610/397817/badge.svg)](https://semaphoreci.com/vdaubry/linkastor)      

# Linkastor

Linkastor is an opensource curation web app inspired by [Linkydink](http://linkydink.io/) with few improvements (on the way).

It's meant to be self hosted (Instructions will come when it makes sense).


## Setup development environment

To start Linkastor locally you need to add some environment variables in a ```.env``` file :

> TWITTER_OAUTH_API_ID=
> TWITTER_OAUTH_API_SECRET=
> SENDGRID_USERNAME=
> SENDGRID_PASSWORD=
> POCKET_CONSUMER_KEY=

- Install [Docker Toolbox](https://www.docker.com/docker-toolbox) 
- setup the docker machine : `docker-machine create --driver=virtualbox default` and update the docker environment : `eval "$(docker-machine env default)"`
- create the cluster : `docker-compose build`
- setup the database : `docker-compose run web rake db:setup` (eventually run `db:seed` the same way)
- launch the cluster : `docker-compose run --service-ports -d web`
- visit the web app : `open "http://".$(docker-machine ip default).":5000"`

### Run tests

- setup the database : `docker-compose run web rake db:setup`
- launche the tests : `docker-compose run test`

## Stop everything

- run `docker-compose stop`

Or use Kitematic to visualize the runing containers

- stop the docker vm : `docker-machine stop default` 

## Import links from your custom source

You can generate adaptors to fetch links from any source in your mail digest
There is a generator to scaffold a new adaptor, for example if you wanted to create a Facebook adaptor to fetch link from a Facebook page :

``` rails generate custom_source facebook ```

It will create a new model under :

- app/models/custom_source/facebook.rb

And views for a form where the user can add a new facebook page to watch :

- app/views/custom_source/facebook/new.html.erb
- app/views/custom_source/facebook/_form.html.erb

Have a look at the comment in the generated files. You can also look at the Twitter adapter to see a working implementation :

- app/models/custom_source/twitter.rb
- app/views/custom_source/twitter/new.html.erb
- app/views/custom_source/twitter/_form.html.erb

## Feature roadmap 

Few things we already though about :
- Social login (Twitter? Facebook?)
- Comments thread for every post -> the ability to reply/react on a posted link was one of the big things missing on Linkydink for us
- Social sharing, send to pocket...
- Search Feature (Algolia?)
- The ability to choose the right time/frequence for the digest (Linkydink don't send anything on Friday/Week-end so you end up with a lot things to read on Monday and probably not time for it until the next Week-end)
- Chrome extension
- Mobile app/extension?
- Input via email

## Security

Be carefull with integration test :
- In order to incude integration tests to our CI, we commit VCR cassettes that contains recorded http requests with Twitter. They contains traces of your Twitter application credentials. Be sure to use a dummy Twitter app when recording your unit test.

- ```spec/lib/oauth/twitter/credential_spec.rb``` contains example of valid user oauth credentials. Be sure to use a dummy twitter user.

## Contributors

- Vincent Daubry ([@vdaubry](http://github.com/vdaubry))
- Thibaut Le Levier ([@tibo](http://github.com/tibo))
