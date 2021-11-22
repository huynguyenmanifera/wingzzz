include FactoryBot::Syntax::Methods if defined?(FactoryBot)

file = "#{ENV.fetch('SEED', Rails.env).downcase}.rb"
load(Rails.root.join('db', 'seeds', file))
