class UnfollowController < ApplicationController

  def initialize(count)
    @logins = Login.where(following: true, friend: false, used: false).first(count)
  end

  def unfollow(browser)

    AutogramController.new.authentication(browser)
    puts 'AutogramController.new.authentication(browser)'
    @logins.each do |login|
      browser.goto "instagram.com/#{login.name}/"
      sleep(rand(10..20))
      puts login
      if browser.text.include?("Sorry, this page isn't available.")
        puts "Sorry, this page isn't available."
        login.used = true
        login.save
      else
        if browser.button(class: FOLLOW).exists? || browser.button(class: FOLLOW_PRIVATE_PAGE).exists?
          puts 'browser.button(class: FOLLOW).exists? || browser.button(class: FOLLOW_PRIVATE_PAGE).exists?'
          login.used = true
          login.save
        elsif browser.button(class: REQUESTED).exists?
          puts 'browser.button(class: REQUESTED).exists?'
          login.used = true
          login.save
        elsif browser.button(class: FOLLOWING).exists?
          puts 'browser.button(class: FOLLOWING).exists?'
          begin
            browser.button(class: FOLLOWING).click
          rescue
          end
          if browser.button(class: UNFOLLOWING).exists?
            puts 'browser.button(class: UNFOLLOWING).exists?'
            sleep(rand(2..7))
            begin
              puts 'browser.button(class: UNFOLLOWING).click'
              browser.button(class: UNFOLLOWING).click
            rescue
            end
            login.used = true
            login.save
          end
        end
      end
      sleep(rand(180..260))
    end
    # UnfollowWorker.perform_async(browser)
    # redirect_to action: :start
  end
end
