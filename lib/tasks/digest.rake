namespace :digest do
  desc 'Send daily digests'
  task daily: :environment do
    User.verified.includes(:topics).each do |user|
      user.topics.each do |topic|
        SendDailyDigestJob.perform_later(topic.latest_result)
      end
    end
  end
end
