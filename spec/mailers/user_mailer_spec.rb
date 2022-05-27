require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "verify_email" do
    let(:mail) { UserMailer.verify_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Verify email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
