class RailsBox
  def RailsBox.configure(config, settings)
    # Setup our box
    config.vm.box = "thoughtbot/ubuntu-14-04-server-with-laptop"
    config.vm.hostname = "rails-box"

    # Networking
    config.vm.network :forwarded_port, host: 3000, guest: 3000
    config.vm.network :forwarded_port, host: 4000, guest: 80

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      settings["vm-config"].each do |config|
          vb.customize ["modifyvm", :id, "--memory", config["memory"] ||= "2048"]
          vb.customize ["modifyvm", :id, "--cpus", config["cpus"] ||= "1"]
      end
    end

    # Copy The Bash Aliases
    config.vm.provision "shell" do |s|
      s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
    end

    # Register All Of The Configured Shared Folders
    settings["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"]
    end
  end
end