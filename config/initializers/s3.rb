CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => "AKIAI243RJZGRU43JK4Q",
      :aws_secret_access_key  => "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",
      :region                 => 'us-west-1' # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = "techauriga"
end