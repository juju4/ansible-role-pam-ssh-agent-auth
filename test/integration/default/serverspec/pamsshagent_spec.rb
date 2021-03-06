require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

describe package('sudo') do
  it { should be_installed }
end
describe package('pam-ssh-agent-auth'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  it { should be_installed }
end
describe package('libpam-ssh-agent-auth'), :if => os[:family] == 'ubuntu' && os[:release] == '17.04' do
  it { should be_installed }
end
describe package('libpam-ssh-agent-auth'), :if => os[:family] == 'debian' do
  it { should be_installed }
end
describe package('pam_ssh_agent_auth'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe file('/etc/sudoers') do
  it { should be_file }
  its(:content) { should match /Defaults env_keep \+= SSH_AUTH_SOCK/ }
  let(:sudo_options) { '-u root -H' }
end

describe file('/etc/pam.d/sudo') do
  it { should be_file }
  its(:content) { should match /auth sufficient pam_ssh_agent_auth\.so file=%h\/.ssh\/authorized_keys/ }
end

