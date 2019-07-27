# frozen_string_literal: true

require 'rails_helper'
require 'support/ui_helper'

feature 'Authns', type: :feature, js: true do
  include_context 'db_cleanup_each'
  let(:user_props) { FactoryGirl.attributes_for(:user) }

  feature 'sign-up' do
    context 'valid registration' do
      scenario 'creates account and navigates away from signup page' do
        start_time = Time.now
        signup user_props

        # check we re-directed to home page
        expect(page).to have_no_css('#signup-form')
        # check the DB for the existance of the User account
        user = User.where(email: user_props[:email]).first
        # make sure we were the ones that created it
        expect(user.created_at).to be > start_time
        sleep 0.5 # give time for async requests to finish on server
      end
    end

    context 'rejected registration' do
      before(:each) do
        signup user_props
        expect(page).to have_no_css('#signup-form')
      end

      scenario 'account not created and stays on page' do
        dup_user = FactoryGirl.attributes_for(:user, email: user_props[:email])
        signup dup_user, false # should get rejected by server

        # account not created
        expect(User.where(email: user_props[:email], name: user_props[:name])).to exist
        expect(User.where(email: dup_user[:email], name: dup_user[:name])).to_not exist

        expect(page).to have_css('#signup-form')
        expect(page).to have_button('Sign Up')
      end
    end

    context 'invalid field' do
      after(:each) do
        within('#signup-form') do
          expect(page).to have_button('Sign Up', disabled: true)
        end
      end

      scenario 'bad email' do
        fillin_signup FactoryGirl.attributes_for(:user, email: 'yadayadayada')
        expect(page).to have_css("input[name='signup-email'].ng-invalid-email")
      end
      scenario 'missing password' do
        fillin_signup FactoryGirl.attributes_for(:user, password: nil)
        expect(page).to have_css("input[name='signup-password'].ng-invalid-required")
        expect(page).to have_css("input[name='signup-password_confirmation'].ng-invalid-required")
      end
    end
  end
end
