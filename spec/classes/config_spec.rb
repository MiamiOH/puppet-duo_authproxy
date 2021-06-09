require 'spec_helper'

describe 'duo_authproxy::config' do
  let(:pre_condition) { "class { 'duo_authproxy': settings => {'main' => {'debug' => 'true'}} }" }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with settings' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('authproxy.cfg').with(
            'ensure'  => 'file',
            'path'    => '/opt/duoauthproxy/conf/authproxy.cfg',
            'owner'   => 'duo_authproxy_svc',
            'group'   => 'root',
            'mode'    => '0400',
            'content' => 'Sensitive [value redacted]',
          )
        end
      end
    end
  end
end
