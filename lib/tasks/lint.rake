task :lint do
  sh 'yarn prettier --check'
end
