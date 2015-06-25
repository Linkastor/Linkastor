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
