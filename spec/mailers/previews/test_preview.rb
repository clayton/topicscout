# Preview all emails at http://localhost:3000/rails/mailers/test
class TestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/test/hello
  def hello
    TestMailer.hello
  end

end
