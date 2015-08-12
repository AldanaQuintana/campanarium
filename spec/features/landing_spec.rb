require 'spec_helper'

describe 'landing' do
  context 'when a visitor visits it' do
    before do
      visit "/"
    end

    it do
      expect(page).to have_link("Sobre el proyecto")
      expect(page).to have_link("FAQs")
      expect(page).to have_link("Contacto")
      expect(page).to have_link("Ingresa con Twitter")
      expect(page).to have_link("Ingresa con Facebook")
    end
  end
end