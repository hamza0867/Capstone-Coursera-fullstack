# frozen_string_literal: true

module FooUiHelper
  FOO_FORM_XPATH = '//h3[text()="Foos"]/../md-content/form'
  FOO_LIST_XPATH = '//h3[text()="Foos"]/../md-list'

  def create_foo(foo_state)
    visit root_path unless page.has_xpath?('//h3', text: /foos/i)

    within(:xpath, FOO_FORM_XPATH) do
      fill_in('name', with: foo_state[:name])
      click_button('Create Foo')
    end

    within(:xpath, FOO_LIST_XPATH) do
      expect(page).to have_css('button', text: /#{foo_state[:name]}/i)
    end
  end

  def update_foo(exisintg_name, new_name)
    visit root_path unless page.has_xpath?('//h3', text: /foos/i)
    within(:xpath, FOO_LIST_XPATH) do
      expect(page).to have_css('button', text: /#{exisintg_name}/i)
      click_button(exisintg_name.to_s)
    end
    within(:xpath, FOO_FORM_XPATH) do
      expect(page).to have_css('button', text: /update/i)
      fill_in('name', with: new_name)
      click_button('Update')
    end
    within(:xpath, FOO_LIST_XPATH) do
      expect(page).to have_no_css('button', text: /#{exisintg_name}/i)
      expect(page).to have_css('button', text: /#{new_name}/i)
    end
  end

  def delete_foo(name)
    visit root_path unless page.has_xpath?('//h3', text: /foos/i)
    within(:xpath, FOO_LIST_XPATH) do
      expect(page).to have_css('button', text: /#{name}/i)
      click_button(name.to_s)
    end
    within(:xpath, FOO_FORM_XPATH) do
      expect(page).to have_css('button', text: /Delete/i)
      click_button('Delete')
    end
    within(:xpath, FOO_LIST_XPATH) do
      expect(page).to have_no_css('button', text: /#{name}/i)
    end
  end
end
