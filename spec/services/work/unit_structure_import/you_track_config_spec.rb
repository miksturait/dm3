require 'spec_helper'

describe Work::UnitStructureImport::YouTrackConfig do
  context "general config" do
    let(:config) { described_class.new("") }
    subject(:general) { config.attrs }

    its([:url]) { should eq "https://youtrack.mikstura.it" }
    its([:login]) { should eq "user" }
    its([:passwd]) { should eq "passwd" }
  end

  context "specific config" do
    before do
      ENV['YOUTRACK_MIKSTURA_IT_URL'] = 'http://mikstura.it'
      ENV['YOUTRACK_MIKSTURA_IT_LOGIN'] = 'some_user_login'
      ENV['YOUTRACK_MIKSTURA_IT_PASSWD'] = 'some_password'
    end
    let(:config) { described_class.new('mikstura_it') }
    subject(:mikstura_it) { config.attrs }

    its([:url]) { should eq "http://mikstura.it" }
    its([:login]) { should eq "some_user_login" }
    its([:passwd]) { should eq "some_password" }
  end

  context "when configuration keys are not defined" do
    let(:config) { described_class.new('dwo_mikstura_it') }
    subject(:mikstura_it) { config.attrs }

    its([:url]) { should be_nil }
  end
end