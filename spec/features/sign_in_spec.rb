require 'spec_helper'

describe 'sign in' do
  context 'when a visitor' do
    describe 'visits the landing' do
      before do
        visit "/"
      end

      it do
        expect_to_be_on_landing
      end
    end

    describe 'visits notice page' do
      before do
        visit "/noticias"
      end

      it do
        expect_to_be_on_landing
      end
    end
  end

  context 'when a user signs in' do
    let!(:user){ create(:user) }
    before do
      login!(user)
    end

    it do
      expect_to_be_on_notices_page
    end

    describe 'visits the landing' do
      before do
        visit("/")
      end

      it do
        expect_to_be_on_notices_page
      end
    end
  end

  def expect_to_be_on_notices_page
    expect(response).to eq(200)
    expect(current_path).to eq("/noticias")
    expect(page).not_to have_link("Ingresa con Twitter")
    expect(page).not_to have_link("Ingresa con Facebook")
  end

  def expect_to_be_on_landing
    expect(current_path).to eq("/")
    expect(page).to have_link("EL PROYECTO")
    expect(page).to have_link("FAQS")
    expect(page).to have_link("CONTACTO")
    expect(page).to have_link("Ingresa con Twitter")
    expect(page).to have_link("Ingresa con Facebook")
  end
end