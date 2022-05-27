class TestMailer < ApplicationMailer
  default from: 'clayton@labountylabs.com'

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'clayton@labountylabs.com',
      from: 'clayton@labountylabs.com',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'outbound')
  end
end