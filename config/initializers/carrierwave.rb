CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAT6BJJ77RF75QJFOZ',                        # required unless using use_iam_profile
    aws_secret_access_key: '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',                        # required unless using use_iam_profile
    region:                'us-east-2'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'vedel'
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
end