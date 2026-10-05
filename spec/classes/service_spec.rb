require 'spec_helper'

describe 'duo_authproxy::service' do
  let(:pre_condition) { 'include duo_authproxy' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with init script' do
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

        it {
          is_expected.not_to contain_file('/etc/systemd/system/duoauthproxy.service')
        }
      end

      context 'with systemd' do
        let(:pre_condition) do
          "class { 'duo_authproxy': use_systemd => true }"
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/system/duoauthproxy.service').with(
            ensure: 'file',
            owner: 'root',
            group: 'root',
            mode: '0644',
          )
        }

        it {
          is_expected.to contain_service('duoauthproxy').with(
            ensure: 'running',
            enable: true,
            hasrestart: true,
            provider: 'systemd',
          )
        }

        it {
          is_expected.to contain_service('duoauthproxy')
            .with_require(
              'File[/etc/systemd/system/duoauthproxy.service]',
            )
        }

        it 'creates the expected systemd unit' do
          resource = catalogue.resource(
            'File[/etc/systemd/system/duoauthproxy.service]',
          )

          content = resource[:content]

          content = content.unwrap if content.respond_to?(:unwrap)

          expect(content).to include(
            '[Unit]',
            'Description=Duo Security Authentication Proxy',
            'After=network.target',
            '[Service]',
            'Type=forking',
            'ExecStart=/opt/duoauthproxy/bin/authproxyctl start',
            'ExecStop=/opt/duoauthproxy/bin/authproxyctl stop',
            'StandardOutput=journal',
            'RemainAfterExit=true',
            '[Install]',
            'WantedBy=multi-user.target',
          )
        end
      end
    end
  end
end
