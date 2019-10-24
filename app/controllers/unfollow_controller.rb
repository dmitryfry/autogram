class UnfollowController < ApplicationController

  def initialize(count)
    @logins = Login.where(following: true, friend: false, used: false).first(count)
  end

  def unfollow(browser)

    AutogramController.new.authentication(browser)
    logger.info "AutogramController.new.authentication(browser)"
    @logins.each do |login|
      browser.goto "instagram.com/#{login.name}/"
      sleep(rand(10..20))
      logger.info(login.name)
      if browser.text.include?("Sorry, this page isn't available.")
        logger.info("Sorry, this page isn't available.")
        login.used = true
        login.save
      else
        if browser.button(text: REQUESTED_TEXT).exists?
          logger.info("REQUESTED exists")
          begin
            browser.button(text: REQUESTED_TEXT).click
          rescue
          end
          if browser.button(class: UNFOLLOWING).exists?
            logger.info("UNFOLLOWING exists")
            sleep(rand(2..7))
            begin
              browser.button(class: UNFOLLOWING).click
            rescue
            end
            login.used = true
            login.save
          end
        elsif browser.button(text: FOLLOWING_TEXT).exists?
          logger.info("FOLLOWING exists")
          begin
            browser.button(text: FOLLOWING_TEXT).click
          rescue
          end
          if browser.button(class: UNFOLLOWING).exists?
            logger.info("UNFOLLOWING exists")
            sleep(rand(2..7))
            begin
              browser.button(class: UNFOLLOWING).click
            rescue
            end
            login.used = true
            login.save
          end
        elsif browser.button(text: FOLLOW_TEXT).exists? #|| browser.button(text: FOLLOW_PRIVATE_PAGE).exists?
          logger.info("FOLLOW exists")
          login.used = true
          login.save
        end
      end
      sleep(rand(80..100))
    end
    # UnfollowWorker.perform_async(browser)
    # redirect_to action: :start
  end
end
