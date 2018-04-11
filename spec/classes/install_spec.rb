require 'spec_helper'

describe 'duo_authproxy::install' do
  let(:pre_condition) { 'include duo_authproxy' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
