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

  factory :document_v2, class: ShareNotify::Graph do
    push_doc = ShareNotify::PushDocument.new("http://example.com/", DateTime.new(1990, 12, 12, 12, 12, 12, '+5'))
    push_doc.title = "V2 title"
    push_doc.languages = ["English"]
    push_doc.tags = ["tag1", "tag2"]
    push_doc.related_agents = [{ agent_type: "creator", type: "person", name: "person name" }]
    push_doc.add_contributor(name: 'Roger Madness Ebert')
    initialize_with { new(push_doc) }
  end
end
