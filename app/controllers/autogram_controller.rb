class AutogramController < ApplicationController

  def start
  end

  # def run
  #   unfollow = UnfollowController.new(run_params[:count].to_i)
  #   unfollow.unfollow(browser)
  #   # unfollow.unfollow(browser)
  # end

  def run
    unfollow = UnfollowController.new(run_params[:count].to_i)
    unfollow.unfollow(browser)
  end

  def browser
    linux_chrome = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'
    args = ["--headless", "user-agent=#{linux_chrome}"]
    browser = Watir::Browser.new :chrome, options: {args: args}
  end

  def authentication(browser)
    browser.goto LOGIN_PAGE
    puts 'goto LOGIN_PAGE'
    sleep(rand(3..7))
    browser.text_field(:name => 'username').set $username
    sleep(rand(3..7))
    browser.text_field(:name => 'password').set $password
    sleep(rand(3..10))
    #Click login button
    # browser.button(class: LOGIN_BUTTON).click
    browser.driver.execute_script(LOGIN_BUTTON_CLICK)
    puts 'LOGIN_BUTTON_CLICK'
    sleep(rand(6..10))
  end

  private

  def run_params
    params.permit(:count)
  end
end
