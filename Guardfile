guard 'rspec', cmd: "bundle exec rspec" do
  # watch /lib/ files
  watch(%r{^lib/siren_client/(.+).rb$}) do |m|
    "spec/unit/#{m[1]}_spec.rb"
  end

  # watch /spec/ files
  watch(%r{^spec/(.+)/(.+).rb$}) do |m|
    "spec/#{m[1]}/#{m[2]}.rb"
  end
end
