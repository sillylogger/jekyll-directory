module JekyllConfigDirs
  def source_dir(*subdirs)
    File.join(File.dirname(__FILE__), '..', 'source', *subdirs)
  end

  def dest_dir(*subdirs)
    File.join(File.dirname(__FILE__), '..', 'dest', *subdirs)
  end

  def plugins_dir
    File.join(File.dirname(__FILE__), '..', '..', '_plugins')
  end
end

