define :zipfile_directory, :url => '', :checksum => nil, :mode => 0755, :owner => 'root', :group => 'root', :umask => nil do

  target_dir = params[:name]
  zipfile_name = params[:url].split('/')[-1]
  cached_zipfile = "#{Chef::Config[:file_cache_path]}/#{zipfile_name}"

  # from the UNZIP(1) manpage:
  # The duplicated option -DD forces suppression of timestamp restoration
  # for all extracted entries (files and directories).  This option
  # results in setting the timestamps for all extracted entries to the
  # current time.

  unzip_command = %Q[ unzip -q -o "#{cached_zipfile}" ]

  remote_file cached_zipfile do
    source params[:url]
    checksum params[:checksum]
    mode params[:mode]
    notifies :run, "execute[#{unzip_command}]", :immediately
  end
  
  execute unzip_command do
    cwd target_dir
    user params[:owner]
    group params[:group]
    umask params[:umask]
    action :nothing
  end

end