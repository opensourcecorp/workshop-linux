# Allows for setting an env var for fewer (or more) team servers, for different
# testing scenarios & hardware
num_team_servers = Integer(ENV["num_team_servers"].nil? ? 2 : ENV["num_team_servers"])

Vagrant.configure("2") do |config|
  box = "debian/bookworm64" # Debian 12

  cpus   = 1
  memory = 768

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = cpus
    vb.memory = memory
  end

  config.vm.provider "libvirt" do |lv|
    lv.cpus   = cpus
    lv.memory = memory
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  # hub server static IP
  hub_addr = "10.0.1.10"
  ip_bytes = hub_addr.split(".")

  config.vm.define "hub" do |hub|
    hub.vm.box = box

    hub.vm.network "private_network", ip: hub_addr
    hub.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp" # hub
    hub.vm.network "forwarded_port", guest: 8000, host: 8000, protocol: "tcp" # Dummy web app
    hub.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: "tcp" # Score dashboard

    hub.vm.synced_folder ".", "/vagrant", disabled: true

    hub.vm.provision "file", source: "./scripts", destination: "/tmp/scripts"
    hub.vm.provision "file", source: "./services", destination: "/tmp/services"
    hub.vm.provision "file", source: "./score-server", destination: "/tmp/score-server"
    hub.vm.provision "file", source: "./dummy-web-app", destination: "/tmp/dummy-web-app"

    hub.vm.provision "shell",
      inline: <<-SCRIPT
        #!/usr/bin/env bash
        set -euo pipefail

        # Need both running here for Vagrant -- other platforms should ONLY have 2332
        sudo sh -c 'grep -q 2332 /etc/ssh/sshd_config || printf "Port 2332\nPort 22\n" >> /etc/ssh/sshd_config'
        sudo systemctl restart ssh

        rm -rf /root/{score-server,services,dummy-web-app}
        sudo cp -r /tmp/{score-server,services,dummy-web-app} /root/
        bash /tmp/scripts/init-hub.sh
      SCRIPT
  end

  (1..num_team_servers).each do |i|
    config.vm.define "team#{i}" do |team|
      team.vm.box = box

      # TODO: this looks as gross as it does b/c maybe we'll loop over it later
      # when we're simulating more teams
      team.vm.network "private_network", ip: ip_bytes[0..2].join(".") + "." + String(Integer(ip_bytes[-1]) + i)

      team.vm.synced_folder ".", "/vagrant", disabled: true

      team.vm.provision "file", source: "./scripts", destination: "/tmp/scripts"
      team.vm.provision "file", source: "./services", destination: "/tmp/services"
      team.vm.provision "file", source: "./instructions", destination: "/tmp/instructions"
      team.vm.provision "file", source: "./dummy-app-src", destination: "/tmp/dummy-app-src"

      team.vm.provision "shell",
        inline: <<-SCRIPT
          #!/usr/bin/env bash
          set -euo pipefail

          # Need both running here for Vagrant -- other platforms should ONLY have 2332
          sudo sh -c 'grep -q 2332 /etc/ssh/sshd_config || printf "Port 2332\nPort 22\n" >> /etc/ssh/sshd_config'
          sudo systemctl restart ssh

          export team_name="Team-#{i}"
          export hub_addr='#{hub_addr}'
          bash /tmp/scripts/init.sh
          bats -F pretty /.ws/scripts/test.bats
        SCRIPT
    end
  end
end
