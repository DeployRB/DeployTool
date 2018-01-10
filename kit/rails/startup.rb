class DeployKit
  def startup_authorize_sudo
    startup_authorize(:sudo)
  end

  def startup_authorize_deployer
    startup_authorize(:deployer)
  end

  def startup_authorize(user_name)
    deploy_user = config.ssh.user[user_name]

    puts "YOUR PASS: #{ deploy_user.password }".red
    remote_exec("mkdir -p ~/.ssh/", user_name)

    auth_keys = '~/.ssh/authorized_keys'

    unless remote_file_exists?(auth_keys, user_name)
      local_exec "cat #{ deploy_user.key_pub } | ssh #{ deploy_user.login }@#{ deploy_user.domain } 'cat > #{ auth_keys }'"
      puts "#{auth_keys} file was initialized on the server".light_green
    else
      puts "#{auth_keys} file is already exists on the server".light_red
    end
  end

  def startup_create_base_dirs
    cmds = [
      "mkdir -p ~/.ssh/",
      "mkdir -p #{ app_root_path }",

      "mkdir -p #{ releases_path } ",
      "mkdir -p #{ configs_path }",
      "mkdir -p #{ shared_path }",
      "mkdir -p #{ ssl_path }",

      "mkdir -p #{ app_services_files_path }",
      "mkdir -p #{ app_settings_files_path }",
    ]

    remote_exec cmds
  end

  def startup_copy_ssh_files
    unless remote_file_exists?('~/.ssh/id_rsa')
      copy_file_to_remote deployer.key, '~/.ssh/id_rsa'
    end

    unless remote_file_exists?('~/.ssh/id_rsa.pub')
      copy_file_to_remote deployer.key_pub, '~/.ssh/id_rsa.pub'
    end

    unless remote_file_exists?('~/.ssh/known_hosts')
      template_upload "ssh_ssl/known_hosts", '~/.ssh/known_hosts'
    end
  end
end

# remote_exec "ssh -T git@github.com"
# remote_exec "ssh -T git@bitbucket.com"
