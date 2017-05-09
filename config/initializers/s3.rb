CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAIEIF6ASH6Z6LEOKQ',  
      :aws_secret_access_key  => '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',
      :region                 => 'us-west-1' # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = "techauriga"
end