require 'rails_helper'

RSpec.feature "Inputfile management", :type => :feature do
  scenario "Page directs to Input file manager" do
    visit "/inputfiles"
    expect(page).to have_content("New Input File")
  end
  scenario "User clicks to create load new inputfile" do
    visit "/inputfiles"
    click_link("New Input File")
    expect(page).to have_content("Menu Name")
  end
  scenario "User is able to vist help page" do
    visit "/help"
    expect(page).to have_content("Sample File")
  end
  scenario "Expect root to direct to main landing page" do
    visit "/"
    expect(page).to have_content("Restaurant Challenge")
  end
end
