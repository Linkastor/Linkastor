# Linkastor

Linkastor is an opensource curation web app inspired by [Linkydink](http://linkydink.io/) with few improvements (on the way).

It's meant to be self hosted (Instructions will came when it will make sense).

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
- In order to incude integration tests to our CI, we commit VCR cassettes that contains recorded http requests with Twitter. They contains traces of your Twitter application credentials. Be sure to use a fake application.

- ```spec/lib/oauth/twitter/credential_spec.rb``` contains example of valid user oauth credentials. Be sure to use a fake user.

## Contributors

- Vincent Daubry ([@vdaubry](http://github.com/vdaubry))
- Thibaut Le Levier ([@tibo](http://github.com/tibo))
