namespace :diagrams do

  desc 'Generates a class diagram and a state machine as saves them to the doc folder'
  task :generate do
    `bin/rails erd` # Use .erdconfig for configuration
    `bin/railroady -A | dot -Tsvg > doc/aasm.svg`
  end

end
