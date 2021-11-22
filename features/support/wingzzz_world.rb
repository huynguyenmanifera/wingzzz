# Starting point to define cucumber helper methods.
# We should probably split up somewhere in time.
module WingzzzWorld
  def wait_until_full_epub_is_rendered
    # We should find a better way to check if the epub
    # is fully rendered, since this is currently not scalable.
    sleep 5
  end

  def within_an_epub_page(side = :left)
    within('div[data-visible="true"]') do
      index = side == :left ? 0 : -1
      iframe = all('iframe')[index]

      within_frame(iframe) { yield }
    end
  end

  def epub_page_visible?
    page.has_css? 'div[data-visible="true"]'
  end

  def search_results_visible?
    page.has_css? '.search_results'
  end

  def click_on_and_confirm(locator)
    link_or_button = find(:link_or_button, locator)
    page.evaluate_script('window.confirm = () => true')
    expect(link_or_button['data-confirm']).to be_a(String)
    link_or_button.click
  end

  def within_library
    within('.library ul') { yield }
  end

  def within_search_results
    within('.search_results ul') { yield }
  end

  def within_new_releases
    within('.recently-added ul') { yield }
  end

  def within_currently_reading
    within('.currently-reading ul') { yield }
  end

  def drag_by(right_by, down_by)
    driver.browser.action.drag_and_drop_by(native, right_by, down_by).perform
  end
end

World(WingzzzWorld)
