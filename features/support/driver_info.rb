module DriverInfo
  def javascript_capable?
    selenium_driver? || poltergeist_driver? || webkit_driver?
  end

  def selenium_driver?
    Object.const_defined?('Capybara::Selenium') &&
      Capybara.current_session.driver.is_a?(Capybara::Selenium::Driver)
  end

  def poltergeist_driver?
    Object.const_defined?('Capybara::Poltergeist') &&
      Capybara.current_session.driver.is_a?(Capybara::Poltergeist::Driver)
  end

  def webkit_driver?
    Object.const_defined?('Capybara::Webkit') &&
      Capybara.current_session.driver.is_a?(Capybara::Webkit::Driver)
  end
end

World(DriverInfo)
