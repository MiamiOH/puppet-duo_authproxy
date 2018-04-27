require 'spec_helper'

describe 'duo_authproxy::config' do
  let(:pre_condition) { "class { 'duo_authproxy': settings => {'main' => {'debug' => 'true'}} }" }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with settings' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_ini_setting('/opt/duoauthproxy/conf/authproxy.cfg [main] debug').with(
            'section' => 'main',
            'setting' => 'debug',
            'value'   => 'true',
            'path'    => '/opt/duoauthproxy/conf/authproxy.cfg',
          )
        end
      end
    end
  end
end
