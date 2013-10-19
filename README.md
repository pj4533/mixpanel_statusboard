Mixpanel StatusBoard
====================

A simple Sinatra app for sending [Mixpanel](https://mixpanel.com/docs/api-documentation/data-export-api#segmentation-default) data to [Status Board](http://panic.com/statusboard/)


### Parameters Supported

```
api_key: (required) Mixpanel API key
api_secret: (required) Mixpanel API secret
event: (required) Mixpanel event to segment
on: (required) Property segment your event on
title: (required) Title for StatusBoard
type: (optional) general,unique,average -- see Mixpanel docs for details
limit: (optional) max number to return
```

### Local Testing

Use shotgun for autoreloading, runs on port 9393
```
shotgun mixpanel_statusboard.rb
```

#### Example Request

```
curl "http://localhost:9393/mixpanel?api_key=<apikey>&api_secret=<apisecret>&on=OID&title=Users+By+OID&event=application+started&type=unique"
```

Output should be a CSV that looks something like:

```
80%,20%
Users By OID,
bar1,16
foo2,15
derp3,13
foo4,9
bar4,8
```

### To The Cloud!

I followed the instructions [here](https://devcenter.heroku.com/articles/getting-started-with-ruby) to deploy to Heroku.  Basically, you can just do:

```
heroku create [app name]
bundle install
git push heroku master
```

Obviously, that is skipping over some, but the steps are very easy for a little sintra app like this.  Just read that link and you'll be going in a few minutes.