# frozen_string_literal: true

class RegistrationMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to our site')
  end
end
