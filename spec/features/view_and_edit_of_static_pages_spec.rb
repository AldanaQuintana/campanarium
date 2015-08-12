require 'spec_helper'

describe 'view and edit of static pages' do
  context 'when a visitor visits a static page' do
    let!(:static_page){
      StaticPage.create(title_identifier: "Static Page",
        title: "Static Page", main_content: "Main static page content")
    }
    before do
      visit static_page_path(static_page)
    end

    it 'should be able to see the static page contents' do
      expect(current_path).to eq("/static_pages/static-page")
      expect(page).to have_content("Static Page")
      expect(page).to have_content("Main static page content")
    end
  end
end