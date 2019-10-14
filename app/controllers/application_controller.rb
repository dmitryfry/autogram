class ApplicationController < ActionController::Base
  include Constants

  def browser
    linux_chrome = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'
    args = ["--headless", "user-agent=#{linux_chrome}"]
    browser = Watir::Browser.new :chrome, options: {args: args}
  end

  def authentication(browser)
    browser.text_field(:name => 'username').set "#{$username}"
    sleep(rand(3..7))
    browser.text_field(:name => 'password').set "#{$password}"
    sleep(rand(3..10))
    #Click login button
    browser.button(class: LOGIN_BUTTON).click
    sleep(rand(7..10))
  end
end
