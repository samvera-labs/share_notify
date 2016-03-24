# Queries the SHARE search api for an existing record. This assumes the class into which this
# module is included responds to #url and that in turn is mapped to the docID of the Share
# document that was originally uploaded via the SHARE push API.
#
# @see ShareNotify::NotificationQueryService for details of interface expectations
module ShareNotify::Metadata
  extend ActiveSupport::Concern
  extend Forwardable

  def_delegator :notification_query_service, :share_notified?

  private

    def notification_query_service
      @notification_query_service ||= ShareNotify::NotificationQueryService.new(self)
    end
end
