class LogoComponent < ViewComponent::Base
  def initialize(dark_mode: false)
    @dark_mode = dark_mode
  end

  def image_file
    @dark_mode ? 'wingzzz_logo_white.png' : 'wingzzz_logo_black.png'
  end
end
