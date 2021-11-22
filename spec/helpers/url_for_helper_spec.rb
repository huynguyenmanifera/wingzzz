require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#url_for_options_w_fallback' do
    before do
      allow(helper.request).to receive(:env).and_return(env)
      allow(helper).to receive(:action_name).and_return(action_name)
    end

    subject { helper.url_for_options_w_fallback(options) }

    let(:request_path) { '/users/password/new' }
    let(:env) { { 'REQUEST_PATH' => request_path } }
    let(:options) { { locale: 'nl' } }

    describe 'after a query request' do
      let(:action_name) { 'index' }

      it { is_expected.to eql(options) }

      it 'stores the URL' do
        subject
        expect(session[:wz_fallback_location]).to eql(request_path)
      end
    end

    describe 'after a command request' do
      before { allow(helper).to receive(:session).and_return(session) }

      let(:session) do
        { wz_fallback_location: '/users/password/new?locale=en' }
      end
      let(:expected_path) { '/users/password/new?locale=nl' }

      context 'create' do
        let(:action_name) { 'create' }
        it { is_expected.to eql(expected_path) }
      end

      context 'update' do
        let(:action_name) { 'update' }
        it { is_expected.to eql(expected_path) }
      end
    end
  end
end
