require 'spec_helper'
include Alchemy::Admin::EssencesHelper

describe 'alchemy/essences/_essence_boolean_editor' do
  let(:element) { Alchemy::Element.new }
  let(:essence) { Alchemy::EssenceBoolean.new(ingredient: false) }
  let(:content) { Alchemy::Content.new(essence: essence, name: 'Boolean', element: element) }

  it_behaves_like "an essence editor partial"

  it "renders a checkbox" do
    render partial: "alchemy/essences/essence_boolean_editor", locals: {content: content}
    expect(rendered).to have_selector('input[type="checkbox"]')
  end

  context 'with default value given in view local options' do
    it "checks the checkbox" do
      render partial: "alchemy/essences/essence_boolean_editor", locals: {content: content, options: {default_value: true}}
      expect(rendered).to have_selector('input[type="checkbox"][checked="checked"]')
    end
  end

  context 'with default value given in content settings' do
    before { allow(content).to receive(:settings).and_return({default_value: true}) }

    it "checks the checkbox" do
      render partial: "alchemy/essences/essence_boolean_editor", locals: {content: content}
      expect(rendered).to have_selector('input[type="checkbox"][checked="checked"]')
    end
  end
end
