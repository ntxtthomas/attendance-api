# Configure ActiveModelSerializers defaults
# Adapter choices: :attributes (simple hashes), :json_api (JSON:API), etc.
ActiveModelSerializers.config.adapter = :attributes
ActiveModelSerializers.config.key_transform = :unaltered

# If you prefer JSON:API output, switch to:
# ActiveModelSerializers.config.adapter = :json_api