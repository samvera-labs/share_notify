FactoryGirl.define do
  factory :document, class: ShareNotify::PushDocument do
    uri "http://example.com/fake-uri"
    initialize_with { new(uri) }

    factory :document_with_datetime do
      initialize_with { new(uri, DateTime.new(1990, 12, 12, 12, 12, 12, '+5')) }
    end

    factory :document_with_date do
      initialize_with { new(uri, Date.today) }
    end

    factory :valid_document do
      title 'Some title'
      after(:build) { |d| d.add_contributor(name: 'Job', email: 'joe@joe.com') }
    end

    factory :share_document do
      uri     'http://example.com/document1'
      version 'someID'
      title   'Interesting research'
      updated DateTime.new(2014, 12, 12)
      after(:build) do |d|
        d.add_contributor(name: 'Roger Movies Ebert', email: 'rogerebert@example.com')
        d.add_contributor(name: 'Roger Madness Ebert')
      end

      factory :delete_document do
        after(:build, &:delete)
      end
    end
  end

  # factory :document_v2, class: ShareNotify::Client::GraphNode do
  #   initialize_with {new ("CreativeWork", title: "alice tests", 
  #                         identifiers:[initialize_with { new("WorkIdentifier", uri: "http://example.com/alice")}]
  #                         )
  #                   }

  #   factory :workIdentifier_node do
  #     initialize_with { new('WorkIdentifier', uri: 'http://example.com/alice') }
  #   end
  # end

  # factory :document, class: ShareNotify::Client::Graph do
  #   uri "http://example.com/fake-uri"
  #   initialize_with { new(uri) }
  # end
end
