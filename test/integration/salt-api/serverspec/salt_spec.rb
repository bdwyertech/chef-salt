require 'serverspec'

set :backend, :exec

describe 'Salt Key Exchange' do
  describe command('salt-key --list=pre') do
    its(:stdout) { should match(/salt-api-/) }
  end
end

describe 'Salt Master' do
  describe package('salt-master') do
    it { should be_installed }
  end

  describe package('salt-api') do
    it { should be_installed }
  end

  # Service check not supported in RedHat 5, however we still have the proccess check
  unless os[:family] == 'RedHat' && os[:release] =~ /^5\./
    describe service('salt-master') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('salt-api') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe process('salt-master') do
    it { should be_running }
  end

  describe process('salt-api') do
    it { should be_running }
  end

  describe file('/etc/salt/master') do
    it { should be_file }
    its(:content) { should match(/^interface: 0.0.0.0/) }
    its(:content) { should match(/^ipv6: false/) }
    its(:content) { should match(/^publish_port: 4505/) }
    its(:content) { should match(/^user: root/) }
    its(:content) { should match(/^max_open_files: 100000/) }
    its(:content) { should match(/^worker_threads: 5/) }
    its(:content) { should match(/^ret_port: 4506/) }
    its(:content) { should match %r{^pidfile: /var/run/salt-master.pid} }
    its(:content) { should match %r{^root_dir: /} }
    its(:content) { should match %r{^pki_dir: /etc/salt/pki/master} }
    its(:content) { should match %r{^cachedir: /var/cache/salt/master} }
    its(:content) { should match(/^verify_env: true/) }
    its(:content) { should match(/^keep_jobs: 24/) }
    its(:content) { should match(/^timeout: 5/) }
    its(:content) { should match(/^loop_interval: 60/) }
    its(:content) { should match(/^output: nested/) }
    its(:content) { should match(/^show_timeout: true/) }
    its(:content) { should match(/^color: true/) }
    its(:content) { should match(/^strip_colors: false/) }
    its(:content) { should match %r{^sock_dir: /var/run/salt/master} }
    its(:content) { should match(/^enable_gpu_grains: false/) }
    its(:content) { should match(/^job_cache: true/) }
    its(:content) { should match(/^minion_data_cache: true/) }
    its(:content) { should match(/^event_return_queue: 0/) }
    its(:content) { should match(/^max_event_size: 1048576/) }
    its(:content) { should match(/^ping_on_rotate: false/) }
    its(:content) { should match(/^preserve_minion_cache: false/) }
    its(:content) { should match(/^con_cache: false/) }
    its(:content) { should match(/^open_mode: false/) }
    its(:content) { should match(/^auto_accept: false/) }
    its(:content) { should match(/^autosign_timeout: 120/) }
    its(:content) { should match %r{^autosign_file: /etc/salt/autosign.conf} }
    its(:content) { should match %r{^autoreject_file: /etc/salt/autoreject.conf} }
    its(:content) { should match(/^permissive_pki_access: false/) }
    its(:content) { should match(/^sudo_acl: false/) }
    its(:content) { should match(/^token_expire: 43200/) }
    its(:content) { should match(/^file_recv: false/) }
    its(:content) { should match(/^file_recv_max_size: 100/) }
    its(:content) { should match(/^sign_pub_messages: false/) }
    its(:content) { should match(/^cython_enable: false/) }
    its(:content) { should match(/^state_top: top.sls/) }
    its(:content) { should match(/^renderer: yaml_jinja/) }
    its(:content) { should match(/^jinja_lstrip_blocks: false/) }
    its(:content) { should match(/^failhard: false/) }
    its(:content) { should match(/^state_verbose: true/) }
    its(:content) { should match(/^state_output: full/) }
    its(:content) { should match(/^state_aggregate: false/) }
    its(:content) { should match(/^state_events: false/) }
    its(:content) { should match(/^hash_type: md5/) }
    its(:content) { should match(/^file_buffer_size: 1048576/) }
    its(:content) { should match(/^fileserver_events: false/) }
    its(:content) { should match %r{^log_file: /var/log/salt/master} }
    its(:content) { should match %r{^key_logfile: /var/log/salt/key} }
    its(:content) { should match(/^log_level: warning/) }
    its(:content) { should match(/^log_level_logfile: warning/) }
    its(:content) { should match(/^log_datefmt: '%H:%M:%S'/) }
    its(:content) { should match(/^log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'/) }
    its(:content) { should match(/^log_fmt_console: '\[%\(levelname\)-8s\] %\(message\)s'/) }
    its(:content) { should match(/^log_fmt_logfile: '%\(asctime\)s,%\(msecs\)03.0f \[%\(name\)-17s\]\[%\(levelname\)-8s\] %\(message\)s'/) }
    its(:content) { should match(/^return: mysql/) }

    # salt-api config
    its(:content) { should match(/^rest_cherrypy:/) }
    its(:content) { should match(/^  collect_stats: false/) }
    its(:content) { should match(/^  debug: false/) }
    its(:content) { should match(/^  disable_ssl: true/) }
    its(:content) { should match(/^  expire_responses: true/) }
    its(:content) { should match(/^  host: 0.0.0.0/) }
    its(:content) { should match(/^  max_request_body_size: 1048576/) }
    its(:content) { should match(/^  port: 8000/) }
    its(:content) { should match(/^  socket_queue_size: 30/) }
    its(:content) { should match(/^  ssl_crt: /) }
    its(:content) { should match(/^  ssl_key: /) }
    its(:content) { should match(/^  thread_pool: 100/) }
    its(:content) { should match(/^  webhook_disable_auth: false/) }
    its(:content) { should match %r{^  webhook_url: /hook} }
  end

  describe port(4505) do
    it { should be_listening.with('tcp') }
  end

  describe port(4506) do
    it { should be_listening.with('tcp') }
  end

  # salt-api port
  describe port(8000) do
    it { should be_listening.with('tcp') }
  end
end

describe 'Salt Minion' do
  describe package('salt-minion') do
    it { should be_installed }
  end

  # Service check not supported in RedHat 5, however we still have the proccess check
  unless os[:family] == 'RedHat' && os[:release] =~ /^5\./
    describe service('salt-minion') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe process('salt-minion') do
    it { should be_running }
  end

  describe file('/etc/salt/minion') do
    it { should be_file }
    its(:content) { should match(/^master: 127.0.0.1/) }
    its(:content) { should match(/id: salt-api-/) }
    its(:content) { should match(/^  environment: _default/) }
    its(:content) { should match(/^    - salt_minion/) }
    its(:content) { should match(/^  quinoa: delicious/) }
    its(:content) { should match(/^  stooges:/) }
    its(:content) { should match(/^    - moe/) }
    its(:content) { should match(/^ipv6: false/) }
    its(:content) { should match(/^user: root/) }
    its(:content) { should match(/^master_port: 4506/) }
    its(:content) { should match %r{^pidfile: /var/run/salt-minion.pid} }
    its(:content) { should match %r{^root_dir: /} }
    its(:content) { should match %r{^pki_dir: /etc/salt/pki/minion} }
    its(:content) { should match %r{^cachedir: /var/cache/salt/minion} }
    its(:content) { should match(/^verify_env: true/) }
    its(:content) { should match(/^auth_timeout: 60/) }
    its(:content) { should match(/^loop_interval: 60/) }
    its(:content) { should match(/^color: true/) }
    its(:content) { should match(/^strip_colors: false/) }
    its(:content) { should match %r{^sock_dir: /var/run/salt/minion} }
    its(:content) { should match(/^open_mode: false/) }
    its(:content) { should match(/^permissive_pki_access: false/) }
    its(:content) { should match(/^state_verbose: true/) }
    its(:content) { should match(/^state_output: full/) }
    its(:content) { should match(/^hash_type: md5/) }
    its(:content) { should match %r{^log_file: /var/log/salt/minion} }
    its(:content) { should match %r{^key_logfile: /var/log/salt/key} }
    its(:content) { should match(/^log_level: warning/) }
    its(:content) { should match(/^log_level_logfile: warning/) }
    its(:content) { should match(/^log_datefmt: '%H:%M:%S'/) }
    its(:content) { should match(/^log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'/) }
    its(:content) { should match(/^log_fmt_console: '\[%\(levelname\)-8s\] %\(message\)s'/) }
    its(:content) { should match(/^log_fmt_logfile: '%\(asctime\)s,%\(msecs\)03.0f \[%\(name\)-17s\]\[%\(levelname\)-8s\] %\(message\)s'/) }
    its(:content) { should match(/^return: mysql/) }
  end
end
