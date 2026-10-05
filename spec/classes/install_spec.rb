require 'spec_helper'

describe 'duo_authproxy::install' do
  let(:pre_condition) { 'include duo_authproxy' }

  # Point rspec-puppet to your module's actual Hiera configuration
  let(:hiera_config) { File.expand_path('../../hiera.yaml', __dir__) }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }

        # Dynamically discover and assert all packages generated from Hiera data
        it 'contains all dependency packages resolved from Hiera' do
          # Extract all package resource titles present in the compiled catalog
          packages = catalogue.resources
                              .select { |r| r.type == 'Package' }
                              .map { |r| r.title }

          expect(packages).not_to be_empty, "Expected Hiera to provide dependency packages for #{os}, but none were found."

          # Assert each dynamically found package so rspec-puppet marks them as touched
          packages.each do |pkg|
            is_expected.to contain_package(pkg)
          end
        end

        it 'creates the archive using the Hiera version' do
          version = catalogue.resource('Class[Duo_authproxy]')[:version]

          expect(catalogue).to contain_archive(
            "/tmp/duoauthproxy-#{version}-src.tgz",
          )
        end

        it {
          is_expected.to contain_exec('duoauthproxy-make')
            .with(
              'command' => 'make > duoauthproxy-make.log',
              'cwd' => %r{/tmp/duoauthproxy-.*-src},
            )
        }

        it {
          is_expected.to contain_exec('duoauthproxy-install')
            .with_command(%r{--install-dir /opt/duoauthproxy})
        }

        it {
          is_expected.to contain_exec('duoauthproxy-tag')
            .with_command(%r{touch /opt/duoauthproxy/})
        }
      end

      context 'with exec_timeout set' do
        let(:exec_timeout) { 200 }

        let(:pre_condition) do
          "class { 'duo_authproxy': exec_timeout => #{exec_timeout} }"
        end

        it {
          is_expected.to contain_exec('duoauthproxy-make')
            .with(
              'command' => 'make > duoauthproxy-make.log',
              'cwd' => %r{/tmp/duoauthproxy-.*-src},
              'timeout' => exec_timeout,
            )
        }

        it {
          is_expected.to contain_exec('duoauthproxy-install')
            .with(
              'command' => %r{--install-dir /opt/duoauthproxy},
              'timeout' => exec_timeout,
            )
        }

        it {
          is_expected.to contain_exec('duoauthproxy-tag')
            .with(
              'command' => %r{touch /opt/duoauthproxy/},
              'timeout' => exec_timeout,
            )
        }
      end

      context 'with exec_timeout undef' do
        let(:exec_timeout) { 'undef' }

        let(:pre_condition) do
          "class { 'duo_authproxy': exec_timeout => #{exec_timeout} }"
        end

        it {
          is_expected.to contain_exec('duoauthproxy-make')
            .with(
              'command' => 'make > duoauthproxy-make.log',
              'cwd' => %r{/tmp/duoauthproxy-.*-src},
            )
            .without_timeout
        }

        it {
          is_expected.to contain_exec('duoauthproxy-install')
            .with_command(%r{--install-dir /opt/duoauthproxy})
            .without_timeout
        }

        it {
          is_expected.to contain_exec('duoauthproxy-tag')
            .with_command(%r{touch /opt/duoauthproxy/})
            .without_timeout
        }
      end
    end
  end
end
