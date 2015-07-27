class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def delete_confirmation(user)
    @user = user
    @url = 'www.google.com'
    mail(to: @user.email, subject: 'Sorry to ban you')
  end
  
end
