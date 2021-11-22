require 'rails_helper'

RSpec.describe Auth::OmniauthCallbacksController, type: :controller do
  describe 'access the mainpage' do
    around(:each) do |example|
      prev_fb_id = ENV['FACEBOOK_APP_ID']
      prev_google_id = ENV['GOOGLE_APP_ID']

      ENV['FACEBOOK_APP_ID'] = 'some_id'
      ENV['GOOGLE_APP_ID'] = 'some_id'

      example.run

      ENV['FACEBOOK_APP_ID'] = prev_fb_id
      ENV['GOOGLE_APP_ID'] = prev_google_id
    end

    it 'can sign in user with Facebook account' do
      visit new_user_session_path
      assert page.has_content?('Sign in with Facebook')
      mock_auth_hash 'facebook'
      click_link 'Sign in with Facebook'
      assert page.has_content?('My account')
      assert page.has_content?('14 days left in trial')
      assert page.has_content?('Sign out')
      click_link 'Sign out'
    end

    it 'can sign in user with Google account' do
      visit new_user_session_path
      assert page.has_content?('Sign in with Google')
      mock_auth_hash 'google_oauth2'
      click_link 'Sign in with Google'
      assert page.has_content?('My account')
      assert page.has_content?('14 days left in trial')
      assert page.has_content?('Sign out')
      click_link 'Sign out'
    end
  end
end
