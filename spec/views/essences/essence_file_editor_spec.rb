require 'spec_helper'
include Alchemy::Admin::EssencesHelper

describe 'alchemy/essences/_essence_editor_view' do
  let(:file)       { File.new(File.expand_path('../../../fixtures/image with spaces.png', __FILE__)) }
  let(:attachment) { build_stubbed(:attachment, file: file) }
  let(:essence)    { build_stubbed(:essence_file, attachment: attachment) }
  let(:content)    { build_stubbed(:content, essence: essence) }
  let(:element)    { Alchemy::Element.new }

  it_behaves_like "an essence editor partial"

  subject do
    render partial: "alchemy/essences/essence_file_editor", locals: {content: content}
    rendered
  end

  before do
    view.class.send :include, Alchemy::Admin::BaseHelper
    allow(view).to receive(:_t).and_return('')
    allow(content).to receive(:element) { element }
  end

  context 'with ingredient present' do
    before do
      allow(content).to receive(:ingredient).and_return(attachment)
    end

    it "renders a hidden field with attachment id" do
      is_expected.to have_selector("input[type='hidden'][value='#{attachment.id}']")
    end

    it "renders a link to open the attachment library overlay" do
      is_expected.to have_selector("a.assign_file[href='/admin/attachments?content_id=#{content.id}&options=%7B%7D']")
    end

    it "renders a link to edit the essence" do
      is_expected.to have_selector("a.edit_file[href='/admin/essence_files/#{essence.id}/edit?options=%7B%7D']")
    end

    context "with settings[:except]" do
      before do
        allow(content).to receive(:settings) { {except: 'pdf'} }
      end

      it "does requests for these type of files" do
        render_essence_editor(content)
        expect(rendered).to have_selector('a[href*="except=pdf"]')
      end
    end

    context "with options[:except]" do
      it "does requests for these type of files" do
        render_essence_editor(content, except: 'pdf')
        expect(rendered).to have_selector('a[href*="except=pdf"]')
      end
    end

    context "with settings[:only]" do
      before do
        allow(content).to receive(:settings) { {only: 'pdf'} }
      end

      it "does requests for these type of files" do
        render_essence_editor(content)
        expect(rendered).to have_selector('a[href*="only=pdf"]')
      end
    end

    context "with options[:only]" do
      it "does requests for these type of files" do
        render_essence_editor(content, only: 'pdf')
        expect(rendered).to have_selector('a[href*="only=pdf"]')
      end
    end
  end

  context 'without ingredient present' do
    before do
      allow(content).to receive(:ingredient).and_return(nil)
    end

    it "does not render a hidden field with attachment id" do
      is_expected.to_not have_selector("input[type='hidden']")
    end
  end
end
