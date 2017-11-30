class DeployKit
  def copy_file_to_remote from, to
    login  = config.ssh.user.deployer.login
    domain = config.ssh.user.deployer.domain
    local_exec scp("#{ from } #{ login }@#{ domain }:#{ to }")
  end

  def copy_file_from_remote from, to
    login  = config.ssh.user.deployer.login
    domain = config.ssh.user.deployer.domain
    local_exec scp("#{ login }@#{ domain }:#{ from } #{ to }")
  end
end
