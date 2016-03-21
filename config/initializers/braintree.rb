Braintree::Configuration.environment = :production #:sandbox#
Braintree::Configuration.logger = Logger.new('log/braintree.log')
Braintree::Configuration.merchant_id = 'fqmh5bkjbcbz5t57'#ENV['BRAINTREE_MERCHANT_ID']
Braintree::Configuration.public_key = 'z2ddq3cqkf4kbtzt'#ENV['BRAINTREE_PUBLIC_KEY']
Braintree::Configuration.private_key = '0b451d6104a672ee425fc44fe244588f'#ENV['BRAINTREE_PRIVATE_KEY']