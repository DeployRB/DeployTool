class DeployKit
  def file_exists?(file_path)
    "if [ -f #{file_path} ]; then echo 'true'; else echo 'false'; fi"
  end

  def local_file_exists?(file_path)
    res = local_exec file_exists?(file_path)
    res.strip == 'true'
  end

  def remote_file_exists?(file_path, as = nil)
    cmd = file_exists?(file_path)
    res = remote_exec(cmd, as)
    res.strip == 'true'
  end
end
