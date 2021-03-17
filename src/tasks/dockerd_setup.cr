require "sam"
require "file_utils"
require "colorize"
require "totem"
require "./utils/utils.cr"


desc "The dockerd tool is used to run docker commands against the cluster."
task "install_dockerd" do |_, args|
  VERBOSE_LOGGING.info "install_dockerd" if check_verbose(args)
  resp = KubectlClient::Apply.file(dockerd_filename)
  # status = Process.run("kubectl create -f #{dockerd_filename}",
  #                               shell: true,
  #                               output: install_dockerd = IO::Memory.new,
  #                               error: stderr = IO::Memory.new).success?
  # LOGGING.info "Dockerd_Install output: #{install_dockerd.to_s}"
  # LOGGING.info "Dockerd_Install stderr: #{stderr.to_s}"
  # LOGGING.info "Dockerd_Install status: #{status}"
  status = check_dockerd
  if status
    LOGGING.error "Dockerd_Install failed.".colorize(:red)
  end
  LOGGING.info "Dockerd_Install status: #{status}"
  status
end

desc "Uninstall dockerd"
task "uninstall_dockerd" do |_, args|
  LOGGING.info "uninstall_dockerd" 
  # delete_dockerd = `kubectl delete -f #{dockerd_filename}`
  KubectlClient::Delete.file(dockerd_filename)
  # LOGGING.info "Dockerd_uninstall: #{delete_dockerd}"
end

def dockerd_filename
  "./#{TOOLS_DIR}/dockerd/manifest.yml"
end

def dockerd_tempname
  "./#{TOOLS_DIR}/dockerd/manifest.tmp"
end

def dockerd_tempname_helper
  LOGGING.info "dockerd_tempname_helper"
  LOGGING.info "ls #{TOOLS_DIR}"
  LOGGING.info `ls #{TOOLS_DIR}`
  LOGGING.info "ls #{TOOLS_DIR}/dockerd"
  LOGGING.info `ls #{TOOLS_DIR}/dockerd`
  `mv #{dockerd_filename} #{dockerd_tempname}`
end

def dockerd_name_helper
  LOGGING.info "dockerd_name_helper"
  LOGGING.info "ls #{TOOLS_DIR}"
  LOGGING.info `ls #{TOOLS_DIR}`
  LOGGING.info "ls #{TOOLS_DIR}/dockerd"
  LOGGING.info `ls #{TOOLS_DIR}/dockerd`
  `mv #{dockerd_tempname} #{dockerd_filename}`
end

def check_dockerd
  LOGGING.info "check_dockerd"
  KubectlClient::Get.resource_wait_for_install("Pod", "dockerd", wait_count = 5)
end
