# frozen_string_literal: true

require 'rails_helper'

feature 'ManageFoos', type: :feature, js: true do
  include_context 'db_cleanup_each'
  FOO_FORM_CSS = 'body > div > div > div > div > div > md-content > form'
  FOO_FORM_XPATH = '//h3[text()="Foos"]/../md-content/form'
  FOO_LIST_XPATH = '//h3[text()="Foos"]/../md-list'

  feature 'view existing foos' do
    let(:foos) { (1..5).map { FactoryGirl.create(:foo) }.sort_by { |v| v['name'] } }

    scenario 'when no instances exist' do
      visit root_path
      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_no_css('md-list-item')
      end
    end
    scenario 'when instances exist' do
      visit root_path if foos
      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_css("md-list-item:nth-child(#{foos.count})")
        foos.each_with_index do |foo, idx|
          # expect(page).to have_css("md-list-item:nth-child(#{idx + 1})", text: foo.name.upcase)
          within(:xpath, FOO_LIST_XPATH + "/md-list-item[position()=#{idx + 1}]") do
            expect(page).to have_content(/#{foo.name}/i)
          end
        end
      end
    end
  end

  feature 'add new Foo' do
    background(:each) do
      visit root_path
      expect(page).to have_css('h3', text: 'Foos')
      expect(page).to have_no_css('md-list-item')
    end
    scenario 'has input form' do
      expect(page).to have_css('label', text: 'Name')
      expect(page).to have_css('input[name="name"][ng-model*="foo.name"]')
      expect(page).to have_css("button[ng-click*='create()']", text: 'Create Foo'.upcase)
      expect(page).to have_button('Create Foo')
    end
    scenario 'complete form'
  end

  feature 'with existing Foo' do
    scenario 'can be updated'
    scenario 'can be deleted'
  end
end
