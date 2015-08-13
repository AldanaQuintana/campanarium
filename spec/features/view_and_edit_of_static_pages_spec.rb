require 'spec_helper'

describe 'view and edit of static pages' do
  let!(:static_page){
    StaticPage.create(title_identifier: "Static Page",
      title: "Static Page", main_content: "Main static page content")
  }
  context 'when a visitor' do
    describe 'visits a static page' do
      before do
        visit static_page_path(static_page)
      end

      it 'should be able to see the static page contents' do
        expect_to_be_on_static_page
        expect(page).not_to have_css("a.edit-static-page", :text => "Editar")
      end
    end

    describe 'tries to access to the editor mode' do
      before do
        visit "/editor" + static_page_path(static_page)
      end

      it 'should be redirected to root path' do
        expect(current_path).to eq("/")
        expect(page).to have_content("No tiene autorización para realizar esa acción.")
      end
    end
  end

  context 'when a signed in user' do
    let!(:user){ create(:user) }
    describe 'visits a static page' do
      before do
        login!(user)
        visit static_page_path(static_page)
      end

      it 'should be able to see the static page contents' do
        expect_to_be_on_static_page
        expect(page).not_to have_css("a.edit-static-page", :text => "Editar")
      end
    end

    describe 'tries to access to the editor mode' do
      before do
        visit "/editor" + static_page_path(static_page)
      end

      it 'should be redirected to root path' do
        expect(current_path).to eq("/")
        expect(page).to have_content("No tiene autorización para realizar esa acción.")
      end
    end
  end

  context 'when an admin' do
    let!(:admin){ create(:admin) }
    describe 'visits a static page' do
      before do
        login!(admin)
        visit static_page_path(static_page)
      end

      it 'should be able to see the static page contents and the edit button' do
        expect_to_be_on_static_page
        expect(page).to have_css("a.edit-static-page", :text => 'Editar')
      end
    end
  end

  def expect_to_be_on_static_page
    expect(current_path).to eq("/static_pages/static-page")
    expect(page).to have_content("Static Page")
    expect(page).to have_content("Main static page content")
  end
end