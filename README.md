# Dabble Me
### The open-source replacement for OhLife

Dabble Me helps people remember what's happened in their life. Use it as a light-weight journal on a daily, weekly, or even monthly basis...it's up to you! Dabble Me will email you on a time & days you choose - you simply reply to the email to post entries. The app is live at [https://dabble.me](https://dabble.me).

This app utilizes the following 3rd party services:

* [SendGrid](http://sendgrid.com) for Sending & Receiving Email (free for 200 emails per day)
* [Filepicker](http://filepicker.io) for Photo Uploads & Storage (free for 500 uploads per month)
* [MailChimp](http://mailchimp.com) for sending updates to all users (free for 2000 subscribers)
* [Google Analytics](http://google.com/analytics) for traffic stats (free for standard analytics)
* [Skylight](http://skylight.io) for server monitoring (free for basic monitoring)
* [Downloader.io](http://downloader.io) for zipping up photos to download (not currently available to the public)

I recommend forking and setting up a free server at [Ninefold](https://ninefold.com/). You can generate a free SSL certificate at [StartSSL](https://www.startssl.com/).

You will need to setup SendGrid to receive incoming emails and point them to your app to parse. Visit this [Settings Page](https://sendgrid.com/developer/reply); add your hostname of ```post.yourdomain.com``` and point the URL to ```https://yourdomain.com/email_processor```. I have spam check turned off, since that hasn't been an issue yet. Make sure you setup an MX record for the ```post.yourdomain.com``` subdomain that points to ```mx.sendgrid.net```, and setup an A Record for ```yourdomain.com``` that points to the Public IP address of your Ninefold server (found under Infrastructure/Show Details). You'll also need to add ```yourdomain.com``` as a domain under the Overview tab.

In order to turn on scheduled emails in Ninefold, you'll need to add the following line to the "After Migrations" section in the [Ninefold Portal/Configuration](https://portal.ninefold.com):
```
bundle exec whenever --update-crontab dabble_me
```

Your local environment variables at ```config/local_env.yml``` will need to be something like this:

```
MAIN_DOMAIN: yourdomain.com
SECRET_KEY_BASE: 1234..1234
DEVISE_SECRET_KEY: 1234..1234
SMTP_DOMAIN: post.yourdomain.com
SENDGRID_USERNAME: your_sendgrid_username
SENDGRID_PASSWORD: your_sendgrid_password
MAILCHIMP_API_KEY: f....3333-ek3
MAILCHIMP_LIST_ID: 9982...112
FILEPICKER_API_KEY: A....z
FILEPICKER_CDN_HOST: https://123abc.cloudfront.net
ADMIN_EMAILS: user1@domain.com,user2@domain.com
DOWNLOADER_ID: 1234..1234
DOWNLOADER_SECRET: 1234..1234
DOWNLOADER_URL: us.downloader.io
SEND_REPORT: "yes"
```

Your environment variables on Ninefold will need to be something like this:

```
MAIN_DOMAIN=yourdomain.com
SMTP_DOMAIN=post.yourdomain.me
RAILS_ENV=production
SECRET_KEY_BASE=1234..1234
DEVISE_SECRETE_KEY=1234..1234
SENDGRID_USERNAME=username
SENDGRID_PASSWORD=password
GOOGLE_ANALYTICS_ID=UA-12345-67
FILEPICKER_API_KEY=A....z
FILEPICKER_CDN_HOST=https://123abc.cloudfront.net
ADMIN_EMAILS=user1@domain.com,user2@domain.com

MAILCHIMP_API_KEY=f....3333-ek3
MAILCHIMP_LIST_ID=9982...112
SKYLIGHT_APPLICATION=abc123
SKYLIGHT_AUTHENTICATION=def456
DOWNLOADER_ID=1234..1234
DOWNLOADER_SECRET=1234..1234
DOWNLOADER_URL=us.downloader.io
SEND_REPORT="yes"
```

###Things you may want to rip out

Filepicker has an option to use Cloudfront to serve up the photos you upload. This will make loading your images a bit faster, so I recommend it if you already have AWS setup. However, you can skip this if you don't want to mess with all that by simply setting ```FILEPICKER_CDN_HOST=https://www.filepicker.io```.

If you want to bypass using Mailchimp to collect email addresses, simply don't put a value in for MAILCHIMP_API_KEY. I use Mailchimp to email out new features to the users at Dabble.me, so if you're the only one using your app it doesn't make sense to have Mailchimp.

Skylight is a server monitoring service I use to make sure the queries are optimized appropriately. You can remove the gem, and delete the file ```config/skylight.yml``` if you don't want to use this service.

Downloader.io is a service I was grandfathered into with a Heroku app I had. It's a fast qay to generate ZIP files so I used it here. Unfortunately they don't allow any more sign ups on the service, so you'll need to code up your own way of zipping up photos if you want that option. That's under ```entries#zip_up```.


###Administration Portal

The Admin emails are accounts that have access to the Admin Dropdown in the navbar (lock icon) that give you details into the number of entries and users in the system.

If you want random bits of inspiration, you can load up different quotes in the Inspiration table to be shown above the New Posts page and at the bottom of emails. If you plan on using OhLife, the system will tag imported posts with ```inspiration_id``` of 1 - so create the first Inspiration with a category name of "OhLife".

```
Inspiration.create(:category => "OhLife", :body => "Imported from OhLife")
```

=====

**Current features:**

* Read past entries by month/year
* Create new entries with simple formatting
* OhLife Importer
* Email: Reply-to-post new entries on days of the week you choose (with random past entries embedded)
* Associate 1 image to a specific entry, additional images emailed in will add to the bottom of posts
* Search with basic analytics around posting
* Hashtag support for tagging your entries

=====

Note: there is a directory at ```/public/cast``` that is not necessary for the journaling site, but rather part of an existing Chromecast site (https://dabble.me/cast) that is running on Dabble.me and needs to be there for the site to still function. Feel free to remove if you setup Dabble Me on your own servers.
