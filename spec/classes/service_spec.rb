require 'spec_helper'

describe 'duo_authproxy::service' do
  let(:pre_condition) { 'include duo_authproxy' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_service('duoauthproxy').with(
          ensure: 'running',
          enable: true,
          hasrestart: true,
          hasstatus: false,
          status: '/opt/duoauthproxy/bin/authproxyctl status',
        )
      }
    end
  end
end
