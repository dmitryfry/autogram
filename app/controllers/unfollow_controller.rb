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
        if browser.button(class: FOLLOW).exists? || browser.button(class: FOLLOW_PRIVATE_PAGE).exists?
          logger.info("FOLLOW_PRIVATE_PAGE exists")
          login.used = true
          login.save
        # elsif browser.button(class: REQUESTED).exists?
        #   logger.info("REQUESTED exists")
        #   login.used = true
        #   login.save
        elsif browser.button(class: FOLLOWING_OR_REQUESTED).exists?
          logger.info("FOLLOWING_OR_REQUESTED exists")
          begin
            browser.button(class: FOLLOWING_OR_REQUESTED).click
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
        end
      end
      sleep(rand(80..100))
    end
    # UnfollowWorker.perform_async(browser)
    # redirect_to action: :start
  end
end
