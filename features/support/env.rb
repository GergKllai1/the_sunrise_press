require 'coveralls'
Coveralls.wear_merged!('rails')
require 'cucumber/rails'
ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Chromedriver.set_version '2.42'

chrome_options = %w[no-sandbox disable-popup-blocking disable-infobars]

chrome_options << 'auto-open-devtools-for-tabs'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: chrome_options
  )
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Before '@stripe' do
  chrome_options << 'headless'
  StripeMock.start
end

After '@stripe' do 
  StripeMock.stop
end

Capybara.server = :puma
Capybara.javascript_driver = :chrome