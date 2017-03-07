# ShareNotify

[![Gem Version](https://badge.fury.io/rb/share_notify.svg)](https://badge.fury.io/rb/share_notify)
[![Build Status](https://api.travis-ci.org/projecthydra-labs/share_notify.png?branch=master)](https://travis-ci.org/projecthydra-labs/share_notify)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

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

(In reality, any object that conforms to the PushDocument interface will work).
Then send the document the Share Push-Gateway using the `ApiV2` class:

    api = ShareNotify::ApiV2.new
    api.upload_record(document)

#### Push Document Metadata

The `PushDocument` should supply the following fields.

Method          | Description
----------------|------------
`.title`        | the title as a string
`.rights`       | the usage rights, as a string
`.description`  | the description, as a string
`.languages`    | the language the document is in, as a list of strings
`.date_published` | the date the document was published, as string?
`.providerUpdatedDateTime` | the modified date of this record
`.type`         | the type of item this is. Defaults to "CreativeWork"
`.related_agents` | any authors or other people related to the work
                | is list of hashes with the fields
                | .type - ?
                | .agent_type - ?
                | .name, etc..(from share)
`.uris.canonicalUri` | the canonical URI identifying the work
`.tags`         | list of tags for this item. is a list of strings
`.is_deleted`   | true if this item is to be deleted from SHARE


### Deleting Data

Same as above, but adding an additional "delete" property informs the Share API that this
document should be delete from the Search API:

    >  document = ShareNotify::PushDocument.new("http://my.document.id/1234")
    >  document.title = "Some Title"
    >  document.add_contributor(name: "My Name", email: "myemail@example.com")
    >  document.delete
    >  api = ShareNotify::ApiV2.new
    >  api.upload_record(document)

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
in or be deleted from the Search API.

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
