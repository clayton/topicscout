class PromoteUserToListJob < ApplicationJob
  queue_as :priority

  def perform(token, list_id, user_id)
    
    client = Birder::Client.new(token)

    begin
      raise "Missing Token", "Token is missing" if token.blank?
      raise "Missing List ID", "List ID is missing" if list_id.blank?
      raise "Missing User ID", "User ID is missing" if user_id.blank?
      
      client.list.promote(list_id, user_id)
    rescue Birder::Error => e
      Honeybadger.notify(e)
    end
  end
end
