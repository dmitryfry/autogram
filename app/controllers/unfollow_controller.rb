class UnfollowController < ActionController::Base

  def initialize(count)
    @logins = Login.where(following: true, friend: false, used: false).first(count)
  end

  def unfollow(browser)

    @logins.each do |login|

      browser.goto "instagram.com/#{login.name}/"
      sleep(rand(10..20))

      if browser.text.include?("Sorry, this page isn't available.")
        login.used = true
        login.save
      else
        if browser.button(class: FOLLOW).exists? || browser.button(class: FOLLOW_PRIVATE_PAGE).exists?
          login.used = true
          login.save
        elsif browser.button(class: REQUESTED).exists?
          login.used = true
          login.save
        elsif browser.button(class: FOLLOWING).exists?
          begin
            browser.button(class: FOLLOWING).click
          rescue
          end
          if browser.button(class: UNFOLLOWING).exists?
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
      sleep(rand(180..260))
    end
  end
end