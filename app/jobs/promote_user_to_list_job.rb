class PromoteUserToListJob < ApplicationJob
  queue_as :priority

  def perform(token, list_id, user_id)
    client = Birder::Client.new(token)
    
    begin
      client.list.promote(list_id, user_id)
    rescue Birder::Error => e
      Honeybadger.notify(e)
    end
  end
end
