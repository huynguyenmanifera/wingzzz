module Fullscreen
  def app_is_in_full_screen?
    page.evaluate_script('!!document.fullscreenElement')
  end
end

World(Fullscreen)
