require 'spec_helper'

describe AppdirectIntegration do
  it 'has a version number' do
    expect(AppdirectIntegration::VERSION).not_to be nil
  end

  describe 'configuration' do
    before do
      AppdirectIntegration.configure do |c|
      end
    end

    it 'exists' do
      expect(AppdirectIntegration.configuration).not_to be nil
    end

    it 'points to appdirect' do
      expect(AppdirectIntegration.configuration.appdirect_url).to eq 'https://www.appdirect.com'
    end
  end
end
