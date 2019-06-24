# frozen_string_literal: true

require 'rails_helper'

feature 'Mainpages', type: :feature, js: true do
  context 'when the main page is accessed' do
    before(:each) do
      visit '/'
    end
    it 'displays the index.html launch page' do
      # save_and_open_screenshot
      expect(page).to have_content('Hello')
      expect(page).to have_content('from app/views/ui/index.html.erb')
    end
    it 'index page has bootstrap styling' do
      expect(page).to have_css('div.layout-row')
      expect(page).to have_css('div.layout-row > div.flex-gt-sm-70.flex')
    end
    it 'displays the main application page' do
      expect(page).to have_content('Sample App')
      expect(page).to have_content('from spa-demo/pages/main.html')
    end
    it 'displays the foos tile' do
      expect(page).to have_content('Foos')
      expect(page).to have_content('from spa-demo/foos/foos.html')
    end
  end
end
