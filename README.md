# ShareNotify

Provides basic tools for creating documents to send to SHARENotify's Push API as well as query for documents
using SHARE Search.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'share_notify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install share_notify

## Usage

### Configuration

In order to push data to Share, you will need a token from OSF. Once obtained, you'll put this in a config folder
in your Rails application or project as `config/share_notify.yml`:

    ---
    host: "https://osf.io"
    token: "MY_TOKEN"

### Pushing Data

First, create a `PushDocument` with the required metadata:

    >  document = ShareNotify::PushDocument.new("http://my.document.id/1234")
    >  document.title = "Some Title"
    >  document.add_contributor(name: "My Name", email: "myemail@example.com")
    >  document.valid?
    => true

Then send the document to Share using the `API` class:

    api = ShareNotify::API.new
    api.post(document.to_share.to_json)

### Querying

You can query Share's Search API using the terms outlined in <https://osf.io/dajtq/wiki/SHARE%20Search>

    api = ShareNotify::API.new
    api.search([query terms])

#### Extending Your Classes

Assuming your data class has a `#url` method, and that url is used to create the initial `PushDocument`
that's sent to Share, you can include `ShareNotify::Metadata` to query Share and determine 
if the document is already present in ShareNotify's Search API.

    class MyDataClass
      include ShareNotify::Metadata

      def url
        "http://my.document.id/1234"
      end
    end

    >  document = MyDataClass.find("1234")
    >  document.share_notified?
    => true

Note: It may take 24 hours or more before documents that have been initially pushed to Share will appear
in the Search API.

## Contributing

### Hydra Developers

For Hydra developers, or anyone with a signed CLA, please clone the repo and submit PRs via
feature branches. If you don't have rights to projecthydra-labs and do have a signed
CLA, please send a note to hydra-tech@googlegroups.com.

1. Clone it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Non-Hydra Developers

Anyone is welcome to use this software and report issues.
In order to merge any work contributed, you'll need to sign a contributor license agreement.
For more information on signing a CLA, please contact `legal@projecthyra.org`
# Project Hydra
This software has been developed by and is brought to you by the Hydra community.  Learn more at the
[Project Hydra website](http://projecthydra.org)
